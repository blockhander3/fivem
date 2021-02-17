local garages = {
	["Peaceful street"] = {
		pos = {x = 2141.0314941406, y = 4818.3256835938, z = 41.236743927002, h = 107.91876220703},
		type = 'cars',
		blip = 50,
	},
	["Great Ocean Hwy"] = {
		pos = {x = -195.20651245117, y = 6225.5185546875, z = 31.062280654907, h = 47.219085693359},
		type = 'cars',
		blip = 50,
	},
	["Panorama Drv"] = {
		pos = {x = 1767.6580810547, y = 3346.2253417969, z = 40.437675476074, h = 145.78295898438},
		type = 'cars',
		blip = 50,
	},
	["Shank St"] = {
		pos = {x = 1341.8265380859, y = 4224.2788085938, z = 30.590071868896, h = 193.09747314453},
		type = 'boats',
		blip = 371,
	},
	["New Empire Way"] = {
		pos = {x = -285.26608276367, y = 6626.2827148438, z = 2.1027164459229, h = 101.25735473633},
		type = 'boats',
		blip = 371,
	},
	["Joad Ln"] = {
		pos = {x = 1887.6228027344, y = 3766.2568359375, z = 32.783638000488, h = 210.71147155762},
		type = 'cars',
		blip = 50,
	}

}

local myGarage = {}
myGarage.cars = {}
myGarage.aircrafts = {}
myGarage.boats = {}

local myVehicles = {}
local menuEnabled = false

function getCarDetails(veh)
	local details = {
		plate = 'undefined',
		livery = 0,
		fuel = 100,
		damage = {
			engine = 1000,
			body = 1000,
			advanced = {
				electronics = 100,
				clutch = 100,
				gearbox = 100,
				brakes = 100,
				transmission = 100,
				axle = 100,
				fuel_injectors = 100,
				fuel_tank = 100,
				tires = 100,
			},
		},
		modkit = 0,
		customisations = {
			plate = 0,
			windows = 0,
			headlightcolor = -1,
			colours = {
				main = {0,0},
				extras = {0,0},
			},
			neons = {
				enabled = {false, false, false},
				colours = {0,0,0},
			},
			wheels = {
				type = 0,
				smoke = {0,0,0},
			},
			mods = {},
		}
	}
	-- damage
	details.damage.engine = GetVehicleEngineHealth(veh)
	details.damage.body = GetVehicleBodyHealth(veh)
	for k, dmg in pairs(details.damage.advanced) do
		if DecorGetInt(veh, 'vehDMG:'..k) then
			details.damage.advanced[k] = DecorGetInt(veh, 'vehDMG:'..k)
		end
	end
	
	-- fuel
	if DecorGetInt(veh, 'fuelLevel') then
		details.fuel = DecorGetInt(veh, 'fuelLevel')
	end
	
	-- livery
	details.livery = GetVehicleLivery(veh)
	
	-- window tint
	details.customisations.windows = GetVehicleWindowTint(veh)
	
	-- plate
	details.plate = GetVehicleNumberPlateText(veh)
	details.customisations.plate = GetVehicleNumberPlateTextIndex(veh)
	
	-- neons
	for i = 0, 3 do
		details.customisations.neons.enabled[i] = IsVehicleNeonLightEnabled(veh, i)
	end	
	details.customisations.neons.colours[1],details.customisations.neons.colours[2],details.customisations.neons.colours[3] = GetVehicleNeonLightsColour(veh)

	-- headlightcolor
	details.customisations.headlightcolor = GetVehicleHeadlightsColour(veh)

	-- colours 
	details.customisations.colours.main[1],details.customisations.colours.main[2] = GetVehicleColours(veh)
	details.customisations.colours.extras[1],details.customisations.colours.extras[2] = GetVehicleExtraColours(veh)
	
	-- wheels
	details.customisations.wheels.type = GetVehicleWheelType(veh)
	details.customisations.wheels.smoke[1],details.customisations.wheels.smoke[2],details.customisations.wheels.smoke[3] = GetVehicleTyreSmokeColor(veh)
	
	-- other mods
	details.modkit = GetVehicleModKit(veh)
	for i = 0, 16 do
		details.customisations.mods[i] = GetVehicleMod(veh,i)
	end
	for i = 17, 22 do
		details.customisations.mods[i] = IsToggleModOn(veh,i)
	end
	for i = 23, 48 do
		details.customisations.mods[i] = GetVehicleMod(veh,i)
	end
	
	--
	return details
end

AddEventHandler('blckhndr_main:character', function()
	TriggerServerEvent('blckhndr_cargarage:reset', exports.blckhndr_main:blckhndr_CharID())
end)

