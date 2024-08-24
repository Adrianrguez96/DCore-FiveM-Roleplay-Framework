Core.Database.GetPlayers = function(callback) 
    Core.Database.SelectAll("SELECT * FROM players",function(result)
        return callback(result or {})
    end)
end

Core.Database.GetPlayer = function(id,cb)
    Core.Database.SelectByOne("SELECT * FROM players",{key= 'id',value = id},function(Player)
        return cb(Player)
    end)
end

Core.Database.RegisterPlayer = function(registerData,cb)
    Core.Database.Insert("players",registerData, function(id)
        Core.Database.GetPlayer (id, function(player)
            return cb(player)
        end)
    end)
end

Core.Database.SavePlayer = function(data,player,cb)
    Core.Database.Update("players",data,player)
end

Core.Database.GetAllPlayerVehicles = function(callback) 
    Core.Database.SelectAll("SELECT * FROM player_vehicles",function(result)
        return callback(result or {})
    end)
end

Core.Database.GetAllBankAccountsId = function(callback)
    Core.Database.SelectAll("SELECT id, playerid FROM player_accounts",function(result)
        return callback(result or {})
    end)
end

Core.Database.GetAllLicenses = function(callback)
    Core.Database.SelectAll("SELECT * FROM player_licences",function(result)
        return callback(result or {})
    end)
end