Player = function (playerData)
    local this = {}

    -- Save the basic data players
    this.id = playerData.id
    this.identifier = playerData.identifier
    this.name = playerData.name
    this.lastName = playerData.lastName
    this.gender = playerData.gender
    this.birthday = playerData.birthday
    this.height = playerData.height
    this.position = json.decode(playerData.position)
    this.isDead = playerData.isDead
    this.isRegister = playerData.isRegister
    this.money = playerData.money
    this.job = json.decode(playerData.job)
    this.skin = json.decode(playerData.skin)
    this.inventory = json.decode(playerData.inventory)
    this.meta = json.decode(playerData.meta)

    this.Vehicles = {}
    this.BankAccounts = {}
    this.License = nil

    -- Add player Vehicles
    this.AddVehicle = function(vehicle)
        this.Vehicles[vehicle.id] = vehicle
    end

    -- Add player licenses
    this.AddLicense = function(license)
        this.License = license
    end

    -- Get license
    this.GetLicenses = function()
        return this.License
    end

    --Set license
    this.SetLicense = function(type,state)
        if type == "carLicense" then
            this.License.carLicense = state
        elseif type == "motorcycleLicense" then
            this.License.motorcycleLicense = state
        elseif type == "trunkLicense" then
            this.License.trunkLicense = state
        end
    end

    --Get all vehicles
    this.GetVehicles = function()
        return this.Vehicles
    end

    this.ChangeDiedState = function(state)
        this.isDead = state
    end

    --Update player coords 
    this.UpdateCoords = function(coords)
        this.position = coords
    end

    -- Get player money
    this.GetMoney = function()
        return this.money
    end

    -- Add player money
    this.SetMoney = function (money) 
        this.money = money
    end

    -- Set player whitelist job
    this.SetPlayerWhitelistJob = function(hash,rank)
        this.job.whitelistJob = hash
        this.job.rank = rank
    end

    -- Set player minor job
    this.SetPlayerJob = function(hash)
        this.job.minorJob = hash 
    end


    -- Get player data job
    this.GetDataJob = function()
        return this.job
    end

    -- Add item to player 
    this.AddItem = function(item,amount,slot)
        slot = slot or this.GetFreeInventorySlot()
        local item = { 
            hashName = item.hashName,
            slot = slot, 
            name = item.name, 
            type = item.type, 
            weight = item.weight, 
            numberPack = item.maxPack, 
            amount = amount, 
            isPocket =  item.isPocket, 
            meta = item.meta
        }

        this.inventory[slot] = item
        print(json.encode(this.inventory))
    end

    -- Remove item to player
    this.RemoveItem = function(item,slot,amount)

        if tonumber(item.amount) > amount then
            this.inventory[slot].amount = this.inventory[slot].amount - amount
        else
            this.inventory[slot] = nil
        end
    end

    --Change mateDataItem
    this.ChangeMetaItem = function(slot,metaName,data)
        this.inventory[slot].meta[metaName] = data or ""
    end

    -- Get inventory
    this.GetInventory = function()
        return this.inventory
    end

    -- See what is the free last inventory slot
    this.GetFreeInventorySlot = function()
        for slot = 1, Config.maxSlots do
            if(this.inventory[slot] == nil) then
                return slot
            end
        end
    end

    -- Get a specific item
    this.GetItem = function(slot)
        return this.inventory[slot]
    end

    --Has a item
    this.HasItem = function(hashName)
        for i,item in pairs(this.inventory) do
            if item.hashName == hashName then
                return i, hashName
            end
        end
        return false
    end

    -- Get inventory weight
    this.GetInventoryWeight = function ()
        local weight = 0

        for _,item in pairs (this.inventory) do
            if item.weight ~= nil then
                weight = weight + (item.weight*item.amount)
            end
        end
        return weight
    end

    -- Add bank account id to player
    this.AddBankAccountId = function(accountid)
        this.BankAccounts[#this.BankAccounts + 1] = accountid
    end

    -- Get account player
    this.GetAccounts = function()
        return this.BankAccounts
    end

    -- Get player name 
    this.GetPlayerName = function()
        return {
            name = this.name,
            lastName = this.lastName
        }
    end

    --Get player id 
    this.GetPlayerId = function()
        return this.id 
    end

    -- Get player birthday 
    this.GetPlayerBirthday = function()
        return this.birthday
    end

    -- Get player sex
    this.GetPlayerGender = function()
        return this.gender
    end

    -- Get player metadata
    this.GetPlayerMeta = function(metadata)
        return this.meta[metadata] or nil
    end

    -- Set player metadata 
    this.SetPlayerMeta = function(metadata,value)
        this.meta[metadata] = value
    end

    -- Send the player data Entity
    this.PlayerClientEntity = function()
        return {
            id = this.id,
            name = this.name,
            lastName = this.lastName,
            gender = this.gender,
            position = this.position,
            isDead = this.isDead,
            isRegister = this.isRegister,
            job = this.job,
            skin = this.skin,
            inventory = this.inventory,
            meta = this.meta
        }
    end

    return this
end