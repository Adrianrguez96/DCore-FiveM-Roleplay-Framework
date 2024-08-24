MainController = function()
    local this = {}

    this.ServerTime = Config.ServerTime
    this.TimeOffset = Config.TimeOffset

    this.init = function ()
        -- Load events 
        this.PlayerConnecting()
        this.PlayerDisconnecting()
        this.OnResourseStarted()
        this.SyncTime()
    end

    -- Function to player connect in server
    this.PlayerConnecting = function ()
        AddEventHandler("playerConnecting", function(name, setKickReason, deferrals) 
            local src = source
            local steamIdentifier 
            local identifiers = GetPlayerIdentifiers(src)
            
            deferrals.defer()
        
            for _, v in pairs(identifiers) do
                if string.find(v, "steam") then
                    steamIdentifier = v
                    break
                end
            end
        
            Wait(0)
            if not steamIdentifier then 
                deferrals.done("\n\n[ERROR 412]: Es necesario que tengas tú steam abierto para poder acceder al servidor.")
            else
                local isBan, time, reason = Core.Ban.IsPlayerBanned(steamIdentifier)
                if not isBan then
                    if Core.WhiteList.IsPlayerWhiteList(steamIdentifier) and Config.WhitelistActive then

                        Core.Helper.PrintColor(string.format("[Conexión]: Usuario %s con identificador %s esta entrando al servidor",name,steamIdentifier),"green")
                        deferrals.done()
                        
                    else deferrals.done("\n\nNecesitas tener el rango whitelist para poder acceder al servidor.")
                    end
                else 
                    local tableTime = os.date("*t",time)
                    deferrals.done(string.format("\n\nTú cuenta ha sido baneada hasta el %s/%s/%s a las %s:%s por la siguiente razón:\n\n %s",
                    tableTime["day"],
                    tableTime["month"],
                    tableTime["year"],
                    tableTime["hour"],
                    tableTime["min"],
                    reason
                ))
                end
            end
        end)
    end

    -- Function tu player disconect to server
    this.PlayerDisconnecting = function()
        AddEventHandler("playerDropped",function(reason)

            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local playerName = GetPlayerName(src)

            -- Save player when disconnect
            TriggerEvent("Core:client:UpdatePlayerCoords")
            Core.Player.RemoveOnlinePlayer(identifier)

            Core.Helper.PrintColor(string.format("[Desconexión]: Usuario %s con identificador %s se ha desconectado por la siguiente razón: %s",
            playerName,identifier,reason),"red")
        end)
    end

    -- Function to control other core resourses 
    this.OnResourseStarted = function()
        AddEventHandler('onServerResourceStart', function(resName)
            Wait(500)
            for _, player in ipairs(GetPlayers()) do
                Core.Commands.Refresh(player)
            end
        end)
    end

    this.SyncTime = function()
        local previous = 0
        Citizen.CreateThread(function()
            while true do
                local newBaseTime = os.time(os.date("!*t"))/2 + 360
                if (newBaseTime % 60) ~= previous then
                    previous = newBaseTime % 60
                end
                this.ServerTime = newBaseTime
                TriggerClientEvent("core:client:syncTime", -1, this.ServerTime, this.TimeOffset)
                Citizen.Wait(2000)
            end
        end)
    end

    return this
end