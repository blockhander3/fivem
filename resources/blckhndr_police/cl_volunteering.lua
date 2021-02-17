local polspot = {x = 1854.5119628906, y = 3687.7941894531, z = 34.3090279419}
local polspot2 = {x = -445.99594116211, y = 6016.2690429688, z = 31.7665412903}
local polunteer_police = {}

local whitelisted = true

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tab)
end

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if blckhndr_getPDLevel() == 0 then
		if GetDistanceBetweenCoords(polspot.x,polspot.y,polspot.z,GetEntityCoords(GetPlayerPed(-1)),false) < 10 then
			DrawMarker(25,polspot.x, polspot.y, polspot.z -0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(polspot.x,polspot.y,polspot.z,GetEntityCoords(GetPlayerPed(-1)),false) < 1 then
				Util.DrawText3D(polspot.x, polspot.y, polspot.z, '[E] ~g~Jelentkezés:~w~ ~b~Sheriffség', {255,255,255,200}, 0.25)
				if IsControlJustPressed(0, 38) then
				local phonenum = exports.blckhndr_main:blckhndr_GetPlayerPhoneNumber()
				local charnamef = exports.blckhndr_main:blckhndr_CharNamesF()
				local charnamel = exports.blckhndr_main:blckhndr_CharNamesL()
				local charname = charnamef.. ' ' ..charnamel
				local charname = charnamef.. ' ' ..charnamel
				local email = string.sub(charnamef, 1, 1).. '' ..charnamel.. '@lifeinvader.com'
				local ped = GetPlayerPed( -1 )
				ClearPedTasks(ped)
				startAnim()
				Citizen.Wait(5000)
				stopAnim()
				ClearPedTasks(ped)

				TriggerServerEvent('blckhndr_police:polunteering', charname, phonenum, email, charid)
				TriggerEvent('blckhndr_notify:displayNotification', 'Sikeresen jelentkeztél ide: <span style="color: #f45942">Sheriffség</span>', 'centerLeft', 6000, 'info')
				end
				
			end
		end
		if GetDistanceBetweenCoords(polspot2.x,polspot2.y,polspot2.z,GetEntityCoords(GetPlayerPed(-1)),false) < 10 then
			DrawMarker(25,polspot2.x, polspot2.y, polspot2.z -0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(polspot2.x,polspot2.y,polspot2.z,GetEntityCoords(GetPlayerPed(-1)),false) < 1 then
				Util.DrawText3D(polspot2.x, polspot2.y, polspot2.z, '[E] ~g~Jelentkezés:~w~ ~b~Sheriffség', {255,255,255,200}, 0.25)
				if IsControlJustPressed(0, 38) then
				local phonenum = exports.blckhndr_main:blckhndr_GetPlayerPhoneNumber()
				local charnamef = exports.blckhndr_main:blckhndr_CharNamesF()
				local charnamel = exports.blckhndr_main:blckhndr_CharNamesL()
				local charname = charnamef.. ' ' ..charnamel
				local charid = exports.blckhndr_main:blckhndr_CharID()
				local email = string.sub(charnamef, 1, 1).. '' ..charnamel.. '@lifeinvader.com'
				local ped = GetPlayerPed( -1 )
				ClearPedTasks(ped)
				startAnim()
				Citizen.Wait(5000)
				stopAnim()
				ClearPedTasks(ped)

				TriggerServerEvent('blckhndr_police:volunteering', charname, phonenum, email, charid)
				TriggerEvent('blckhndr_notify:displayNotification', 'Sikeresen jelentkeztél ide: <span style="color: #f45942">Sheriffség</span>', 'centerLeft', 6000, 'info')
				end

			end
		end
	end
end
end)
