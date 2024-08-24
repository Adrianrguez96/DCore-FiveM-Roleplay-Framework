VehicleController = function (playerController)

    local this = {}

    this.Pcontroller = playerController

    this.Vehicles = {}

    this.InitVehicles = function (vehicles)
        for k, v in pairs(vehicles) do
            this.Vehicles[v.id] = Vehicle(v)
        end

        --Vehicle events 
        this.LoadAllPlayerVehicles()
    end

    --Load all player vehicles
    this.LoadAllPlayerVehicles = function()
        RegisterNetEvent("Core:server:SetPlayerVehicles")
        AddEventHandler("Core:server:SetPlayerVehicles", function(playerid)

            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local Player = this.Pcontroller.Players[identifier][playerid]
            local playerVehicles = Player.GetVehicles()

            TriggerClientEvent("Core:client:SpawnPlayerVehicles", src, playerVehicles)
        end)
    end

    return this
end