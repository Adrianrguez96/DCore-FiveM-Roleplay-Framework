Citizen.CreateThread(function()

    local VehicleHud = VehicleHudController()
    local PlayerHud = PlayerHudController(VehicleHud)

    PlayerHud.Run()
    VehicleHud.Run()
end)