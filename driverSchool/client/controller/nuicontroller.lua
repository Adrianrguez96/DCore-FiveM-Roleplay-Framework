NuiController = function(controllerPractical)

    local this = {}

    this.PracticalTest = controllerPractical

    this.Run = function()
        this.CloseNuiTest()
    end

    this.CloseNuiTest = function()
        RegisterNUICallback('finishTest', function(data, cb)
            SetNuiFocus(false,false)
            if data.approved then
                this.PracticalTest.StartPracticalTest("carLicense")
            end
        end)
    end
    return this
end