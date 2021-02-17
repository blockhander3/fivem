local vehicle_colours = {
	'Black',
	'Graphite',
	'Black Steel',
	'Silver',
	'Bluish Silver',
	'Rolled Steel',
	'Shadow Silver',
	'Stone Silver',
	'Midnight Silver',
	'Cast Iron Silver',
	'Anthractite Black',
	'Matte Black',
	'Matte Gray',
	'Light Gray',
	'Util Black',
	'Util Black Poly',
	'Util Dark Silver',
	'Util Silver',
	'Util Gun Metal',
	'Util Shadow Silver',
	'Worn Black',
	'Worn Graphite',
	'Worn Silver Gray',
	'Worn Silver',
	'Worn Blue Silver',
	'Worn Shadow Silver',
	'Red',
	'Torino Red',
	'Formula Red',
	'Blaze Red',
	'Grace Red',
	'Garnet Red',
	'Sunset Red',
	'Cabernet Red',
	'Candy Red',
	'Sunrise Orange',
	'Gold',
	'Orange',
	'Red',
	'Dark Red',
	'Matte Orange',
	'Yellow',
	'Util Red',
	'Util Bright Red',
	'Util Garnet Red',
	'Worn Red',
	'Worn Golden Red',
	'Worn Dark Red',
	'Dark Green',
	'Metallic Racing Green',
	'Sea Green',
	'Olive Green',
	'Bright Green',
	'Metalic Gasoline Green',
	'Matte Lime Green',
	'Dark Green',
	'Worn Green',
	'Worn Sea Wash',
	'Metallic Midnight Blue',
	'Metallic Dark Blue',
	'Galaxy Blue',
	'Dark Blue',
	'Saxon Blue',
	'Blue',
	'Mariner Blue',
	'Harbor Blue',
	'Diamond Blue',
	'Surf Blue',
	'Nautical Blue',
	'Ultra Blue',
	'Schafter Purple',
	'Metallic Ultra Blue',
	'Racing Blue',
	'Light Blue',
	'Util Midnight Blue',
	'Util Blue',
	'Util Sea Foam Blue',
	'Util Lightening Blue',
	'Util Maui Blue Poly',
	'Util Bright Blue',
	'Slate Blue',
	'Dark Blue',
	'Blue',
	'Matte Midnight Blue',
	'Worn Dark Blue',
	'Worn Blue',
	'Baby Blue',
	'Yellow',
	'Race Yellow',
	'Bronze',
	'Dew Yellow',
	'Metallic Lime',
	'Metalic Champagne',
	'Feltzer Brown',
	'Creek Brown',
	'Chocolate Brown',
	'Maple Brown',
	'Saddle Brown',
	'Straw Brown',
	'Moss Brown',
	'Bison Brown',
	'Woodbeech Brown',
	'Beechwood Brown',
	'Straw Brown',
	'Sandy Brown',
	'Bleached Brown',
	'Cream',
	'Util Brown',
	'Util Medium Brown',
	'Util Light Brown',
	'Ice White',
	'Frost White',
	'Worn Honey Beige',
	'Worn Brown',
	'Dark Brown',
	'Worn Straw Beige',
	'Brushed Steel',
	'Brushed Black Steel',
	'Brushed Alluminum',
	'Chrome',
	'Worn Off-White',
	'Util Off-White',
	'Worn Orange',
	'Worn Light Orange',
	'Pea Green',
	'Worn Taxi Yellow',
	'Police Blue',
	'Green',
	'Matte Brown',
	'Worn Orange',
	'Ice White',
	'Worn White',
	'Worn Olive Army Green',
	'Pure White',
	'Hot Pink',
	'Salmon Pink',
	'Pfistrer Pink',
	'Bright Orange',
	'Green',
	'Flourescent Blue',
	'Midnight Blue',
	'Midnight Purple',
	'Wine Red',
	'Hunter Green',
	'Bright Purple',
	'Midnight Purple',
	'Carbon Black',
	'Matte Purple',
	'Matte Dark Purple',
	'Metallic Lava Red',
	'Olive Green',
	'Matte Olive Orab',
	'Dark Earth',
	'Desert Tan',
	'Matte Foilage Green',
	'Default Alloy',
	'Epsilon Blue',
	'Pure Gold',
	'Brushed Gold',
	'Secret Gold'
}