RegisterNetEvent('blckhndr_cargarage:makeMine')
AddEventHandler('blckhndr_cargarage:makeMine', function(ent, classname, plate)
	table.insert(myVehicles, #myVehicles+1, {
		ent = ent,
		plate = plate,
		model = classname
	})
end)

RegisterNetEvent('blckhndr_cargarage:checkStatus')
AddEventHandler('blckhndr_cargarage:checkStatus', function(plate)
	for k, v in pairs(myVehicles) do
		if v.plate == plate then
			if DoesEntityExist(v.ent) then
				TriggerEvent('blckhndr_notify:displayNotification', 'This exists somewhere in the world!!', 'centerLeft', 3000, 'error')
			else
				TriggerServerEvent('blckhndr_cargarage:vehicle:toggleStatus', plate, 0, '0')
				TriggerEvent('blckhndr_notify:displayNotification', 'Vehicle returned to any garage.', 'centerLeft', 3000, 'success')
			end
			return
		end
	end
	TriggerEvent('blckhndr_notify:displayNotification', 'You have not spawned this vehicle', 'centerLeft', 3000, 'error')
end)

RegisterNetEvent('blckhndr_cargarage:vehicleStatus')
AddEventHandler('blckhndr_cargarage:vehicleStatus', function(plate, status, grg)
	local statuses = {
		[0] = 'INGARAGE',
		[1] = 'OUTGARAGE',
		[2] = 'IMPOUNDED',
		[3] = 'SEIZED'
	}
	TriggerEvent('blckhndr_notify:displayNotification', 'INFO: <b>'..plate..'</b> set to <b>'..statuses[status]..'</b> at <b><i>'..grg, 'centerLeft', 3000, 'info')
end)

RegisterNetEvent('blckhndr_cargarage:receiveVehicles')
AddEventHandler('blckhndr_cargarage:receiveVehicles', function(type, vehtbl)
	if type == 'cars' then
		myGarage.cars = vehtbl
		local grg = json.encode(vehtbl)
		SendNUIMessage({
			receive = 'vehicles',
			garage = grg
		})
	elseif type == 'aircrafts' then
		myGarage.aircrafts = vehtbl
		local grg = json.encode(vehtbl)
		SendNUIMessage({
			receive = 'aircrafts',
			garage = grg
		})
	elseif type == 'boats' then
		myGarage.boats = vehtbl
		local grg = json.encode(vehtbl)
		SendNUIMessage({
			receive = 'boats',
			garage = grg
		})
	else
	end
end)

function blckhndr_ToggleGarageMenu()
	FreezeEntityPosition(GetPlayerPed(-1), 0)
  SetEntityCollision(GetPlayerPed(-1), 1, 1)
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then
		SetNuiFocus( true, true )
		SendNUIMessage({
			showmenu = true
		})
	else
		SetNuiFocus( false )
		SendNUIMessage({
			hidemenu = true
		})
	end
end

function blckhndr_GetVehicleDetails(vehid)
	for k, v in pairs(myGarage) do
		for key, value in pairs(v) do
			if value.veh_id == vehid then
				return value
			end
		end
	end
end

function blckhndr_GetVehicleVehIDP(plate)
	for k, v in pairs(myGarage) do
		for key, value in pairs(v) do
			if value.plate == plate then
				print(value.plate)
			end
		end
	end
	return false
end

function blckhndr_SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- vehicle decors
DecorRegister('fuelLevel', 3)
DecorRegister('vehDMG:electronics', 3)
DecorRegister('vehDMG:clutch', 3)
DecorRegister('vehDMG:gearbox', 3)
DecorRegister('vehDMG:breaks', 3)
DecorRegister('vehDMG:transmission', 3)
DecorRegister('vehDMG:axle', 3)
DecorRegister('vehDMG:fuel_injectors', 3)
DecorRegister('vehDMG:fuel_tank', 3)
DecorRegister('vehDMG:tyre_depth', 3)

function doCarDamages(eh, bh, veh)
	
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = eh + 0.0
	local body = bh + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end
	
	print('blckhndr_cargarage: details eh('..eh..') bh('..bh..') smash('..tostring(smash)..') damageOutside('..tostring(damageOutside)..') damageOutside2('..tostring(damageOutside2)..')')
	
	local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(GetPlayerPed(-1), false)

	Citizen.Wait(100)
	SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.0)
	end
end

