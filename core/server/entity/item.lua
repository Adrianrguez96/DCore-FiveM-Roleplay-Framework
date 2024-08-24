Item = function (itemData)

    local this = {}

    this.id = itemData.id 
    this.hashName = itemData.hash
    this.name = itemData.name
    this.type = itemData.type 
    this.weight = itemData.weight
    this.meta = json.decode(itemData.meta)
    this.price = itemData.price
    this.isPocket = itemData.isPocket

    this.TYPE_WEAPON = 1 
    this.TYPE_PACK = 2
    this.TYPE_FOOD = 3

    -- Get meta item
    this.GetItemMeta = function (metadata)
        return this.meta[metadata] or nil
    end
    
    -- Send the item data Entity
    this.ItemClientEntity = function()
        return {
            id = this.id,
            hashName = this.hashName,
            name = this.name,
            type = this.type,
            weight = this.weight,
            price = this.price,
            meta = this.meta,
            isPocket = this.isPocket
        }
    end

    return this
end

