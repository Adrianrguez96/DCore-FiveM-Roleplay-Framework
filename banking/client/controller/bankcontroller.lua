BankController = function()
    local this = {}

    this.nearBanking = false

    this.Run = function()
        this.CreateBlips()
        this.DetectBanksPositions()
    end

    this.CreateBlips = function()
        Citizen.CreateThread (function()
            for _,coords in pairs(Config.BankLocations) do
                Core.Utility.CreateBlipForCoords(coords,Config.Blip.Type,2,Config.Blip.Scale,Config.Blip.Color,Config.Blip.Title)
            end
        end)
    end

    this.DetectBanksPositions = function()
        Citizen.CreateThread(function()
            while true do 
                Citizen.Wait(2000)
                if this.NearBankingPosition() and not this.nearBanking then
                    this.nearBanking = true 
                    this.KeyBankingPressing() 
                elseif not this.NearBankingPosition() then 
                    this.nearBanking = false
                end
            end
        end)
    end


    this.KeyBankingPressing = function()
        Citizen.CreateThread(function()
            while this.nearBanking do
                Citizen.Wait(1)
                if IsControlJustPressed(1, 38) then
                    SendNUIMessage({status ="openBanking"})
                    SetNuiFocus(true,true)
                end
            end
        end)
    end

    this.NearBankingPosition = function()
        local playercoords = GetEntityCoords(PlayerPedId())

        for _,banks in pairs(Config.BankLocations) do
            if #(playercoords - banks) < 5.0 then return true end 
        end

        for _,atmProp in pairs(Config.ATMModels) do
            local atm = GetClosestObjectOfType(playercoords, 1.0, GetHashKey(atmProp), false, false, false)
            if DoesEntityExist(atm) then return true end
        end
    end

    return this
end
