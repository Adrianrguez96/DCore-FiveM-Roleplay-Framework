MenuController = function()
    local this = {}

    this.isServer = false

    this.init = function()
        this.CloseMenuNui()
        this.ClickOptionNui()
    end
    
    this.CreateMenu = function(title,options,isServer)
        this.isServer = isServer or false
        SetNuiFocus(true,true)
        SendNUIMessage({
            action='OpenMenu',
            title = title,
            options = options
        })
    end

    this.CreateWheelMenu = function(options,isServer)
        this.isServer = isServer or false
        SetNuiFocus(true,true)
        SendNUIMessage({
            action='OpenWheelNav',
            options = options
        })
    end

    this.CloseMenuNui = function()
        RegisterNUICallback("closeMenu",function(data,cb)
            SetNuiFocus(false)
        end)
    end

    this.CloseWheelMenu = function()
        SendNUIMessage({action='CloseWheelMenu'})
    end

    this.ClickOptionNui = function()
        RegisterNUICallback("clickedOption",function(data,cb)
            PlaySoundFrontend(-1, 'Highlight_Cancel','DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
            if data.event then
                local args = data.args or ""

                if this.isServer then
                    if args == "" then 
                        TriggerServerEvent(data.event)
                    else 
                        TriggerServerEvent(data.event,args)
                    end
                else
                    if args == "" then 
                        TriggerEvent(data.event)
                    else 
                        TriggerEvent(data.event,args)
                    end
                end
            end
            SetNuiFocus(false)
        end)
    end

    return this
end