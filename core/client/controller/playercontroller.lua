PlayerController = function() 
    
    local this = {}

    this.init = function (spawn)

        -- Children controllers
        this.SpawnController = spawn

        -- Player events
        this.SetPlayersEvent()
        this.LoadPlayer()
        this.RegisterPlayer()
    end

    -- Event set player in client
    this.SetPlayersEvent = function()
        RegisterNetEvent("core:client:setPlayers")
        AddEventHandler("core:client:setPlayers",function(players)
            this.SpawnController.SpawnPlayerSelection(players)
        end)
    end

    -- Event to load player
    this.LoadPlayer = function()
        RegisterNetEvent("core:client:loadPlayer")
        AddEventHandler("core:client:loadPlayer",function(player,newRegister)

            local register = newRegister or false
            
            if register then 
                this.SpawnController.CutSceneRegisterPlayer(player) 
                return
            end

            if not this.SpawnController.PlayerLogin then 
                this.SpawnController.ChangePlayerSelection(player)
            else 
                this.SpawnController.SpawnPlayerInPosition(player) 
            end
        end)
    end

    -- Event to register player
     this.RegisterPlayer = function()
        RegisterNUICallback("registerPlayer",function(data,cb)
            this.SpawnController.SpawnPlayerInRegisterPosition(data)
            this.SpawnController.PlayerLogin  = true
        end)
    end
    
    -- Update player Coords
    this.UpdatePlayerCoords = function()
        TriggerServerEvent("Core:server:UpdatePlayerCoords",this.GetPlayerCoords(PlayerPedId()))
    end

    --Update player data 
    this.UpdatePlayerData = function ()

            local health = GetEntityHealth(PlayerPedId())
            local armour = GetPedArmour(PlayerPedId())

        TriggerServerEvent("core:server:UpdatePlayerData",source,health,armour)
    end
    
    -- Get the distance player and vehicle
    this.GetClosestVehicle = function(coords)
        local vehicles        = GetGamePool('CVehicle')
        local closestDistance = -1
        local closestVehicle  = -1
        local coords          = coords
        
        if coords == nil then
            local playerPed = PlayerPedId()
            coords = GetEntityCoords(playerPed)
        end
        for i=1, #vehicles, 1 do
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance = #(vehicleCoords - coords)
        
            if closestDistance == -1 or closestDistance > distance then
                closestVehicle  = vehicles[i]
                closestDistance = distance
            end
        end
        return closestVehicle, closestDistance
    end
        
    -- Get the distance ped to player
    this.GetClosestPed = function(coords, ignoreList) 
        local ignoreList      = ignoreList or {}
        local closestDistance = -1
        local closestPed      = -1
            
        if coords == nil then
            coords = GetEntityCoords(PlayerPedId())
        end
        
        for i=1, #peds, 1 do
            local pedCoords = GetEntityCoords(peds[i])
            local distance = #(pedCoords - coords)
        
            if closestDistance == -1 or closestDistance > distance then
                closestPed      = peds[i]
                closestDistance = distance
            end
        end
        
        return closestPed, closestDistance
    end
        
    -- Get player coords
    this.GetPlayerCoords = function(entity)
        local coords = GetEntityCoords(entity, false)
        local healding = GetEntityHeading(entity)
        return {
             x = coords.x,
            y = coords.y,
            z = coords.z,
            healding = healding
        }
    end
        
    -- Get all players in game
    this.GetPlayers = function()
        local players = {}
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                table.insert(players, player)
            end
        end
        return players
    end
        
    -- Get a distance from another player
    this.GetClosestPlayer = function(coords)
        if coords == nil then
            coords = GetEntityCoords(PlayerPedId())
        end
            
        local closestPlayers = this.GetPlayersFromCoords(coords)
        local closestDistance = -1
        local closestPlayer = -1
        
        for i=1, #closestPlayers, 1 do
            if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
                local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
                local distance = #(pos - coords)
        
                if closestDistance == -1 or closestDistance > distance then
                    closestPlayer = closestPlayers[i]
                    closestDistance = distance
                end
            end
        end
        
        return closestPlayer, closestDistance
    end
    
    -- Get Players positions 
    this.GetPlayersFromCoords = function(coords, distance)
        local players = this.GetPlayers()
        local closePlayers = {}
        if coords == nil then
            coords = GetEntityCoords(PlayerPedId())      
        end        
        if distance == nil then            
            distance = 5.0       
        end        
        for _, player in pairs(players) do            
            local target = GetPlayerPed(player)            
            local targetCoords = GetEntityCoords(target)            
            local targetdistance = #(targetCoords - coords)           
            if targetdistance <= distance then               
                table.insert(closePlayers, player)           
            end       
        end        
        return closePlayers
    end
    
    return this
end