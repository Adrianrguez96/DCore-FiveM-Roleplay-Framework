Core.Database.GetVehicles = function(callback) 
    Core.Database.SelectAll("SELECT * FROM vehicles",function(result)
        return callback(result or {})
    end)
end