Core.Database.GetItems = function(callback) 
    Core.Database.SelectAll("SELECT * FROM items",function(result)
        return callback(result or {})
    end)
end