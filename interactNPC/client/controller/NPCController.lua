NPCController = function()
    local this = {}

    this.NPCData = {}

    this.Run = function()
        this.TalkToNPC()
    end

    this.CreateNPC  = function (coordx,coordy,coordz,hashSkin,dialog,options) 
        local ped = CreatePed(0,GetHashKey(hashSkin),coordx,coordy,coordz,0.0,true,true)
        SetEntityInvincible(ped, true)
        this.NPCData[#this.NPCData + 1] =
        {
            ['coords'] = {x = coordx, y = coordy, z = coordz},
            ['hash'] = hashSkin,
            ['dialog'] = dialog,
            ['options'] = options
        }
        print(this.NPCData[1]['coords'].z)
    end

    this.TalkToNPC = function ()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                for k,coords in pairs(this.NPCData) do
                    if IsControlJustPressed(1,350)  then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        if GetDistanceBetweenCoords(playerCoords,coords['coords'].x, coords['coords'].y,coords['coords'].z, true) < 3.0 then
                            print("va")
                        end
                    end
                end
            end
        end)
    end
    return this
end