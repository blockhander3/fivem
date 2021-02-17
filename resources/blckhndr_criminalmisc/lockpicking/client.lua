local picklocking = false
local lastSafe = 0

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

local desks = {}
RegisterNetEvent('blckhndr_bankrobbery:desks:receive')
AddEventHandler('blckhndr_bankrobbery:desks:receive', function(tbl)
	desks = tbl
end)

RegisterNetEvent('blckhndr_criminalmisc:lockpicking')
AddEventHandler('blckhndr_criminalmisc:lockpicking', function()
	if not picklocking then
		for k, v in pairs(desks) do
			if GetDistanceBetweenCoords(v.door.x, v.door.y, v.door.z, GetEntityCoords(GetPlayerPed(-1)), true) < 2 then
				picklocking = true
				TriggerEvent('blckhndr_notify:displayNotification', 'Elkezdted betörni a széf ajtaját.', 'centerLeft', 3500, 'error')
				while ( not HasAnimDictLoaded( "mini@safe_cracking" ) ) do
					RequestAnimDict( "mini@safe_cracking" )
					Citizen.Wait( 5 )
				end
				TaskPlayAnim(GetPlayerPed(-1), "mini@safe_cracking", "idle_base", 8.0, 1.0, 12000, 2, 0, 0, 1, 1 )
				Citizen.Wait( 12000 )
				if exports["blckhndr_police"]:blckhndr_getCopAmt() > 0 then
					TriggerServerEvent('blckhndr_bankrobbery:desks:doorUnlock', k)
					local pos = GetEntityCoords(GetPlayerPed(-1))
					local coords = {
					 x = pos.x,
					 y = pos.y,
					 z = pos.z
					}
					TriggerServerEvent('blckhndr_police:dispatch', coords, 12, '10-90 | BANKRABLÁS FOLYAMATBAN')
					picklocking = false
					CancelEvent()
				else
					TriggerEvent('blckhndr_notify:displayNotification', 'Kicsit kevés rendőr van a közelben..', 'centerLeft', 3500, 'error')
					picklocking = false
					CancelEvent()
				end
			end
		end
		local lost_safe = {x = 977.23968505859, y = -104.10308074951, z = 74.845184326172}
		if GetDistanceBetweenCoords(lost_safe.x, lost_safe.y, lost_safe.z, GetEntityCoords(GetPlayerPed(-1))) < 2 then
			print(exports['blckhndr_police']:blckhndr_getCopAmt()..' are online')
			if exports['blckhndr_police']:blckhndr_getCopAmt() < 3 then
				--TriggerEvent('blckhndr_bankrobbery:LostMC:spawn')
				TriggerEvent('blckhndr_notify:displayNotification', 'Nincs elég rendőr a heisthez..', 'centerLeft', 3500, 'error')
			else
				picklocking = true
				while ( not HasAnimDictLoaded( "mini@safe_cracking" ) ) do
					RequestAnimDict( "mini@safe_cracking" )
					Citizen.Wait( 5 )
				end
				TaskPlayAnim(GetPlayerPed(-1), "mini@safe_cracking", "idle_base", 8.0, 1.0, 12000, 2, 0, 0, 1, 1 )
				Citizen.Wait( 12000 )
				if math.random(1,100) > 50 then
					TriggerEvent('blckhndr_bankrobbery:LostMC:spawn')
				end
				if math.random(1,100) > 80 then
					local maff = lastSafe + 900
					if maff < exports["blckhndr_main"]:blckhndr_GetTime() then
						lastSafe = exports["blckhndr_main"]:blckhndr_GetTime()
						TriggerEvent('blckhndr_notify:displayNotification', 'Feltörted a LostMC széfét...', 'centerLeft', 6000, 'success')
						if math.random(1,100) > 50 then
							TriggerEvent('blckhndr_inventory:item:add', 'modified_drillbit', 1)
						end
						TriggerEvent('blckhndr_inventory:item:add', 'dirty_money', math.random(450,4000))
						if math.random(1, 100) > 50 then TriggerEvent('blckhndr_inventory:item:add', 'lockpick', math.random(1,5)) end
						if math.random(1, 100) > 50 then TriggerEvent('blckhndr_inventory:item:add', 'zipties', math.random(1,3)) end
						if math.random(1, 100) > 50 then TriggerEvent('blckhndr_inventory:item:add', 'joint', math.random(1,10)) end
						if math.random(1, 100) > 50 then TriggerEvent('blckhndr_inventory:item:add', 'joint', math.random(1,10)) end
						if math.random(1, 100) > 70 then TriggerEvent('blckhndr_inventory:item:add', 'packaged_cocaine', math.random(1,5)) end
						--TriggerEvent('blckhndr_bankrobbery:LostMC:spawn')
						local pos = GetEntityCoords(GetPlayerPed(-1))
						local coords = {
						 x = pos.x,
						 y = pos.y,
						 z = pos.z
						}
						TriggerServerEvent('blckhndr_police:dispatch', coords, 12, '10-90 | A LostMC klubháznál rablás történt...')
					else
						TriggerEvent('blckhndr_notify:displayNotification', 'Ezt nem teheted meg', 'centerLeft', 3500, 'error')
					end
				else
					TriggerEvent('blckhndr_notify:displayNotification', 'Eltorted a tolvajkulcsodat...', 'centerLeft', 3500, 'error')
					TriggerEvent('blckhndr_inventory:item:take', 'lockpick', 1)
				end
			end
			picklocking = false
		else
			picklocking = true
			doLockpick()
		end
	end
end)

