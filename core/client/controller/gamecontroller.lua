GameController = function()
    local this = {}

    -- Variable sync time and weather 
    this.ServerTime = Config.ServerTime
    this.TimeOffset = Config.TimeOffset
    this.Timer = 0

    this.init = function()
        this.ServerTimeSync()
    end

    this.ServerTimeSync = function()
        RegisterNetEvent("core:client:syncTime")
        AddEventHandler("core:client:syncTime", function(serverTime, offset)
            this.serverTime = serverTime
            this.timeOffset = offset
        end)
    end

    return this

end