Core.Database.GetWhiteLists = function(callback) 
    Core.Database.SelectAll("SELECT * FROM whitelists", function(result)
        return callback(result or {})
    end)
end