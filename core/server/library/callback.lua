Callback = function()
    local this = {}

    this.ServerCallbacks = {}

    this.init = function()
        this.EventTriggerCallback()
    end

    this.Create = function(name, cb)
        this.ServerCallbacks[name] = cb
    end

    this.Trigger = function(name, source, cb, ...)
        if this.ServerCallbacks[name] ~= nil then
            this.ServerCallbacks[name](source, cb, ...)
        end
    end

    this.EventTriggerCallback = function()
        RegisterServerEvent("Core:Server:TriggerCallback")
        AddEventHandler('Core:Server:TriggerCallback', function(name, ...)
            local src = source
            this.Trigger(name, src, function(...)
                TriggerClientEvent("Core:Client:TriggerCallback", src, name, ...)
            end, ...)
        end)
    end

    return this
end