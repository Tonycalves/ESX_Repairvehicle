ESX 						= nil
local mecanoConnected 		= 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountMecano()

	local xPlayers = ESX.GetPlayers()

	mecanoConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'mecano' then
			mecanoConnected = mecanoConnected + 1
		end
	end
	SetTimeout(5000, CountMecano)
end

CountMecano()

RegisterServerEvent('esx_repairvehicule:checkmoney')
AddEventHandler('esx_repairvehicule:checkmoney', function ()
	TriggerEvent('es:getPlayerFromId', source, function (user)
		if mecanoConnected <= 0 then
			if Config.enableprice == true then
				userMoney = user.getMoney()
				if userMoney >= Config.price then
					user.removeMoney(Config.price)
					TriggerClientEvent('esx_repairvehicule:success', source, Config.price)
				else
					moneyleft = Config.price - userMoney
					TriggerClientEvent('esx_repairvehicule:notenoughmoney', source, moneyleft)
				end
			end
		else
			TriggerClientEvent('esx:showNotification', source, "~h~~r~Un mécano est en ville, contactez le !")
		end
	end)
end)