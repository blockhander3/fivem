local gangs = {}
RegisterNetEvent('blckhndr_gangs:recieve')
AddEventHandler('blckhndr_gangs:recieve', function(tbl)
	gangs = tbl
	for name,g in pairs(gangs) do
		if g.members then
			for _,m in pairs(g.members) do
				if exports['blckhndr_main']:blckhndr_CharID() == m.id then
					mygang = g.short
					mylevel = m.level
				end
			end
		end
	end
end)

local takeover = false -- do NOT touch this
local takeover_t = false -- do NOT touch this
local takeover_timeout = 600 -- max seconds a takeover can last, or fail
takeover_timeout = takeover_timeout * 1000 -- do NOT touch this
local takeover_r_timeout = 60 -- max seconds a round can take, or fail
takeover_r_timeout = takeover_r_timeout * 1000 -- do NOT touch this

local interior = {
	inside = false,
	g = false,
	carloc = {x = 1090.5086669922, y = -3195.8386230469, z = -39.416301727295, h = 53.002780914307},
	doorloc = {x = 1088.7668457031, y = -3187.4638671875, z = -38.993473052979},
	storageloc = {x = 1096.8743896484, y = -3192.8137207031, z = -38.993446350098},
	veh = false,
	leaving = false
}
RegisterNetEvent('blckhndr_gangs:hideout:enter')
AddEventHandler('blckhndr_gangs:hideout:enter', function(key, g)
	gangs[key] = g
	DoScreenFadeOut(1000)
	Citizen.Wait(800)
	SetEntityCoords(GetPlayerPed(-1),interior.doorloc.x, interior.doorloc.y, interior.doorloc.z)
	Citizen.Wait(200)
	DoScreenFadeIn(2000)
	interior.g = key
	interior.inside = true


	local g = gangs[key]
	if g.interior.car then
		local c = g.interior.car
		local i = interior
		while not HasModelLoaded(c.model) do 
			Citizen.Wait(0)
			RequestModel(c.model)
		end
		i.car = CreateVehicle(c.model, i.carloc.x,i.carloc.y,i.carloc.z,i.carloc.h,false,true)
		SetVehicleNumberPlateText(i.car, g.short)
		SetModelAsNoLongerNeeded(c.model)
	end
end)
RegisterNetEvent('blckhndr_gangs:hideout:leave')
AddEventHandler('blckhndr_gangs:hideout:leave', function(plate)
	print'gotleave'
	local g = gangs[interior.g]
	DoScreenFadeOut(1000)
	Citizen.Wait(200)
	interior.inside = false
	if plate then
		-- do shit to spawn car :)
		SetEntityCoords(GetPlayerPed(-1), g.interior.garage.x,g.interior.garage.y,g.interior.garage.z)
		SetEntityHeading(GetPlayerPed(-1), g.interior.garage.h)
		Citizen.Wait(100)
		local vid = exports['blckhndr_cargarage']:blckhndr_GetVehicleVehIDP(plate)
		print(plate..' has vid '..vid)
		exports['blckhndr_cargarage']:blckhndr_SpawnVehicle(vid)
	else
		SetEntityCoords(GetPlayerPed(-1), g.interior.door.x,g.interior.door.y,g.interior.door.z)
	end
	Citizen.Wait(700)
	DoScreenFadeIn(2000)
	if interior.car then 
		DeleteEntity(interior.car)
		interior.car = false
	end
	interior.g = false
	interior.leaving = false
end)

function MissionText(text, subtext,time)
	Citizen.CreateThread(function()
		time = time * 1000
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end

		BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieMethodParameterString(text)
		if subtext then
			PushScaleformMovieMethodParameterString(subtext)
		else
			PushScaleformMovieMethodParameterString('')
		end
		PushScaleformMovieMethodParameterInt(5)
		EndScaleformMovieMethod()

		local start = GetGameTimer()
		while true do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			if start + time < GetGameTimer() then break end
		end
	end)
end

