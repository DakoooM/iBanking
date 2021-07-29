local ESX = exports.es_extended:getSharedObject()
local iBanque = {}

iBanque.getLocalTime = function()
    local myDate = os.date("%d/%m/%Y", os.time())
    local myTime = os.date("%H:%M:%S", os.time())
    return myDate.. " " ..myTime
end

iBanque.setSQLTransaction = function(args)
    local xPlayer = ESX.GetPlayerFromId(args.playerId)
    MySQL.Async.execute("INSERT INTO `iBanque` (identifier, type, amount, hours) VALUES (@identifier, @type, @amount, @hours)", {
        ["@identifier"] = xPlayer.identifier,
        ["@type"] = args.type,
        ["@amount"] = args.amout,
        ["@hours"] = args.hours
    }, function(after)
        print("After", after)
    end)
end

RegisterServerEvent("iBanque:setNewTransaction")
AddEventHandler("iBanque:setNewTransaction", function(args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args.type == "depot" then
        if xPlayer.getMoney() >= args.number then
            xPlayer.removeMoney(args.number)
            xPlayer.addAccountMoney('bank', args.number)
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~g~<C>Dépôt</C>~s~\nVous avez déposer $" ..tostring(args.number).. " dans votre compte en banque")
            iBanque.setSQLTransaction({playerId = xPlayer.source, type = args.type, amout = args.number, hours = iBanque.getLocalTime()})
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~<C>Impossible</C>~s~\nVous n'avez pas assez d'argent dans votre portefeuille")
        end
    elseif args.type == "retrait" then
        if xPlayer.getAccount('bank').money >= args.number then
            xPlayer.addMoney(args.number)
            xPlayer.removeAccountMoney('bank', args.number)
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~<C>Retrait</C>~s~\nVous avez retirer $" ..tostring(args.number).. " de votre compte en banque")
            iBanque.setSQLTransaction({playerId = xPlayer.source, type = args.type, amout = args.number, hours = iBanque.getLocalTime()})
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~<C>Impossible</C>~s~\nVous n'avez pas assez d'argent sur votre compte bancaire")
        end
    end
end)

RegisterServerEvent("iBanque:DeleteFromTable")
AddEventHandler("iBanque:DeleteFromTable", function(idSelected)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM `iBanque` WHERE id=@id AND identifier=@identifier", {
        ["@id"] = tostring(idSelected),
        ["@identifier"] = xPlayer.identifier
    }, function(result) 
    end)
end)

ESX.RegisterServerCallback("iBanque:getListAndMoney", function(source, callback, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "selectsql" then
        MySQL.Async.fetchAll("SELECT * FROM `iBanque` WHERE identifier=@identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result)
            callback(result)
        end)
    elseif type == "getbank" then
        callback(xPlayer.getAccount('bank').money)
    end
end)