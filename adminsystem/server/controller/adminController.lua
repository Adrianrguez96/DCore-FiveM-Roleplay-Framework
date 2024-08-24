AdminController = function()

    local this = {}

    this.ReportTickets = {}

    this.Run = function()
        this.CheckMenuOpenEvent()
        this.GetAllPlayers()
        this.GetAllJobs()
        this.GetPlayerData()
        this.GetUserData()
        this.UpdateInventoryUser()
        this.GetAllNuiTickets()
    end

    this.CheckMenuOpenEvent = function()
        Core.Callback.Create("AdminSystem:Server:CheckAdminStatus",function(src,cb)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local result = this.UpdateMainPanelData()
                cb(isAdmin,result) 
            end
        end)
    end

    this.UpdateMainPanelData = function()
        local adminData = {
            onlinePlayers = GetNumPlayerIndices(),
            totalRegisters = 2
        }
        return adminData
    end

    this.SendStaffMessage = function(msg,color)
        for _,player in pairs(GetPlayers()) do
            local adminLevel = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(player)[1])
            if adminLevel >= 0 then
                TriggerClientEvent('chat:addMessage',player, {
                    color = color,
                    multiline = false,
                    args = {"[Reporte entrante]: ", msg}
                  })
            end
        end
    end

    this.CreateReportTicket = function (src,msg)
        this.ReportTickets[#this.ReportTickets + 1] = {
            ticketid = #this.ReportTickets + 1,
            userid = src,
            user = GetPlayerName(src),
            msg = msg,
            attendFor = "n/a"
        }
        this.SendStaffMessage(msg,{255,0,0})
        this.SendStaffMessage("Para atender el reporte use /atrep " .. #this.ReportTickets,{255,0,0})
    end

    this.AttendTicket = function(src,ticketid)
        local id = tonumber(ticketid) 
        if id <= #this.ReportTickets then
            this.ReportTickets[id].attendFor = GetPlayerName(src)

            TriggerClientEvent("core:showNotification",this.ReportTickets[id].userid,"check","Tú reporte ha sido aceptado por " .. GetPlayerName(src),3500)
            TriggerClientEvent("core:showNotification",src,"check","Has aceptado el reporte #" .. ticketid .. " de " .. this.ReportTickets[id].user ,3500)

            this.SendStaffMessage("Moderador " .. GetPlayerName(src) .. " ha aceptado el reporte #" ..ticketid .. " del usuario " .. this.ReportTickets[id].user,{255,0,0})
        else 
            TriggerClientEvent("core:showNotification",src,"error","Este reporte no existe",3500)
        end
    end

    this.DeleteTicket = function(src,ticketid)
        local id = tonumber(ticketid) 
        if id <= #this.ReportTickets then
            table.remove(this.ReportTickets,id)
            TriggerClientEvent("core:showNotification",src,"check","Has borrado el reporte #" .. ticketid ,3500)
        else 
            TriggerClientEvent("core:showNotification",src,"error","Este reporte no existe",3500)
        end
    end

    this.GetAllTickets = function(src)
        TriggerClientEvent("chat:addMessage",src, {
            color = { 255, 0, 0},
            multiline = false,
            args = {"Reportes activos actualmente"}
          })
        for id,ticket in pairs(this.ReportTickets) do
            TriggerClientEvent("chat:addMessage",src, {
                color = { 255, 0, 0},
                multiline = false,
                args = {"[Reporte#" .. id .. "]: " ,"Enviado por:" .. ticket.user .. ". Atendido por: " .. ticket.attendFor}
              })
        end
    end
    
    -- Get All online players in server
    this.GetAllPlayers = function()
        Core.Callback.Create("AdminSystem:Server:GetAllPlayers",function(src,cb)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local players = {}

                for _,player in pairs(GetPlayers()) do
                    local steamUser = GetPlayerIdentifiers(player)[1]
                    local onlinePlayer = Core.Player.GetPlayerOnlineId(steamUser)  
                    local Player  = Core.Player.GetPlayerById(onlinePlayer)         
                    
                    players[#players + 1] = {
                        serverid = player,
                        playerid = onlinePlayer,
                        UserName = GetPlayerName(player),
                        steamUser = steamUser,
                        playerName = Player.GetPlayerName(),
                        discordid = GetPlayerIdentifiers(player)[5]
                    }
                end
    
                table.sort(players, function(a, b)
                    return a.serverid < b.serverid
                end)
    
                cb(players)
            end
        end)
    end

    -- Get all jobs
    this.GetAllJobs = function()
        Core.Callback.Create("AdminSystem:Server:GetAllJobs",function(src,cb)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local jobs = Core.Job.GetAllJobs()
                cb(jobs)
            end
        end)

        Core.Callback.Create("AdminSystem:Server:GetJobData",function(src,cb,hashName)
            local job = Core.Job.GetJob(hashName)
            cb(job)
        end)
    end

    --Get Playerdata
    this.GetPlayerData = function()
        Core.Callback.Create("AdminSystem:Server:GetPlayerData",function(src,cb,playerid,targetsrc)
            
            local Player  = Core.Player.GetPlayerById(playerid)   

            local playerData = {
                serverid = targetsrc,
                playerName = Player.GetPlayerName(),
                gender = Player.GetPlayerGender(),
                birthday = Player.GetPlayerBirthday(),
                money = Player.GetMoney(),
                job = Player.GetDataJob(),
                steamName = GetPlayerName(targetsrc),
                discordid = GetPlayerIdentifiers(targetsrc)[5]
            }
            cb(playerData)
        end)
    end

    -- Get users data 
    this.GetUserData = function()
        Core.Callback.Create("AdminSystem:Server:GetUserInventory",function(src,cb,targetsrc)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(targetsrc)[1])

                if playerid then
                    local player = Core.Player.GetPlayerById(playerid)
                    local inventory = player.GetInventory()

                    local inventoryData = {}
                    for _,item in pairs(inventory) do
                        inventoryData[#inventoryData + 1] = {
                            name = item.name,
                            hashName = item.hashName,
                            weight = item.weight,
                            amount = item.amount
                        }
                    end
                    cb(inventoryData) 
                end
            end
        end)

        Core.Callback.Create("AdminSystem:Server:GetUserVehicles",function(src,cb,targetsrc)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(targetsrc)[1])

                if playerid then
                    local player = Core.Player.GetPlayerById(playerid)
                    local vehicles = player.GetVehicles()
                    cb(vehicles) 
                end
            end
        end)

        Core.Callback.Create("AdminSystem:Server:GetUserSantions",function(src,cb,targetsrc)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(targetsrc)[1])

                if playerid then
                    local player = Core.Player.GetPlayerById(playerid)
                    local vehicles = player.GetVehicles()

                    cb(vehicles) 
                end
            end
        end)
    end

    --Update inventory items 
    this.UpdateInventoryUser = function()
        RegisterNetEvent("AdminSystem:Server:DeleteInventory")
        AddEventHandler("AdminSystem:Server:DeleteInventory",function(targetsrc,hashName)
            local src = source
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 2 then 
                local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(targetsrc)[1])

                if playerid then
                    Core.Item.RemoveItem(targetsrc,hashName,9999)
                end
            else 
                TriggerClientEvent("core:showNotification",src,"error","No tienes los permisos para borrar items",3500)
            end
        end)
    end

    --Get Nui tickets
    this.GetAllNuiTickets = function()
        Core.Callback.Create("AdminSystem:Server:GetTickets",function(src,cb)
            local isAdmin = Core.WhiteList.GetPlayerPermisions(GetPlayerIdentifiers(src)[1])
            if isAdmin > 0 then 
                cb(this.ReportTickets)
            end
        end)
    end
    
    return this
end