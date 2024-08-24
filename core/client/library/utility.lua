Utility = function() 
    local this = {}

    this.DrawText3D = function (x,y,z,scale,text)

        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x, y, z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end

    this.DrawText = function(x, y, width, height, scale, r, g, b, a, text)
        -- Use local function instead
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(scale, scale)
        SetTextColour(r, g, b, a)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(2, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x - width/2, y - height/2 + 0.005)
    end

    this.Trim = function(value)
        if not value then return nil end
        return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
    end

    this.DrawText3DRectagle = function(x,y,z,text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        local factor = (string.len(text)) / 370
        DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
        ClearDrawOrigin()
    end

    this.RequestAnimDict = function (animDict) 
        if not HasAnimDictLoaded(animDict) then
            RequestAnimDict(animDict)
    
            while not HasAnimDictLoaded(animDict) do
                Wait(4)
            end
        end
    end

    this.GetVehicles = function() 
        return GetGamePool('CVehicle')
    end

    this.GetObjects = function()
        return GetGamePool('CObject')
    end

    this.GetPeds = function (ignoreList)
        local pedPool = GetGamePool('CPed')
        local ignoreList = ignoreList or {}
        local peds = {}
        for i = 1, #pedPool, 1 do
            local found = false
            for j = 1, #ignoreList, 1 do
                if ignoreList[j] == pedPool[i] then
                    found = true
                end
            end
            if not found then
                peds[#peds + 1] = pedPool[i]
            end
        end
        return peds
    end

    this.LoadParticleDictionary = function(dictionary)
        if not HasNamedPtfxAssetLoaded(dictionary) then
            RequestNamedPtfxAsset(dictionary)
            while not HasNamedPtfxAssetLoaded(dictionary) do
                Wait(0)
            end
        end
    end

    this.StartParticlesAtCoords = function(Dict, ptName, looped, coords, rot, scale, alpha, color, duration)
        this.LoadParticleDictionary(Dict)
        UseParticleFxAssetNextCall(Dict)
        SetPtfxAssetNextCall(Dict)
        local particleHandle
        if looped then
            particleHandle = StartParticleFxLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
            if color then
                SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
            end
            SetParticleFxLoopedAlpha(particleHandle, alpha or 10.0)
            if duration then
                Wait(duration)
                StopParticleFxLooped(particleHandle, 0)
            end
        else
            SetParticleFxNonLoopedAlpha(alpha or 10.0)
            if color then
                SetParticleFxNonLoopedColour(color.r, color.g, color.b)
            end
            StartParticleFxNonLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
        end
    
        return particleHandle
    end

    this.StartParticlesOnEntity = function(Dict, ptName, looped, entity, bone, offset, rot, scale, alpha, color, evolution, duration)
        this.LoadParticleDictionary(Dict)
        UseParticleFxAssetNextCall(Dict)
        local particleHandle, boneID
        if bone and GetEntityType(entity) == 1 then
            boneID = GetPedBoneIndex(entity, bone)
        elseif bone then
            boneID = GetEntityBoneIndexByName(entity, bone)
        end
        if looped then
            if bone then
                particleHandle = StartParticleFxLoopedOnEntityBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
            else
                particleHandle = StartParticleFxLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
            end
            if evolution then
                SetParticleFxLoopedEvolution(particleHandle, evolution.name, evolution.amount, false)
            end
            if color then
                SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
            end
            SetParticleFxLoopedAlpha(particleHandle, alpha)
            if duration then
                Wait(duration)
                StopParticleFxLooped(particleHandle, 0)
            end
        else
            SetParticleFxNonLoopedAlpha(alpha or 10.0)
            if color then
                SetParticleFxNonLoopedColour(color.r, color.g, color.b)
            end
            if bone then
                StartParticleFxNonLoopedOnPedBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
            else
                StartParticleFxNonLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
            end
        end
    end

    this.CreateBlipForCoords = function(coords,sprite,display,scale,color,title)

        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip,sprite)
        SetBlipDisplay(Blip, display)
        SetBlipScale(Blip, scale)
        SetBlipColour(Blip, color)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(title)
        EndTextCommandSetBlipName(Blip)  
    end

    return this
end