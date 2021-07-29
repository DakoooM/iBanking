local ESX = nil
CreateThread(function()
    while ESX == nil do
        ESX = exports.es_extended:getSharedObject()
        while not ESX.IsPlayerLoaded() do 
            Wait(20)
        end
    end
end)

function Banking.getTransaction(type)
    ESX.TriggerServerCallback("iBanque:getListAndMoney", function(table) 
        if type == "selectsql" then
            Banking.ListTransaction = table
        elseif type == "getbank" then
            Banking.MoneyBank = table
        end
    end, type)
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

Banking.keyBoard = function(nameInput, Title, text, maxCharacters)
    SetPlayerControl(PlayerId(), false, 12)
    AddTextEntry(nameInput, Title) 
    DisplayOnscreenKeyboard(1, nameInput, "", text, "", "", "", maxCharacters)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Wait(500) 
        return result 
    else
        Wait(500) 
        return nil 
    end
end

local ColorVar, openBanking = "", false
MenuBankingMain = RageUI.CreateMenu("ATM", "Banque", iBanque.Config.PositionMenu.x, iBanque.Config.PositionMenu.y)
MenuBankingMain.Closed = function()
    SetPlayerControl(PlayerId(), true, 12)
    openBanking = false
end

DepotMenuMain = RageUI.CreateSubMenu(MenuBankingMain, "Dépôt", "Banque", iBanque.Config.PositionMenu.x, iBanque.Config.PositionMenu.y)
RetraitMenuMain = RageUI.CreateSubMenu(MenuBankingMain, "Retrait", "Banque", iBanque.Config.PositionMenu.x, iBanque.Config.PositionMenu.y)
TransactMenuMain = RageUI.CreateSubMenu(MenuBankingMain, "Historique", "Banque", iBanque.Config.PositionMenu.x, iBanque.Config.PositionMenu.y)
TransactMenuMain:DisplayPageCounter(true)

Banking.openBanking = function()
    if openBanking == false then
        if openBanking then 
            openBanking = false
        else
            openBanking = true
            Banking.getTransaction("getbank")
            RageUI.Visible(MenuBankingMain, true)
            SetPlayerControl(PlayerId(), false, 12)
            CreateThread(function()
                while openBanking do
                    Wait(1.0)
                    RageUI.IsVisible(MenuBankingMain, function()

                        RageUI.Separator("Banque: ~b~" ..tostring(Banking.MoneyBank).. "$~s~")

                        for index, var in pairs (iBanque.Config.MainMenu) do
                            RageUI.Button(var.button, var.desc, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    var.funcs()
                                end
                            }, var.sub())
                        end
                    end)

                    RageUI.IsVisible(DepotMenuMain, function()
                        for index, var in pairs (iBanque.Config.DepotMenuMain) do
                            RageUI.Button(var.button, var.desc, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    var.funcs()
                                    Banking.getTransaction("getbank")
                                end
                            })
                        end
                    end)
                    
                    RageUI.IsVisible(RetraitMenuMain, function()
                        for index, var in pairs (iBanque.Config.RetraitMenuMain) do
                            RageUI.Button(var.button, var.desc, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    var.funcs()
                                    Banking.getTransaction("getbank")
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(TransactMenuMain, function()
                        if json.encode(Banking.ListTransaction) ~= "[]" then
                            for index, transact in ipairs (Banking.ListTransaction) do
                                if transact.type == "depot" then
                                    ColorVar = "~g~$"
                                elseif transact.type == "retrait" then
                                    ColorVar = "~r~$"
                                end
                                RageUI.Button("Type: " ..transact.type.. " (" ..ColorVar.. "" ..tostring(transact.amount).. "~s~)", "Le: " ..transact.hours, {RightLabel = "→→"}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("iBanque:DeleteFromTable", transact.id)
                                        RageUI.GoBack()
                                    end
                                })
                            end
                        else
                            RageUI.Button("~r~Aucune Transactions~s~", nil, {}, true, {})
                        end
                    end)
                end
            end)
        end
    end
end

Keys.Register("E", "-openbankatm", "Ouvrir le menu ATM", function()
    for index, objects in ipairs (iBanque.Config.ATMObjects) do
        local myCoords = GetEntityCoords(PlayerPedId())
        local getClosestObjects = GetClosestObjectOfType(myCoords.x, myCoords.y, myCoords.z, 0.7, GetHashKey(objects), true, true, true)
        if getClosestObjects ~= 0 then
            Banking.openBanking()
        end
    end
end)