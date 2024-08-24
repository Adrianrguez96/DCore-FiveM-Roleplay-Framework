Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            --Active controllers
            local PracticalTest = controllerPractical()
            local TheoricalTest = ControllerTheorical(PracticalTest)
            local DriverPoint = ControllerPoint(PracticalTest)
            local Nui = NuiController(PracticalTest)

            DriverPoint.Run()
            TheoricalTest.Run()
            Nui.Run()

            break   
        end
        Wait(0)
    end
end)
