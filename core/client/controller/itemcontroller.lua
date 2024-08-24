ItemController = function()

    local this = {}

    this.ItemDrops = {}
    this.ItemDropsNear = {}
    this.CurrentDrop = nil

    this.TYPE_WEAPON = 1 
    this.TYPE_BULLET = 2
    this.TYPE_FOOD = 3
    this.TYPE_INTERACTOBJECT = 4
    
    -- Function init item events
    this.init = function()
        this.UseItem()
        this.AddDropItem()
    end

    --Event to use Item
    this.UseItem = function()
        RegisterNetEvent("core:client:useItem")
        AddEventHandler("core:client:useItem", function(playerid,item)
            if item == nil then return 0 end
            
            local playerPed = PlayerPedId()
            local hashWeapon = GetHashKey(string.upper(item.hashName))
            local lastWeapon = HasPedGotWeapon(playerPed, hashWeapon, false)

            RemoveAllPedWeapons (playerPed, true)
            
            if item.type == this.TYPE_WEAPON then --All weapons
                if lastWeapon then return end

                local meta = item.meta or nil
                

                if meta ~= nil then
                    SetWeaponsNoAutoswap(true)
                    SetWeaponsNoAutoreload(true)
                    GiveWeaponToPed(playerPed,hashWeapon,tonumber(meta.bullet),false,true)
                else
                    GiveWeaponToPed(playerPed,hashWeapon,1,false,true)
                end
            elseif item.type == this.TYPE_BULLET then -- bullets
                TriggerEvent("Inventory:client:ReloadWeapon",playerid,item)
            else  -- other items
                TriggerEvent("core:client:ItemEvent",playerid,item)
            end

            if item.isPocket == 0 then
                TriggerEvent("Inventory:client:heavyItem")
            end
        end)
    end

    this.AddDropItem = function()
        RegisterNetEvent("core:client:AddDropItem")
        AddEventHandler("core:client:AddDropItem",function(source,coords,hashName,amount,meta)
            local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(source)))
            local x, y, z = table.unpack(coords + forward * 0.5)

            table.insert(this.ItemDrops, {
                coords = {
                    x = x,
                    y = y,
                    z = z - 0.3
                },
                hashName = hashName,
                amount = amount,
                meta = meta
            })
        end)
    end

    this.TakeDropItem = function()
        local dropNear = this.ItemDropsNear[this.CurrentDrop]
        if dropNear ~= nil then
            TriggerServerEvent("core:server:TakeDropItem",this.CurrentDrop,dropNear.hashName,dropNear.amount,dropNear.meta)
            TriggerEvent("core:showNotification","check","Acabas de recoger un objeto",5000)
            table.remove(this.ItemDrops,this.CurrentDrop)
            this.CurrentDrop = nil

            RequestAnimDict("pickup_object")
            while not HasAnimDictLoaded("pickup_object") do
                Citizen.Wait(7)
            end
            TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false)
            Citizen.Wait(2000)
            ClearPedTasks(PlayerPedId())
        end
    end

    return this
end