OnAtEnter = false
UseKey = true
if UseKey then
	ToggleKey = 303
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
function blckhndr_lookingAt()
	local targetVehicle = false

	local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, -1.0)
	targetVehicle = getVehicleInDirection(coordA, coordB)

	return targetVehicle
end

local vehicles = {}; RPWorking = true
myKeys = {}

RegisterNetEvent('blckhndr_vehiclecontrol:getKeys')
RegisterNetEvent('blckhndr_vehiclecontrol:giveKeys')
AddEventHandler('blckhndr_vehiclecontrol:getKeys', function(veh)
	if not table.contains(myKeys, GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
		table.insert(myKeys, {GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)),true})
		TriggerEvent('blckhndr_notify:displayNotification', 'You got keys to this vehicle!', 'centerLeft', 5000, 'info')
	else
		TriggerEvent('blckhndr_notify:displayNotification', 'You already have keys to the vehicle', 'centerLeft', 5000, 'info')
	end
end)
AddEventHandler('blckhndr_vehiclecontrol:giveKeys', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		if exports.blckhndr_cargarage:blckhndr_IsVehicleOwner(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			local ply = false
			for _, id in ipairs(GetActivePlayers()) do --for id = 0, 32 do
	      if NetworkIsPlayerActive(id) then
	        ped = GetPlayerPed(id)
					if ped ~= GetPlayerPed(-1) then
						if GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(GetPlayerPed(-1))) < 5 then
							if IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped, false) == GetVehiclePedIsIn(GetPlayerPed(-1), false)then
								ply = id
							else
								TriggerEvent('blckhndr_notify:displayNotification', 'They have to be in the car too!!', 'centerLeft', 5000, 'info')
								return
							end
						end
					end
				end
			end
			if ply then
				TriggerServerEvent('blckhndr_vehiclecontrol:givekeys', GetVehiclePedIsIn(GetPlayerPed(-1), false), GetPlayerServerId(ply))
				TriggerEvent('blckhndr_notify:displayNotification', ':FSN: You gave keys to: '..ply, 'centerRight', 5000, 'info')
			else
				TriggerEvent('blckhndr_notify:displayNotification', 'Nobody detected :(<br>You have no friends', 'centerRight', 5000, 'info')
			end
		else
			TriggerEvent('blckhndr_notify:displayNotification', 'You cannot give keys to a vehicle you do not own', 'centerLeft', 5000, 'info')
		end
	else
		TriggerEvent('blckhndr_notify:displayNotification', 'You have to be in the vehicle to give keys', 'centerLeft', 5000, 'info')
	end
end)

RegisterNetEvent('EngineToggle:Engine')
RegisterNetEvent('EngineToggle:RPDamage')

