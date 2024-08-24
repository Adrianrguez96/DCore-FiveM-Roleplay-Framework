Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 

            local Inventory = InventoryController()
            local NUI = NuiController(Inventory)

            Inventory.Run()
            NUI.Run()
            
            break   
        end
        Wait(0)
    end
end)