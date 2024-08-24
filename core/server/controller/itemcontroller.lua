ItemController = function(PlayerController)

    local this = {}

    this.pController = PlayerController

    this.Items =  {}
    this.DropItems = {}

    this.InitItems = function(items)

        for k, v in pairs(items) do
            this.Items[v.hash] = Item(v)
        end

        -- Load item events 
        this.GetItem()
        this.TakeDropItem()
    end

    -- Give items to player
    this.GiveItem = function(src,hashName,amount,meta)

        local playerid = this.pController.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
        local player = this.pController.GetPlayerById(tonumber(playerid))

        if (#player.GetInventory() <= Config.maxSlots) then
            if player.GetInventoryWeight() <= Config.maxWeight then
                if this.Items[hashName] then
                    local item = this.Items[hashName].ItemClientEntity()
                    local amount = amount
                    item.meta = meta or {}
    
                    if item.type == 1 then
                        item.meta.bullet = amount
                        amount = 1
                    end
    
                    player.AddItem(item,amount)
    
                    if item.isPocket == 0 then
                        item.amount = amount
                        TriggerClientEvent("core:client:useItem",src,playerid,item)
                    end
                else
                    Core.Helper.PrintColor("[Error]: Se ha intentado setear un item que no existe en la base de datos","red")
                end
            else
                Core.Helper.PrintColor("[Error]: El jugador " .. playerid .. " tiene demasiado peso." ,"red")
            end
        else
            Core.Helper.PrintColor("[Error]: El jugador " .. playerid .. " tiene todos los slots ocupados." ,"red")
        end
    end

    -- Event to remove items to player
    this.RemoveItem = function(src,hashName,amount)

        local playerid = this.pController.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
        local player = this.pController.GetPlayerById(playerid)
        local playerInventory = player.GetInventory()
    
        for v,item in pairs(playerInventory) do
            if item.hashName == hashName then
                player.RemoveItem(item,v,amount)
                return
            end
        end
    end

    -- Return the item data value
    this.GetItemData = function (hashName)
        return this.Items[hashName] or nil
    end

    --Create drop item 
    this.CreateDropItem = function(src,hashName,amount,meta)
        local coords = GetEntityCoords(GetPlayerPed(src))

        local item = this.Items[hashName].ItemClientEntity()
        table.insert(this.DropItems,item)

        TriggerClientEvent("core:client:AddDropItem",-1,src,coords,hashName,amount,meta)
    end

    -- Destroy drop item
    this.TakeDropItem = function()
        RegisterNetEvent("core:server:TakeDropItem")
        AddEventHandler("core:server:TakeDropItem",function(dropid,hashName,amount,meta)
            local src = source
            if(this.DropItems[dropid] ~= nil) then
                this.GiveItem(src,hashName,amount,meta)
                table.remove(this.DropItems,dropid)
            end
        end)
    end

    -- Event to get item select
    this.GetItem = function()
        RegisterNetEvent("core:server:getItemSelect")
        AddEventHandler("core:server:getItemSelect",function(slot)

            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local selectItem = player.GetItem(slot + 1)
            TriggerClientEvent("core:client:useItem",src,playerid,selectItem)
        end)
    end

    return this
end