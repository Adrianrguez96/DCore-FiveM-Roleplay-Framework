WhiteList = function(whiteListData)

    local this = {}

    this.id = whiteListData.id
    this.identifier = whiteListData.identifier
    this.discordName = whiteListData.discordName
    this.adminLevel = whiteListData.adminLevel

    -- Get player admin
    this.GetPlayerPermision = function ()
        return this.adminLevel
    end
   
    return this
end