ESX 						   = nil
local connectedPolice       	   = 0
local playerConnected = {}
local atmrob = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Count Police
function CountPolice()
	local xPlayers = ESX.GetPlayers()
	connectedPolice = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			connectedPolice = connectedPolice + 1
		end
	end
	
	SetTimeout(60000, CountPolice)
end

CountPolice()

ESX.RegisterUsableItem('lockpick', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if connectedPolice >= Config.RequiredCops then
        TriggerClientEvent('nb_atmrob:client:ATMCheck', source)
    else
        xPlayer.showNotification(_U('nedostatekpd', Config.RequiredCops))
    end
end)

RegisterServerEvent('nb_atmrob:server:getcash')
AddEventHandler('nb_atmrob:server:getcash', function(dalto, atm)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = math.random(5000,15000)
    if atm and dalto then 
        if atmrob[source] then 
            atmrob[source] = false
            if Config.BlackMoney then 
                xPlayer.addAccountMoney('black_money', cash)
            else
                xPlayer.addMoney(cash)
            end
            xPlayer.removeInventoryItem('lockpick', 1)
            xPlayer.showNotification(_U('dostalpenize', cash))
        else
            print(GetPlayerName(source).. ' Tried some fishy things')
        end
    else
        xPlayer.removeInventoryItem('lockpick', 1)
    end
end)

RegisterServerEvent('nb_atmrob:server:startedrob')
AddEventHandler('nb_atmrob:server:startedrob', function()
    if atmrob[source] == nil or atmrob[source] == false then 
        atmrob[source] = true
    end
end)

