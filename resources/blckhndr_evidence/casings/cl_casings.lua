local wep

RegisterNetEvent('blckhndr_evidence:weaponInfo')
AddEventHandler('blckhndr_evidence:weaponInfo', function(weapon)
	if weapon ~= nil then
		wep = weapon
	end
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if IsPedShooting(GetPlayerPed(-1)) and exports["blckhndr_criminalmisc"]:HoldingWeapon() and not exports["blckhndr_police"]:blckhndr_PDDuty() then
			--print(wep)
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local coords = {
			 x = pos.x,
			 y = pos.y,
			 z = pos.z
			}
			if wep ~= nil then
				TriggerServerEvent('blckhndr_evidence:drop:casing',wep,pos)
			end
			if wep.isAuto then
				Citizen.Wait(500)
			else
				Citizen.Wait(1000)
			end
		end
	end
end)