Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:server:GetFramework", function(core) Core = core end)
        if Core.Status then
            local PlayerHudController = PlayerHudController()
            PlayerHudController.Run()
            break   
        end
        Wait(0)
    end
end)
