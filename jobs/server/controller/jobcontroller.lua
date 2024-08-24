JobController = function()
    local this = {}

    this.Run = function()
        this.GetGenderEvent()
        this.AddPlayerItem()
    end

    this.GetGenderEvent = function()
        RegisterNetEvent("Job:Server:GetPlayerGender")
        AddEventHandler("Job:Server:GetPlayerGender",function(args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            TriggerClientEvent("Jobs:Client:ChangeClother",src,args.ClotherName,player.GetPlayerGender())
        end)
    end

    this.AddPlayerItem = function()
        RegisterNetEvent("Job:Server:AddPlayerItem")
        AddEventHandler("Job:Server:AddPlayerItem",function(args)
            local src = source
            Core.Item.GiveItem(src,args.ItemHashName,args.ItemAmount)
            TriggerClientEvent("core:showNotification",src,"check","Acabas de coger algo del almacen" ,3500)
        end)
    end
    
    return this
end