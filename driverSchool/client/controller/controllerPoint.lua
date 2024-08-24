ControllerPoint = function(controllerPractical)
    local this = {}

    this.PracticalTest = controllerPractical

    this.Run = function()
        this.OpenDMVMenu()
    end

    this.OpenDMVMenu = function()
        Citizen.CreateThread(function()
            while true do
                local Sleep
        
                local PlayerCoords = GetEntityCoords(PlayerPedId())

                if  #(PlayerCoords - Config.LicencePoint) < 3.0 then   
                    if IsControlJustPressed(1,Config.ControlKey) then
                        if(this.PracticalTest.typeTest == nil) then
                            Core.Menu.CreateMenu("Licencia a solicitar la prueba",Config.DMVMenu,false)
                        else
                            TriggerEvent("core:showNotification","error","Actualmente estas ya estas cogiendo una licencia",3500)
                        end
                    end
                    Sleep = 3
                else
                    Sleep = 2000
                end
                Wait(Sleep)
            end
        end)
    end

    return this
end