BasicVehicleController = function()
    local this = {}

    this.Run = function()
        this.KeyOpenMenuVehicleSystem()
        this.BasicVehicleEvents()
    end

    this.KeyOpenMenuVehicleSystem = function ()
        Citizen.CreateThread (function()
            while true do
                Citizen.Wait(1)
                if IsControlJustPressed(1, 183) then
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                        this.CreateWheelMenu()
                    end
                end
            end
        end)
    end

    this.CreateWheelMenu = function()
        Core.Menu.CreateWheelMenu({
            {
                header = "Encender/Apagar motor",
                params = {
                    event = "VehicleSystem:Engine"
                }
            },
            {
                header = "Abrir/cerrar capo",
                params = {
                    event = "VehicleSystem:DoorState",
                    args = {
                        type = "hood"
                    }
                }
            },
            {
                header = "Abrir/cerrar maletero",
                params = {
                    event = "VehicleSystem:DoorState",
                    args = {
                        type = "trunk"
                    }
                }
            },
            {
                header = "Abrir/cerrar puertas",
                params = {
                    event = "VehicleSystem:WheelMenuDoors",
                }
            }
        })
    end

    this.BasicVehicleEvents = function ()
        AddEventHandler("VehicleSystem:DoorState",function(args)

            local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
            if args.type == "hood" then
                if  GetVehicleDoorAngleRatio(Vehicle,4) == 0 then
                    SetVehicleDoorOpen(Vehicle,4,0,0)
                else
                    SetVehicleDoorShut(Vehicle,4,0,0)
                end
            
            elseif args.type == "trunk" then
                if  GetVehicleDoorAngleRatio(Vehicle,5) == 0 then
                    SetVehicleDoorOpen(Vehicle,5,0,0)
                else
                    SetVehicleDoorShut(Vehicle,5,0,0)
                end
            elseif args.type == "door" then
                if  GetVehicleDoorAngleRatio(Vehicle,args.doorIndex) == 0 then
                    SetVehicleDoorOpen(Vehicle,args.doorIndex,0,0)
                else
                    SetVehicleDoorShut(Vehicle,args.doorIndex,0,0)
                end
            end
        end)

        AddEventHandler("VehicleSystem:WheelMenuDoors",function()
            Wait(0)
            Core.Menu.CreateWheelMenu({
                {
                    header = "Conductor",
                    params = {
                        event = "VehicleSystem:DoorState",
                        args = {
                            type = "door",
                            doorIndex = 0
                        }
                    }
                },
                {
                    header = "Pasajero derecha",
                    params = {
                        event = "VehicleSystem:DoorState",
                        args = {
                            type = "door",
                            doorIndex = 3
                        }
                    }
                }, 
                {
                    header = "Copiloto",
                    params = {
                        event = "VehicleSystem:DoorState",
                        args = {
                            type = "door",
                            doorIndex = 1
                        }
                    }
                },
                {
                    header = "Pasajero izquierda",
                    params = {
                        event = "VehicleSystem:DoorState",
                        args = {
                            type = "door",
                            doorIndex = 2
                        }
                    }
                }
            })
        end)

        AddEventHandler("VehicleSystem:Engine",function()
            local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if Vehicle ~= nil and Vehicle ~= 0 and GetPedInVehicleSeat(Vehicle, 0) then
                SetVehicleEngineOn(Vehicle, (not GetIsVehicleEngineRunning(Vehicle)), false, true)
            end
        end)
    end

    return this
end