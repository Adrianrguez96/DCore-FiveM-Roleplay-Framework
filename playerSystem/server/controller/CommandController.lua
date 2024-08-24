CommandController = function()
    local this = {}

    this.Run = function()
        this.UserBasicCommands()
    end

    this.UserBasicCommands = function() 

        Core.Commands.Add("msg","Te permite enviar un mensaje privado a otro usuario",{{name = "playerid", help ="Id del jugador"},{name = "texto", help ="Texto"}},true,function(source,args)
            local src = source
            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(args[1])[1])
            local msg = table.concat(args," ")

            if playerid then
                TriggerClientEvent("chat:addMessage",src, {
                    color = { 255, 0, 0},           
                    multiline = false,            
                    args = {"[Msg a id: " .. args[1] .. "]", string.sub(msg,2)}              
                })   
                TriggerClientEvent("chat:addMessage",tonumber(args[1]), {
                    color = { 255, 0, 0},           
                    multiline = false,            
                    args = {"[Msg de id: " .. args[1] .. "]", string.sub(msg,2)}          
                })  
            else
                TriggerClientEvent("core:showNotification",src,"error","Has puesto una id invalida",3500) 
            end 
        end)

        Core.Commands.Add("dinero","Te permite saber el dinero que tienes en cartera",{},false,function(source,args)
            local src = source

            local playerid = Core.Player.GetPlayerOnlineId(GetPlayerIdentifiers(src)[1])
            local player = Core.Player.GetPlayerById(playerid)
            local money = player.GetMoney()

            TriggerClientEvent("chat:addMessage",src, {
                color = { 255, 0, 0},           
                multiline = false,            
                args = {"[Dinero en mano]: " .. money .."$"}          
            })  
        end)
    end

    return this
end