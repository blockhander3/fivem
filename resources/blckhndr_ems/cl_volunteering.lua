local volspot = {x = 1837.3231201172, y = 3680.3776855469, z = 34.270065307617}
local volunteer_ems = {}

local whitelisted = true

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if blckhndr_getEMSLevel() == 0 then
		if GetDistanceBetweenCoords(volspot.x,volspot.y,volspot.z,GetEntityCoords(GetPlayerPed(-1)),false) < 10 then
			DrawMarker(25,volspot.x, volspot.y, volspot.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(volspot.x,volspot.y,volspot.z,GetEntityCoords(GetPlayerPed(-1)),false) < 1 then
				Util.DrawText3D(volspot.x, volspot.y, volspot.z, '[E] ~g~Jelentkezés:~w~ ~r~EMS', {255,255,255,200}, 0.25)
				if IsControlJustPressed(0, 38) then
				local phonenum = exports.blckhndr_main:blckhndr_GetPlayerPhoneNumber()
				local charnamef = exports.blckhndr_main:blckhndr_CharNamesF()
				local charnamel = exports.blckhndr_main:blckhndr_CharNamesL()
				local charname = charnamef.. ' ' ..charnamel
				local email = string.sub(charnamef, 1, 1).. '' ..charnamel.. '@lifeinvader.com'
				local ped = GetPlayerPed( -1 )
				ClearPedTasks(ped)
				TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, false)
				Citizen.Wait(2600)
				ClearPedTasks(ped)
				Citizen.Wait(2400)
				TriggerServerEvent('blckhndr_ems:volunteering', charname, phonenum, email, exports.blckhndr_main:blckhndr_CharID())
				TriggerEvent('blckhndr_notify:displayNotification', 'Sikeresen jelentkeztél ide: <span style="color: #f45942">EMS</span>', 'centerLeft', 6000, 'info')
				end

			end
		end
	end
end
end)


