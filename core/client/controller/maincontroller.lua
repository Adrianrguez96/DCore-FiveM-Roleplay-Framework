MainController = function()
    local this = {}
    this.Game = GameController()
    this.Player = PlayerController()
    this.Death = DeathController ()
    this.Vehicle = VehicleController()
    this.Item = ItemController()
    this.Menu = MenuController()
    this.Loop = LoopController(this.Player,this.Death,this.Vehicle,this.Item,this.Game)
    this.Spawn = SpawnController(this.Loop)

    this.init = function()

        this.Game.init()
        this.Player.init(this.Spawn)
        this.Vehicle.init()
        this.Item.init()
        this.Menu.init()
        this.Loop.DisableGTAHud()
        this.DiscordRichPresenceActive()
        
        TriggerServerEvent("core:server:getPlayers")
    end

    this.DiscordRichPresenceActive = function ()
        SetDiscordAppId(Config.RichPresence.id)
        SetRichPresence("Conectandose al servidor ...")
        SetDiscordRichPresenceAsset(Config.RichPresence.bigImage)
        SetDiscordRichPresenceAssetText(Config.RichPresence.textImage)   
        
        SetDiscordRichPresenceAction(0, "Test button 1", "https//...")
        SetDiscordRichPresenceAction(1, "Test button 2", "fivem://...")
    end
    return this
end