DocumentController = function()
    local this = {}

    this.Run = function()
        this.GetPlayerDocuments()
        this.CreateNewDocument()
    end

    this.GetPlayerDocuments = function()
        RegisterNetEvent("documents:getPlayerDocuments")
        AddEventHandler("documents:getPlayerDocuments", function(target,hashName,meta)
        TriggerClientEvent("core:client:OpenDocument",target,hashName,meta)
        end)
    end

    this.CreateNewDocument = function()
        RegisterNetEvent("documents:server:CreateNewDocument")
        AddEventHandler("documents:server:CreateNewDocument",function()
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local player = Core.Player.GetPlayerById(Core.Player.GetPlayerOnlineId(identifier))
            Core.Item.GiveItem(src,"item_idcard",1,{
                idNumber = this.RandomNumberId(player.GetPlayerId()),
                name = player.GetPlayerName().name,
                lastName = player.GetPlayerName().lastName,
                gender = player.GetPlayerGender(), 
                birthday = player.GetPlayerBirthday(),
                expedition = os.date('%d/%m/%Y')
            })
        end)

        RegisterNetEvent("documents:server:CreateNewLicense")
        AddEventHandler("documents:server:CreateNewLicense",function(licenseType)
            local src = source
            local identifier = GetPlayerIdentifiers(src)[1]
            local player = Core.Player.GetPlayerById(Core.Player.GetPlayerOnlineId(identifier))
            Core.Item.GiveItem(src,"item_licenseCard",1,{
                name = player.GetPlayerName().name,
                lastName = player.GetPlayerName().lastName,
                gender = player.GetPlayerGender(), 
                birthday = player.GetPlayerBirthday(),
                expedition = os.date('%d/%m/%Y'),
                licenseType = licenseType
            })
        end)
    end

    this.RandomNumberId = function(playerid)
        math.randomseed(playerid)
        local randomValue = math.random() * 1000000
        return tonumber(string.format("%.0f", randomValue))
    end

    return this
end