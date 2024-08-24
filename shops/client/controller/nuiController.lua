NuiController = function ()
    local this = {}

    this.Run = function()
        this.CancelNuiClother()
    end


    this.CancelNuiClother = function()
        RegisterNUICallback("cancel", function(data)
            print("va")
            SetNuiFocus(false,false)
        end)
    end
    return this
end