local ingang = false
function isInTerritory()
	return ingang
end

local mygang = false
local mylevel = 0
local nearbygang = false
function myGang()
	return mygang,mylevel
end
function nearbyGang()
	return nearbygang
end
function getGang(short)
	local g = false
	for k, v in pairs(gangs) do
		if v.short == short then
			g = k
		end
	end
	return g
end

Util.Tick(function()
	local cur_gang = false
	local cur_nearby = false
	for name,g in pairs(gangs) do
		if not g.npc.ped or not DoesEntityExist(g.npc.ped) then
			RequestModel(GetHashKey(g.npc.model))
			while not HasModelLoaded(GetHashKey(g.npc.model)) do Citizen.Wait(1) end
			g.npc.ped = CreatePed(1, GetHashKey(g.npc.model), g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z, g.npc.xyz.h, false, true)
			Citizen.Wait(1000)
			FreezeEntityPosition(g.npc.ped, true)
			SetModelAsNoLongerNeeded(GetHashKey(g.npc.model))
		else
			if IsPedDeadOrDying(g.npc.ped) then
				if not g.npc.npc_death_cooldown then
					g.npc.npc_death_cooldown = GetGameTimer()
				else
					if g.npc.npc_death_cooldown + 800000 < GetGameTimer() then 
						DeleteEntity(g.npc.ped)
						g.npc.npc_death_cooldown = false
					end
				end
			end
		end
		if Util.GetVecDist(vector3(g.xyz.x, g.xyz.y, g.xyz.z),GetEntityCoords(GetPlayerPed(-1))) < 75 then
			DrawMarker(1,g.xyz.x, g.xyz.y, g.xyz.z-13,0,0,0,0,0,0,150.0,150.0,20.0,g.color[1],g.color[2],g.color[3],175,0,0,0,1)
			cur_gang = g.short
			if not IsPedDeadOrDying(g.npc.ped) and Util.GetVecDist(vector3(g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z),GetEntityCoords(GetPlayerPed(-1))) < 2 then
				Util.DrawText3D(g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z+0.2, string.upper(name))
				if not g.owner then
					Util.DrawText3D(g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z-0.1, '[E] Elfoglalás ($'..g.takeover.cost..')')
					if IsControlJustPressed(0, Util.GetKeyNumber('E')) then
						--TriggerServerEvent('blckhndr_gangs:tryTakeOver', name)
						TAKEOVER(name)
					end
				elseif g.short == myGang() then
					Util.DrawText3D(g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z, 'Üdvözlet ujra')
				else
					Util.DrawText3D(g.npc.xyz.x, g.npc.xyz.y, g.npc.xyz.z-0.1, '[E] Elfoglalás')
					if IsControlJustPressed(0, Util.GetKeyNumber('E')) then
						--TriggerServerEvent('blckhndr_gangs:tryTakeOver', name)
						TAKEOVER(name)
					end
				end
			end
		elseif Util.GetVecDist(vector3(g.xyz.x, g.xyz.y, g.xyz.z),GetEntityCoords(GetPlayerPed(-1))) < 180 then
			if not cur_gang then cur_nearby = g.short end 
		end
	end
	if cur_gang ~= false then
		if not ingang then
			ingang = cur_gang
			nearbygang = cur_gang
		end
	else
		if cur_nearby then
			nearbygang = cur_nearby
		end
		ingang = false
	end
end)

function TAKEOVER(key)
	MissionText("~g~ELFOGLALÁS ELKEZDVE", false, 3)
	local g = gangs[key]
	takeover = true
	takeover_t = {
		start = GetGameTimer(),
		g = key,
		round = {
			start = GetGameTimer(),
			cur = 1,
			started = false,
			peds = {},
		}
	}
