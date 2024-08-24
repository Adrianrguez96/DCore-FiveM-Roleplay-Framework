PlayerHudController = function(VehicleHudController)

    local this = {}

    this.vhudController = VehicleHudController

    this.Run = function()
        this.OnPlayerConnect()
        this.PlayerHudUpdate() 
    end

    this.OnPlayerConnect = function()
        RegisterNetEvent("core:client:playerConnect")
        AddEventHandler("core:client:playerConnect",function(player)
            this.UpdateHud()
        end)
    end

    this.UpdateHud = function()
        Citizen.CreateThread(function()
            while true do 
                TriggerServerEvent("hud:server:updateData",source)
                this.vhudController.VehicleHudUpdate()
                Citizen.Wait(200)
            end
        end)
    end

    this.PlayerHudUpdate = function () 
        RegisterNetEvent("hud:client:updateData")
        AddEventHandler("hud:client:updateData", function(hunger,thirsty)
            local player = PlayerPedId()
    

            
            SendNUIMessage({
                action = 'updateStatus',
                health = GetEntityHealth(player) - 100,
                hunger = hunger,
                thirsty = thirsty,
                armour = GetPedArmour(player),
                inWater = IsPedSwimming(player),
                oxygenTime = GetPlayerUnderwaterTimeRemaining(player),
                showHud = IsPauseMenuActive(),
            })
        end)
    end

    return this
end