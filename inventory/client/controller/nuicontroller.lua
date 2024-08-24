NuiController = function(InventoryController)

    local this = {}

    this.invController = InventoryController

    this.Run = function()
        this.NuiUpdateInventory()
        this.NuiThrownItem()
        this.NuiExitInventory()
        this.NuiDivideItem()
    end

    this.NuiUpdateInventory = function()
        RegisterNUICallback("updateInventory",function(data,cb)
            PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

            Core.Callback.Trigger("Inventory:Server:UpdateInventory",function(targetItem,draggableItem)
                local item = {
                    target = targetItem,
                    draggable = draggableItem
                }
                cb(item)
            end,data)

            
        end)
    end
    
    this.NuiThrownItem = function()
        RegisterNUICallback("throwItem", function(data)
            TriggerServerEvent("Inventory:Server:DropItem",data.slot)
        end)
    end

    this.NuiDivideItem = function()
        RegisterNUICallback("divideItem",function(data)
            TriggerServerEvent("Inventory:Server:DivideItems",data.slot,data.dividedSlot)
        end)
    end

    this.NuiExitInventory = function()
        RegisterNUICallback("exit", function(data)
            this.invController.InventoryOpen = false
            SetNuiFocus(false,false)
        end)
    end

    return this
end