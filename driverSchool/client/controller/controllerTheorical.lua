ControllerTheorical = function(controllerPractical)
    local this = {}

    this.PracticalTest = controllerPractical

    this.Run = function()
        this.TheoricalCallbacks()
    end

    this.TheoricalCallbacks = function()
        RegisterNetEvent("DriverSchool:Client:OpenTheoricalTest")
        AddEventHandler("DriverSchool:Client:OpenTheoricalTest",function(args)
            TriggerServerEvent("driverSchool:Server:Check",Config.LicensePrices[args.type],args.type)

        end)
        RegisterNetEvent("driverSchool:client:IsPlayerPay")
        AddEventHandler("driverSchool:client:IsPlayerPay",function(isPay,type)
            if isPay then
                if type == "carLicense" then
                    SendNUIMessage({status ="openTheoricalTest"})
                    SetNuiFocus(true,true)
                else
                    this.PracticalTest.StartPracticalTest(type)
                end
            end
        end)
    end

    return this
end
