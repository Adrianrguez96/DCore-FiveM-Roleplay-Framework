Notifications = function()

    local this = {}

    this.Init = function()
        this.ShowNotification()
    end

    this.ShowNotification = function ()
        RegisterNetEvent('core:showNotification')
        AddEventHandler('core:showNotification', function(typeMessage,message,time)
        
            SendNUIMessage({
                type = 'notification',
                typeMessage = typeMessage,
                message = message,
                time = time
            })
        end)

        RegisterNetEvent('core:showNotificationAbove')
        AddEventHandler('core:showNotificationAbove', function(message)
        
            SendNUIMessage({
                type = 'notification-above',
                message = message     
            })
        end)
    end

    return this
end

local Notifications = Notifications()
Notifications.Init()