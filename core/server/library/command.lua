Command = function()

    local this = {}

    this.CommandList = {}

    this.init = function() 
        this.CommandChat()
        this.CallCommandEvent()
    end

    this.Add = function(name, help, arg, argsrequired, callback, permission)
        this.CommandList[name:lower()] = {
            name = name:lower(),
            permission = permission or 0,
            help = help,
            arg = arg,
            argsrequired = argsrequired,
            callback = callback
        }
    end

    this.CallCommand = function(source,command,args)
        local src = source
        if this.CommandList[command] then
            local hasPerm = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            
            if hasPerm >= this.CommandList[command].permission  or isPrincipal then
                if (this.CommandList[command].argsrequired and #this.CommandList[command].arg ~= 0 and args[#this.CommandList[command].arg] == nil) then
                    TriggerClientEvent("core:showNotification",src,"error","Faltan argumentos en el comando",3500)
                else
                    this.CommandList[command].callback(src, args)
                end
            else
                TriggerClientEvent("core:showNotification",src,"error","No tienes acceso a este comando",3500)
            end
        end
    end

    this.CommandChat = function()
        AddEventHandler('chatMessage', function(source, n, message)
            if string.sub(message, 1, 1) == '/' then
                local args = this.SplitStr(message, ' ')
                local command = string.gsub(args[1]:lower(), '/', '')
                table.remove(args, 1)
                CancelEvent()
                this.CallCommand(source,command,args)
            end
        end)
    end

    this.CallCommandEvent = function ()
        RegisterNetEvent("Core:CallCommand")
        AddEventHandler("Core:CallCommand",function(command,argument)
            local src = source
            local args = this.SplitStr(argument, ' ')
            this.CallCommand(src,command,args)
        end)
    end

    this.Refresh = function (source)
        local src = source
        local suggestions = {}

        for command, info in pairs(this.CommandList) do
            local hasPerm = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            local isPrincipal = IsPlayerAceAllowed(src, 'command')
            if hasPerm or isPrincipal then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end

    this.SplitStr = function(str, delimiter)
        local result = { }
        local from = 1
        local delim_from, delim_to = string.find(str, delimiter, from)
        while delim_from do
            table.insert(result, string.sub(str, from, delim_from - 1))
            from = delim_to + 1
            delim_from, delim_to = string.find(str, delimiter, from)
        end
        table.insert(result, string.sub(str, from))
        return result
    end
    

    return this
end