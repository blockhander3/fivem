local equipped = false

RegisterNetEvent('blckhndr_inventory:rebreather:use')
AddEventHandler('blckhndr_inventory:rebreather:use', function()
	equipped = true
	equipped_time = GetGameTimer()
	exports['mythic_notify']:DoHudText('success', 'Scuba activated')
end)

local loc = {x = -272.41735839844, y = 6642.5791015625, z = 7.3662776947021}

Citizen.CreateThread(function()
	--[[local bleep = AddBlipForCoord(loc.x, loc.y, loc.z)
	SetBlipSprite(bleep, 597)
	SetBlipColour(bleep, 0)
	SetBlipAsShortRange(bleep, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Scuba Store")
	EndTextCommandSetBlipName(bleep)--]]
	while true do Citizen.Wait(0)
		if equipped then
			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 400.00)
			SetEnableScuba(GetPlayerPed(-1),true)
			if equipped_time+600000 < GetGameTimer() then
				equipped = false
				exports['mythic_notify']:DoHudText('error', 'Scuba expired')
			end
		else
			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 100.00)
			SetEnableScuba(GetPlayerPed(-1),false)
		end
		
		-- store
		if GetDistanceBetweenCoords(loc.x, loc.y, loc.z, GetEntityCoords(GetPlayerPed(-1)), false) < 10 then
			DrawMarker(25,loc.x, loc.y, loc.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(loc.x, loc.y, loc.z, GetEntityCoords(GetPlayerPed(-1)), false) < 1 then
				Util.DrawText3D(loc.x, loc.y, loc.z, '[E] ~b~Búvárfelszerelés ~w~vásárlása', {255,255,255,200}, 0.25)
				if IsControlJustPressed(0,38) then
					if exports["blckhndr_main"]:blckhndr_CanAfford(500) then
						TriggerEvent('blckhndr_bank:change:walletMinus', 500)
						TriggerEvent('blckhndr_inventory:items:add', {
							index = 'scuba',
							name = 'Scuba Gear',
							amt = 1,
							data = {
								weight = 6.0
							},
						})
					end
				end
			end
		end
	end
end)