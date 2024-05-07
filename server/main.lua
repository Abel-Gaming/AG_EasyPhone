RegisterServerEvent('esx_EasyPhone:NewCall')
AddEventHandler('esx_EasyPhone:NewCall', function(playerID, recipientID, channelID)
	for k,v in ipairs(GetPlayers()) do
        local id = v
        if v == recipientID then
			local player = source
            local playerName = GetPlayerName(player)
            TriggerClientEvent('esx_EasyPhone:CallRequest', recipientID, playerName, source, channelID)
            if Config.EnableServerLog then
                print('' .. playerName .. ' is calling player ' .. recipientID .. ' on channel ' .. channelID)
            end
			break
        end
    end
end)

RegisterServerEvent('esx_EasyPhone:CallAccepted')
AddEventHandler('esx_EasyPhone:CallAccepted', function(playerID)
    TriggerClientEvent('esx_EasyPhone:CallAcceptedNotification', playerID)
end)

RegisterServerEvent('esx_EasyPhone:CallDeclined')
AddEventHandler('esx_EasyPhone:CallDeclined', function(playerID)
    TriggerClientEvent('esx_EasyPhone:CallDeniedNotification', playerID)
end)