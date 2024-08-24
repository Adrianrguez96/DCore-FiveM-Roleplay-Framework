VehicleHudController = function()
    local this = {}

    this.speedLimit = false
    this.SeatBelt = false
    this.Directions = {
        N = 360, 0,
        NE = 315,
        E = 270,
        SE = 225,
        S = 180,
        SW = 135,
        W = 90,
        NW = 45
    }

    this.Run = function()
        this.VehicleHudUpdate()
        this.VehicleControls()
        this.VehicleGPS()
    end

    this.VehicleHudUpdate = function () 
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)

        if IsPedInAnyVehicle(player, false) then
            DisplayRadar(true)
            SendNUIMessage ({
                action='enableVehicleHud',
                speed = GetEntitySpeed(vehicle) * 3.6,
                showHud = IsPauseMenuActive()
            })

        else
            DisplayRadar(false)
            this.SpeedLimit = false
            this.SeatBelt = false

            SendNUIMessage ({
                action='disableVehicleHud',
                showHud = IsPauseMenuActive()
            })
        end
    end

    this.VehicleControls = function ()
        Citizen.CreateThread(function()
            while true do
                if IsPedInAnyVehicle(PlayerPedId(),false) then 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        
                    --Seat belt on
                    if  this.SeatBelt then
                        DisableControlAction(0, 75, true) 
                        DisableControlAction(27, 75, true) 
                    end
            
                    --Speed vehicle limit
                    if IsControlJustPressed(1, 73) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                        if this.SpeedLimit then
                            SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,'CHandlingData','fInitialDriveMaxFlatVel'))
                            TriggerEvent("core:showNotification","error","Has quitado el limitador de velocidad",3500)
                            this.SpeedLimit = false
                        else
                            local maxSpeed = GetEntitySpeed(vehicle)
                            SetEntityMaxSpeed(vehicle, maxSpeed)
                            TriggerEvent("core:showNotification","check","Has puesto el limitador a " .. math.floor(maxSpeed * 3.6) .. " km/h",3500)
                            this.SpeedLimit = true
                        end
                    end
            
                    -- Put seat belt in vehicle
                    if IsControlJustPressed(1,182) and vehicle ~= 0 then
                        this.SeatBelt = not this.SeatBelt
                        SendNUIMessage({
                            action = 'setSeatbelt',
                            state = this.SeatBelt
                        })
                    end
                end
                Citizen.Wait(1)
            end
        end)
    end

    this.VehicleGPS = function () 
        Citizen.CreateThread(function()
            while true do
                --Take and send location information when you are in vehicle
                if IsPedInAnyVehicle(PlayerPedId(),false) then
                    
                    local coords = GetEntityCoords(PlayerPedId())
                    local heading = GetEntityHeading(PlayerPedId())
                    for k, v in pairs(this.Directions) do
                        if (math.abs(heading - v) < 22.5) then
                            heading = k;
                  
                            if (heading == 1) then
                                heading = 'N';
                                break;
                            end
        
                            break;
                        end
                    end
                    SendNUIMessage({
                        action ='updateLocation',
                        direction = heading,
                        zoneName = this.GetZoneName(GetNameOfZone(coords.x, coords.y, coords.z)),
                        streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)),
                        showHud = IsPauseMenuActive()
                    })
                end
                Citizen.Wait(1000)
            end
        end)
    end

    this.GetZoneName = function(name)
        local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", 
        ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", 
        ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", 
        ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", 
        ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", 
        ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", 
        ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", 
        ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", 
        ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", 
        ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", 
        ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", 
        ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", 
        ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", 
        ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", 
        ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", 
        ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", 
        ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
        return zones[name]
    end

    return this
end