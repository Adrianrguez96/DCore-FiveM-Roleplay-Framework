AdminController = function()
    
    local this = {}

    this.InvisiblePlayer = false
    this.GodModePlayer = false
    this.PlayerFrozen = false
    this.SpecPlayer = false
    this.LastSpectateCoord = nil

    this.Run = function()
        this.GoToMarkerEvent()
        this.SpawnVehicleEvent()
        this.DeleteVehicle()
        this.SetPlayerInvisible()
        this.ActiveGodMode()
        this.SetPlayerPed()
        this.SetFreezePlayer()
        this.DiedPlayer()
        this.SpectatePlayer()
        this.RevivePlayer()
    end

    this.GoToMarkerEvent = function()
        RegisterNetEvent("AdminSystem:client:GoToMarker")
        AddEventHandler("AdminSystem:client:GoToMarker",function()
            local playerped = PlayerPedId()
            local blip = GetFirstBlipInfoId(8)
            if DoesBlipExist(blip) then
                local blipCoords = GetBlipCoords(blip)
                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(playerped, blipCoords.x, blipCoords.y, height + 0.0)
                    local foundGround, zPos = GetGroundZFor_3dCoord(blipCoords.x, blipCoords.y, height + 0.0)
                    if foundGround then
                        SetPedCoordsKeepVehicle(playerped, blipCoords.x, blipCoords.y, height + 0.0)
                        break
                    end
                    Citizen.Wait(0)
                end
                TriggerEvent("core:showNotification","check","Acabas de ser teleportado a la ubicación",3500)
            else TriggerEvent("core:showNotification","error","No has elegido ninguna ubicación en el mapa",3500)
            end
        end)
    end

    this.RevivePlayer = function()
        RegisterNetEvent("AdminSystem:client:RevivePlayer")
        AddEventHandler("AdminSystem:client:RevivePlayer",function(ped)
            local pos = GetEntityCoords(playerPed)
            NetworkResurrectLocalPlayer(pos.x,pos.y,pos.z + 0.5, true, true, false)
            SetPlayerInvincible(ped, false)
            ClearPedBloodDamage(ped)
        end)
    end

    this.SpawnVehicleEvent = function()
        RegisterNetEvent("AdminSystem:client:SpawnVehicle")
        AddEventHandler("AdminSystem:client:SpawnVehicle",function(vehName)
            local playerped = PlayerPedId()
            local hash = GetHashKey(vehName)
            if not IsModelInCdimage(hash) then
                TriggerEvent("core:showNotification","error","Acabas de indicar un modelo invalido",3500)
                return
            end
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(10)
            end
            local vehicle = CreateVehicle(hash, GetEntityCoords(playerped), GetEntityHeading(playerped), true, false)
            TaskWarpPedIntoVehicle(playerped, vehicle, -1)
            SetModelAsNoLongerNeeded(vehicle)
            TriggerEvent("core:showNotification","check","Acabas de spawnear el vehículo " .. vehName,3500)
        end)
    end

    this.DeleteVehicle = function()
        RegisterNetEvent("AdminSystem:client:DeleteVehicle")
        AddEventHandler("AdminSystem:client:DeleteVehicle",function()
            local playerped = PlayerPedId()
            local veh = GetVehiclePedIsUsing(playerped)
            if veh ~= 0 then
                SetEntityAsMissionEntity(veh, true, true)
                DeleteVehicle(veh)
            else
                local pcoords = GetEntityCoords(playerped)
                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in pairs(vehicles) do
                    if #(pcoords - GetEntityCoords(vehicle)) <= 5.0 then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        DeleteVehicle(vehicle)
                    end
                end
            end
            TriggerEvent("core:showNotification","check","Acabas de borrar todos los vehículos",3500)
        end)
    end

    this.SetPlayerInvisible = function()
        RegisterNetEvent("Admin:Client:SetPlayerInvisible")
        AddEventHandler("Admin:Client:SetPlayerInvisible",function()
            SetEntityVisible(PlayerPedId(), this.InvisiblePlayer, 0)
            this.InvisiblePlayer = not this.InvisiblePlayer
            TriggerEvent("core:showNotification","check","Acabas de cambiar tú visibilidad",3500)
        end)
    end

    
    this.ActiveGodMode = function()
        RegisterNetEvent("Admin:Client:ActiveGodMode")
        AddEventHandler("Admin:Client:ActiveGodMode",function()

            this.GodModePlayer = not this.GodModePlayer
            if this.GodModePlayer then
                TriggerEvent("core:showNotification","check","Acabas de activar el modo dios",3500)    
                while this.GodModePlayer do
                    Wait(0)
                    SetPlayerInvincible(PlayerId(), true)
                end
                SetPlayerInvincible(PlayerId(), false)
            else 
                TriggerEvent("core:showNotification","check","Acabas de desactivar el modo dios",3500)    
            end
        end)
    end

    this.SetPlayerPed = function()
        RegisterNetEvent("Admin:Client:SetPlayerPed")
        AddEventHandler("Admin:Client:SetPlayerPed",function(skin,skinData)
            local ped = PlayerPedId()
            local model = GetHashKey(skin)
        
            SetEntityInvincible(ped, true)
            if skin == "normal" then
                Core.Player.SpawnController.SetPlayerModel(skinData.gender,skinData.skin)
                TriggerEvent("core:showNotification","check","Se ha restablecido tu personaje",3500)
            else
                if IsModelInCdimage(model) and IsModelValid(model) then
                    TriggerEvent("core:showNotification","check","Se te ha puesto la ped correctamente",3500)
                    RequestModel(skin)
                    while not HasModelLoaded(skin) do
                      Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
        
                    if isPedAllowedRandom(skin) then
                        SetPedRandomComponentVariation(ped, true)
                    end
    
                    SetModelAsNoLongerNeeded(model)    

                end               
            end
            SetEntityInvincible(ped, false)
        end)    
    end

    this.SetFreezePlayer = function()
        RegisterNetEvent("Admin:Client:FreezePlayer")
        AddEventHandler("Admin:Client:FreezePlayer",function()
            local target = PlayerPedId()
            if not this.PlayerFrozen then
                this.PlayerFrozen = true
                FreezeEntityPosition(target, true)
            else
                this.PlayerFrozen = false
                FreezeEntityPosition(target, false)
            end
        end)
    end

    this.DiedPlayer = function()
        RegisterNetEvent("Admin:Client:DiedPlayer")
        AddEventHandler("Admin:Client:DiedPlayer",function()
            SetEntityHealth(GetPlayerPed(-1),0)
        end)
    end

    this.SpectatePlayer = function()
        RegisterNetEvent("AdminSystem:client:SpectatePlayer")
        AddEventHandler("AdminSystem:client:SpectatePlayer",function(targetplayer)
            local ped = PlayerPedId()
            if not this.SpecPlayer then
                this.SpecPlayer = true
                SetEntityVisible(ped, false) 
                SetEntityCollision(ped, false, false) 
                SetEntityInvincible(ped, true) 
                NetworkSetEntityInvisibleToNetwork(ped, true) 
                this.LastSpectateCoord = GetEntityCoords(ped) 
                NetworkSetInSpectatorMode(true, targetplayer)
            else
                this.SpecPlayer = false
                NetworkSetInSpectatorMode(false, targetplayer)
                NetworkSetEntityInvisibleToNetwork(ped, false) 
                SetEntityCollision(ped, true, true) 
                SetEntityCoords(ped, this.LastSpectateCoord) 
                SetEntityVisible(ped, true)
                SetEntityInvincible(ped, false) 
                this.LastSpectateCoord = nil 
                
            end
        end)
    end

    return this
end