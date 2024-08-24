BankAccount = function(AccountData)

    local this = {}

    this.id = AccountData.id
    this.playerid = AccountData.playerid
    this.name = AccountData.name
    this.money = AccountData.money

    -- Add account money
    this.AddAccountMoney = function(money)
        this.money = money
    end

    -- Get account money
    this.GetAccountMoney = function()
        return this.money
    end

    return this
end