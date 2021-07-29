iBanque = {}

Banking = {}
Banking.ListTransaction = {}
Banking.MoneyBank = {}

iBanque.Config = {
    PositionMenu = {x = 20, y = 100},
    ATMObjects = {
        "prop_fleeca_atm",
        "prop_atm_01",
        "prop_atm_03",
        "prop_atm_02",
    },
    MainMenu = {
        {
            button = "Déposer",
            desc = nil,
            funcs = function() end,
            sub = function() 
                return DepotMenuMain
            end,
        },
        {
            button = "Retrait",
            desc = nil,
            funcs = function() end,
            sub = function() 
                return RetraitMenuMain
            end,
        },
        {
            button = "Historique",
            desc = "Accèdez a l'historique de vos transactions",
            funcs = function() Banking.getTransaction("selectsql") end,
            sub = function()  return TransactMenuMain end,
        },
    },
    DepotMenuMain = {
        {
            button = "Déposer 500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "depot", number = 500})
            end,
        },
        {
            button = "Déposer 1500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "depot", number = 1500})
            end,
        },
        {
            button = "Déposer 2500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "depot", number = 2500})
            end,
        },
        {
            button = "Déposer 3500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "depot", number = 3500})
            end,
        },
        {
            button = "Déposer une somme personalisée",
            desc = nil,
            funcs = function()
                local depotSomme = Banking.keyBoard("DEPOT_BANKING", "Déposer une somme personalisée", "", 4)
                if depotSomme ~= nil and tonumber(depotSomme) then
                    TriggerServerEvent("iBanque:setNewTransaction", {type = "depot", number = tonumber(depotSomme)})
                else
                    ShowNotification("~r~Vous ne pouvez pas faire cela~s~")
                end
            end,
        },
    },
    RetraitMenuMain = {
        {
            button = "Retirer 500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "retrait", number = 500})
            end,
        },
        {
            button = "Retirer 1500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "retrait", number = 1500})
            end,
        },
        {
            button = "Retirer 2500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "retrait", number = 2500})
            end,
        },
        {
            button = "Retirer 3500$",
            desc = nil,
            funcs = function()
                TriggerServerEvent("iBanque:setNewTransaction", {type = "retrait", number = 3500})
            end,
        },
        {
            button = "Retirer une somme personalisée",
            desc = nil,
            funcs = function()
                local retraitSomme = Banking.keyBoard("RETRAIT_BANKING", "Retirer une somme personalisée", "", 4)
                if retraitSomme ~= nil and tonumber(retraitSomme) then
                    TriggerServerEvent("iBanque:setNewTransaction", {type = "retrait", number = tonumber(retraitSomme)})
                else
                    ShowNotification("~r~Vous ne pouvez pas faire cela~s~")
                end
            end,
        },
    },
}