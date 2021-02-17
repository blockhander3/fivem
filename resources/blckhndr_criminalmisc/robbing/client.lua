RegisterNetEvent('blckhndr_criminalmisc:robbing:startRobbing')
AddEventHandler('blckhndr_criminalmisc:robbing:startRobbing', function(ply)
	while not HasAnimDictLoaded('mini@triathlon') do
		RequestAnimDict('mini@triathlon')
		Citizen.Wait(5)
	end
	TaskPlayAnim(GetPlayerPed(-1), "mini@triathlon", "rummage_bag", 8.0, -8, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(2500)
	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(ply)), GetEntityCoords(GetPlayerPed(-1)), true) < 3 then
		exports['mythic_notify']:DoHudText('success', 'Robbing player: '..GetPlayerServerId(ply))
		TriggerServerEvent('blckhndr_inventory:sys:request', GetPlayerServerId(ply), GetPlayerServerId(PlayerId()))
	else
		exports['mythic_notify']:DoHudText('error', 'Player is too far away!')
	end
end)
