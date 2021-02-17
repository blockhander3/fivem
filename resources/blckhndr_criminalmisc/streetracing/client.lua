local races = {}
local inrace = false
local myrace = 0
local myrace_xy = {}
local racestarted = false
local raceblip = false

RegisterNetEvent('blckhndr_criminalmisc:racing:createRace')
AddEventHandler('blckhndr_criminalmisc:racing:createRace', function()
	if IsWaypointActive() then
		local wypt = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
		local signup = 0 
		Citizen.CreateThread(function()
		  DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "#ID NUMBER", "", "", "", "", 10)
		  local editOpen = true
		  while UpdateOnscreenKeyboard() == 0 or editOpen do
			Wait(0)
			drawTxt('Mennyi legyen a verseny téte?',4,1,0.5,0.30,0.7,255,255,255,255)
			drawTxt('~b~A tét minimum 500$',4,1,0.5,0.35,0.4,255,255,255,255)
			drawTxt('~r~A verseny 5 perc mulva lejár.',4,1,0.5,0.49,0.4,255,255,255,255)
			if UpdateOnscreenKeyboard() ~= 0 then
			  editOpen = false
			  if UpdateOnscreenKeyboard() == 1 then
				if tonumber(GetOnscreenKeyboardResult()) then
					signup = tonumber(GetOnscreenKeyboardResult())
					local pos = GetEntityCoords(GetPlayerPed(-1))
					local ex = pos.x
					local why = pos.y
					local zed = pos.z
					local name, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
					local name2, var2 = GetStreetNameAtCoord(wypt.x, wypt.y, 0, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
					TriggerServerEvent('blckhndr_criminalmisc:racing:newRace', signup, GetStreetNameFromHashKey(name), ex, why, zed, wypt.x, wypt.y, GetStreetNameFromHashKey(name2))
				else
					TriggerEvent('blckhndr_notify:displayNotification', 'Be kell írnod egy számot', 'centerRight', 4000, 'error')
				end
			  end
			  break
			end
		  end
		end)
	else
		TriggerEvent('blckhndr_notify:displayNotification', 'Nincs úticél bejelölve', 'centerLeft', 4000, 'error')
	end
end)

RegisterNetEvent('blckhndr_criminalmisc:racing:update')
AddEventHandler('blckhndr_criminalmisc:racing:update', function(tbl)
	races = tbl
end)

RegisterNetEvent('blckhndr_criminalmisc:racing:putmeinrace')
AddEventHandler('blckhndr_criminalmisc:racing:putmeinrace', function(id, members)
	for k, v in ipairs(races) do
		if v.race_id == id then
			ClearGpsPlayerWaypoint()
			SetWaypointOff()
			if raceblip then
				RemoveBlip(raceblip)
			end
			raceblip = AddBlipForCoord(v.finish.x, v.finish.y, 0.0)
			SetBlipSprite(raceblip, 38)
			SetBlipColour(raceblip, 3)
			SetBlipRouteColour(raceblip, 1)
			SetBlipRoute(raceblip,  true)
			inrace = true
			myrace_xy = v.finish
			myrace = k
		end
	end
	TriggerEvent('blckhndr_notify:displayNotification', 'Beléptél a versenybe, '.. #members-1 ..' másik emberrel együtt', 'centerRight', 4000, 'success')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if inrace then
			if not races[myrace] then
				TriggerEvent('blckhndr_notify:displayNotification', 'Elvesztetted a versenyt.', 'centerRight', 4000, 'error')
				if raceblip then
					RemoveBlip(raceblip)
				end
				SetNewWaypoint(myrace_xy.x,myrace_xy.y)
				myrace = 0
				inrace = false
				racestarted = false
			end
		end
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then --and IsPedDiving(GetPlayerPed(-1)) then
			for key, race in ipairs(races) do
				if race.state == 1 then -- waiting for people
					if GetDistanceBetweenCoords(race.start.x, race.start.y, race.start.z, GetEntityCoords(GetPlayerPed(-1)), false) < 20 then
						if inrace then
							-- already in the race
							blckhndr_drawText3D(race.start.x, race.start.y, race.start.z, '~y~Várakozás~w~ további versenyzökre...\nHa túl messze mész akkor ~r~visszakapod~w~ az eddigi tétedet ($'..race.start.price..')! ')
						else
							if exports["blckhndr_main"]:blckhndr_CanAfford(race.start.price) then
								blckhndr_drawText3D(race.start.x, race.start.y, race.start.z, '[~g~E~w~] to join race ($'..race.start.price..')')
								if IsControlJustPressed(0, 38) then
									TriggerServerEvent('blckhndr_criminalmisc:racing:joinRace', race.race_id) 
								end
							else
								blckhndr_drawText3D(race.start.x, race.start.y, race.start.z, '~r~Nincs elég pénzed!')
							end
						end
					else
						if inrace then
							TriggerEvent('blckhndr_notify:displayNotification', 'Kiléptél a versenyböl.', 'centerRight', 4000, 'error')
							if raceblip then
								RemoveBlip(raceblip)
							end
							myrace = 0
							inrace = false
							racestarted = false
						end
					end
				elseif race.state == 2 and key == myrace then -- race starting 
					if GetDistanceBetweenCoords(race.start.x, race.start.y, race.start.z, GetEntityCoords(GetPlayerPed(-1)), false) < 20 then
						if inrace then
							-- already in the race
							blckhndr_drawText3D(race.start.x, race.start.y, race.start.z, '~g~A verseny 20 másodpercen belül kezdődik!~w~\nHa túl messze mész akkor ~r~visszakapod~w~ az eddigi tétedet ($'..race.start.price..')! ')
						end
					else
						if inrace then
							TriggerEvent('blckhndr_notify:displayNotification', 'Kiléptél a versenyből.', 'centerRight', 4000, 'error')
							if raceblip then
								RemoveBlip(raceblip)
							end
							myrace = 0
							inrace = false
							racestarted = false
						end
					end
				elseif race.state == 3 and key == myrace then -- race ongoing
					blckhndr_drawText3D(race.finish.x, race.finish.y, race.start.z, 'Verseny vége')
					if GetDistanceBetweenCoords(race.finish.x, race.finish.y, GetEntityCoords(GetPlayerPed(-1))['x'], GetEntityCoords(GetPlayerPed(-1)), false) < 2 then
						 TriggerServerEvent('blckhndr_criminalmisc:racing:win', key)
						 if raceblip then
							RemoveBlip(raceblip)
						end
						myrace = 0
						inrace = false
						racestarted = false
					end
				elseif race.state == 4 and key == myrace then -- race ended
				else -- unknown state??
				
				end
			end
		end
	end
end)