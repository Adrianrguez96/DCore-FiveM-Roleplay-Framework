Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:server:GetFramework", function(core) Core = core end)
        if Core.Status then 
            break   
        end
        Wait(0)
    end
end)