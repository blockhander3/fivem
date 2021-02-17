inbed = false
mybed = 0 
local mycharge = 0
beds = {
	{
		enter = {x = 1826.4929199219, y = 3677.5776367188, z = 34.270034790039},
		bed = {x = 1825.5493164062, y = 3678.2749023438, z = 35.184803009033, h = 10.98306274414},
		occupied = {false, 0, false, {0,0}},
	},	
	{
		enter = {x = 1828.8057861328, y = 3675.744140625, z = 34.270034790039},
		bed = {x = 1829.845703125, y = 3676.2006835938, z = 35.184803009033, h = 120.98306274414},
		occupied = {false, 0, false, {0,0}},
	},
	{
		enter = {x = 1819.7227783203, y = 3672.1752929688, z = 34.270065307617},
		bed = {x = 1820.1375732422, y = 3671.5026855469, z = 35.184803009033, h = 10.98306274414},
		occupied = {false, 0, false, {0,0}},
	},
	
}

RegisterNetEvent('blckhndr_ems:bed:update')
AddEventHandler('blckhndr_ems:bed:update', function(bedid, bed)
	beds[bedid] = bed
	--print('blckhndr_ems:bed Bed update for ('..bedid..') ['..tostring(bed)..']')
end)

function blckhndr_drawText3D(x,y,z, text,r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 140)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if inbed then
			local newhealth =GetEntityHealth(GetPlayerPed(-1))+10 
			if newhealth >= 200 then
				SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
				TriggerEvent('blckhndr_notify:displayNotification', 'Meg lettél gyógyítva', 'centerLeft', 2000, 'error')
				TriggerEvent('mythic_hospital:client:ResetLimbs')
				TriggerEvent('mythic_hospital:client:RemoveBleed')
			else
				SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1))+10)
				TriggerEvent('blckhndr_notify:displayNotification', 'Gyógyítás...', 'centerLeft', 2000, 'error')
			end
			TriggerServerEvent('blckhndr_ems:bed:health', mybed, GetEntityHealth(GetPlayerPed(-1)), GetEntityHealth(GetPlayerPed(-1)))
		end
	end
end)

