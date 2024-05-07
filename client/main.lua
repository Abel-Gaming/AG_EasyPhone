local CallPending = false
local CallPendingChannel = 0
local CallPendingID = nil

----- COMMANDS -----
RegisterCommand('call', function(source, args)
	local playerID = PlayerPedId()
	local recipientID = args[1]
	local channelID = math.random(1, 999)

	TriggerServerEvent('esx_EasyPhone:NewCall', playerID, recipientID, channelID)
	exports['pma-voice']:setCallChannel(channelID)
	exports['pma-voice']:addPlayerToCall(channelID)
	exports['pma-voice']:setCallVolume(50)
end)

RegisterCommand('acceptcall', function(source, args)
	if CallPending then
		exports['pma-voice']:setCallChannel(CallPendingChannel)
		exports['pma-voice']:addPlayerToCall(CallPendingChannel)
		exports['pma-voice']:setCallVolume(50)
		InfoMessage("Call Accepted")
		TriggerServerEvent('esx_EasyPhone:CallAccepted', CallPendingID)
		CallPending = false
		CallPendingChannel = 0
		CallPendingID = nil
	end
end)

RegisterCommand('denycall', function(source, args)
	if CallPending then
		InfoMessage("Call Declined")
		TriggerServerEvent('esx_EasyPhone:CallDeclined', CallPendingID)
		CallPending = false
		CallPendingChannel = 0
	end
end)

RegisterCommand('endcall', function(source, args)
	exports['pma-voice']:setCallChannel(0)
	InfoMessage('Call Ended')
end)

RegisterCommand('checkcall', function()
	local plyState = LocalPlayer.state
	local callChannel = plyState.callChannel
	print(callChannel)
end)

----- EVENTS -----
RegisterNetEvent('esx_EasyPhone:CallRequest')
AddEventHandler('esx_EasyPhone:CallRequest', function(playerName, playerID, channelID)
	InfoMessage("~b~" .. playerName .. "~w~ is calling. Do /acceptcall to accept the call")
	CallPending = true
	CallPendingChannel = channelID
	CallPendingID = playerID
end)

RegisterNetEvent('esx_EasyPhone:CallAcceptedNotification')
AddEventHandler('esx_EasyPhone:CallAcceptedNotification', function()
	InfoMessage('The player accepted the call')
end)

RegisterNetEvent('esx_EasyPhone:CallDeniedNotification')
AddEventHandler('esx_EasyPhone:CallDeniedNotification', function()
	InfoMessage('The player denied the call')
	exports['pma-voice']:setCallChannel(0)
end)

----- FUNCTIONS -----
function InfoMessage(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~y~[INFO]~w~ ' .. message)
	DrawNotification(false, true)
end