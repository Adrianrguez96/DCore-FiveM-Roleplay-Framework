BankAccountController = function(playerController)
    local this = {}

    this.pController = playerController

    this.BankAccounts = {}

    this.InitBankAccounts = function(BankAccounts)
        for k, v in pairs(BankAccounts) do
            this.BankAccounts[v.id] = BankAccount(v)
        end

        -- Bank Accounts events
        this.AddMoneyAccount()
        this.CreateNewAccount()
    end

    -- Add money in account event
    this.AddMoneyAccount = function()
        RegisterNetEvent("core:server:addMoneyAccount")
        AddEventHandler("core:server:addMoneyAccount", function(accountid,money)
            if not this.BankAccounts[accountid] then
                Framework.Helper.PrintColor("[Error]: No existe una cuenta con esa id en la base de datos")
                return
            end
            this.BankAccounts[accountid].AddAccountMoney(money)
        end)
    end

    --Create a new bank account
    this.CreateNewAccount = function()
        RegisterNetEvent("core:server:createNewBankAccount")
        AddEventHandler("core:server:createNewBankAccount", function(playerid,accountName)
            Core.Database.CreateBankAccount ({
                keys = {
                    'playerid',
                    'accountName',
                    'money'
                }, values = {
                    playerid,
                    accountName,
                    0 -- Initial money in account
                }
            },function(accountEntity)
                BankAccount(accountEntity)
                local player = this.pController.GetPlayerById(tonumber(playerid))
                player.AddBankAccountId(accountEntity.id)
            end)

        end)
    end

    return this
end
