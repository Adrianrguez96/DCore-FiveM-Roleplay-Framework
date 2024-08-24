ClotherShopController = function()
    local this = {}

    this.nearClotherShop = false

    this.Run = function()
        --this.CreateBlips()
        this.DetectClotherShopPositions()
    end

    this.CreateBlips = function()
        Citizen.CreateThread (function()
            for _,coords in pairs(Config.ClotherStoreLocation) do
                Core.Utility.CreateBlipForCoords(coords,Config.Blip.Type,2,Config.Blip.Scale,Config.Blip.Color,Config.Blip.Title)
            end
        end)
    end

    this.DetectClotherShopPositions = function()
        Citizen.CreateThread(function()
            while true do 
                Citizen.Wait(2000)
                if this.NearClotherShopPosition() and not this.nearClotherShop then
                    this.nearClotherShop = true 
                    this.KeyClothingPressing() 
                elseif not this.NearClotherShopPosition() then 
                    this.nearClotherShop = false
                end
            end
        end)
    end


    this.KeyClothingPressing = function()
        Citizen.CreateThread(function()
            while this.nearClotherShop do
                Citizen.Wait(1)
                if IsControlJustPressed(1, 38) then
                    SendNUIMessage({status ="openClotherShop"})
                    SetNuiFocus(true,true)
                end
            end
        end)
    end

    this.NearClotherShopPosition = function()
        local playercoords = GetEntityCoords(PlayerPedId())

        for _,banks in pairs(Config.ClotherStoreLocation) do
            if #(playercoords - banks) < 5.0 then return true end 
        end
    end

    return this
end
