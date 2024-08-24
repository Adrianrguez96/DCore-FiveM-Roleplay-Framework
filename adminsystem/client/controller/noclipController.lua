NoClipController = function()
     local this = {}

     this.ResourceName = GetCurrentResourceName()
     this.IsNoClipping      = false
     this.PlayerPed         = nil
     this.NoClipEntity      = nil
     this.Camera            = nil
     this.PlayerIsInVehicle = false

     this.MinY, this.MaxY        = -89.0, 89.0
    
    
     this.PedFirstPersonNoClip      = false      
     this.VehFirstPersonNoClip      = false      
    

     this.Speed                     = 1         
     this.MaxSpeed                  = 16.0     
    
    -- Key bindings
     this.MOVE_FORWARDS             = 32        
     this.MOVE_BACKWARDS            = 33        
     this.MOVE_LEFT                 = 34        
     this.MOVE_RIGHT                = 35        
     this.MOVE_UP                   = 44        
     this.MOVE_DOWN                 = 46        
    
     this.SPEED_DECREASE            = 14        
     this.SPEED_INCREASE            = 15        
     this.SPEED_RESET               = 348       
     this.SPEED_SLOW_MODIFIER       = 36        
     this.SPEED_FAST_MODIFIER       = 21       
     this.SPEED_FASTER_MODIFIER     = 19        

     this.Run = function()
        RegisterNetEvent("AdminSystem:client:ToggleNoClip", function()
            this.ToggleNoClip(not this.IsNoClipping)
        end)

        AddEventHandler('onResourceStop', function(resourceName)
            if resourceName == this.ResourceName then
                FreezeEntityPosition(this.NoClipEntity, false)
                FreezeEntityPosition(this.PlayerPed, false)
                SetEntityCollision(this.NoClipEntity, true, true)
                SetEntityVisible(this.NoClipEntity, true, false)
                SetLocalPlayerVisibleLocally(true)
                ResetEntityAlpha(this.NoClipEntity)
                ResetEntityAlpha(this.PlayerPed)
                SetEveryoneIgnorePlayer(this.PlayerPed, false)
                SetEntityInvincible(this.NoClipEntity, false)
            end
        end)
    end

     this.DisabledControls = function()
        DisableAllControlActions(0)
        DisableAllControlActions(1)
        DisableAllControlActions(2)
        EnableControlAction(0, 220, true)
        EnableControlAction(0, 221, true)
        EnableControlAction(0, 245, true)
    end

    this.IsControlAlwaysPressed = function(inputGroup, control)
        return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
    end
    
    this.IsPedDrivingVehicle = function(ped, veh)
        return ped == GetPedInVehicleSeat(veh, -1)
    end

    this.SetupCam = function()
        local entityRot = GetEntityRotation(this.NoClipEntity)
        this.Camera = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(this.NoClipEntity), vector3(0.0, 0.0, entityRot.z), 75.0)
        SetCamActive(this.Camera, true)
        RenderScriptCams(true, true, 1000, false, false)
    
        if this.PlayerIsInVehicle == 1 then
            AttachCamToEntity(this.Camera, this.NoClipEntity, 0.0, this.VehFirstPersonNoClip == true and 0.5 or -4.5, this.VehFirstPersonNoClip == true and 1.0 or 2.0, true)
        else
            AttachCamToEntity(this.Camera, this.NoClipEntity, 0.0, this.PedFirstPersonNoClip == true and 0.0 or -2.0, this.PedFirstPersonNoClip == true and 1.0 or 0.5, true)
        end
    
    end

    this.DestroyCamera = function()
        SetGameplayCamRelativeHeading(0)
        RenderScriptCams(false, true, 1000, true, true)
        DetachEntity(this.NoClipEntity, true, true)
        SetCamActive(this.Camera, false)
        DestroyCam(this.Camera, true)
    end

    this.GetGroundCoords = function(coords)
        local rayCast  = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, -10000.0, 1, 0)
        local _, hit, hitCoords  = GetShapeTestResult(rayCast)
        return (hit == 1 and hitCoords) or coords
    end

    this.CheckInputRotation = function()
        local rightAxisX = GetControlNormal(0, 220)
        local rightAxisY = GetControlNormal(0, 221)
    
        local rotation = GetCamRot(this.Camera, 2)
    
        local yValue = rightAxisY * -5
        local newX
        local newZ = rotation.z + (rightAxisX * -10)
        if (rotation.x + yValue > this.MinY) and (rotation.x + yValue < this.MaxY) then
            newX = rotation.x + yValue
        end
        if newX ~= nil and newZ ~= nil then
            SetCamRot(this.Camera, vector3(newX, rotation.y, newZ), 2)
        end
        
        SetEntityHeading(this.NoClipEntity, math.max(0, (rotation.z % 360)))        
    end

    this.RunNoClipThread = function()
        Citizen.CreateThread(function()
            while this.IsNoClipping do
                Citizen.Wait(0)
                this.CheckInputRotation()
                this.DisabledControls()
    
                if this.IsControlAlwaysPressed(2, this.SPEED_DECREASE) then
                    this.Speed = this.Speed - 0.5
                    if this.Speed < 0.5 then
                        this.Speed = 0.5
                    end
                elseif this.IsControlAlwaysPressed(2, this.SPEED_INCREASE) then
                    this.Speed = this.Speed + 0.5
                    if this.Speed > this.MaxSpeed then
                        this.Speed = this.MaxSpeed
                    end
                elseif IsDisabledControlJustReleased(0, this.SPEED_RESET) then
                    this.Speed = 1
                end
    
                local multi = 1.0
                if this.IsControlAlwaysPressed(0, this.SPEED_FAST_MODIFIER) then
                    multi = 2			
                elseif this.IsControlAlwaysPressed(0, this.SPEED_FASTER_MODIFIER) then
                    multi = 4			
                elseif this.IsControlAlwaysPressed(0, this.SPEED_SLOW_MODIFIER) then
                    multi = 0.25
                end
    
                if this.IsControlAlwaysPressed(0, this.MOVE_FORWARDS) then
                    local pitch = GetCamRot(this.Camera, 0)
    
                    if pitch.x >= 0 then
                        SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, 0.5*(this.Speed * multi), (pitch.x*((this.Speed/2) * multi))/89))
                    else
                        SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, 0.5*(this.Speed * multi), -1*((math.abs(pitch.x)*((this.Speed/2) * multi))/89)))
                    end
                elseif this.IsControlAlwaysPressed(0, this.MOVE_BACKWARDS) then
                    local pitch = GetCamRot(this.Camera, 2)
    
                    if pitch.x >= 0 then
                        SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, -0.5*(this.Speed * multi), -1*(pitch.x*((this.Speed/2) * multi))/89))
                    else
                        SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, -0.5*(this.Speed * multi), ((math.abs(pitch.x)*((this.Speed/2) * multi))/89)))
                    end
                end
    
                if this.IsControlAlwaysPressed(0, this.MOVE_LEFT) then 			
                    SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, -0.5*(this.Speed * multi), 0.0, 0.0))
                elseif this.IsControlAlwaysPressed(0, this.MOVE_RIGHT) then
                    SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.5*(this.Speed * multi), 0.0, 0.0))
                end
    
                if this.IsControlAlwaysPressed(0, this.MOVE_UP) then 			
                    SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, 0.0, 0.5*(this.Speed * multi)))
                elseif this.IsControlAlwaysPressed(0, this.MOVE_DOWN) then
                    SetEntityCoordsNoOffset(this.NoClipEntity, GetOffsetFromEntityInWorldCoords(this.NoClipEntity, 0.0, 0.0, -0.5*(this.Speed * multi)))
                end
    
                local coords = GetEntityCoords(this.NoClipEntity)
       
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    
                FreezeEntityPosition(this.NoClipEntity, true)
                SetEntityCollision(this.NoClipEntity, false, false)
                SetEntityVisible(this.NoClipEntity, false, false)
                SetEntityInvincible(this.NoClipEntity, true)
                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(this.NoClipEntity, 0, false)
                if this.PlayerIsInVehicle == 1 then
                    SetEntityAlpha(this.PlayerPed, 0, false)
                end
                SetEveryoneIgnorePlayer(this.PlayerPed, true)
            end
            this.StopNoClip()
        end)
    end

    this.CameraStopNoClip = function()
        FreezeEntityPosition(this.NoClipEntity, false)
        SetEntityCollision(this.NoClipEntity, true, true)
        SetEntityVisible(this.NoClipEntity, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(this.NoClipEntity)
        ResetEntityAlpha(this.PlayerPed)
        SetEveryoneIgnorePlayer(this.PlayerPed, false)
    
        if GetVehiclePedIsIn(this.PlayerPed, false) ~= 0 then
            while (not IsVehicleOnAllWheels(this.NoClipEntity)) and not this.IsNoClipping do
                Wait(0)
            end
            while not this.IsNoClipping do
                Wait(0)
                if IsVehicleOnAllWheels(this.NoClipEntity) then
                    return SetEntityInvincible(this.NoClipEntity, false)
                end
            end
        else
            if (IsPedFalling(this.NoClipEntity) and math.abs(1 - GetEntityHeightAboveGround(this.NoClipEntity)) > 1.00) then
                while (IsPedStopped(this.NoClipEntity) or not IsPedFalling(this.NoClipEntity)) and not this.IsNoClipping do
                    Wait(0)
                end
            end
            while not this.IsNoClipping do
                Wait(0)
                if (not IsPedFalling(this.NoClipEntity)) and (not IsPedRagdoll(this.NoClipEntity)) then
                    return SetEntityInvincible(this.NoClipEntity, false)
                end
            end
        end
    end

    this.StopNoClip = function()
        FreezeEntityPosition(this.NoClipEntity, false)
        SetEntityCollision(this.NoClipEntity, true, true)
        SetEntityVisible(this.NoClipEntity, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(this.NoClipEntity)
        ResetEntityAlpha(this.PlayerPed)
        SetEveryoneIgnorePlayer(this.PlayerPed, false)
    
        if GetVehiclePedIsIn(this.PlayerPed, false) ~= 0 then
            while (not IsVehicleOnAllWheels(this.NoClipEntity)) and not this.IsNoClipping do
                Wait(0)
            end
            while not this.IsNoClipping do
                Wait(0)
                if IsVehicleOnAllWheels(this.NoClipEntity) then
                    return SetEntityInvincible(this.NoClipEntity, false)
                end
            end
        else
            if (IsPedFalling(this.NoClipEntity) and math.abs(1 - GetEntityHeightAboveGround(this.NoClipEntity)) > 1.00) then
                while (IsPedStopped(this.NoClipEntity) or not IsPedFalling(this.NoClipEntity)) and not this.IsNoClipping do
                    Wait(0)
                end
            end
            while not this.IsNoClipping do
                Wait(0)
                if (not IsPedFalling(this.NoClipEntity)) and (not IsPedRagdoll(this.NoClipEntity)) then
                    return SetEntityInvincible(this.NoClipEntity, false)
                end
            end
        end
    end

    this.ToggleNoClip = function(state)
        this.IsNoClipping = state or not this.IsNoClipping
        this.PlayerPed  = PlayerPedId()
        this.PlayerIsInVehicle = IsPedInAnyVehicle(this.PlayerPed, false)
        if this.PlayerIsInVehicle ~= 0 and this.IsPedDrivingVehicle(this.PlayerPed, GetVehiclePedIsIn(this.PlayerPed, false)) then
            this.NoClipEntity = GetVehiclePedIsIn(this.PlayerPed, false)
            SetVehicleEngineOn(this.NoClipEntity, not this.IsNoClipping, true, this.IsNoClipping)
        else
            this.NoClipEntity = this.PlayerPed
        end
    
        if this.IsNoClipping then
            FreezeEntityPosition(this.PlayerPed)
            this.SetupCam()
            PlaySoundFromEntity(-1, "SELECT", this.PlayerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
    
            if not this.PlayerIsInVehicle then
                ClearPedTasksImmediately(this.PlayerPed)
                if this.PedFirstPersonNoClip then
                    Citizen.Wait(1000) 
                end
            else
                if this.VehFirstPersonNoClip then
                    Citizen.Wait(1000) 
                end
            end
    
        else
            local groundCoords   = this.GetGroundCoords(GetEntityCoords(this.NoClipEntity))
            SetEntityCoords(this.NoClipEntity, groundCoords.x, groundCoords.y, groundCoords.z)
            Citizen.Wait(50)
            this.DestroyCamera()
            PlaySoundFromEntity(-1, "CANCEL", this.PlayerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
        end
        
        SetUserRadioControlEnabled(not this.IsNoClipping)
       
        if this.IsNoClipping then
            this.RunNoClipThread()
        end
    end
    
    return this
end