local lockpicking_car = false
local lockpicking_vehicle = false
local lockpicking_start = 0
local lockpicking_length = 0 
function doLockpick()
	while ( not HasAnimDictLoaded( "mini@safe_cracking" ) ) do
		RequestAnimDict( "mini@safe_cracking" )
		Citizen.Wait( 5 )
	end
	TaskPlayAnim(GetPlayerPed(-1), "mini@safe_cracking", "idle_base", 8.0, 1.0, 1000, 2, 0, 0, 1, 1 )
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		lockpicking_vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		TriggerEvent('blckhndr_notify:displayNotification', 'Megpróbálod beindítani a járművet.', 'centerLeft', 3500, 'error')
		lockpicking_car = true
	else
		if blckhndr_lookingAt() then
			lockpicking_vehicle = blckhndr_lookingAt()
			TriggerEvent('blckhndr_notify:displayNotification', 'Megpróbálod feltörni a járművet.', 'centerLeft', 3500, 'error')
			lockpicking_car = true
		else
			TriggerEvent('blckhndr_notify:displayNotification', 'Nincs a közeledben egy jármű sem.', 'centerLeft', 3500, 'error')
		end
	end
	
	lockpicking_start = exports["blckhndr_main"]:blckhndr_GetTime()
	lockpicking_length = GetVehicleMaxSpeed(lockpicking_vehicle)
	if lockpicking_length > 55 then
		print 'fast car make lockpicking longer'
		local mafffff = lockpicking_length / 2
		lockpicking_length = lockpicking_length + mafffff
	end
	print('lockpicking car for: '..lockpicking_length)
	exports["blckhndr_progress"]:blckhndr_ProgressBar(58, 133, 255,'Feltörés',lockpicking_length)
	dispatchAlert(lockpicking_vehicle)
	Citizen.CreateThread(function()
		while lockpicking_car do
			Citizen.Wait(0)
			local maff = lockpicking_start + lockpicking_length
			if maff >= exports["blckhndr_main"]:blckhndr_GetTime() then
				if GetDistanceBetweenCoords(GetEntityCoords(lockpicking_vehicle), GetEntityCoords(GetPlayerPed(-1))) > 5 or IsControlJustPressed( 1,  288 ) then
					picklocking = false
					exports["blckhndr_progress"]:removeBar()
					lockpicking_car = false
				end
				if not IsEntityPlayingAnim(GetPlayerPed(-1), "mini@safe_cracking", "idle_base", 3) then
					TaskPlayAnim(GetPlayerPed(-1), "mini@safe_cracking", "idle_base", 8.0, 1.0, 1000, 2, 0, 0, 1, 1 )
				end
			else
				-- i finished
				local plate = GetVehicleNumberPlateText(lockpicking_vehicle)
				TriggerEvent('blckhndr_vehiclecontrol:keys:carjack', plate)
				if math.random(1, 100) > 70 then
					TriggerEvent('blckhndr_notify:displayNotification', 'Eltört a tolvajkulcsod.', 'centerLeft', 5000, 'error')
					TriggerEvent('blckhndr_inventory:item:take', 'lockpick', 1)
				end
				picklocking = false
				lockpicking_car = false
			end
		end
	end)
end

function dispatchAlert(veh)
	if math.random(1,100) < 40 then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local coords = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
		local colour = table.pack(GetVehicleColours(veh))
		colour = colour[1]
		colour = vehicle_colours[colour+1]
		local vehicle = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
		local plate = GetVehicleNumberPlateText(veh)
		if plate then
			TriggerServerEvent('blckhndr_police:dispatch', coords, 10, '10-60 | Jármü: '..vehicle..' | Rendszám: '..plate..' | Szín: '..colour)
		end
	end
end