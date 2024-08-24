Ban = function (banData)
    local this = {}

    this.id = banData.id
    this.identifier = banData.identifier
    this.time = banData.time
    this.reason = banData.reason
    
    
    this.BanClientEntity = function()
        return {
            id = this.id,
            time = this.time,
            reason = this.reason
        }
    end

    return this
end