---@diagnostic disable: undefined-global
CommandController = function(adminController)

    local this = {}

    this.aController = adminController

    this.Run = function()
        this.AdminCommands()
    end

    this.AdminCommands = function()
        -- Teleport player to map mark
        Core.Commands.Add("tpm", "Te teletransporta al lugar marcado en el mapa (Mod)", {},false,function(source)
            local src = source
            TriggerClientEvent("AdminSystem:client:GoToMarker",src)
        end,1)

        -- Teleport to another player
        Core.Commands.Add("goto","Te teleporta hacia un jugador especifico (Mod)",{{ name = "playerid", help = "Id del jugador" }},true,function(source,args)
            local src = source
            local playerid = tonumber(args[1])
            local playerTeleport = GetPlayerPed(playerid)

            if playerTeleport ~= 0 then
                local adminPed = GetPlayerPed(src)
                local playerCoords = GetEntityCoords(playerTeleport)
                SetEntityCoords(adminPed,playerCoords)
                TriggerClientEvent("core:showNotification",src,"check","Te has teletransportado al usuario " .. GetPlayerName(playerid),3500)
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,1)

        -- Teleport a player to your position
        Core.Commands.Add("bring","Teleporta a un jugador hacia tú posición (Mod)",{{ name = "playerid", help = "Id del jugador" }},true,function(source,args)
            local src = source
            local playerid = tonumber(args[1])
            local playerTeleport = GetPlayerPed(playerid)

            if playerTeleport ~= 0 then
                local adminPed = GetPlayerPed(src)
                local adminCoords = GetEntityCoords(adminPed)
                SetEntityCoords(playerTeleport,adminCoords)
                TriggerClientEvent("core:showNotification",src,"check","Has teletransportado al usuario " .. GetPlayerName(playerid),3500)
                TriggerClientEvent("core:showNotification",playerid,"check","Te ha teletransportado el moderador " .. GetPlayerName(src),3500)
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,1)

        -- Spawn a vehicle
        Core.Commands.Add("car","Te spawnea el coche que hayas indicado (Admin)", {{ name = "model", help = "Nombre del modelo del vehículo" }},true, function(source,args)
            local src = source
            TriggerClientEvent("AdminSystem:client:SpawnVehicle",src,args[1])
        end,3)

        -- Delete a vehicle
        Core.Commands.Add("dv", "Borra los vehículos de la zona (Mod)", {},false,function(source)
            local src = source
            TriggerClientEvent("AdminSystem:client:DeleteVehicle",src)
        end,1)

        -- Kick player
        Core.Commands.Add("kick","Kickea a un jugador en especifico del servidor (Mod)", {{name = "player", help = "Id del jugador"},{name = "Razon", help = "Razon del kick"}},true,function(source,args)
            
            local src = source
            local playerDrop = GetPlayerPed(tonumber(args[1]))

            if playerDrop ~= 0 then 
                if playerDrop ~= GetPlayerPed(src) then
                    local reason = table.concat(args," ", 2)
                    DropPlayer(args[1], string.format("Has sido kickeado por %s por el siguiente motivo:\n %s", GetPlayerName(src), reason))
                    TriggerClientEvent("core:showNotification",src,"check","Has kickeado al usuario " .. GetPlayerName(playerDrop),3500)
                else
                    TriggerClientEvent("core:showNotification",src,"error","No puedes hacerte kick a ti mismo",3500)
                end
            else 
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,1)

        -- Ban player
        Core.Commands.Add("ban","Banear a un usuario del servidor (Mod)",{{name = "player", help = "Id del jugador"},{name = "Tiempo", help = "Tiempo de baneo (Horas)"},{name = "Razon", help = "Razon"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])

            if playerid then
                local banTime = tonumber(os.time() + args[2] * 3600) 
                local tableTime = os.date("*t",banTime)
                local reason = table.concat(args," ", 3)
                print(reason)
                Core.Ban.AddBan(src,banTime,reason)
                DropPlayer(args[1], string.format("Has sido baneado por %s por el siguiente motivo:\n %s \nHasta: %s/%s/%s %s:%s", 
                GetPlayerName(src), 
                reason,
                tableTime["day"],
                tableTime["month"],
                tableTime["year"],
                tableTime["hour"],
                tableTime["min"]
            ))
                TriggerClientEvent("core:showNotification",src,"check","Acabas banear al usuario " .. GetPlayerName(args[1]),4000)
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end)

        -- Set player ped
        Core.Commands.Add("setped","Le pone un ped a un jugador especifico (Admin)", {{name = "player", help = "Id del jugador"},{name = "Razon", help = "Razon del kick"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])

            if playerid then
                if args[2] == "normal" then
                    local player = Core.Player.GetPlayerById(playerid)
                    local skinData = {
                        gender = player.gender,
                        skin = json.decode(player.skin)
                    }
                    TriggerClientEvent("Admin:Client:SetPlayerPed",tonumber(args[1]),args[2],skinData)
                else
                    TriggerClientEvent("Admin:Client:SetPlayerPed",tonumber(args[1]),args[2])
                end
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,2)

        -- Freeze or unfreeze player
        Core.Commands.Add("freeze","Congela o descongela a un jugador (Mod)",{{name = "player", help = "Id del jugador"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])

            if playerid then
                TriggerClientEvent("core:showNotification",src,"check","Acabas de congelar/descongelar al usuario " .. GetPlayerName(args[1]) ,4000)
                TriggerClientEvent("Admin:Client:FreezePlayer",tonumber(args[1]))
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,1)

        -- Dead player
        Core.Commands.Add("died","Mata a un jugador en especifico (Mod)",{{name = "player", help = "Id del jugador"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])

            if playerid then
                TriggerClientEvent("core:showNotification",src,"check","Acabas de matar al usuario " .. GetPlayerName(args[1]) ,4000)
                TriggerClientEvent("Admin:Client:DiedPlayer",tonumber(args[1]))
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,2)

        -- Dead player
        Core.Commands.Add("revive","Revive a un jugador (Mod)",{{name = "player", help = "Id del jugador"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
        
            if playerid then
                TriggerClientEvent("core:showNotification",src,"check","Acabas de revivir a " .. GetPlayerName(args[1]) ,4000)
                TriggerClientEvent("AdminSystem:client:RevivePlayer",tonumber(args[1]))
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,2)

        -- Set player money 
        Core.Commands.Add("setmoney","Le da o le quita dinero al jugador del bolsillo (Admin)", {{name = "playerid", help ="Id del jugador"},{name = "Cantidad", help ="Cantidad a dar"}},true,function(source,args)
           
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])

            if playerid then
                local player = Core.Player.GetPlayerById(playerid)
                local money = tonumber(args[2])

                if money then
                    local newMoney = player.GetMoney() + money
                    player.SetMoney(newMoney)
                    TriggerClientEvent("core:showNotification",src,"check","Le has dado " .. money .. "$ al usuario " .. GetPlayerName(args[1]),3500)
                    TriggerClientEvent("core:showNotification",tonumber(args[1]),"check","Has recibido " .. money .."$ por un administrador",3500)
                else 
                    TriggerClientEvent("core:showNotification",src,"error","Cantidad de dinero invalida",3500)
                end
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end

        end,3)

        -- Set player group
        Core.Commands.Add("setgroup","Le cambia la facción whitelist al usuario (C. facciones)", {{name = "playerid", help ="Id del jugador"},{name = "Facción", help ="Nombre de la facción"},{name = "Rango", help ="Rango en la facción"}},true,function(source,args)
            
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
            local job = Core.Job.GetJob(args[2])

            if playerid then
                if job then 
                    local jobData = job.JobClientEntity()
                    if jobData.uniqueJob == 1 then
                        if #jobData.ranks >= tonumber(args[3]) then
                            local player = Core.Player.GetPlayerById(playerid)
                            player.SetPlayerWhitelistJob(args[2],args[3])
                            TriggerClientEvent("core:showNotification",src,"check","Le has puesto " .. jobData.name .. " rango " .. args[3] .. " al usuario " .. GetPlayerName(args[1]),3500)
                            TriggerClientEvent("core:showNotification",tonumber(args[1]),"check","Un administrador te ha puesto " .. jobData.name .. " rango " .. args[3],3500)
                        else
                            TriggerClientEvent("core:showNotification",src,"error","Has puesto un rango inexistente",3500)
                        end
                    else
                        TriggerClientEvent("core:showNotification",src,"error","Has puesto un trabajo no whitelist",3500)
                    end
                else
                    TriggerClientEvent("core:showNotification",src,"error","Has puesto una facción que no existe",3500)
                end
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,3)

        -- Set player job
        Core.Commands.Add("setjob","Le cambia el trabajo al usuario (C. facciones)", {{name = "playerid", help ="Id del jugador"},{name = "Trabajo", help ="Nombre del trabajo"}},true,function(source,args)
            
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
            local job = Core.Job.GetJob(args[2])

            if playerid then
                if job then 
                    local jobData = job.JobClientEntity()
                    if jobData.uniqueJob == 0 then
                        local player = Core.Player.GetPlayerById(playerid)
                        player.SetPlayerJob(args[2])
                        TriggerClientEvent("core:showNotification",src,"check","Le has puesto " .. jobData.name .. " al usuario " .. GetPlayerName(args[1]),3500)
                        TriggerClientEvent("core:showNotification",tonumber(args[1]),"check","Un administrador te ha puesto " .. jobData.name,3500)
                    else
                        TriggerClientEvent("core:showNotification",src,"error","Has puesto una facción whitelist",3500)
                    end
                else
                    TriggerClientEvent("core:showNotification",src,"error","Has puesto un trabajo que no existe",3500)
                end
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,3)

        -- Give item to player
        Core.Commands.Add("giveitem","Da un objeto al jugador (admin)", {{name = "playerid", help ="Id del jugador"},{name = "Nombre", help ="Nombre del item"},{name = "cantidad", help ="Cantidad del objeto"}},true,function(source,args)
            
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
            local item = Core.Item.GetItemData(args[2])
            local amount = tonumber(args[3])

            if playerid then
                if item then
                   if amount > 0 then
                    Core.Item.GiveItem(args[1],item.hashName,amount)
                    TriggerClientEvent("core:showNotification",src,"check","Le has dado " .. item.name .. " al usuario " .. GetPlayerName(args[1]),3500)
                    TriggerClientEvent("core:showNotification",tonumber(args[1]),"check","Un administrador te ha puesto " .. item.name,3500)
                   else
                    TriggerClientEvent("core:showNotification",src,"error","Cantidad del item invalida",3500)
                   end
                else
                    TriggerClientEvent("core:showNotification",src,"error","El item indicado no existe",3500)
                end

            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,2)

        -- NoClip system
        Core.Commands.Add("noclip","Activa/desactiva el noclip",{},false,function(source)
            local src = source
            TriggerClientEvent("AdminSystem:client:ToggleNoClip",src)
        end,3)

        -- Specplayer
        Core.Commands.Add("spec","Le permite spectear a otros jugadores",{{name = "playerid", help ="Id del jugador"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
            if playerid then
                TriggerClientEvent("AdminSystem:client:SpectatePlayer",src,GetPlayerPed(args[1]))
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500)
            end
        end,3)

        -- Invisible player
        Core.Commands.Add("invisible","Te vuelve invisible o visible a otros jugadores (Mod)",{},false,function(source)
            local src = source
            TriggerClientEvent("Admin:Client:SetPlayerInvisible",src)
        end,1)

        -- God mode player
        Core.Commands.Add("godmode","Te habilita la invisibilidad en el juego (Admin)",{},false,function(source)
            local src = source
            TriggerClientEvent("Admin:Client:ActiveGodMode",src)
        end,2)

        -- Report command
        Core.Commands.Add("report","Te permite reportar a un usuario o bug",{{name = "descripción", help ="Describe toda la información sobre tu problema"}},true,function(source,args)
            local src = source
            local msg = table.concat(args," ")
        
            TriggerClientEvent("chat:addMessage",src, {
                color = { 255, 0, 0},           
                multiline = false,            
                args = {"[Reporte enviado]: ", msg}          
            })
        
            this.aController.CreateReportTicket(src,msg)        
            TriggerClientEvent("core:showNotification",src,"check","Tú reporte ha sido enviado correctamente",4000)
        end)

        -- Attent report
        Core.Commands.Add("atrep","Permite ver todos los reportes activos",{{name = "report id", help ="Indica el número de reporte a atender"}},true,function(source,args)
            local src = source
            this.aController.AttendTicket(src,args[1])
        end,1)
    
        -- See all active reports
        Core.Commands.Add("getrep","Ver todos los reportes activos",{},false,function(source)
            local src = source
            this.aController.GetAllTickets(src)
        end,1)

        -- Delete report
        Core.Commands.Add("delrep","Borra un reporte activo",{{name = "report id", help ="Indica el número de reporte a atender"}},true,function(source,args)
            local src = source
            this.aController.DeleteTicket(src,args[1])
        end,1)

    end

    return this
end