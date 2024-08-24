CallbacksController = function()

    local this = {}

    this.Run = function()
        this.Callbacks()
    end

    this.Callbacks = function()
        RegisterNetEvent("driverSchool:Server:Check")
        AddEventHandler("driverSchool:Server:Check",function(pay,type)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local money = player.GetMoney()
            local license = player.GetLicenses()
            local isPay = false
            print(license.carLicense)
            if money >= pay then
                if type == "carLicense" and license.carLicense == 1 then 
                    TriggerClientEvent("core:showNotification",src,"error","Ya tienes la licencia de coche",3500)
                    return
                elseif type == "motorcycleLicense" and license.motorcycleLicense == 1 then 
                    TriggerClientEvent("core:showNotification",src,"error","Ya tienes la licencia de moto",3500)
                    return
                elseif type == "trunkLicense" and license.trunkLicense == 1 then 
                    TriggerClientEvent("core:showNotification",src,"error","Ya tienes la licencia de camión",3500)
                    return
                end

                isPay = true
                player.SetMoney(money - pay)
            else
                isPay = false
                TriggerClientEvent("core:showNotification",src,"error","No tienes suficiente dinero para pagar la licencia",3500)
            end
            TriggerClientEvent("driverSchool:client:IsPlayerPay",src,isPay,type)
        end)

        RegisterNetEvent("driverSchool:Sever:GiveLicense")
        AddEventHandler("driverSchool:Sever:GiveLicense",function(type)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            print(type)
            player.SetLicense(type,1)
            Core.Database.Update("player_licences",{keys= {type},values = {1}},{key= 'playerid',value = playerid})
            TriggerEvent("documents:server:CreateNewLicense")
        end)
    end
    return this
end