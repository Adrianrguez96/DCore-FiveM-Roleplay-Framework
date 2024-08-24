Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            
            local Job = JobController()
            local Police = PoliceController()
            local Medic = MedicController()
            local Government = GovernmentController()
            local Ilegal = IlegalController()

            Job.Run()
            Police.Run()
            Medic.Run()
            Government.Run()
            Ilegal.Run()
            break   
        end
        Wait(0)
    end
end)
