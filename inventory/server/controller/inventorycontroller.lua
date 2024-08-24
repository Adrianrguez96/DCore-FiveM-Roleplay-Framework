InventoryController = function()

    local this = {}

    this.Run = function() 
        this.InventoryEvent()
        this.UseFoodItemEvent()
        this.ReloadWeaponEvent()
    end

    this.InventoryEvent = function()
        RegisterNetEvent("Inventory:Server:SetInventoryState")
        AddEventHandler("Inventory:Server:SetInventoryState", function(type,vehicleClass)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)

            if type == "OpenInventory" then
                TriggerClientEvent("Inventory:client:OpenInventory",src,"OwnInventory",player.GetInventory())
            elseif type == "updateInventory" then
                TriggerClientEvent("Inventory:client:UpdateInventory",src,player.GetInventory())
            elseif type == "OpenTrunk" then
                local secondInventory = 
                {
                    maxSlot = 12,
                    maxWeigth = 1200
                }
                TriggerClientEvent("Inventory:client:OpenInventory",src,"TrunkInventory",player.GetInventory(),secondInventory)
            elseif type == "OpenGloveBox" then
                local secondInventory = 
                {
                    maxSlot = Config.GloveBoxInventory.maxSlot,
                    maxWeigth = Config.GloveBoxInventory.maxWeight
                }
                TriggerClientEvent("Inventory:client:OpenInventory",src,"GloveBoxInventory",player.GetInventory(),secondInventory)
            end
        end)

        Core.Callback.Create("Inventory:Server:UpdateInventory",function(src,cb,data)
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local targetItem = player.GetItem(data.targetSlot)
            local draggableItem = player.GetItem(data.dragableSlot)

            if targetItem == nil then
                player.RemoveItem(draggableItem,data.dragableSlot,draggableItem.amount)
                player.AddItem(draggableItem,draggableItem.amount,data.targetSlot)
            else
                if draggableItem.hashName == targetItem.hashName then
                    player.RemoveItem(draggableItem,data.dragableSlot,draggableItem.amount)
                    player.AddItem(targetItem,targetItem.amount + draggableItem.amount,data.targetSlot)
                else
                    player.AddItem(draggableItem,draggableItem.amount,data.targetSlot)
                    player.AddItem(targetItem,targetItem.amount,data.dragableSlot)
                end

            end

            cb(targetItem,draggableItem)
        end)
        
        RegisterNetEvent("Inventory:Server:DropItem")
        AddEventHandler("Inventory:Server:DropItem",function(slot)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local dropItem = player.GetItem(slot)

            Core.Item.CreateDropItem(src,dropItem.hashName,dropItem.amount,dropItem.meta)
            player.RemoveItem(dropItem,slot,dropItem.amount)
            TriggerClientEvent("Inventory:Client:DropItem",src,dropItem.isPocket)
        end)

        RegisterNetEvent("Inventory:Server:DivideItems")
        AddEventHandler("Inventory:Server:DivideItems",function(slot,divided)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local dividedItem = player.GetItem(slot)

            if dividedItem.amount > divided and dividedItem.amount ~= 1  then
                player.RemoveItem(dividedItem,slot,divided)
                Core.Item.GiveItem(src,dividedItem.hashName,divided,dividedItem.meta)
                TriggerClientEvent("Inventory:client:UpdateInventory",src,player.GetInventory())
            else
                TriggerClientEvent("core:showNotification",src,"error","No puedes dividir este item mas",3500)
            end
        end)
    end

    this.UseFoodItemEvent = function()
        RegisterNetEvent("inventory:server:useFoodItem")
        AddEventHandler("inventory:server:useFoodItem", function(item)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)

            local item = Core.Item.GetItemData(item.hashName)

            local hunger =  player.GetPlayerMeta("hunger") + item.GetItemMeta("hunger")
            local thirsty = player.GetPlayerMeta("thirsty") + item.GetItemMeta("thirsty")
            
            if (hunger >= 100) then hunger = 100 end
            if (thirsty >= 100) then thirsty = 100 end
            
            player.SetPlayerMeta("hunger", hunger)
            player.SetPlayerMeta("thirsty", thirsty)
            
            Core.Item.RemoveItem(src,item.hashName,1)
        end)
    end

    this.ReloadWeaponEvent = function()
        RegisterNetEvent("Inventory:server:ReloadWeapon")
        AddEventHandler("Inventory:server:ReloadWeapon",function(weaponType,ammoClip,weaponSlot)
            local src = source

            if weaponType == 416676503 then -- Pistol
                this.ReloadWeapon(src,"item_pistolmagazine",ammoClip,weaponSlot)
            elseif weaponType == 860033945 then -- Shotgun
                this.ReloadWeapon(src,"item_shotguncartridge",ammoClip,weaponSlot)
            elseif weaponType == 3337201093 then -- Submachine
                this.ReloadWeapon(src,"item_submachinemagazine",ammoClip,weaponSlot)
            elseif weaponType == 970310034 then -- Assault Rifle
                this.ReloadWeapon(src,"item_machinemagazine",ammoClip)
            elseif weaponType == 1159398588 then -- Light Machine
                this.ReloadWeapon(src,"item_lightmachinemagazine",ammoClip,weaponSlot)
            elseif weaponType == 3082541095 then -- Sniper
                this.ReloadWeapon(src,"item_snipermagazine",ammoClip,weaponSlot)
            end
        end)
    end

    this.ReloadWeapon = function(src,magazine,ammoClip,weaponSlot)
        local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
        local player = Core.Player.GetPlayerById(playerid)
        local magazineSlot,hashName = player.HasItem(magazine)
        
        if magazineSlot then
            Core.Item.RemoveItem(src,hashName,1)
            player.ChangeMetaItem(weaponSlot,"bullet",ammoClip)
            TriggerClientEvent("Inventory:client:ReloadWeapon",src,ammoClip)
        end
    end

    return this
end