function blckhndr_SpawnVehicle(vehid)
	Citizen.CreateThread(function()
		-- spawn vehicle and get details
		local veh = blckhndr_GetVehicleDetails(vehid)

		if veh.veh_status == 1 or veh.veh_status == 3 then
			TriggerEvent('blckhndr_notify:displayNotification', 'You cannot spawn this vehicle!', 'centerLeft', 4000, 'error')
			return
		end

		if veh.veh_status == 0 then
			TriggerEvent('blckhndr_bank:change:walletMinus', 50)
		elseif veh.veh_status == 2 then
			TriggerEvent('blckhndr_bank:change:walletMinus', 2500)
		end

		local model = GetHashKey(veh.veh_spawnname)
		local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)

		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end
		local personalvehicle = CreateVehicle(model, pos.x, pos.y, pos.z, GetEntityHeading(GetPlayerPed(-1)), true, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(personalvehicle)
		SetVehicleHasBeenOwnedByPlayer(personalvehicle, true)
		local id = NetworkGetNetworkIdFromEntity(personalvehicle)
		SetNetworkIdCanMigrate(id, true)
		
		SetVehicleNumberPlateText(personalvehicle, veh.veh_plate)
		
		------------------------------
		-- make the vehicle look and function right
		------------------------------
		if veh.veh_details then
			local details = json.decode(veh.veh_details)
			SetVehicleNumberPlateTextIndex(personalvehicle, details.customisations.plate)
			
			-- damage
			SetVehicleBodyHealth(personalvehicle, details.damage.body-0.01)
			SetVehicleEngineHealth(personalvehicle, details.damage.engine-0.01)
			for k, v in pairs(details.damage.advanced) do
				DecorSetInt(personalvehicle, 'vehDMG:'..k, v)
			end
			
			-- colours
			SetVehicleColours(personalvehicle, details.customisations.colours.main[1], details.customisations.colours.main[2])
			SetVehicleExtraColours(personalvehicle, details.customisations.colours.extras[1], details.customisations.colours.extras[2])
			
			-- windows
			SetVehicleWindowTint(personalvehicle, details.customisations.windows)
			
			-- livery
			SetVehicleLivery(personalvehicle, details.livery)
			
			-- neons
			for i = 0, 3 do
				SetVehicleNeonLightEnabled(personalvehicle, i, details.customisations.neons.enabled[i])
			end

			-- headlightcolor
			SetVehicleHeadlightsColour(personalvehicle,details.customisations.headlightcolor)
			
			-- wheels
			SetVehicleWheelType(personalvehicle, details.customisations.wheels.type)
			SetVehicleTyreSmokeColor(personalvehicle, details.customisations.wheels.smoke[1], details.customisations.wheels.smoke[2], details.customisations.wheels.smoke[3])
			
			-- mods
			SetVehicleModKit(personalvehicle, 0)
			for i = 0, 16 do
				SetVehicleMod(personalvehicle, i, details.customisations.mods[tostring(i)])
			end

			for i = 17, 22 do
				ToggleVehicleMod(personalvehicle, i, details.customisations.mods[tostring(i)])
			end

			for i = 23, 24 do
				SetVehicleMod(personalvehicle, i, details.customisations.mods[tostring(i)])
			end

			for i = 23, 48 do
				SetVehicleMod(personalvehicle, i, details.customisations.mods[tostring(i)])
			end
			
			-- damage
			doCarDamages(details.damage.engine-0.01, details.damage.body-0.01, personalvehicle)
		end
		------------------------------
		-- finish spawning
		------------------------------
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalvehicle, -1)
		table.insert(myVehicles, #myVehicles+1, {
			ent = personalvehicle,
			plate = veh.veh_plate,
			model = veh.veh_name
		})
		TriggerEvent('blckhndr_vehiclecontrol:keys:carjack', GetVehicleNumberPlateText(personalvehicle))
		SetEntityAsMissionEntity(personalvehicle, false, true)
		TriggerServerEvent('blckhndr_cargarage:vehicle:toggleStatus', veh.veh_plate, 1, '0')
	end)
end

RegisterNUICallback( "ButtonClick", function( data, cb )

	local split = blckhndr_SplitString(data, '-')
	if split[1] == 'spawn' then
		local vehid = tonumber(split[2])
		blckhndr_SpawnVehicle(vehid)
		blckhndr_ToggleGarageMenu()
	end
	if split[1] == 'sell' then
		local vehid = tonumber(split[2])
		local vehicle_details = blckhndr_GetVehicleDetails(vehid)
		--blckhndr_VehicleSale(vehicle_details)
		blckhndr_ToggleGarageMenu()
	end
	if ( data == "exit" ) then
		blckhndr_ToggleGarageMenu()
		return
	end
end )

