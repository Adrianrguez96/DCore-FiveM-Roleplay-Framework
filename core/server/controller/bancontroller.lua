BanController = function ()

    local this = {}

    this.Bans = {}

    --Load ban
    this.InitBans = function(bans)
        for _,ban in pairs(bans) do
            this.Bans[ban.identifier] = Ban(ban)
        end
    end

    --Player is banned 
    this.IsPlayerBanned = function(identifier)
        local ban = this.Bans[identifier]
        local isBan = false
        local reason = ""
        local time = ""
        if ban then 
            local banData = ban.BanClientEntity()
            if os.time() < tonumber(banData.time) then
                isBan = true
                reason = banData.reason
                time = banData.time
            else
                this.Bans[ban.identifier] = nil
            end
        end

        return isBan, time, reason
    end

    -- Register ban event
    this.AddBan = function(src,time,reason)
        local identifier = GetPlayerIdentifiers(src)[1]
        local steamName = GetPlayerName(src)

        Core.Database.RegisterBan({
            keys = {
                'identifier',
                'steamName',
                'time',
                'reason'
            },
            values = {
                identifier,
                steamName,
                time,
                reason
            }
        },function(banEntity)
            this.Bans[identifier] = Ban(banEntity)
        end)
    end

    return this
end