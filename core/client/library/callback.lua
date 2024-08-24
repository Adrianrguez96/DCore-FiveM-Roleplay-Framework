Callback = function()
    local this = {}

    this.ServerCallbacks = {}

    this.init = function()
        this.EventTriggerCallback()
    end

    this.Trigger = function(name, cb, ...)
        this.ServerCallbacks[name] = cb
        TriggerServerEvent("Core:Server:TriggerCallback", name, ...)   
    end

    this.EventTriggerCallback = function()
        RegisterNetEvent('Core:Client:TriggerCallback')
        AddEventHandler('Core:Client:TriggerCallback', function(name, ...)
            if this.ServerCallbacks[name] ~= nil then
                this.ServerCallbacks[name](...)
                this.ServerCallbacks[name] = nil
            end
        end)
    end

    return this
end