end
Util.Tick(function()
	if interior.inside then
		local i = interior
		local g = gangs[interior.g]
		if Util.GetVecDist(vector3(i.doorloc.x,i.doorloc.y,i.doorloc.z), GetEntityCoords(GetPlayerPed(-1))) > 50 then
			-- has glitched out of the building
			SetEntityCoords(GetPlayerPed(-1), vector3(1093.6, -3196.6, -38.99841))
		else
			-- is inside the building
			-- exit
			DrawMarker(25, i.doorloc.x, i.doorloc.y, i.doorloc.z - 0.95, 0, 0, 0, 0, 0, 0, 0.50, 0.50, 10.3, 255, 255, 255, 140, 0, 0, 1, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(i.doorloc.x, i.doorloc.y, i.doorloc.z, GetEntityCoords(GetPlayerPed(-1)), true) < 0.5 then
				Util.DrawText3D(i.doorloc.x, i.doorloc.y, i.doorloc.z, "[E] Kilépés")
				if IsControlJustPressed(0, Util.GetKeyNumber('E')) then
					if not i.leaving then
						TriggerServerEvent('blckhndr_gangs:hideout:leave', i.g, false)
						i.leaving = true
					end
				end
			end

			-- inventory
			DrawMarker(25, i.storageloc.x, i.storageloc.y, i.storageloc.z - 0.95, 0, 0, 0, 0, 0, 0, 0.50, 0.50, 10.3, 255, 255, 255, 140, 0, 0, 1, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(i.storageloc.x, i.storageloc.y, i.storageloc.z, GetEntityCoords(GetPlayerPed(-1)), true) < 0.5 then
				Util.DrawText3D(i.storageloc.x, i.storageloc.y, i.storageloc.z, "[E] Tároló használata")
			end

			if i.car and not g.interior.car then
				DeleteEntity(i.car)
			else
				SetVehicleEngineOn(i.car,false, true,true)
				if g.interior.car then
					if exports['blckhndr_cargarage']:blckhndr_IsVehicleOwnerP(g.interior.car.plate) then
						Util.DrawText3D(GetEntityCoords(i.car).x,GetEntityCoords(i.car).y,GetEntityCoords(i.car).z, 'Ülj be, hogy kimehess vele')
						if GetVehiclePedIsIn(GetPlayerPed(-1),false) == i.car then 
							if not i.leaving then
								TriggerServerEvent('blckhndr_gangs:hideout:leave', i.g, true)
								i.leaving = true
							end
						end
					end
				end
			end
		end
	else
		if nearbyGang() then 
			-- CHANGE THIS LINE
			if true then --if nearbyGang() == myGang() then
				local g = gangs[getGang(nearbyGang())]
				if g then 
					if GetDistanceBetweenCoords(g.interior.door.x, g.interior.door.y, g.interior.door.z, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
						DrawMarker(25, g.interior.door.x, g.interior.door.y, g.interior.door.z - 0.95, 0, 0, 0, 0, 0, 0, 0.50, 0.50, 10.3, 255, 255, 255, 140, 0, 0, 1, 0, 0, 0, 0)
						if GetDistanceBetweenCoords(g.interior.door.x, g.interior.door.y, g.interior.door.z, GetEntityCoords(GetPlayerPed(-1)), true) < 0.5 then
							Util.DrawText3D(g.interior.door.x, g.interior.door.y, g.interior.door.z, "[E] Belépés")
							if IsControlJustPressed(0,Util.GetKeyNumber('E')) then
								TriggerServerEvent('blckhndr_gangs:hideout:enter',getGang(nearbyGang()))
							end
						end
					end
					if IsPedInAnyVehicle(GetPlayerPed(-1)) and exports['blckhndr_cargarage']:blckhndr_IsVehicleOwnerP(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and GetDistanceBetweenCoords(g.interior.garage.x, g.interior.garage.y,g.interior.garage.z, GetEntityCoords(GetPlayerPed(-1))) < 2 then
						Util.DrawText3D(g.interior.garage.x, g.interior.garage.y,g.interior.garage.z, '[E] Belépés')
						if IsControlJustPressed(0,Util.GetKeyNumber('E')) then
							TriggerServerEvent('blckhndr_gangs:garage:enter', getGang(nearbyGang()), GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)), GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
						end
					end
				end
			end
		end
	end
	if takeover then 
		local t = takeover_t
		local g = gangs[t.g]
		if t.start + takeover_timeout < GetGameTimer() then takeover = false MissionText('~r~ELFOGLALÁS SIKERTELEN', 'Túl sokág próbaltad elfoglalni!', 10) end
		if t.round.start + takeover_r_timeout < GetGameTimer() then takeover = false MissionText('~r~ELFOGLALÁS SIKERTELEN', 'Kör ~y~'..t.round.cur..'~w~ túl sokáig tartott!', 10) end  
		if not t.round.started then
			if t.round.cur > #g.takeover.lvls then
				-- takeover is complete

				takeover = false
				MissionText('~g~SIKERES ELFOGLALÁS', 'Te vagy mostantol a vezetője a: '..t.g,10'-nak/nek')
			else
				local num = g.takeover.lvls[t.round.cur]
				for i=1,num do
					local m = GetHashKey(g.takeover.mdls[math.random(1,#g.takeover.mdls)])
					RequestModel(m)
					while not HasModelLoaded(m) do Citizen.Wait(1) end
					local l = g.takeover.coords[math.random(1, #g.takeover.coords)]
					local PED = CreatePed(1, m, l.x, l.y, l.z,l.h, false, true)

					-- REMOVE THIS LINE
					FreezeEntityPosition(PED, true)
					table.insert(t.round.peds, #t.round.peds+1, PED)
				end
				t.round.started = true
				t.round.start = GetGameTimer()
			end
		else
			local dead = 0
			-- round is going on
			if exports['blckhndr_ems']:blckhndr_IsDead() then
				takeover = false
				MissionText('~r~ELFOGLALÁS SIKERTELEN', 'Meghaltál.', 10)
			end
			for k,PED in pairs(t.round.peds) do
				if not NetworkHasControlOfEntity(PED) then
					NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(PED))
					while not NetworkHasControlOfNetworkId(NetworkGetNetworkIdFromEntity(PED)) do
						Citizen.Wait(0)
					end
				end
				DrawMarker(1,GetEntityCoords(PED),0,0,0,0,0,0,1.0,1.0,30.0,255,0,0,60,0,0,0,1)

				if not DoesEntityExist(PED) or IsEntityDead(PED) then
					dead = dead+1
				end
			end

			if dead >= g.takeover.lvls[t.round.cur] then
				-- round has ended
				for k,PED in pairs(t.round.peds) do
					DeleteEntity(PED)
				end

				TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kör '..t.round.cur..' sikeres!'})
				t.round.cur = t.round.cur + 1
				t.round.peds = {}
				t.round.started = false
			end
		end 
	else
		if takeover_t then
			for _,PED in pairs(takeover_t.round.peds) do
				DeleteEntity(PED)
			end
			takeover_t = false
		end
	end

end)

Citizen.CreateThread(function()
	TriggerServerEvent('blckhndr_gangs:request')
end)


Citizen.CreateThread(function()
	StopEntityFire(GetPlayerPed(-1))
	while true do Citizen.Wait(0)
		if GetEntityModel(GetPlayerPed(-1)) == GetHashKey('mp_f_freemode_01') or GetEntityModel(GetPlayerPed(-1)) == GetHashKey('mp_m_freemode_01') then
			if GetPedDrawableVariation(GetPlayerPed(-1), 1) == 94 and GetPedTextureVariation(GetPlayerPed(-1),1) == 1 then
				if not IsEntityOnFire(GetPlayerPed(-1)) then
					StartEntityFire(GetPlayerPed(-1))
					Citizen.Wait(1000)
					StopEntityFire(GetPlayerPed(-1))
					Citizen.Wait(1000)
					StartEntityFire(GetPlayerPed(-1))
					Citizen.Wait(1000)
					StopEntityFire(GetPlayerPed(-1))
					Citizen.Wait(1000)
				end
			end
		end
	end
end)