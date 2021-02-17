local my_char = false 
local locs = {
	{ name = 'Apartman', ["x"] = -178.92723083496,["y"] = 6432.9799804688, ["z"] = 31.915609359741, h = 254.32080078125 },
	--{ name = 'Los Santos Airport', x = -1037.74, y = -2738.04, z = 20.1693, h = 282.91 },
	--{ name = 'Bus Station', x = 454.349, y = -661.036, z = 27.6534, h = 282.91 },
	--{ name = 'Train Station', x = -206.674, y = -1015.1, z = 30.1381, h = 282.91 },
	{ name = 'Paleto Bay - Tűzoltóság', x = -384.636566, y = 6123.02832031, z = 31.479526519, h = 42.8814125 },
	{ name = 'Paleto Bay - Szerelőműhely', x = 116.892333, y = 6593.51708984, z = 32.193756, h = 318.1908569 },
	{ name = 'Grapeseed - Sheriffség', x = 1682.403808, y = 4889.499023, z = 42.02764511, h = 90.052314 },
	{ name = 'Sandy Shores - Sheriffség', x = 1807.46887207, y = 3676.142333, z = 34.2766914, h = 139.6860809 },
	--{ name = 'Pier', x = -1686.61, y = -1068.16, z = 13.1522, h = 282.91 },
	--{ name = 'Legion Square', x = 238.69, y = -762.66, z = 30.82, h = 158.23 },
	--{ name = 'Vinewood', x = 280.571, y = 182.679, z = 104.504, h = 282.91 },
}

local busy = false
local script_cam = false

function camToLoc(key)
	while busy do Citizen.Wait(1) end
	busy = true
	SendNUIMessage({
		hide = true
	})

	DoScreenFadeOut(1000)
	Citizen.Wait(800)
	RenderScriptCams(false, true, 500, true, true)
	SetEntityCoords(GetPlayerPed(-1), 2556.2429199, 4335.70019, 232.2)
	Citizen.Wait(200)
	DoScreenFadeIn(1000)
	Citizen.Wait(1001)

	local loc = locs[key]
	for k,v in pairs(locs) do
		if v.selected then
			v.selected = false
		end
		if k == key then
			v.selected = true
		end
	end
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, false, 0)
    SetEntityCoords(playerPed, loc.x, loc.y, loc.z)
    FreezeEntityPosition(playerPed, true)
    RenderScriptCams(true,true,true,true,true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(startcam, 2556.2429199, 4335.70019, 232.2)
    SetCamActive(startcam, true)
    PointCamAtCoord(startcam, loc.x, loc.y, loc.z+200)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, loc.x, loc.y, loc.z+200)
    PointCamAtCoord(cam, loc.x, loc.y, loc.z+2)
    SetCamActiveWithInterp(cam, startcam, 3700, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    Citizen.Wait(3700)
	PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam2, loc.x, loc.y, loc.z+1)
    PointCamAtCoord(cam2, loc.x+10, loc.y, loc.z)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    busy = false
    SendNUIMessage({
		locs = locs
	})
end



function openGUI(char)
	SendNUIMessage({
		locs = locs
	})
	SetNuiFocus(true,true)
end

RegisterNetEvent('blckhndr_spawnmanager:start')
AddEventHandler('blckhndr_spawnmanager:start', function(char)
    SetEntityVisible(GetPlayerPed(-1), false, 0)
    if char then
		my_char = char
		TriggerEvent("clothes:spawn", json.decode(char.char_model))
	else
		print('skipping, charid: '..my_char.char_id)
		TriggerEvent("clothes:spawn", json.decode(my_char.char_model))
	end
	

	DoScreenFadeOut(1000)
	Citizen.Wait(900)
	SetEntityCoords(GetPlayerPed(-1),2556.2429199, 4335.70019, 232.2)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	SetEntityVisible(GetPlayerPed(-1),false)
	Citizen.Wait(100)
	DoScreenFadeIn(1000)
	Citizen.Wait(1001)
	openGUI(my_char)
end)

RegisterNUICallback('camToLoc', function(data, cb)
	if data.loc then
		camToLoc(data.loc+1)
	end
end)

RegisterNUICallback('spawnAtLoc', function(data, cb)
	local spawnloc = false
	for k, v in pairs(locs) do
		if v.selected then
			spawnloc = locs[k]
		end	
	end
	if not spawnloc then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Válaszd ki ujra a spawnolási helyedet!'})
	else
		DoScreenFadeOut(1000)
		Citizen.Wait(900)
		RenderScriptCams(false, true, 500, true, true)
		TriggerEvent('blckhndr_main:character', my_char)
		TriggerEvent('blckhndr_police:init', my_char.char_police)
		TriggerEvent('blckhndr_jail:init', my_char.char_id)
		TriggerEvent('blckhndr_inventory:initChar', my_char.char_inventory)
		TriggerEvent('blckhndr_bank:change:bankAdd', 0)
		TriggerEvent('blckhndr_ems:reviveMe:force')

		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Spawn: '..spawnloc.name})
	
		TriggerServerEvent('blckhndr_apartments:getApartment', my_char.char_id)

		SendNUIMessage({
			hide = true
		})
		SetNuiFocus(false)

		--[[
		 spawn stuffs :)
		]]--

		SetEntityVisible(GetPlayerPed(-1), true)
		FreezeEntityPosition(GetPlayerPed(-1), false)

		--TriggerEvent('fsn->esx:clothing:spawn', json.decode(my_char.char_model))
		--TriggerEvent("clothes:spawn", json.decode(my_char.char_model))

		if spawnloc.name == 'Apartman' then
			exports['blckhndr_apartments']:EnterMyApartment()
			TriggerEvent('spawnme')
			TriggerEvent("clothes:spawn", json.decode(my_char.char_model))
		else
			SetEntityCoords(GetPlayerPed(-1), spawnloc.x, spawnloc.y,spawnloc.z)
			TriggerEvent('spawnme')
			TriggerEvent("clothes:spawn", json.decode(my_char.char_model))
		end

		Citizen.Wait(100)
		DoScreenFadeIn(1000)
		Citizen.Wait(1001)
	end
end)

--[[
Citizen.CreateThread(function()
	Citizen.Wait(4000)
	TriggerEvent('blckhndr_spawnmanager:start', {})
end)
]]--