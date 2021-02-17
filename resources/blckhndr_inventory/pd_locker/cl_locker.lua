local spot = {
	{x = 1841.2465820312, y = 3691.439453128, z = 34.258255004883},
	{x = -432.40658569336, y = 6000.46484375, z = 31.716529846191}
}

	


Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		for k, spot in pairs(spot) do
		if GetDistanceBetweenCoords(spot.x, spot.y, spot.z, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
			DrawMarker(25,spot.x, spot.y, spot.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(spot.x, spot.y, spot.z, GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
				if exports["blckhndr_doormanager"]:IsDoorLocked(21) == false or exports["blckhndr_police"]:blckhndr_PDDuty() then
					Util.DrawText3D(spot.x, spot.y, spot.z, '[E] ~b~Rendörségi tároló', {255,255,255,200}, 0.25)
					if IsControlJustPressed(0,38) then
						TriggerServerEvent('blckhndr_inventory:locker:request')
					end
					if exports["blckhndr_police"]:blckhndr_getPDLevel() > 8 then
						Util.DrawText3D(spot.x, spot.y, spot.z+0.2, '[LALT+NUM5] ~r~RENDÖRSÉGI TÁROLÓ KIÜRÍTÉSE\n(nem visszavonható)', {255,255,255,200}, 0.25)
						if IsControlPressed(0,19) then
							if IsControlJustPressed(0,126) then
								TriggerServerEvent('blckhndr_inventory:locker:empty')
							end
						end
					end
				end
			end
		end
	end
		
	end
end)
