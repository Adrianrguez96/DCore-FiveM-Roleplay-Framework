FrameworkController = function ()

    local this = {}
    
    -- Load Controllers
    this.Player = PlayerController()
    this.Ban = BanController()
    this.WhiteList = WhiteListController()
    this.Vehicle = VehicleController(this.Player)
    this.BankAccount = BankAccountController(this.Player)
    this.Item = ItemController(this.Player)
    this.Job = JobController(this.Player)
    this.Database = Core.Database -- Provisional fixed 

    this.Status = false

    this.Helper = Helper()

    this.init = function(cb) 
        this.Helper.PrintWithTitle(Config.ServerName, "Iniciando Core ...","lightblue")
        this.Helper.PrintWithTitle(Config.ServerName, "1 - Cargando componentes","lightblue")
        this.Helper.PrintWithTitle("Servidor DEV", "2 - Cargando base de datos", "lightblue")
        MySQL.ready(function()
            this.Helper.PrintColor("Base de datos cargada correctamente", "green")

            -- Load players
            this.Helper.PrintWithTitle(Config.ServerName, "3 - Cargando jugadores","lightblue")
            Core.Database.GetPlayers(function(players)
                this.Player.InitPlayers(players)
                this.Helper.PrintColor("Jugadores cargados " .. #players, "green")

                -- Load bans
                this.Helper.PrintWithTitle(Config.ServerName, "4 - Cargando baneos","lightblue")
                Core.Database.GetBans(function(bans)
                    this.Ban.InitBans(bans)
                    this.Helper.PrintColor("Total de baneados cargados " .. #bans, "green")

                    --Load whitelist
                    this.Helper.PrintWithTitle(Config.ServerName, "5 - Cargando whitelist","lightblue")
                    Core.Database.GetWhiteLists(function(whiteLists)
                        this.WhiteList.InitWhiteLists(whiteLists)
                        this.Helper.PrintColor("Total de whitelist cargados " .. #whiteLists, "green")

                        -- Load vehicles
                        this.Helper.PrintWithTitle(Config.ServerName, "6 - Cargando vehiculos","lightblue")
                        Core.Database.GetVehicles(function(vehicles)
                            this.Vehicle.InitVehicles(vehicles)
                            this.Helper.PrintColor("Total de vehiculos cargados " .. #vehicles, "green")

                            -- Load bank accounts 
                            this.Helper.PrintWithTitle(Config.ServerName, "7 - Cargando cuentas bancarias","lightblue")
                            Core.Database.GetBankAccount(function(bankAccounts)
                                this.BankAccount.InitBankAccounts(bankAccounts)
                                this.Helper.PrintColor("Total de cuentas bancarias cargadas " .. #bankAccounts, "green")

                                --Load items 
                                this.Helper.PrintWithTitle(Config.ServerName, "8 - Cargando items","lightblue")
                                Core.Database.GetItems(function(items)
                                    this.Item.InitItems(items)
                                    this.Helper.PrintColor("Total de items cargados " .. #items, "green")

                                    --Load jobs
                                    this.Helper.PrintWithTitle(Config.ServerName, "9 - Cargando trabajos","lightblue")
                                    Core.Database.GetJobs(function(jobs)
                                        this.Job.InitJobs(jobs)
                                        this.Helper.PrintColor("Total de trabajos cargados " .. #jobs, "green")

                                        --Framework inicializado
                                        this.Helper.PrintWithTitle(Config.ServerName, "Framework iniciado correctamente","lightblue")    
                                        this.Status = true               
                                        return cb()
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)

    end

    return this
end