Config = {}

-- Basic servers configs
Config.ServerName = "Servidor DEV"
Config.WhitelistActive = true

-- New player data 
Config.FirstMoney = 5000
Config.FirstSpawn = {
    x = 414.95,
    y = -979.23,
    z = 29.45,
    healding = 93.92
}

-- Player configs
Config.maxSlots = 16
Config.maxWeight = 120
Config.HungerLost = 2
Config.ThirstyLost = 5

-- Time and weather configs
Config.ServerTime = 8
Config.TimeOffset = 0
Config.HospitalTimer = 12
Config.DiedTimer = 12

-- Config admin levels 
Config.AdminLevel = {
    User = 0,
    Moderator = 1,
    Admin = 2,
    Founder = 3
}

--DiscordRichPresenceActive 
Config.RichPresence = {
	id = 835875127182360587,
	bigImage = 'logo',
	textImage = 'D-Core'
}