NuiController = function()

    local this = {}

    this.Run = function()
        this.KeyPressAdminPanel()
        this.NuiExitAdminPanel()
        this.NuiGetOnlineUsers()
        this.NuiGetPlayerData()
        this.NuiGetJobs()
        this.NuiGetUserData()
        this.NuiUpdateUser()
        this.NuiTickets()
    end

    this.KeyPressAdminPanel = function()
        RegisterCommand("adminmenu",function()
            Core.Callback.Trigger("AdminSystem:Server:CheckAdminStatus",function(isAdmin,result)
                if isAdmin then
                    SendNUIMessage({status = "openPanel", result = result})
                    SetNuiFocus(true,true)
                end
            end)
        end)
        RegisterKeyMapping("adminmenu","Abre el menú de administración","keyboard","F7")
    end

    this.NuiExitAdminPanel = function()
        RegisterNUICallback("exit", function(data)
            SetNuiFocus(false,false)
        end)
    end

    this.NuiGetOnlineUsers = function()
        RegisterNUICallback("getUsers",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetAllPlayers",function(players)
                cb(players)
            end)
        end)
    end

    this.NuiGetPlayerData = function()
        RegisterNUICallback("getPlayerData",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetPlayerData",function(playerData)
                cb(playerData)
            end,data.playerid,data.src)
        end)
    end

    this.NuiGetJobs = function()
        RegisterNUICallback("getJobs",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetAllJobs",function(jobData)
                cb(jobData)
            end)
        end)

        RegisterNUICallback("getJobData",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetJobData",function(jobData)
                cb(jobData)
            end,data.hashName)
        end)
    end

    
    this.NuiGetUserData = function()
        RegisterNUICallback("showInventory",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetUserInventory",function(inventoryData)
                cb(inventoryData)
            end,data.src)
        end)

        RegisterNUICallback("showVehicles",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetUserVehicles",function(vehiclesData)
                cb(vehiclesData)
            end,data.src)
        end)

        RegisterNUICallback("showSantions",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetUserSantions",function(santionsData)
                cb(santionsData)
            end,data.src)
        end)
    end

    this.NuiUpdateUser = function()
        RegisterNUICallback("deleteItem",function(data,cb)
            TriggerServerEvent("AdminSystem:Server:DeleteInventory",data.src,data.hashName)
            TriggerEvent("core:showNotification","check","Has borrado el item correctamente",3500)
            cb(true)
        end)

        RegisterNUICallback("gotoPlayer",function(data,cb)
            TriggerServerEvent("Core:CallCommand","goto",data.targetsrc)
        end)

        RegisterNUICallback("bringPlayer",function(data,cb)
            TriggerServerEvent("Core:CallCommand","bring",data.targetsrc)
        end)

        RegisterNUICallback("freezePlayer",function(data,cb)
            TriggerServerEvent("Core:CallCommand","freeze",data.targetsrc)
        end)

        RegisterNUICallback("setPlayerPed",function(data,cb)
            TriggerServerEvent("Core:CallCommand","setped",data.targetsrc .. ' ' .. data.value)
        end)

        RegisterNUICallback("setPlayerItem",function(data,cb)
            TriggerServerEvent("Core:CallCommand","giveitem",data.targetsrc .. ' ' .. data.value.first .. ' ' .. data.value.second)
        end)

        RegisterNUICallback("setPlayerMoney",function(data,cb)
            TriggerServerEvent("Core:CallCommand","setmoney",data.targetsrc .. ' ' .. data.value)
        end)
    end

    this.NuiTickets = function()
        RegisterNUICallback("getTickets",function(data,cb)
            Core.Callback.Trigger("AdminSystem:Server:GetTickets",function(ticketsData)
                cb(ticketsData)
            end)
        end)

        RegisterNUICallback("attendrep",function(data,cb)
            TriggerServerEvent("Core:CallCommand","atrep",data.ticketid)
            cb(true)
        end)

        RegisterNUICallback("delrep",function(data,cb)
            TriggerServerEvent("Core:CallCommand","delrep",data.ticketid)
            cb(true)
        end)
    end

    return this
end