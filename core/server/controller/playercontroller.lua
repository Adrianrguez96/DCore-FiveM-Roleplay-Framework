PlayerController = function() 

    local this = {}

    this.Players = {}
    this.PlayersById = {}
    this.OnlinePlayers = {}

    -- Main player function
    this.InitPlayers = function(players) 
        for _,player in pairs(players) do
            this.AddPlayer(player)
        end
        -- Init players
        this.InitPlayerVehicles()
        this.InitPlayerBankAccounts()
        this.InitPlayerLicense()

        -- Player events 
        this.RegisterPlayerEvent()
        this.SelectPlayerEvent()
        this.GetPlayerEvent()
        this.PlayerDeathEvent()
        this.UpdatePlayerCoords()
        this.UpdatePlayerData()
    end

    --Load all players in the BD to players
    this.AddPlayer = function(player) 
        if not this.Players[player.identifier] then
            this.Players[player.identifier] = {}
        end

        local player = Player(player)

        this.Players[player.identifier][player.id] = player
        this.PlayersById[player.id] = player.identifier
    end

    -- Init player vehicles 
    this.InitPlayerVehicles = function()
        Core.Database.GetAllPlayerVehicles(function(vehicles)
            for k,vehicle in pairs(vehicles) do
                local player = this.GetPlayerById(vehicle.playerid)
                
                if player then
                    player.AddVehicle(vehicle)
                end
            end
        end)
    end
    
    -- Init bank accounts
    this.InitPlayerBankAccounts = function()
        Core.Database.GetAllBankAccountsId(function(accountsid)
            for k, accountid in pairs(accountsid) do
                local player = this.GetPlayerById(accountid.playerid)
                if player then
                    player.AddBankAccountId(accountid.id)
                end
            end
        end)
    end

    -- Int player license
    this.InitPlayerLicense = function()
        Core.Database.GetAllLicenses(function(licenses)
            for k, license in pairs(licenses) do
                local player = this.GetPlayerById(license.playerid)
                if player then
                    player.AddLicense(license)
                end
            end
        end)
    end

    
    -- Get player by id 
    this.GetPlayerById = function(id)
        local identifier = this.PlayersById[id] or false
        if identifier then
            return this.Players[identifier][id] or false
        end
    end

    -- Get all players identities 
    this.GetAllPlayerIdentities = function()
        local players = {}

        for k, v in pairs(this.Players) do
            for _, player in pairs(v) do
                table.insert(players, player)
            end
        end

        return players
    end

    -- Add player in online player
    this.AddOnlinePlayer = function(identifier,playerid)
        this.OnlinePlayers[identifier] = playerid
    end

    -- Remove player in online player
    this.RemoveOnlinePlayer = function(identifier)
        this.OnlinePlayers[identifier] = nil
    end

    -- Get player id online
    this.GetPlayerOnlineId = function(identifier)
        return this.OnlinePlayers[identifier] or nil
    end

    -- Get player events
    this.GetPlayerEvent = function()
        RegisterNetEvent("core:server:getPlayers")
        AddEventHandler("core:server:getPlayers",function()
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]

            local players = {}

            for k,v in pairs(this.Players[identifier] or {}) do
                table.insert(players,v.PlayerClientEntity())
            end
            TriggerClientEvent("core:client:setPlayers", src, players)
        end)
    end
    
    -- Select Player
    this.SelectPlayerEvent = function ()
        RegisterNetEvent("core:server:selectplayer")
        AddEventHandler("core:server:selectplayer", function(data)

            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local id = data
            local clientPlayer = {}

            if this.Players[identifier] then
                for k,v in pairs(this.Players[identifier]) do
                    if v.id == id then
                        local player = this.Players[identifier][k]
                        clientPlayer = player.PlayerClientEntity()
                        this.AddOnlinePlayer(identifier,clientPlayer.id)
                        break
                    end
                end
            end
            Core.Commands.Refresh(src)
            TriggerClientEvent("core:client:loadPlayer", src, clientPlayer)
        end)
    end

    --Update player coords
    this.UpdatePlayerCoords = function()
        RegisterNetEvent("Core:server:UpdatePlayerCoords")
        AddEventHandler("Core:server:UpdatePlayerCoords", function(coords)
            
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local player = this.GetPlayerById(this.OnlinePlayers[identifier])

            player.UpdateCoords(coords)
        end)
    end

    -- Update player data
    this.UpdatePlayerData = function ()
        RegisterNetEvent("core:server:UpdatePlayerData")
        AddEventHandler("core:server:UpdatePlayerData", function(health,armour)
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            this.SavePlayerData(identifier)
        end)
    end

    --Save player data
    this.SavePlayerData = function(identifier)
        local player = this.GetPlayerById(this.OnlinePlayers[identifier])
        -- Update hungry and hungry and thirsty 
        local currentHunger = player.GetPlayerMeta("hunger")
        local currentThirsty = player.GetPlayerMeta("thirsty")

        if currentHunger <= 0 then currentHunger = 0 end
        if currentThirsty <= 0 then currentThirsty = 0 end

        player.SetPlayerMeta("hunger", currentHunger - Config.HungerLost)
        player.SetPlayerMeta("thirsty", currentThirsty - Config.ThirstyLost)
    end

    this.PlayerDeathEvent = function()
        RegisterNetEvent("core:server:playerDied")
        AddEventHandler("core:server:playerDied",function(state)
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local player = this.GetPlayerById(this.OnlinePlayers[identifier])
            player.ChangeDiedState(state)
        end)
    end

    -- Register player function
    this.RegisterPlayerEvent = function()
        RegisterNetEvent("core:server:RegisterPlayer")
        AddEventHandler("core:server:RegisterPlayer", function(data)

            local src = source 
            local identifier = GetPlayerIdentifiers(src)[1]
            Core.Database.RegisterPlayer ({
                keys = {
                    'identifier',
                    'name',
                    'lastName',
                    'gender',
                    'birthday',
                    'position',
                    'isDead',
                    'isRegister',
                    'height',
                    'money',
                    'job',
                    'skin',
                    'inventory',
                    'meta'
                },
                values = {
                    identifier,
                    data.name,
                    data.lastName,
                    data.gender,
                    data.birthday,
                    json.encode(Config.FirstSpawn),
                    0, -- When your register player is alive
                    0, -- This a first part to register
                    data.height,
                    Config.FirstMoney,
                    json.encode({whitelistJob = "unemployed", rank = "", onduty = 0, minorJob = "unemployed"}),
                    json.encode(data.skin), -- This is a skin player   
                    "[]",
                    json.encode({ 
                        health = 200,
                        armour = 0, 
                        hunger = 100,
                        thirsty = 100
                    }) -- Meta player data
                }
            }, function(playerEntity)
                local player = Player(playerEntity)
                local clientPlayer = player.PlayerClientEntity()
                this.AddPlayer(player)

                
                TriggerClientEvent("core:client:loadPlayer", src, clientPlayer,true)

            end)
        end)
    end
    
    return this
end