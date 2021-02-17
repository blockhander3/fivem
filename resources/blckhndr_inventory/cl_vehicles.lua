RegisterNetEvent('blckhndr_inventory:veh:glovebox')
AddEventHandler('blckhndr_inventory:veh:glovebox', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		TriggerServerEvent('blckhndr_inventory:veh:request', GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 'glovebox')
	else
		exports['mythic_notify']:DoHudText('error', 'Járműben kell lenned, hogy használhasd.', 3000)
	end
end)