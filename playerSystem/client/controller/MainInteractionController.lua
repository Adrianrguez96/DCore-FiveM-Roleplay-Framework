MainInteractionController = function (InteractionPlayerController) 

    local this = {}

    this.InteractionPlayer = InteractionPlayerController

    this.Run = function()
        this.KeyboardEvents()
    end

    this.KeyboardEvents = function ()
        Citizen.CreateThread (function()
            while true do
                Citizen.Wait(1)
                if IsControlJustPressed(1, 183) then
                    local player, distance = Core.Player.GetClosestPlayer()
                    if player ~= -1 and distance < 2.5 then
                        this.InteractionPlayer.InteractionMenu(player)
                    end
                elseif IsControlPressed(1,19) then
                    for _, id in pairs(GetActivePlayers()) do
                        local targetCoords = GetEntityCoords(GetPlayerPed(id))
                        if #(targetCoords -  GetEntityCoords(PlayerPedId())) < 5 then
                            Core.Utility.DrawText3D(targetCoords.x,targetCoords.y,targetCoords.z + 1.0, 0.5, GetPlayerServerId(id))
                        end
                    end
                end
            end
        end)
    end

    return this
end