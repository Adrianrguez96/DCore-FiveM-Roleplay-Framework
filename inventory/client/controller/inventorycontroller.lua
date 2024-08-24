InventoryController = function()
    local this = {}

    this.InventoryOpen = false
    this.ItemSelect = nil
    this.BusyHand = false

    this.Run = function()
        this.OnPlayerConnect()
        this.InventoryEvents()
        this.ItemEvents()
        this.KeyPressing()
        this.ReloadWeaponEvent()
    end

    this.SelectItem = function(slot)
        if not this.BusyHand then
            this.ItemSelect = slot;
            SendNUIMessage({status = "selectItem", mainSlotSelect = slot})
            TriggerServerEvent("core:server:getItemSelect",this.ItemSelect)
        else
            TriggerEvent("core:showNotification","error","Tienes las manos ocupadas",2000)
        end
    end

    this.OnPlayerConnect = function() 
        RegisterNetEvent("core:client:playerConnect")
        AddEventHandler("core:client:playerConnect",function(player)
            for _,item in pairs(player.inventory) do 
                if(item.isPocket == 0) then
                    local hashWeapon = GetHashKey(string.upper(item.hashName))
                    GiveWeaponToPed(PlayerPedId(),hashWeapon,item.amount,false,true)
                    this.BusyHand = true
                    break
                end
            end
            SendNUIMessage({status = "loadInventory", items = player.inventory})
        end)
    end

    this.KeyPressing = function ()
        Citizen.CreateThread(function()
            while true do
                if IsControlJustPressed(1, Config.OpenInventoryKey) and not this.InventoryOpen  then --Open inventory Key
                    this.OpenInventory()
                elseif IsControlJustReleased(0,80) then -- Reload weapon
                    this.ReloadWeapon()
                elseif IsControlJustPressed(1, 157) then -- First main slot
                    this.SelectItem(0) 
                elseif IsControlJustPressed(1, 158) then -- Second main slot
                    this.SelectItem(1) 
                elseif IsControlJustPressed(1, 160) then -- Third main slot
                    this.SelectItem(2) 
                elseif IsControlJustPressed(1, 164) then -- Four main slot
                    this.SelectItem(3) 
                elseif IsControlJustPressed(1, 165) then -- Five main slot
                    this.SelectItem(4) 
                elseif IsControlJustPressed(1, 38) then -- Take a drop item 
                    Core.Item.TakeDropItem()
                    TriggerServerEvent("Inventory:Server:SetInventoryState","updateInventory")
                end
                Citizen.Wait(1)
            end
        end)
    end

    this.OpenInventory = function()
        if not IsPauseMenuActive() and not this.InventoryOpen then
            local ped = PlayerPedId()
            local vehicle = Core.Player.GetClosestVehicle()
            local currentVeh = nil
            local inventoryType = nil

            if GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped or GetPedInVehicleSeat(GetVehiclePedIsIn(ped), 0) == ped then
                local vehicle = GetVehiclePedIsIn(ped, false)
                currentVeh = Core.Vehicle.GetVehiclePlate(vehicle)
                inventoryType = "OpenGloveBox"
            else
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(ped)
                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                    if #(pos - trunkpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                        if GetVehicleDoorLockStatus(vehicle) < 2 then
                            currentVeh = Core.Vehicle.GetVehiclePlate(vehicle)
                            inventoryType = "OpenTrunk"
                        else
                            TriggerEvent("core:showNotification","error","El vehículo esta cerrado",2000)
                            return
                        end
                    else 
                        currentVeh = nil
                    end
                else
                    currentVeh = nil
                end
            end

            if currentVeh then
                local vehClass = GetVehicleClass(vehicle)
                TriggerServerEvent("Inventory:Server:SetInventoryState",inventoryType,vehClass)
            else
                TriggerServerEvent("Inventory:Server:SetInventoryState","OpenInventory")
            end
        end
    end

    this.InventoryEvents = function()
        RegisterNetEvent("Inventory:client:OpenInventory")
        AddEventHandler("Inventory:client:OpenInventory", function(type,primaryInventory,secondInventory)
            if not IsEntityDead(PlayerPedId()) then
                this.InventoryOpen = true
                SetNuiFocus(true,true)
                if type == "OwnInventory" then
                    SendNUIMessage({status = "openInventory", items = primaryInventory})
                elseif type == "TrunkInventory" then
                    secondInventory.type = "Trunk"
                    SendNUIMessage({status = "openInventory",items = primaryInventory, secondInventory = secondInventory})
                elseif type == "GloveBoxInventory" then
                    secondInventory.type = "GloveBox"
                    SendNUIMessage({status = "openInventory",items = primaryInventory, secondInventory = secondInventory})
                end
            end
        end)

        RegisterNetEvent("Inventory:client:UpdateInventory")
        AddEventHandler("Inventory:client:UpdateInventory", function(inventory)
            SendNUIMessage({status = "updateInventory", items = inventory})
        end)
    end

    this.ItemEvents = function()
        RegisterNetEvent("Inventory:client:heavyItem")
        AddEventHandler("Inventory:client:heavyItem",function()
            this.BusyHand = true
            SendNUIMessage({status = "busyHand"})
        end)

        RegisterNetEvent("core:client:ItemEvent")
        AddEventHandler("core:client:ItemEvent", function(playerid,item)
            if item.type == 3 then
                TriggerServerEvent("inventory:server:useFoodItem",item)
                TriggerEvent("core:showNotification","check","Acaba de usar " .. item.name,2000) 
            end
        end)

        RegisterNetEvent("Inventory:Client:DropItem")
        AddEventHandler("Inventory:Client:DropItem",function(isPocket)
            if isPocket == 0 then  this.BusyHand = false end

            local playerPed = PlayerPedId()

            TriggerServerEvent("Inventory:Server:SetInventoryState","updateInventory")
            

            PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
            RemoveWeaponFromPed(playerPed, GetSelectedPedWeapon(playerPed))
            
            Core.Utility.RequestAnimDict("pickup_object")
            TaskPlayAnim(playerPed, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false)
            Citizen.Wait(2000)
            ClearPedTasks(playerPed)
        end)
    end

    this.ReloadWeapon = function()
        local playerPed = PlayerPedId()

        local weaponHash = GetSelectedPedWeapon(playerPed)
        local weaponType = GetWeapontypeGroup(weaponHash)

        if IsPedArmed(playerPed,4) and (IsPedReloading(playerPed) or GetAmmoInPedWeapon(playerPed,weaponHash) == 0)  then
            local ammoClip = GetMaxAmmoInClip(playerPed,weaponHash) + 1
            local weaponSlot = this.ItemSelect + 1

            DisableControlAction(0, 140, true)
            TriggerServerEvent("Inventory:server:ReloadWeapon",weaponType,ammoClip,weaponSlot)
        end
    end

    this.ReloadWeaponEvent = function()
        RegisterNetEvent("Inventory:client:ReloadWeapon")
        AddEventHandler("Inventory:client:ReloadWeapon",function(ammoClip)
            local playerPed = PlayerPedId()
            local weaponHash = GetSelectedPedWeapon(playerPed)
            
            SetAmmoInClip(playerPed,weaponHash,0)
            SetPedAmmo(playerPed,weaponHash,ammoClip)
        end)
    end

    return this
end