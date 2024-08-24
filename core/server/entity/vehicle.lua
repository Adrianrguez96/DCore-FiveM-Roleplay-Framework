Vehicle = function(vehicleData)
    local this = {}

    -- Save basic data vehicle
    this.id = vehicleData.id
    this.name = vehicleData.name
    this.model = vehicleData.model
    this.price = vehicleData.price

    this.TYPE_CAR = 1 
    this.TYPE_MOTORCYCLE = 2 
    this.TYPE_BIKE = 3 
    this.TYPE_HELICOPTER = 4 
    this.TYPE_AIRPLANE = 5
    this.TYPE_BOAT = 6

    -- Send the vehicle data Entity
    this.VehicleClientEntity = function()
        return {
            id = this.id,
            name = this.name,
            model = this.model,
            price = this.price,
            type = this.type
        }
    end

    return this
end