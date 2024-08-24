SpawnController = function(LoopController)

    local this = {}

    this.lController = LoopController
    this.PlayerSelect = nil
    this.selectionCam = nil
    this.FirstSelect = false
    this.PlayerLogin = false
    
    this.SpawnPlayerSelection = function(players)

        local playerid = PlayerPedId(-1)

        SetCanAttackFriendly(playerid, true, false)
        NetworkSetFriendlyFireOption(true)
        DisplayRadar(false)
        ClearPlayerWantedLevel(playerid)
        SetPoliceIgnorePlayer(playerid)
        SetMaxWantedLevel(0)

        SetEntityCoordsNoOffset(playerid, 8.49,529.19,170.63, false, false, false, true)
        NetworkResurrectLocalPlayer(8.49,529.19,170.63, 0.0, true, true, false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true);
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		FreezeEntityPosition(playerid, false)
		DoScreenFadeIn(500)

        this.selectionCam  = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 3.2, 527.65, 170.63, 0.0,0.0,210.00, 100.0, false, 0)
        SetCamActive(this.selectionCam, true)
        RenderScriptCams(true, false, 1, true, true)

        SetNuiFocus(true,true)
        SendNUIMessage({action = "selectMenu", players = players})

        --Load Spawn events 
        this.SpawnPlayerSelectedNUI()
        this.SelectPlayerNUI()
        
    end

    -- Event to SpawnPlayer in NUI
    this.SpawnPlayerSelectedNUI = function()
        RegisterNUICallback("loadPlayer",function(data,cb) 
            TriggerServerEvent("Core:server:SetPlayerVehicles",this.PlayerSelect.id)
            this.SpawnPlayerInPosition(this.PlayerSelect)
        end)
    end

    -- Event to select player in NUI
    this.SelectPlayerNUI = function()
        RegisterNUICallback("selectPlayer",function(data,cb)
            TriggerServerEvent("core:server:selectplayer",data.playeridSelect)
        end)
    end

    -- Event Change player selection
    this.ChangePlayerSelection = function (data)
        this.PlayerSelect = data

        if this.FirstSelect then 
            TaskGoStraightToCoord(PlayerPedId(-1), 8.49,529.19,170.63, 0.2, 4000, GetEntityHeading(PlayerPedId(-1)), 0.5)
            Citizen.Wait(2500)
        end
        if not PlayerLogin then 
            this.SetPlayerModel(data.gender,data.skin)
            TaskGoStraightToCoord(PlayerPedId(-1), 5.12,526.49,170.62, 0.2, 4000, 50.0, 0.5)
        end
        
        this.FirstSelect = true
    end

    -- Set a PlayerModel
    this.SetPlayerModel = function(gender,skin)

        local defaultSkin;

        if gender == "male" then  defaultSkin = GetHashKey("mp_m_freemode_01")
        else defaultSkin = GetHashKey("mp_f_freemode_01") end

        RequestModel(defaultSkin)

        while not HasModelLoaded(defaultSkin) do
            Citizen.Wait(10)
        end

        SetPlayerModel(PlayerId(), defaultSkin)
        if skin.face_md_weight  == nil then
            SetPedDefaultComponentVariation(GetPlayerPed(-1))
        else
            this.SetPlayerComponets(skin)
        end
        
        SetModelAsNoLongerNeeded(defaultSkin)

    end

    -- Set player in register position 
    this.SpawnPlayerInRegisterPosition = function(data)
        TriggerEvent('charactercreator:open',data,{ 'identity','features', 'style', 'apparel' })
    end

    -- Set Player in map positions
    this.SpawnPlayerInPosition = function(player)

        this.PlayerLogin = true
        this.PlayerSelect = nil

        this.lController.InitPlayerLoops()

        this.SetPlayerModel(player.gender,player.skin)

        RenderScriptCams(false, false, 1, true, true)
        SetNuiFocus(false,false)
        SwitchOutPlayer(PlayerPedId(), 0, 1)
        SetRichPresence("Jugando como " .. player.name .. " " .. player.lastName)
        FreezeEntityPosition(PlayerPedId(), true)

        while GetPlayerSwitchState() ~= 5 do
            Citizen.Wait(0)
        end

        SetEntityCoords(PlayerPedId(), player.position.x,player.position.y,player.position.z, false, false, false, true)
        SetEntityHeading(PlayerPedId(), player.position.heading)
        SetEntityHealth(PlayerPedId(), player.meta.health)
        SetPedArmour(PlayerPedId(), player.meta.armour)

        SwitchInPlayer(PlayerPedId())
        DestroyCam(this.selectionCam, true)
        FreezeEntityPosition(PlayerPedId(), false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false);


        while GetPlayerSwitchState() ~= 12 do
            Citizen.Wait(0)
        end
        
        TriggerEvent("core:client:playerConnect",player)
    end

    -- Set Player Components
    this.SetPlayerComponets = function(data)
        --TODO: Possibly pull these out to separate functions
        local playerPed = PlayerPedId()
    
        -- Face Blend
        local weightFace = data.face_md_weight / 100 + 0.0
        local weightSkin = data.skin_md_weight / 100 + 0.0
        SetPedHeadBlendData(playerPed, data.mom, data.dad, 0, data.mom, data.dad, 0, weightFace, weightSkin, 0.0, false)
    
        -- Facial Features
        SetPedFaceFeature(playerPed, 0,  (data.nose_1 / 100)         + 0.0)  -- Nose Width
        SetPedFaceFeature(playerPed, 1,  (data.nose_2 / 100)         + 0.0)  -- Nose Peak Height
        SetPedFaceFeature(playerPed, 2,  (data.nose_3 / 100)         + 0.0)  -- Nose Peak Length
        SetPedFaceFeature(playerPed, 3,  (data.nose_4 / 100)         + 0.0)  -- Nose Bone Height
        SetPedFaceFeature(playerPed, 4,  (data.nose_5 / 100)         + 0.0)  -- Nose Peak Lowering
        SetPedFaceFeature(playerPed, 5,  (data.nose_6 / 100)         + 0.0)  -- Nose Bone Twist
        SetPedFaceFeature(playerPed, 6,  (data.eyebrows_5 / 100)     + 0.0)  -- Eyebrow height
        SetPedFaceFeature(playerPed, 7,  (data.eyebrows_6 / 100)     + 0.0)  -- Eyebrow depth
        SetPedFaceFeature(playerPed, 8,  (data.cheeks_1 / 100)       + 0.0)  -- Cheekbones Height
        SetPedFaceFeature(playerPed, 9,  (data.cheeks_2 / 100)       + 0.0)  -- Cheekbones Width
        SetPedFaceFeature(playerPed, 10, (data.cheeks_3 / 100)       + 0.0)  -- Cheeks Width
        SetPedFaceFeature(playerPed, 11, (data.eye_squint / 100)     + 0.0)  -- Eyes squint
        SetPedFaceFeature(playerPed, 12, (data.lip_thickness / 100)  + 0.0)  -- Lip Fullness
        SetPedFaceFeature(playerPed, 13, (data.jaw_1 / 100)          + 0.0)  -- Jaw Bone Width
        SetPedFaceFeature(playerPed, 14, (data.jaw_2 / 100)          + 0.0)  -- Jaw Bone Length
        SetPedFaceFeature(playerPed, 15, (data.chin_1 / 100)         + 0.0)  -- Chin Height
        SetPedFaceFeature(playerPed, 16, (data.chin_2 / 100)         + 0.0)  -- Chin Length
        SetPedFaceFeature(playerPed, 17, (data.chin_3 / 100)         + 0.0)  -- Chin Width
        SetPedFaceFeature(playerPed, 18, (data.chin_4 / 100)         + 0.0)  -- Chin Hole Size
        SetPedFaceFeature(playerPed, 19, (data.neck_thickness / 100) + 0.0)  -- Neck Thickness
    
        -- Appearance
        SetPedComponentVariation(playerPed, 2, data.hair_1, data.hair_2, 2)                  -- Hair Style
        SetPedHairColor(playerPed, data.hair_color_1, data.hair_color_2)                     -- Hair Color
        SetPedHeadOverlay(playerPed, 2, data.eyebrows_1, data.eyebrows_2 / 100 + 0.0)        -- Eyebrow Style + Opacity
        SetPedHeadOverlayColor(playerPed, 2, 1, data.eyebrows_3, data.eyebrows_4)            -- Eyebrow Color
        SetPedHeadOverlay(playerPed, 1, data.beard_1, data.beard_2 / 100 + 0.0)              -- Beard Style + Opacity
        SetPedHeadOverlayColor(playerPed, 1, 1, data.beard_3, data.beard_4)                  -- Beard Color
    
        SetPedHeadOverlay(playerPed, 0, data.blemishes_1, data.blemishes_2 / 100 + 0.0)      -- Skin blemishes + Opacity
        SetPedHeadOverlay(playerPed, 12, data.bodyb_3, data.bodyb_4 / 100 + 0.0)             -- Skin blemishes body effect + Opacity
    
        SetPedHeadOverlay(playerPed, 11, data.bodyb_1, data.bodyb_2 / 100 + 0.0)             -- Body Blemishes + Opacity
    
        SetPedHeadOverlay(playerPed, 3, data.age_1, data.age_2 / 100 + 0.0)                  -- Age + opacity
        SetPedHeadOverlay(playerPed, 6, data.complexion_1, data.complexion_2 / 100 + 0.0)    -- Complexion + Opacity
        SetPedHeadOverlay(playerPed, 9, data.moles_1, data.moles_2 / 100 + 0.0)              -- Moles/Freckles + Opacity
        SetPedHeadOverlay(playerPed, 7, data.sun_1, data.sun_2 / 100 + 0.0)                  -- Sun Damage + Opacity
        SetPedEyeColor(playerPed, data.eye_color)                                            -- Eyes Color
        SetPedHeadOverlay(playerPed, 4, data.makeup_1, data.makeup_2 / 100 + 0.0)            -- Makeup + Opacity
        SetPedHeadOverlayColor(playerPed, 4, 0, data.makeup_3, data.makeup_4)                -- Makeup Color
        SetPedHeadOverlay(playerPed, 5, data.blush_1, data.blush_2 / 100 + 0.0)              -- Blush + Opacity
        SetPedHeadOverlayColor(playerPed, 5, 2,	data.blush_3)                                -- Blush Color
        SetPedHeadOverlay(playerPed, 8, data.lipstick_1, data.lipstick_2 / 100 + 0.0)        -- Lipstick + Opacity
        SetPedHeadOverlayColor(playerPed, 8, 2, data.lipstick_3, data.lipstick_4)            -- Lipstick Color
        SetPedHeadOverlay(playerPed, 10, data.chest_1, data.chest_2 / 100 + 0.0)             -- Chest Hair + Opacity
        SetPedHeadOverlayColor(playerPed, 10, 1, data.chest_3, data.chest_4)                 -- Chest Hair Color
    
        -- Clothing and Accessories
        SetPedComponentVariation(playerPed, 8,  data.tshirt_1, data.tshirt_2, 2)        -- Undershirts
        SetPedComponentVariation(playerPed, 11, data.torso_1,  data.torso_2,  2)        -- Jackets
        SetPedComponentVariation(playerPed, 3,  data.arms,     data.arms_2,   2)        -- Torsos
        SetPedComponentVariation(playerPed, 10, data.decals_1, data.decals_2, 2)        -- Decals
        SetPedComponentVariation(playerPed, 4,  data.pants_1,  data.pants_2,  2)        -- Legs
        SetPedComponentVariation(playerPed, 6,  data.shoes_1,  data.shoes_2,  2)        -- Shoes
        SetPedComponentVariation(playerPed, 1,  data.mask_1,   data.mask_2,   2)        -- Masks
        SetPedComponentVariation(playerPed, 9,  data.bproof_1, data.bproof_2, 2)        -- Vests
        SetPedComponentVariation(playerPed, 7,  data.neckarm_1,  data.neckarm_2,  2)    -- Necklaces/Chains/Ties/Suspenders
        SetPedComponentVariation(playerPed, 5,  data.bags_1,   data.bags_2,   2)        -- Bags
    
        if data.helmet_1 == -1 then
            ClearPedProp(playerPed, 0)
        else
            SetPedPropIndex(playerPed, 0, data.helmet_1, data.helmet_2, 2)          -- Hats
        end
    
        if data.glasses_1 == -1 then
            ClearPedProp(playerPed, 1)
        else
            SetPedPropIndex(playerPed, 1, data.glasses_1, data.glasses_2, 2)        -- Glasses
        end
    
        if data.lefthand_1 == -1 then
            ClearPedProp(playerPed, 6)
        else
            SetPedPropIndex(playerPed, 6, data.lefthand_1, data.lefthand_2, 2)      -- Left Hand Accessory
        end
    
        if data.righthand_1 == -1 then
            ClearPedProp(playerPed,	7)
        else
            SetPedPropIndex(playerPed, 7, data.righthand_1, data.righthand_2, 2)    -- Right Hand Accessory
        end
    
        if data.ears_1 == -1 then
            ClearPedProp(playerPed, 2)
        else
            SetPedPropIndex (playerPed, 2, data.ears_1, data.ears_2, 2)             -- Ear Accessory
        end
    end

    -- CutScene new player
    this.CutSceneRegisterPlayer = function(player)
        this.PlayerLogin = true
        this.PlayerSelect = nil

        this.lController.InitPlayerLoops()

        this.SetPlayerModel(player.gender,player.skin)

        RenderScriptCams(false, false, 1, true, true)
        SetNuiFocus(false,false)

        PrepareMusicEvent("FM_INTRO_START") 
        TriggerMusicEvent("FM_INTRO_START") 
        local playerped = PlayerPedId() 
    
        RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
    
        while not HasCutsceneLoaded() do Wait(10) end 
        if IsPedModel(playerped, 'mp_m_freemode_01') then
            RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(PlayerPedId()), 0)
            RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
            local female = RegisterEntityForCutscene(0,"MP_Female_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(female, true)
        else
            RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(PlayerPedId()), 0)
            RegisterEntityForCutscene(PlayerPedId(), 'MP_Female_Character', 0, 0, 0)
            SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
            local male = RegisterEntityForCutscene(0,"MP_Male_Character",3,0,64) 
            NetworkSetEntityInvisibleToNetwork(male, true)
        end
    
        for i=0, 7 do 
            SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_" .. i, 0, 1)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. i, 3, GetHashKey('mp_f_freemode_01'), 0)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. i, 3, GetHashKey('mp_m_freemode_01'), 0)
        end
        
        NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)
        SetWeatherTypeNow("EXTRASUNNY") 
        StartCutscene(10) 
    
        Wait(30000) 
        StopCutsceneImmediately()
    
        SetEntityCoords(playerped,-1037.7,-2736.05,20.17, false, false, false, true)
        SetEntityHeading(playerped, 328.92)
        CancelMusicEvent("FM_INTRO_START")

        TriggerEvent("core:client:playerConnect",player)
    end

    return this
end