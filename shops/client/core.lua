Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            
            ClotherShop = ClotherShopController()
            NuiController = NuiController()

            ClotherShop.Run()
            NuiController.Run()
            break   
        end
        Wait(0)
    end
end)
