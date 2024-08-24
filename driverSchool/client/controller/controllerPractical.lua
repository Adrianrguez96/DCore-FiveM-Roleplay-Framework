controllerPractical = function()
    
    local this = {}

    this.vehicleTest = nil
    this.instructorPed = nil
    this.typeTest = nil
    this.CheckPointTest = 1
    this.ExamErrors = 0

    this.StartPracticalTest = function(type)
        Core.Vehicle.VehicleSpawn(Config.vehicleSpawn.Model[type],Config.vehicleSpawn.Pos,true,function(vehicle)
            SetVehicleColours(vehicle,0,0)
            SetVehicleFuelLevel(vehicle, 100.0)

            if type ~= "motorcycleLicense" then
                this.instructorPed = CreatePedInsideVehicle(vehicle,0,GetHashKey('s_m_m_gentransport'), 0, true, false)
                SetPedCombatMovement(instructorPed,0)
            end
            this.vehicleTest = vehicle
            this.typeTest = type
            print (this.typeTest)
            SendNUIMessage({status = "notification",TextExam = "Bien acabas de pagar el precio por hacer el examen de conducir. En estos momentos el instructor te esta esperando fuera para comenzar el examen."})
            this.StartTest()
        end)
    end

    this.StartTest = function()
        Citizen.CreateThread(function()

            while this.typeTest ~= nil do
                Citizen.Wait(0)
    
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if IsPedInVehicle(PlayerPedId(),this.vehicleTest, false) then 
                    if #(PlayerCoords - Config.TheoricalPoint[this.CheckPointTest]) < Config.PointSize then 
                        
                        SendNUIMessage({status = "notification",TextExam = Config.ExamInstructions[this.CheckPointTest]})
    
                        if this.CheckPointTest == #Config.TheoricalPoint then
                            TriggerServerEvent("driverSchool:Sever:GiveLicense",this.typeTest)
                            this.FinishExam()
                        end
                        this.CheckPointTest = this.CheckPointTest + 1
                    end
                end
            end
        end)

        Citizen.CreateThread (function()

            while this.typeTest ~= nil do 
                -- local VehicleSpeed = GetEntitySpeed(vehicleTest) * 3.6
                local VehicleHealth = GetEntityHealth(this.vehicleTest)
        
                if this.ExamErrors >= Config.MaximumErrors then
                    SendNUIMessage({status = "notification",TextExam = "Has superado el número máximo de fallos permitidos a la hora de llevar a cabo la prueba. Vuelve cuando te hayas leido todo el manual y lo tengas bien fresco"})
                    this.FinishExam()
                elseif VehicleHealth <= 900 then
                    SendNUIMessage({status = "notification",TextExam = "¿Pero que acabas de hacer? Has dejado el coche hecho chocapic y, en esta ciudad, las reparaciones son extremadamente caras. A ver que le dijo al jefe ..."})
                    this.FinishExam()
                end
                Citizen.Wait(4000)
            end
        end)
    end

    this.FinishExam = function()
        DeleteEntity(this.instructorPed)
        DeleteVehicle(this.vehicleTest)

        this.CheckPointTest = 1
        this.ExamErrors = 0
        this.typeTest = nil 
    end
    return this

end