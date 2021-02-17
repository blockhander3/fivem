local evidence = {}
RegisterNetEvent('blckhndr_evidence:receive')
AddEventHandler('blckhndr_evidence:receive', function(tbl)
	evidence = tbl
end)

local collecting = false
local destroying = false
local id = 0
local start = 0
local tiime = 4000
Util.Tick(function()
	if collecting then
		if start + tiime < GetGameTimer() then
			TriggerServerEvent('blckhndr_evidence:collect', id)
			start = 0
			FreezeEntityPosition(GetPlayerPed(-1),false)
			ClearPedTasks(GetPlayerPed(-1))
			collecting = false
		else
			FreezeEntityPosition(GetPlayerPed(-1),true)
		
		end
	elseif destroying then
		if start + tiime < GetGameTimer() then
			TriggerServerEvent('blckhndr_evidence:destroy', id)
			start = 0
			FreezeEntityPosition(GetPlayerPed(-1),false)
			ClearPedTasks(GetPlayerPed(-1))
			destroying = false
		else
			FreezeEntityPosition(GetPlayerPed(-1),true)
			
			local dict = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@'
			local anim = 'plant_floor'
			if not HasAnimDictLoaded(dict) then
				RequestAnimDict(dict)
				while not HasAnimDictLoaded(dict) do
					Wait(0)
				end
			end
			if not IsEntityPlayingAnim(GetPlayerPed(-1), dict, anim, 3) and not IsPedRagdoll(GetPlayerPed(-1)) then
				TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
			end
		end
	end
end)

local displaying = false
RegisterNetEvent('blckhndr_evidence:display')
AddEventHandler('blckhndr_evidence:display', function(tbl)
	displaying = tbl
end)
Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if displaying then
			if displaying.e_type == 'blood' then
				Util.DrawText3D(displaying.loc.x, displaying.loc.y, displaying.loc.z, '~r~Vér~w~\nDNA MARKUP: '..displaying.details.dnastring..'\n\n[LALT+E] Bezárás', {255,255,255,240}, 0.25)
			end
			if displaying.e_type == 'casing' then
				Util.DrawText3D(displaying.loc.x, displaying.loc.y, displaying.loc.z, '~r~'..displaying.details.ammoType..' Casing~w~\nMarking: '..displaying.details.serial..'\n\n[LALT+E] Bezárás', {255,255,255,240}, 0.25)
			end
			if IsControlPressed(0, 19) then
				if IsControlJustPressed(0, 38) then
					displaying = false
				end
			end
		end
		for k, e in ipairs(evidence) do
			if e.e_type == 'blood' then
				if e.loc and GetDistanceBetweenCoords(e.loc.x, e.loc.y, e.loc.z, GetEntityCoords(GetPlayerPed(-1)), true) < 50 then
					DrawMarker(25,e.loc.x, e.loc.y, e.loc.z - 0.95, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(e.loc.x, e.loc.y, e.loc.z, GetEntityCoords(GetPlayerPed(-1)), false) < 0.5 then
						if not exports["blckhndr_ems"]:isCrouching() then
							Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Guggolj le, hogy megnézhesd', {255,255,255,50}, 0.2)
							if collecting or destroying then
								Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér~w~\nMüködik...', {255,255,255,240}, 0.2)
							else
								if exports["blckhndr_police"]:blckhndr_PDDuty() then
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér\n[LALT+E] Összegyüjtés', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											collecting = true
											id = k
											start = GetGameTimer()
										end
									end
								else
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér~w~\n[LALT+E] Elpusztítás', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											destroying = true
											id = k
											start = GetGameTimer()
										end
									end
								end
							end
						else
							if collecting or destroying then
								Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér~w~\nMüködik...', {255,255,255,240}, 0.2)
							else
								if exports["blckhndr_police"]:blckhndr_PDDuty() then
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér\n[LALT+E] Összegyüjtés', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											collecting = true
											id = k
											start = GetGameTimer()
										end
									end
								else
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Vér~w~\n[LALT+E] Elpusztítás', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											destroying = true
											id = k
											start = GetGameTimer()
										end
									end
								end
							end
						end
					end
				end
			end
			if e.e_type == 'casing' then
				if GetDistanceBetweenCoords(e.loc.x, e.loc.y, e.loc.z, GetEntityCoords(GetPlayerPed(-1)), true) < 50 then
					DrawMarker(25,e.loc.x, e.loc.y, e.loc.z - 0.95, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(e.loc.x, e.loc.y, e.loc.z, GetEntityCoords(GetPlayerPed(-1)), false) < 0.5 then
						if not exports["blckhndr_ems"]:isCrouching() then
							Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~Guggolj le, hogy megnézhesd', {255,255,255,50}, 0.2)
						else
							if collecting or destroying then
								Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~'..e.details.ammoType..' Casing~w~\nWorking...', {255,255,255,240}, 0.2)
							else
								if exports["blckhndr_police"]:blckhndr_PDDuty() then
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~'..e.details.ammoType..' Casing~w~\n[LALT+E] Összegyüjtés', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											collecting = true
											id = k
											start = GetGameTimer()
										end
									end
								else
									Util.DrawText3D(e.loc.x, e.loc.y, e.loc.z, '~r~'..e.details.ammoType..' Casing~w~\n[LALT+E] Elpusztítás', {255,255,255,100}, 0.2)
									if IsControlPressed(0, 19) then
										if IsControlJustPressed(0, 38) then
											destroying = true
											id = k
											start = GetGameTimer()
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

TriggerServerEvent('blckhndr_evidence:request')
