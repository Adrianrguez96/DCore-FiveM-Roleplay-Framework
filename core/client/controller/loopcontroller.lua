LoopController = function (PlayerController,DeathController,VehicleController,ItemController,GameController)

    local this = {}

    this.pController = PlayerController
    this.dController = DeathController
    this.vController = VehicleController
    this.iController = ItemController
    this.gController = GameController

    this.hour = 0
    this.minute = 0
    this.second = 0

    -- Active the main player loops
    this.InitPlayerLoops = function()
        this.LoopOnePerFramePlayer()
        this.SaveDataPlayer()
        this.DetectAroundDropItem()
    end

    -- Loop one per player frame 
    this.LoopOnePerFramePlayer = function()
        Citizen.CreateThread(function()
            while true do 
                Citizen.Wait(1)
                this.DisableGTAHud()
                this.DropPoint()
                this.TimerSync()
                this.DisableVehicleAirControl()
            end
        end)
    end

    -- Loop to disable GTA hud
    this.DisableGTAHud = function()
        HideHudComponentThisFrame(2) -- Weapon icons 
        HideHudComponentThisFrame(3) -- Cash 
        HideHudComponentThisFrame(4) -- MP Cash
        HideHudComponentThisFrame(6) -- Vehicle name 
        HideHudComponentThisFrame(7) -- Area name
        HideHudComponentThisFrame(8) -- Vehicle class
        HideHudComponentThisFrame(9) -- Street name
        HideHudComponentThisFrame(19) -- Weapon wheel
        HideHudComponentThisFrame(20) -- Weapon wheel stats
        HudWeaponWheelIgnoreSelection() -- Block de weapon selection
    end

    --Loop to detect the item in the position 
    this.DetectAroundDropItem = function()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(500)
                if this.iController.ItemDrops ~= nil and next(this.iController.ItemDrops) ~= nil then
                    local coords = GetEntityCoords(PlayerPedId(),true)
                    for k,drop in pairs(this.iController.ItemDrops) do
                        if this.iController.ItemDrops[k] ~= nil then
                            local position = #(coords - vector3(drop.coords.x,drop.coords.y,drop.coords.z))
                            if position < 7.5 then 
                                this.iController.ItemDropsNear[k] = drop
                                if position < 2 then 
                                    this.iController.CurrentDrop = k
                                else 
                                    this.iController.CurrentDrop = nil 
                                end
                            else
                                this.iController.ItemDropsNear[k] = nil
                            end
                        end
                    end
                else
                    table.remove(this.iController.ItemDropsNear)
                end

                this.dController.PlayerDeath()
            end
        end)
    end

    -- Create a drop point 
    this.DropPoint = function()
        if this.iController.ItemDropsNear ~= nil then
            for k, item in pairs(this.iController.ItemDropsNear) do
                if this.iController.ItemDropsNear[k] ~= nil then
                    DrawMarker(
                        2, 
                        item.coords.x, 
                        item.coords.y, 
                        item.coords.z - 0.5,
                         0.0, 
                         0.0, 
                         0.0, 
                         0.0, 
                         0.0, 
                         0.0, 
                         0.2, 
                         0.2, 
                         0.1, 
                         255, 
                         255, 
                         255, 
                         155, 
                         false, false, false, false, false, false, false)
                end
            end
        end
    end

    --Loop control to save player data 
    this.SaveDataPlayer = function()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(300000)
                this.pController.UpdatePlayerData()
                this.pController.UpdatePlayerCoords()
            end
        end)
    end
    
    --Sync server timer
    this.TimerSync = function()
        local newServerTime = this.gController.ServerTime
        if GetGameTimer() - 22  > this.gController.Timer then
            this.second = this.second + 1
            this.gController.Timer = GetGameTimer()
        end
        this.gController.ServerTime = newServerTime
        this.hour = math.floor(((this.gController.ServerTime + this.gController.TimeOffset)/60)%24)
        if this.minute ~= math.floor((this.gController.ServerTime + this.gController.TimeOffset)%60) then  
            this.minute = math.floor((this.gController.ServerTime + this.gController.TimeOffset)%60)
            this.second = 0
        end
        NetworkOverrideClockTime(this.hour, this.minute, this.second)
    end

    --Disable vehicle air control
    this.DisableVehicleAirControl = function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) and IsEntityInAir(veh) then
            local model = GetEntityModel(veh)
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) then
                DisableControlAction(0, 59)
                DisableControlAction(0, 60) 
            end
        end
    end
    
    return this
end

