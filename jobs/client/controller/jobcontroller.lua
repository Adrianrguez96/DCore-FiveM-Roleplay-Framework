JobController = function ()

    local this = {}

    this.PlayerCuffed = false
    this.PlayerJob = {}

    this.Run = function ()
        this.OnPlayerConnect()
        this.AddJobBlips()
        this.JobItems()
        this.ChangeClotherEvent()
    end

    this.OnPlayerConnect = function() 
        RegisterNetEvent("core:client:playerConnect")
        AddEventHandler("core:client:playerConnect",function(player)
            this.PlayerCuffed = false
            this.PlayerJob = player.job

            this.ToggleDuty()
        end)
    end

    this.JobItems = function ()
        RegisterNetEvent("core:client:ItemEvent")
        AddEventHandler("core:client:ItemEvent", function(playerid,item)
            local itemHash = item.hashName

            -- Interaction items
            if item.type == 4 then
                if itemHash == "item_handcuffs" then 
                    
                    local ped = PlayerPedId()
                    this.PlayerCuffed = not this.PlayerCuffed

                    Core.Utility.RequestAnimDict("mp_arresting")
                    
                    if IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
                        ClearPedSecondaryTask(ped)
                    else
                        TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
                    end	

                    SetEnableHandcuffs(ped, this.PlayerCuffed)
                end
            
            -- Decoration items 
            elseif item.type == 5 then
                print("Has usado un objeto de tipo decorativo")
            end
        end)
    end

    this.AddJobBlips = function()
        for _,blip in pairs(Config.JobBlips) do
            Core.Utility.CreateBlipForCoords(blip.Coords,blip.Type,2,blip.Scale,blip.Color,blip.Title)
        end
    end

    this.WardrobePoint = function()
        CreateThread(function()
            local Sleep
            while this.PlayerJob.onduty do
                local coords = GetEntityCoords(PlayerPedId())
                local listCoords = Config.WardrobeCoords[this.PlayerJob.whitelistJob]
                for _,wardrobeCoords in pairs(listCoords) do
                    if #(coords - wardrobeCoords) < 2.5 then
                        Core.Utility.DrawText3DRectagle(wardrobeCoords.x,wardrobeCoords.y,wardrobeCoords.z,"[~g~E~s~] Para ponerte un uniforme")
                        if #(coords - wardrobeCoords) < 1 then
                            if IsControlJustReleased(0, 38) then
                                local optionsMenu = Config.WardrobeMenu[this.PlayerJob.whitelistJob]
                                Core.Menu.CreateMenu("Guardaropa",optionsMenu,true)
                            end
                        end
                        Sleep = 3 
                        break
                    end
                    Sleep = 2000
                end
                Wait(Sleep)
            end
        end)
    end

    this.ObjectStorePoint = function()
        CreateThread(function()
            local Sleep
            while this.PlayerJob.onduty do
                local coords = GetEntityCoords(PlayerPedId())
                local listCoords = Config.ObjectStoreCoords[this.PlayerJob.whitelistJob]
                for _,objectStoreCoords in pairs(listCoords) do
                    if #(coords - objectStoreCoords) < 2.5 then
                        Core.Utility.DrawText3DRectagle(objectStoreCoords.x,objectStoreCoords.y,objectStoreCoords.z,"[~g~E~s~] Para abrir el almacen")
                        if #(coords - objectStoreCoords) < 1 then
                            if IsControlJustReleased(0, 38) then
                                local optionsMenu = Config.ObjectStoreMenu[this.PlayerJob.whitelistJob]
                                Core.Menu.CreateMenu("Almacen",optionsMenu,true)
                            end
                        end
                        Sleep = 3 
                        break
                    end
                    Sleep = 2000
                end
                Wait(Sleep)
            end
        end)
    end

    this.ToggleDuty = function()
        CreateThread(function()
            local Sleep
            while Config.OnDutyCoords[this.PlayerJob.whitelistJob] ~= nil do
                local coords = GetEntityCoords(PlayerPedId())
                local listCoords = Config.OnDutyCoords[this.PlayerJob.whitelistJob]
                for _,dutyCoords in pairs(listCoords) do
                    if #(coords - dutyCoords) < 2.5 then
                        if not this.PlayerJob.onduty then
                            Core.Utility.DrawText3DRectagle(dutyCoords.x,dutyCoords.y,dutyCoords.z,"[~g~E~s~] Para ponerse de servicio")
                        else
                            Core.Utility.DrawText3DRectagle(dutyCoords.x,dutyCoords.y,dutyCoords.z,"[~g~E~s~] Para salirse de servicio")
                        end

                        if #(coords - dutyCoords) < 1 then
                            if IsControlJustReleased(0, 38) then
                                this.PlayerJob.onduty = not this.PlayerJob.onduty
                                if this.PlayerJob.onduty then
                                    this.WardrobePoint()
                                    this.ObjectStorePoint()
                                    TriggerEvent("core:showNotification","check","Acabas de ponerte en servicio",3500)
                                else
                                    TriggerEvent("core:showNotification","check","Acabas de salirte de servicio",3500)
                                end
                            end
                        end
                        Sleep = 3
                        break 
                    end
                    Sleep = 2000
                end
                Wait(Sleep)
            end
        end)
    end

    this.ChangeClotherEvent = function()
        RegisterNetEvent("Jobs:Client:ChangeClother")
        AddEventHandler("Jobs:Client:ChangeClother",function(clotherName,gender)
            local playerPed = PlayerPedId()
            local playerJob = this.PlayerJob.whitelistJob

            local clother
            if gender == "male" then
                clother = Config.JobClothersMale[playerJob][clotherName]
            else
                clother = Config.JobClothersFemale[playerJob][clotherName]
            end

			SetPedComponentVariation(playerPed, 3, clother.Jacket, 0, 2)  --Jacket
			SetPedComponentVariation(playerPed, 11, clother.Shirt, 0, 2) --Shirt
			SetPedComponentVariation(playerPed, 8, clother.Parachute, 0, 2)  --Parachute
			SetPedComponentVariation(playerPed, 4, clother.Pants, 0, 2)  --Pants
			SetPedComponentVariation(playerPed, 6, clother.Shoes, 0, 2)  --Shoes
			SetPedComponentVariation(playerPed, 10, clother.Rank, 0, 2) --Rank
        end)
    end

    return this
end