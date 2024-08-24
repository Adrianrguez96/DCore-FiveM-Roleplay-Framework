Config = {}

Config.LicencePoint = vector3(5.71,-159.94,55.24)
Config.ControlKey = 38

Config.DMVMenu = {
    {
        header = "Licencia para coches",
        params = {
            event = "DriverSchool:Client:OpenTheoricalTest",
            args = {
                type = "carLicense"
            }
        }
    },
    {
        header = "Licencia para motos",
        params = {
            event = "DriverSchool:Client:OpenTheoricalTest",
            args = {
                type = "motorcycleLicense"
            }
        }
    },
    {
        header = "Licencia para camiones",
        params = {
            event = "DriverSchool:Client:OpenTheoricalTest",
            args = {
                type = "trunkLicense"
            }
        }
    }
}

Config.LicensePrices = {
    ['carLicense'] = 1500,
    ['motorcycleLicense'] = 2000,
    ['trunkLicense'] = 5000
}

Config.vehicleSpawn = {
    Model = {carLicense = 'asea',motorcycleLicense = 'bagger',trunkLicense = 'mule3'},
    Pos = {x = 5.74, y= -150.19, z = 55.77 , healding = 186.43},
}

Config.PointSize = 6
Config.MaximumErrors = 8
Config.TheoricalPoint = {
    vector3(2.79,-143.26,55.97),
    vector3(52.07,-162.2,54.71),
    vector3(208.29,-217.65,53.65),
    vector3(328.51,-268.88,53.46),
    vector3(311.83,-360.73,44.72),
    vector3(209.32,-341.95,43.73),
    vector3(52.55,-282.29,47.16),
    vector3(6.31,-149.97,55.78),
}

Config.ExamInstructions = {
    'Una vez se haya incorporado al carril, continue recto por la avenida hasta la siguiente intercepción.',
    'Bien ... Si vamos a continuar por esta via recto hasta la siguiente intercepción.',
    'Perfecto, continuaremos recto por la avenida y, en cuanto pueda, situese en el carril de la izquierda =>',
    'Vamos a ir en sentido en el hospital se le ve con cara de ser un habitual. Bueno, gire a la derecha => y continue por el carril derecho.',
    'Veo que sabe lo que son los semaforos. Ahora, volvamos a girar a la izquierda en esta intercepcion.',
    'El ayuntamiento... Ahí es donde trabaja mi primo el corrupto. Bueno, continue recto por la avenida hasta la siguiente intercepción.',
    'Bien me he cansado de su cara de inutil y, aparte, apesta a pobre. Volvamos a la autoescuela ya.',
    'Listo ha aprobado el examen y no se ni como ha conseguido llegar aquí. Espero que el oficial Hermoso le quite este carnet algún día.'
}