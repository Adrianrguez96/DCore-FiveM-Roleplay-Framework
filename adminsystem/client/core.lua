Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 

            local Admin = AdminController()
            local Nui = NuiController()
            local NoClip = NoClipController()

            Admin.Run()
            Nui.Run()
            NoClip.Run()
            
            break   
        end
        Wait(0)
    end
end)