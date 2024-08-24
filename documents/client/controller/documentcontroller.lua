DocumentController = function ()

    local this = {}

    this.documentOpen = false

    this.Run = function()
        this.UsedItemEvent()
        this.PositionGetDocuments()
    end

    this.activeDocument = function()
        Citizen.CreateThread(function()
            while this.documentOpen do
                if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) then
                    SendNUIMessage({action = "close"})
                    this.documentOpen = false
                end
            Citizen.Wait(1)
            end
        end)
    end

    this.UsedItemEvent = function()
        RegisterNetEvent("core:client:ItemEvent")
        AddEventHandler("core:client:ItemEvent", function(playerid,item) 
            if item.hashName == "item_idcard" then
                local player, distance = Core.Player.GetClosestPlayer()
                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent("documents:getPlayerDocuments",GetPlayerServerId(player),item.hashName,item.meta)
                else
                    SendNUIMessage({action = "idcard", meta = item.meta})
                    this.documentOpen = true
                    this.activeDocument() 
                end
            end

            if item.hashName == "item_licenseCard" then
                local player, distance = Core.Player.GetClosestPlayer()
                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent("documents:getPlayerDocuments",GetPlayerServerId(player),item.hashName,item.meta)
                else
                    SendNUIMessage({action = "licenseCard", meta = item.meta})
                    this.documentOpen = true
                    this.activeDocument() 
                end
            end
        end)
    end

    this.OpenDocument = function()
        RegisterNetEvent("document:client:OpenDocument")
        AddEventHandler("document:client:OpenDocument", function(type,meta)
            SendNUIMessage({action = type, meta = meta})
            this.documentOpen = true
            this.activeDocument() 
        end)

    end

    this.PositionGetDocuments = function()
        Citizen.CreateThread(function()
            local Sleep
            while true do 
                local pos = GetEntityCoords(PlayerPedId(),true)
                local distance = #(pos - Config.TakeDocumentation.pos)
                if distance < Config.DrawDistance then
                    if IsControlJustPressed(1, 38) and distance < Config.TakeDocumentation.scale then
                        TriggerServerEvent("documents:server:CreateNewDocument")
                    end
        
                    DrawMarker(
                        Config.TakeDocumentation.market, 
                        Config.TakeDocumentation.pos.x, 
                        Config.TakeDocumentation.pos.y, 
                        Config.TakeDocumentation.pos.z - 1, 
                        0.0, 
                        0.0, 
                        0.0, 
                        0.0, 
                        0.0, 
                        0.0, 
                        Config.TakeDocumentation.scale,         
                        Config.TakeDocumentation.scale,         
                        Config.TakeDocumentation.scale,         
                        Config.TakeDocumentation.rgba[1],         
                        Config.TakeDocumentation.rgba[2],       
                        Config.TakeDocumentation.rgba[3],        
                        Config.TakeDocumentation.rgba[4],        
                        false, true, 2, nil, nil, nil, nil)
                    Sleep = 3
                else
                    Sleep = 2000
                end
                Citizen.Wait(Sleep)
            end
        end)
    end

    return this
end