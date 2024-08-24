Core.Database.GetBans = function(callback) 
    Core.Database.SelectAll("SELECT * FROM bans", function(result)
        return callback(result or {})
    end)
end

Core.Database.RegisterBan = function(banData)
    Core.Database.Insert("bans",banData)
end