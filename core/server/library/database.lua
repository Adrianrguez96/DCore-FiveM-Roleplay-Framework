Database = function ()
    local this = {}

    -- Insert to data in database
    this.Insert = function (nameTable,data,cb)
        for v in pairs(data.values) do
            data.values[v] = "\'" .. data.values[v].. "\'"
        end 
    
        local key = table.concat(data.keys,",")
        local value = table.concat(data.values,",")
    
        local SQL = string.format("INSERT INTO %s (%s) VALUES (%s)",nameTable,key,value)
    
        MySQL.Async.insert(SQL,{},function(insertid) 
            return cb(insertid)
        end)
    end

    -- Select all data in database
    this.SelectAll = function(sql,cb)
        MySQL.Async.fetchAll(sql, {} ,function(result)
            return cb(result)
        end)
    end

    -- Select a specific data in database
    this.SelectByOne = function (sql,data,cb)

        local SQL = string.format("%s WHERE %s = %s",sql,data.key,data.value)

        MySQL.Async.fetchAll(SQL, {} ,function(result)
            return cb(result[1])
        end)
    end
    
    -- Update a specific data in database 
    this.Update = function(nameTable,update,data,cb)

        for v in pairs(update.values) do
            update.values[v] =  update.keys[v] .. "=".. "\'" .. update.values[v].. "\'"
        end

        local value = table.concat(update.values,",")
        local SQL = string.format("UPDATE %s SET %s WHERE %s = %s",nameTable,value,data.key,data.value)
        
        MySQL.Async.execute(SQL,{},function(affectedRows) 
            print(SQL)
            return cb
        end)
    end

    -- Delete a specific data in database
    this.Delete = function(nameTable,data,cb)

        local SQL = string.format("DELETE FROM %s WHERE %s = %s",nameTable,data.key,data.value)

        MySQL.Async.execute(SQL, {} ,function(affectedRows)
            print(SQL)
            return cb
        end)
    end
    
    return this
end
Core.Database = Database()   