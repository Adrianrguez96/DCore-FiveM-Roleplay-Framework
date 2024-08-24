Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            local BasicVehicleController = BasicVehicleController()

            BasicVehicleController.Run()
            break   
        end
        Wait(0)
    end
end)
