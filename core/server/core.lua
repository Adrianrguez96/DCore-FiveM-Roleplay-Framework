Core = {}
Core.Database = {}
Citizen.CreateThread(function()
    
    -- Load main controller and framework
    Framework = FrameworkController()
    Framework.init(function()
        local mainController = MainController()
        Core = Framework
        Core.Callback = Callback()
        Core.Callback.init()

        Core.Commands = Command()
        Core.Commands.init()
        
        mainController.init()
    end)   
end)
  