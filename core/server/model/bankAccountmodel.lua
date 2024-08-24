Core.Database.GetBankAccount = function(callback) 
    Core.Database.SelectAll("SELECT * FROM player_accounts",function(result)
        return callback(result or {})
    end)
end

Core.Database.CreateBankAccount = function(bankAccount,cb)
    Core.Database.Insert("player_accounts",bankAccount, function(id)
        return cb(id)
    end)
end

Core.Database.GetAccount = function(id,cb)
    Core.Database.SelectByOne("SELECT * FROM player_accounts",{key= 'id',value = id},function(account)
        return cb(account)
    end)
end

Core.Database.CreateBankAccount = function(registerData,cb)
    Core.Database.Insert("player_accounts",registerData, function(id)
        Core.Database.GetAccount (id, function(account)
            return cb(account)
        end)
    end)
end

Core.Database.Test = function()
    print("Test")
end