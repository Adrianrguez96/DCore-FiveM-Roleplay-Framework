Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            --Active controllers
            local bank = BankController()
            local nui = NuiController()

            bank.Run()
            nui.Run()

            break   
        end
        Wait(0)
    end
end)
