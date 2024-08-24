DeathController = function()
    local this = {}

    this.alreadyDied = false
    this.isInHospital = false
    this.HospitalTime = Config.HospitalTimer
    this.diedTimer = Config.DiedTimer

        --Event to player death
        this.PlayerDeath = function()
            local playerPed = PlayerPedId()
            if IsEntityDead(playerPed) then
                if not this.alreadyDied then

                    while GetEntitySpeed(playerPed) > 0.5 or IsPedRagdoll(playerPed) do
                        Wait(10)
                    end

                    this.alreadyDied = true
                    local pos = GetEntityCoords(playerPed)
                    TriggerServerEvent("core:server:playerDied",true)

                    if IsPedInAnyVehicle(playerPed,true) then
                        local veh = GetVehiclePedIsIn(playerPed)
                        local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
                        for i = -1, vehseats do
                            local occupant = GetPedInVehicleSeat(veh, i)
                            if occupant == playerPed then
                                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                                SetPedIntoVehicle(playerPed, veh, i)
                            end
                        end
                    else
                        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                    end
                    SetEntityInvincible(playerPed, true)
                    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
                    if IsPedInAnyVehicle(playerPed, false) then
                        Core.Utility.RequestAnimDict("veh@low@front_ps@idle_duck")
                        TaskPlayAnim(playerPed, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    else
                        print("Muerto en calle")
                        Core.Utility.RequestAnimDict("dead")
                        TaskPlayAnim(playerPed, "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                    this.DiedTimer()
                    this.ReviveLoop()
                end
            end
        end

        -- Provisional place to loop
        this.ReviveLoop = function()
            while this.alreadyDied or this.isInHospital do

                DisableAllControlActions(0)
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                EnableControlAction(0, 245, true)
                EnableControlAction(0, 38, true)
                EnableControlAction(0, 0, true)
                EnableControlAction(0, 322, true)
                EnableControlAction(0, 288, true)
                EnableControlAction(0, 213, true)
                EnableControlAction(0, 249, true)
                EnableControlAction(0, 46, true)
                EnableControlAction(0, 47, true)

                if not this.isInHospital then
                    if IsControlJustReleased(0, 46) and this.diedTimer <= 0 then
                        local ped = PlayerPedId()
                        this.alreadyDied = false
                        this.isInHospital = true
                        NetworkResurrectLocalPlayer(292.08,-607.44,43.35, true, true, false)
                        SetPlayerInvincible(ped, false)
                        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
                        ClearPedBloodDamage(ped)
                        Core.Utility.RequestAnimDict("missfbi1")
                        TaskPlayAnim(ped, "missfbi1", "cpr_pumpchest_idle", 8.0, -8.0, -1, 1, 0, false, false, false)
                        this.HospitalTimer()
                    end
                end
                Citizen.Wait(3)
            end
        end

        this.HospitalTimer = function()
            CreateThread(function() 
                while this.isInHospital do
                    if this.HospitalTime < 0 then
                        this.HospitalTime = Config.HospitalTimer
                        this.isInHospital = false
                        TriggerEvent("core:showNotificationAbove")
                        local ped = PlayerPedId()
                        if IsEntityPlayingAnim(ped,"missfbi1", "cpr_pumpchest_idle", 3) then
                            StopAnimTask(ped,"missfbi1", "cpr_pumpchest_idle", 3)
                            this.diedTimer = Config.DiedTimer
                        end
                    else
                        this.HospitalTime = this.HospitalTime - 1
                        TriggerEvent("core:showNotificationAbove","Espera tranquilamente hasta que te recuperes bien")
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
        

        this.DiedTimer = function()
            CreateThread(function() 
                while this.diedTimer > 0 do
                    this.diedTimer = this.diedTimer - 1
                    if (this.diedTimer > 0) then
                        TriggerEvent("core:showNotificationAbove","Te quedan " .. tostring(this.diedTimer) .. " segundos para peder la conciencia")
                    else
                        TriggerEvent("core:showNotificationAbove","Pulsa E para proceder a revivir")
                    end

                    Citizen.Wait(1000)
                end
                this.HospitalTimer()
            end)
        end
    return this
end
