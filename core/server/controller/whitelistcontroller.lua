WhiteListController = function()
    local this = {}

    this.WhiteLists = {}

    this.InitWhiteLists = function(whitelists)
        for _,whitelist in pairs(whitelists) do
            this.WhiteLists[whitelist.identifier] = WhiteList(whitelist)
        end

        -- Whitelist events
        this.RegisterWhiteList()
    end

    --Player is whiteList
    this.IsPlayerWhiteList = function(identifier)
        if not this.WhiteLists[identifier] then return false
        else return true end
    end

    -- Get player whitelist by identifier
    this.GetPlayerWhitelist = function(identifier)
        return this.WhiteLists[identifier] or false
    end

    -- Know is player admin
    this.GetPlayerPermisions = function(identifier)
        local whitelist = this.WhiteLists[identifier]
        return whitelist.GetPlayerPermision()
    end
    
    -- Register whitelist event
    this.RegisterWhiteList = function()
        RegisterNetEvent("core:server:registerWhiteList")
        AddEventHandler("core:server:registerWhiteList", function()
    
        local src = source 
        local identifier = GetPlayerIdentifiers(src)[1]
        local steamName = GetPlayerName(src)
    
        Core.Database.RegisterWhiteList({
            keys = {
                'identifier',
                'steamName',
                'adminLevel'
                },
                values = {
                    identifier,
                    steamName,
                    'user' -- Not user admin
                }
            },function(whiteListEntity)
    
                local whitelist = WhiteList(whiteListEntity)
                this.AddWhiteList(whitelist)
            end)
        end)
    end

    return this
end