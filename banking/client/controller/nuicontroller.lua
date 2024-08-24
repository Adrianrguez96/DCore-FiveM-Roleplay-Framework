NuiController = function()
    local this = {}

    this.Run = function()
        this.CloseMenu()
    end

    this.CloseMenu = function()
        RegisterNUICallback('close', function(data, cb)
            SetNuiFocus(false,false)
        end)
    end

    return this
end