Citizen.CreateThread(function()
	for _, grg in pairs(garages) do
		local bleep = AddBlipForCoord(grg.pos.x, grg.pos.y, grg.pos.z)
		SetBlipSprite(bleep, grg.blip)
		SetBlipScale(bleep, 0.8)
		SetBlipAsShortRange(bleep, true)
		BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Garázs")
		EndTextCommandSetBlipName(bleep)
	end
	while true do
		Citizen.Wait(0)
		for key, grg in pairs(garages) do
			if GetDistanceBetweenCoords(grg.pos.x,grg.pos.y,grg.pos.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
        DrawMarker(1,grg.pos.x,grg.pos.y,grg.pos.z-1,0,0,0,0,0,0,5.8, 5.8, 0.5,0,155,255,175,0,0,0,0)
        if GetDistanceBetweenCoords(grg.pos.x,grg.pos.y,grg.pos.z,GetEntityCoords(GetPlayerPed(-1)), true) < 5.8 then
					local vehicle = false
					if IsPedInAnyVehicle(GetPlayerPed(-1)) then
						if GetVehiclePedIsUsing(GetPlayerPed(-1)) then
							vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))		
						end
					else
						vehicle = blckhndr_IsVehicleHere(grg.pos.x,grg.pos.y,grg.pos.z,5.8)
					end
					if vehicle then
						SetTextComponentFormat("STRING")
						AddTextComponentString("Press ~INPUT_CELLPHONE_SELECT~ to ~r~return~w~ your vehicle")
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						if IsControlJustPressed(1, 18) then
							if not blckhndr_IsVehicleOwner(vehicle) then
								TriggerEvent('blckhndr_notify:displayNotification', 'You do not own this vehicle.', 'centerLeft', 4000, 'error')
							else
							if grg.type == 'aircrafts' then	
								if GetVehicleClass(vehicle) == 15 or GetVehicleClass(vehicle) == 16 then
									despawn = true
								else
									TriggerEvent('blckhndr_notify:displayNotification', 'INVALID: Aircraft Garage', 'centerLeft', 4000, 'error')
								end
							elseif grg.type == 'boats' then
								if GetVehicleClass(vehicle) == 14 then
									despawn = true
								else
									TriggerEvent('blckhndr_notify:displayNotification', 'INVALID: Boats Garage', 'centerLeft', 4000, 'error')
								end
							elseif grg.type == 'cars' then
								if GetVehicleClass(vehicle) == 14 or GetVehicleClass(vehicle) == 15 or GetVehicleClass(vehicle) == 16 then
									TriggerEvent('blckhndr_notify:displayNotification', 'INVALID: Car Garage', 'centerLeft', 4000, 'error')	
							else
								despawn = true
							end	
						end		
							
							if despawn == true then
								local deets = getCarDetails(vehicle)
								TriggerServerEvent('blckhndr_garages:vehicle:update', deets)
								SetEntityAsMissionEntity( vehicle, false, true )
								TriggerServerEvent('blckhndr_cargarage:vehicle:toggleStatus', GetVehicleNumberPlateText(vehicle), 0, key)
								Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( vehicle ) )
								despawn = false
							end

					end
				end
					else
						SetTextComponentFormat("STRING")
						AddTextComponentString("Press ~INPUT_PICKUP~ to view your garage")
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						if IsControlJustPressed(1, 38) then
							TriggerServerEvent('blckhndr_cargarage:requestVehicles', grg.type, exports.blckhndr_main:blckhndr_CharID(), key)
							blckhndr_ToggleGarageMenu()
						end
					end
				end
			end
		end
	end
end)

function blckhndr_IsVehicleHere(x,y,z,radius)
	for k, v in pairs(myVehicles) do
		local veh = v.ent
		if not veh then return false end
		if GetDistanceBetweenCoords(x,y,z,GetEntityCoords(veh, true)) < 5.8 then
			return veh
		end
	end
	return false
end

function blckhndr_IsVehicleOwner(veh1)
	local plate = GetVehicleNumberPlateText(veh1)
	for k, v in pairs(myVehicles) do
		local veh2 = v.plate
		if plate == veh2 then
			return true
		end
	end
	return false
end
function blckhndr_IsVehicleOwnerP(plate)
	for k, v in pairs(myVehicles) do
		local veh2 = v.plate
		if plate == veh2 then
			return true
		end
	end
	return false
end

function blckhndr_HasVehicleKeys(plate, model)
	for k, v in pairs(myKeys) do
		if v.plate == plate and v.model == model then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local deets = getCarDetails(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			TriggerServerEvent('blckhndr_garages:vehicle:update', deets)
		end
	end
end)
