Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:server:GetFramework", function(core) Core = core end)
        if Core.Status then 
            local Job = JobController()

            Job.Run()
            break   
        end
        Wait(0)
    end
end)