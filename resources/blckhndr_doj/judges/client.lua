-- Court things
local reman = false
local remanded = {x = 255.24212646484, y = -317.28131103516, z = -118.51996612549, h = 78.67879486084}
function remandMe()
	SetEntityHeading(GetPlayerPed(-1), remanded.h)
	SetEntityCoords(GetPlayerPed(-1), remanded.x, remanded.y, remanded.z)
	ExecuteCommand('e sit3')
end

RegisterNetEvent('blckhndr_doj:court:remandMe')
AddEventHandler('blckhndr_doj:court:remandMe', function(judge)
	if remand then
		remand = false
		TriggerEvent('blckhndr_notify:displayNotification', 'You were released from remand', 'centerLeft', 4000, 'success')
		SetEntityCoords(GetPlayerPed(-1), 246.6311340332, -337.29718017578, -118.80003356934)
		TriggerServerEvent('blckhndr_notify:displayNotification', judge, 'The player has been released from remand', 'centerLeft', 4000, 'success')
	else
		remand = true
		local judgePed = GetPlayerPed(GetPlayerFromServerId(judge))
		if GetDistanceBetweenCoords(GetEntityCoords(judgePed, false), GetEntityCoords(GetPlayerPed(-1),false), true) < 5 then
			remandMe()
			
			TriggerEvent('blckhndr_notify:displayNotification', 'You have been remanded by a judge for violent behaviour', 'centerLeft', 4000, 'error')
		else
			TriggerServerEvent('blckhndr_notify:displayNotification', judge, 'You need to be closer to remand a person', 'centerLeft', 4000, 'error')
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if remand then
			if GetDistanceBetweenCoords(remanded.x, remanded.y, remanded.z, GetEntityCoords(GetPlayerPed(-1),false), true) > 5 then
				remandMe()
				TriggerEvent('blckhndr_notify:displayNotification', 'You cannot escape from remand.', 'centerLeft', 4000, 'error')
			end
		end
	end
end)

RegisterNetEvent('blckhndr_doj:judge:spawnCar')
AddEventHandler('blckhndr_doj:judge:spawnCar', function(car)
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey(car)
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end
  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, true)
  SetVehicleOnGroundProperly(spawned_car)
  SetModelAsNoLongerNeeded(vehicle)
	SetEntityAsMissionEntity(spawned_car, false, true)
  Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	TriggerEvent('blckhndr_cargarage:makeMine', spawned_car, GetDisplayNameFromVehicleModel(GetEntityModel(spawned_car)), GetVehicleNumberPlateText(spawned_car))
	TriggerEvent('blckhndr_notify:displayNotification', 'You now own this vehicle!', 'centerLeft', 4000, 'success')
	TriggerEvent('blckhndr_notify:displayNotification', 'You spawned '..car, 'centerLeft', 2000, 'info')
end)