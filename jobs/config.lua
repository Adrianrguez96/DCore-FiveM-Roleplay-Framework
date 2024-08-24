Config = {}

Config.JobBlips = {
    {
        Title = "Comisaria LSPD",
        Coords = vector3(425.1, -979.5, 30.7),
        Type = 60,
        Color = 29,
        Scale = 0.9
    },
    {
        Title = "Hospital",
        Coords = vector3(307.76, -1433.47, 28.97),
        Type = 61,
        Color = 2,
        Scale = 0.9
    },
    {
        Title = "Ayuntamiento",
        Coords = vector3(-504.78, -211.45, 37.65),
        Type = 419,
        Color = 10,
        Scale = 0.9
    }
}

Config.OnDutyCoords = {
    ["police"] = {
        [1] = vector3(441.09,-975.85,30.69)
    },
    ["medic"] = {
        [1] = vector3(296.38,-603.6,43.3)
    },
    ["government"] = {
        [1] = vector3(441.09,-975.85,30.69)
    }
}

Config.WardrobeCoords = {
    ["police"] = {
        [1] = vector3(451.28,-992.0,30.69)
    }
}

Config.ObjectStoreCoords = {
    ["police"] = {
        [1] = vector3(452.29,-979.9,30.69)
    }
}

Config.WardrobeMenu = {
    ["police"] = {
        {
            header = "Clase A",
            params = {
                event = "Job:Server:GetPlayerGender",
                args = {
                    ClotherName = "ClassA"
                }
            }
        },
        {
            header = "Clase B",
            params = {
                event = "Job:Server:GetPlayerGender",
            }
        }
    }
}

Config.ObjectStoreMenu = {
    ["police"] = {
        {
            header = "Porra",
            params = {
                event = "Job:Server:AddPlayerItem",
                args = {
                    ItemHashName = "weapon_nightstick",
                    ItemAmount = 1
                }
            }
        },
        {
            header = "Taser",
            params = {
                event = "Job:Server:AddPlayerItem",
                args = {
                    ItemHashName = "weapon_stungun",
                    ItemAmount = 1
                }
            }
            
        },
        {
            header = "MP5",
            params = {
                event = "Job:Server:AddPlayerItem",
                args = {
                    ItemHashName = "weapon_smg",
                    ItemAmount = 1
                }
            }
            
        }
    }
}

Config.JobClothersMale = {
    ["police"] = {
        ["ClassA"] = {
            Jacket = 14,
            Shirt = 55,
            Pants = 35,
            Shoes = 24,
            Parachute = 58,
            Rank = 8,
            Hands = 15
        }
    }
}


Config.JobClothersFemale = {
    ["police"] = {
        ["ClassA"] = {
            Jacket = 14,
            Shirt = 48,
            Pants = 34,
            Shoes = 29,
            Parachute = 35,
            Rank = 7,
            Hands = 15
        }
    }
}


