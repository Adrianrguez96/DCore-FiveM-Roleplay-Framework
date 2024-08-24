PlayerHudController = function()

    local this = {}

    this.Run = function()
        this.UpdatePlayerHud()
    end

    this.UpdatePlayerHud = function()
        RegisterNetEvent("hud:server:updateData")
        AddEventHandler("hud:server:updateData",function()
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local player = Core.Player.GetPlayerById(Core.Player.GetPlayerOnlineId(identifier))
            
            local hunger =  player.GetPlayerMeta("hunger")
            local thirsty = player.GetPlayerMeta("thirsty")
            TriggerClientEvent("hud:client:updateData",src,hunger,thirsty)
        end)
    end

    return this
end