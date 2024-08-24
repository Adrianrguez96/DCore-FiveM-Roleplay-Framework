InteractionPlayerController = function ()

    local this = {}

    this.InteractionMenu = function (targetPlayer)
        Core.Menu.CreateWheelMenu({
            {
                header = "Dar dinero",
                params = {
                    event = "InteractionPlayer:GiveMoney",
                    args = {
                        targetPlayer =  targetPlayer
                    }
                }
            },
            {
                header = "Dar número de telefono",
                params = {
                    event = "VehicleSystem:DoorState",
                    args = {
                        targetPlayer =  targetPlayer
                    }
                }
            },
            {
                header = "Cargar persona",
                params = {
                    event = "InteractionPlayer:CarryPerson",
                    args = {
                        targetPlayer =  targetPlayer
                    }
                }
            },
            {
                header = "Tomar como rehen",
                params = {
                    event = "InteractionPlayer:TakeHostage",
                    args = {
                        targetPlayer =  targetPlayer
                    }
                }
            }
        })
    end

    return this 
end