RegisterNetEvent('blckhndr_vehiclecontrol:keys:carjack')
AddEventHandler('blckhndr_vehiclecontrol:keys:carjack', function(plate)
	TriggerEvent('blckhndr_notify:displayNotification', 'You got keys to: '..string.upper(plate), 'centerRight', 3000, 'info')
	table.insert(myKeys, {plate,true})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 7) then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
				if GetVehicleDoorsLockedForPlayer(GetVehiclePedIsIn(GetPlayerPed(-1), false), PlayerId()) then
					SetVehicleDoorsLockedForAllPlayers(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
					TriggerEvent('blckhndr_notify:displayNotification', 'A jármű bezárva!', 'centerRight', 3000, 'info')
					if not IsPedInAnyVehicle(PlayerPedId(), true) then
						TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
					end
					
				else
					TriggerEvent('blckhndr_notify:displayNotification', 'A jármü kinyitva', 'centerRight', 3000, 'info')
					SetVehicleDoorsLockedForAllPlayers(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
					if not IsPedInAnyVehicle(PlayerPedId(), true) then
						TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
					end
					
				end
			else
				local veh = blckhndr_lookingAt()
				if veh then
					if exports.blckhndr_cargarage:blckhndr_IsVehicleOwner(veh) or table.contains(myKeys, GetVehicleNumberPlateText(veh)) then
						if GetVehicleDoorsLockedForPlayer(veh, PlayerId()) then
							SetVehicleDoorsLockedForAllPlayers(veh, false)
							TriggerEvent('blckhndr_notify:displayNotification', 'A jármü kinyitva', 'centerRight', 3000, 'info')
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
						else
							TriggerEvent('blckhndr_notify:displayNotification', 'A jármű bezárva!', 'centerRight', 3000, 'info')
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleDoorsLockedForAllPlayers(veh, true)

						end
					end
				end
			end
		end
		if UseKey and ToggleKey then
			if IsControlJustReleased(1, ToggleKey) then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
					--if exports.blckhndr_cargarage:blckhndr_IsVehicleOwner(GetVehiclePedIsIn(GetPlayerPed(-1), false)) or table.contains(myKeys, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
						if fuel_amount > 0 then

							TriggerEvent('EngineToggle:Engine')
						end
					--else
						--TriggerEvent('blckhndr_notify:displayNotification', 'You don\'t have the keys for this vehicle!', 'centerLeft', 3000, 'error')
				--	end
				end
			end
		end
		if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))) then
			table.insert(vehicles, {GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)), false})--IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))})
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), false) and not table.contains(vehicles, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			table.insert(vehicles, {GetVehiclePedIsIn(GetPlayerPed(-1), false), false})--IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false))})
		end
		for i, vehicle in ipairs(vehicles) do
			if DoesEntityExist(vehicle[1]) then
				if (GetPedInVehicleSeat(vehicle[1], -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle[1], -1) then
					if RPWorking then
						if fuel_amount > 0 then
							SetVehicleEngineOn(vehicle[1], vehicle[2], true, false)
							if not IsPedInAnyVehicle(GetPlayerPed(-1), false) or (IsPedInAnyVehicle(GetPlayerPed(-1), false) and vehicle[1]~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
								if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
									if vehicle[2] then
										SetHeliBladesFullSpeed(vehicle[1])
									end
								end
							end
						end
					end
				end
			else
				table.remove(vehicles, i)
			end
		end
	end
end)

local function canunlock()
	if exports.blckhndr_cargarage:blckhndr_IsVehicleOwner(GetVehiclePedIsIn(GetPlayerPed(-1), false)) or table.contains(myKeys, GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
		return true
	else
		return false
	end
end

AddEventHandler('EngineToggle:Engine', function()
	if not canunlock() then
		TriggerEvent('blckhndr_notify:displayNotification', 'Nincs kulcsod a járműhöz!', 'centerLeft', 3000, 'error')
	return end
	if IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) and not exports["blckhndr_licenses"]:blckhndr_hasLicense('pilot') then 
		TriggerEvent('blckhndr_notify:displayNotification', 'Nem indithatod be ezt a járművet', 'centerLeft', 3000, 'error')
	return end
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	--Citizen.Wait(1500)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
			vehicles[StateIndex][2] = not IsVehicleEngineOn(veh)
			if vehicles[StateIndex][2] then
				Citizen.Wait(2500)
				TriggerEvent('blckhndr_notify:displayNotification', 'Beindítottad a járművet', 'centerLeft', 3000, 'success')
			else
				TriggerEvent('blckhndr_notify:displayNotification', 'Leállítottad a járművet', 'centerLeft', 3000, 'error')
			end
		end
  end
end)

AddEventHandler('EngineToggle:RPDamage', function(State)
	RPWorking = State
end)

if OnAtEnter then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 then
				for i, vehicle in ipairs(vehicles) do
					if vehicle[1] == GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) and not vehicle[2] then
						Citizen.Wait(3500)
						vehicle[2] = true
					end
				end
			end
		end
	end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end