Citizen.CreateThread(function()
	--local blip = AddBlipForCoord(296.18298339844,-584.42895507813,42.720436096191)
	--SetBlipSprite(blip, 80)
	--BeginTextCommandSetBlipName("STRING")
	--	AddTextComponentString("Hospital")
	--EndTextCommandSetBlipName(blip)
	--SetBlipAsShortRange(blip, true)
	while true do
	Citizen.Wait(0)
		if inbed then
			if beds[mybed].occupied[3] then
				blckhndr_drawText3D(beds[mybed].enter.x, beds[mybed].enter.y, beds[mybed].enter.z-0.3, "Az ágyhoz vagy korlátozva.", 255, 0, 0)
			else
				blckhndr_drawText3D(beds[mybed].enter.x, beds[mybed].enter.y, beds[mybed].enter.z-0.3, "[E] Ágy elhagyása", 255, 255, 255)
				if IsControlJustPressed(0, 51) then
					TriggerServerEvent('blckhndr_ems:bed:occupy', mybed)
					DoScreenFadeOut(1000)
					Citizen.Wait(1010)
					SetEntityCoords(GetPlayerPed(-1), beds[mybed].enter.x, beds[mybed].enter.y, beds[mybed].enter.z)
					inbed = false
					mybed = 0
					Citizen.Wait(1500)
					DoScreenFadeIn(2000)
				end
			end
			for i=1,345 do
				if i > 10 and i ~= 249 and i ~= 25 and i ~= 245 and i ~= 51 then
					DisableControlAction(1, i, true)
				end
			end
		end
		if GetDistanceBetweenCoords(1833.0582275391, 3683.0183105469, 34.270065307617, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
			DrawMarker(1,1833.0582275391, 3683.0183105469, 34.270065307617-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
			if GetDistanceBetweenCoords(1833.0582275391, 3683.0183105469, 34.270065307617,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
				SetTextComponentFormat("STRING")
				if #onduty_ems <= 0 then
					AddTextComponentString("Press ~INPUT_PICKUP~ to check in")
					if IsControlJustPressed(0, 51) then
						for k, v in pairs(beds) do
							if not v.occupied[1] and not inbed then
								TriggerServerEvent('blckhndr_ems:bed:occupy', k)
								if blckhndr_IsDead() then
									TriggerEvent('blckhndr_ems:reviveMe')
								end
								DoScreenFadeOut(1000)
								Citizen.Wait(1010)
								SetEntityCoords(GetPlayerPed(-1), v.bed.x, v.bed.y, v.bed.z)
								SetEntityHeading(GetPlayerPed(-1), v.bed.h)
								ExecuteCommand("e sleep")
								inbed = true
								mybed = k
								Citizen.Wait(1500)
								DoScreenFadeIn(2000)
							end
						end
						if not inbed then
							TriggerEvent('blckhndr_notify:displayNotification', 'Nincs elérhető ágy jelenleg.', 'centerLeft', 6000, 'error')
						end
					end
				else
					AddTextComponentString("Menj vissza a recepcióhoz, hogy egy orvos megvizsgálhasson")  
				end
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		for k, v in pairs(beds) do
			if GetDistanceBetweenCoords(v.enter.x, v.enter.y, v.enter.z, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
				if GetDistanceBetweenCoords(v.enter.x, v.enter.y, v.enter.z, GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
					if v.occupied[1] then
						blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z-0.6, v.occupied[4][1].." / "..v.occupied[4][2], 255, 255, 255)
						DrawMarker(25,v.enter.x, v.enter.y, v.enter.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 255, 0, 0, 10, 0, 0, 2, 0, 0, 0, 0)
						blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z, "Ez az ágy el van foglalva ő által: "..v.occupied[2], 255, 255, 255)
						if exports["blckhndr_police"].blckhndr_PDDuty() then
							if v.occupied[3] then
								blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z-0.1, "[E] Elengedés", 66, 209, 244)
								if IsControlJustPressed(0, 51) then
									while not HasAnimDictLoaded('mp_arresting') do
										RequestAnimDict('mp_arresting')
										Citizen.Wait(5)
									end
									TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_arrest_on_floor', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
									TriggerServerEvent('blckhndr_ems:bed:restraintoggle', k)
								end
							else
								blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z-0.1, "[E] Ágyhoz kötés", 66, 209, 244)
								if IsControlJustPressed(0, 51) then
									while not HasAnimDictLoaded('mp_arresting') do
										RequestAnimDict('mp_arresting')
										Citizen.Wait(5)
									end
									TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_arrest_on_floor', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
									TriggerServerEvent('blckhndr_ems:bed:restraintoggle', k)
								end
							end 
						end
						if emsonduty then
							blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z-0.1, "[E] Beteg megvizsgálása", 66, 209, 244)
							if IsControlJustPressed(0, 51) then
								ExecuteCommand('ems revive '..v.occupied[2])
							end
						end
					else
						DrawMarker(25,v.enter.x, v.enter.y, v.enter.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 255, 255, 255, 140, 0, 0, 2, 0, 0, 0, 0)
						blckhndr_drawText3D(v.enter.x, v.enter.y, v.enter.z, "[E] Ágy használata", 255, 255, 255)
						if IsControlJustPressed(0, 51) then
							TriggerServerEvent('blckhndr_ems:bed:occupy', k)
							if blckhndr_IsDead() then
								TriggerEvent('blckhndr_ems:reviveMe')
							end
							DoScreenFadeOut(1000)
							Citizen.Wait(1010)
							SetEntityCoords(GetPlayerPed(-1), v.bed.x, v.bed.y, v.bed.z)
							SetEntityHeading(GetPlayerPed(-1), v.bed.h)
							ExecuteCommand("e sleep")
							inbed = true
							mybed = k
							Citizen.Wait(1500)
							DoScreenFadeIn(2000)
						end
					end
				end
			end
		end
	end
end)