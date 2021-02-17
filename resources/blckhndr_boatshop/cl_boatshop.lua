local inside_store = {x = 1335.6577148438, y = 4270.1655273438, z = 31.503137588501}
local boat_spots = {}
local rented_boats = {}

function BuyBoat(key)
	local veh = boat_spots[key].boat.object
	local model = GetEntityModel(veh)
	local colors = table.pack(GetVehicleColours(veh))
	local extra_colors = table.pack(GetVehicleExtraColours(veh))

	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
	local pos = vector4(1350.4514160156, 4228.8076171875, 30.129796981812, 134.00)
	
	FreezeEntityPosition(ped,false)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
	personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
	SetModelAsNoLongerNeeded(model)

	SetVehicleOnGroundProperly(personalvehicle)
	SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
	local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	SetNetworkIdCanMigrate(id, true)
	--Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	SetEntityAsMissionEntity(personalvehicle, true, true)
	SetVehicleColours(personalvehicle,colors[1],colors[2])
	SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalvehicle,-1)
	SetEntityVisible(ped,true)
	
	local details = {
		plate = GetVehicleNumberPlateText(personalvehicle),
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
	
	local finance = {
		outright = true,
		buyprice = boat_spots[key].boat.buyprice+boat_spots[key].boat.commission,
		base = boat_spots[key].boat.buyprice,
		commission = boat_spots[key].boat.commission
	}
	
	TriggerServerEvent('blckhndr_cargarage:buyVehicle', exports["blckhndr_main"]:blckhndr_CharID(), boat_spots[key].boat.name, boat_spots[key].boat.model, GetVehicleNumberPlateText(personalvehicle), details, finance, 'b', 0)
	exports['mythic_notify']:DoCustomHudText('success', 'Vettél egy '..boat_spots[key].boat.name..' -t $'..boat_spots[key].boat.buyprice+boat_spots[key].boat.commission'-ért', 3000)
	TriggerEvent('blckhndr_bank:change:walletMinus', boat_spots[key].boat.buyprice+boat_spots[key].boat.commission)
	TriggerEvent('blckhndr_cargarage:makeMine', personalvehicle, boat_spots[key].boat.model, GetVehicleNumberPlateText(personalvehicle))
end

function RentBoat(key)

	TriggerEvent('blckhndr_bank:change:walletMinus', boat_spots[key].boat.rentalprice)
	local veh = boat_spots[key].boat.object
	local model = GetEntityModel(veh)
	local colors = table.pack(GetVehicleColours(veh))
	local extra_colors = table.pack(GetVehicleExtraColours(veh))

	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
	local pos = vector4(1350.4514160156, 4228.8076171875, 30.129796981812,134.67294311523)
	
	FreezeEntityPosition(ped,false)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
	boatrental = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
	SetModelAsNoLongerNeeded(model)

	SetVehicleOnGroundProperly(boatrental)
	SetVehicleHasBeenOwnedByPlayer(boatrental,true)
	exports['mythic_notify']:DoCustomHudText('success', 'Kibérelted a hajót!.', 3000)
	local id = NetworkGetNetworkIdFromEntity(boatrental)
	SetNetworkIdCanMigrate(id, true)
	Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(boatrental))
	SetEntityAsMissionEntity(boatrental, true, true)
	SetVehicleColours(boatrental,colors[1],colors[2])
	SetVehicleExtraColours(boatrental,extra_colors[1],extra_colors[2])
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),boatrental,-1)

	TriggerEvent('blckhndr_cargarage:makeMine', boatrental, boat_spots[key].boat.model, GetVehicleNumberPlateText(boatrental))

	local boat = {
		plate = GetVehicleNumberPlateText(boatrental),
		 rentalprice = boat_spots[key].boat.rentalprice
	}

	table.insert(rented_boats, #rented_boats+1, boat)
	
end

Util.Tick(function()
	if GetDistanceBetweenCoords(inside_store.x, inside_store.y, inside_store.z, GetEntityCoords(GetPlayerPed(-1)), true) < 100 then
		for key, boat in pairs(boat_spots) do
			if boat.boat.model then
				if not DoesEntityExist(boat.boat.object) then
					RequestModel(GetHashKey(boat.boat.model))
					while not HasModelLoaded(GetHashKey(boat.boat.model)) do
						Citizen.Wait(1)
						if GetDistanceBetweenCoords(inside_store.x, inside_store.y, inside_store.z, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
							--Util.DrawText3D(boat.x, boat.y, boat.z, ':FSN: Loading vehicle: '..boat.boat.model, {255, 0, 0, 255}, 0.2)
						end
					end
					boat.boat.object = CreateVehicle(GetHashKey(boat.boat.model), boat.x, boat.y, boat.z-1, boat.h, false, false)
					FreezeEntityPosition(boat.boat.object, true)
					SetVehicleOnGroundProperly(boat.boat.object)
					SetVehicleColours(boat.boat.object, boat.boat.color[1], boat.boat.color[2])
					SetVehicleExtraColours(boat.boat.object, -1, -1)
					SetVehicleNumberPlateText(boat.boat.object, "PDMFLOOR")
				else
					if IsEntityAttachedToAnyVehicle(boat.boat.object) then
						-- someone is trying to tow this shit
						DetachEntity(boat.boat.object)
					end
					if GetDistanceBetweenCoords(boat.x,boat.y,boat.z, GetEntityCoords(boat.boat.object), true) > 2 then
						-- boat is not where it's supposed to be :/
						SetEntityCoords(boat.boat.object, boat.x, boat.y, boat.z-1, 1, 0, 0, 1)
						SetVehicleOnGroundProperly(boat.boat.object)
					end
					FreezeEntityPosition(boat.boat.object, true)
					SetEntityInvincible(boat.boat.object,true)
					SetEntityAsMissionEntity( boat.boat.object, true, true )
					
					if not boat.updated then
						IsEntityVisible(boat.boat.object)
						Citizen.Wait(10)
						DeleteEntity(boat.boat.object)
						if not boat.updatestart then
							boat.updatestart = GetNetworkTime()
						end
						if boat.updatestart+300 < GetNetworkTime() then
							local primary, secondary = GetVehicleColours(boat.boat.object)
							print('PRIMARY: '..primary..' ?? '..boat.boat.color[1])
							print('SECONDARY: '..secondary..' ?? '..boat.boat.color[2])
							boat.updated = true
							boat.updatestart = false
						else
							--Util.DrawText3D(boat.x, boat.y, boat.z, ':FSN: Updating vehicle', {255, 0, 0, 255}, 0.2)
						end
					else
						if GetDistanceBetweenCoords(boat.x, boat.y, boat.z, GetEntityCoords(GetPlayerPed(-1)), true) < 5 then
							Util.DrawText3D(boat.x, boat.y, boat.z+2.45, 'Hajó: ~b~'..boat.boat.name, {255, 255, 255, 255}, 0.3)
							Util.DrawText3D(boat.x, boat.y, boat.z+2.3, 'Alap ár: ~g~$'..boat.boat.buyprice, {255, 255, 255, 200}, 0.2)
							Util.DrawText3D(boat.x, boat.y, boat.z+2.18, 'A cég profitja: ~r~'..boat.boat.commission..'~w~%', {255, 255, 255, 200}, 0.2)
							local comm = math.floor(boat.boat.buyprice / 100 * boat.boat.commission)
							Util.DrawText3D(boat.x, boat.y, boat.z+2.06, 'Igazi ár ~g~$'..boat.boat.buyprice+comm, {255, 255, 255, 200}, 0.2)
							Util.DrawText3D(boat.x, boat.y, boat.z+1.94, 'Bérlési ár ~g~$'..boat.boat.rentalprice, {255, 255, 255, 200}, 0.2)
							--if exports["blckhndr_jobs"]:isWhitelistClockedIn(1) then
							if exports['blckhndr_jobs']:isWhitelistClockedIn(4) then
								Util.DrawText3D(boat.x, boat.y, boat.z+1.78, '~r~[ E ] Profit állítása ~b~||~w~ ~g~[ H ] Változtatás ~b~||~w~ /comm {új%}', {255, 255, 255, 200}, 0.2)
								if IsControlJustPressed(0, 74) then
									-- [H] Change boat
									OpenCreator(key)
								end
								if IsControlJustPressed(0, 38) then
									-- [E] Organise finance
									exports['mythic_notify']:DoCustomHudText('error', 'A cég még nincs elég ideje a nyilvántartásban, hogy ezt megtehesd!', 3000)
								end

							else
								Util.DrawText3D(boat.x, boat.y, boat.z+1.78, '~g~[ E ]~w~ Vásárlás ~b~||~w~ Beszélj egy alkalmazottal, hogy megbeszéljétek az árat!', {255, 255, 255, 200}, 0.2)
								Util.DrawText3D(boat.x, boat.y, boat.z+1.65, '~g~[ G ]~w~ Bérlés', {255, 255, 255, 200}, 0.2)
								if IsControlJustPressed(0, 38) then
									-- [E] Purchase
									if exports["blckhndr_main"]:blckhndr_CanAfford(boat.boat.buyprice+comm) then
										BuyBoat(key)
									else
										exports['mythic_notify']:DoCustomHudText('error', 'Nincs elég pénzed ($'..boat.boat.buyprice+comm..') jelenleg', 3000)
									end
								end
								if IsControlJustPressed(0, 47) then
									-- [G] Test Drive\
									if exports["blckhndr_main"]:blckhndr_CanAfford(boat.boat.rentalprice) then
										RentBoat(key)
									else
										exports['mythic_notify']:DoCustomHudText('error', 'Nincs elég pénzed ($'..boat.boat.buyprice+comm..') jelenleg', 3000)
									end
								end
							end
						end
					end					
				end
			else
				Util.DrawText3D(boat.x, boat.y, boat.z+2, 'hajó nincs beállítva', {255, 255, 255, 200}, 0.2)
			end
		end
	end
end, 0)

TriggerServerEvent('blckhndr_boatshop:floor:Request')
RegisterNetEvent('blckhndr_boatshop:floor:Update')
AddEventHandler('blckhndr_boatshop:floor:Update', function(tbl)
	boat_spots = tbl
end)
RegisterNetEvent('blckhndr_boatshop:floor:Updateboat')
AddEventHandler('blckhndr_boatshop:floor:Updateboat', function(updatedboat, tbl)
	print('blckhndr_boatshop: got update for boat('..updatedboat..')')
	boat_spots[updatedboat]['boat']['color'] = tbl['boat']['color']
	boat_spots[updatedboat]['boat']['model'] = tbl['boat']['model']
	boat_spots[updatedboat]['boat']['name'] = tbl['boat']['name']
	boat_spots[updatedboat]['boat']['commission'] = tbl['boat']['commission']
	boat_spots[updatedboat]['boat']['buyprice'] = tbl['boat']['buyprice']
	boat_spots[updatedboat]['boat']['rentalprice'] = tbl['boat']['rentalprice']
	boat_spots[updatedboat]['updated'] = false
end)

-- command shit
RegisterNetEvent('blckhndr_boatshop:floor:commission')
AddEventHandler('blckhndr_boatshop:floor:commission', function(amt)
	for k,v in pairs(boat_spots) do
		if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1)), true) < 2 then
			TriggerServerEvent('blckhndr_boatshop:floor:commission', k, amt)
		end
	end
end)
RegisterNetEvent('blckhndr_boatshop:floor:color:One')
AddEventHandler('blckhndr_boatshop:floor:color:One', function(col)
	for k,v in pairs(boat_spots) do
		if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1)), true) < 2 then
			TriggerServerEvent('blckhndr_boatshop:floor:color:One', k, col)
		end
	end
end)
RegisterNetEvent('blckhndr_boatshop:floor:color:Two')
AddEventHandler('blckhndr_boatshop:floor:color:Two', function(col)
	for k,v in pairs(boat_spots) do
		if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1)), true) < 2 then
			TriggerServerEvent('blckhndr_boatshop:floor:color:Two', k, col)
		end
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(1335.6577148438, 4270.1655273438, 31.503137588501)
	SetBlipSprite(blip, 455)
	SetBlipColour(blip, 3)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, 0.9)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Los Santos Marina")
	EndTextCommandSetBlipName(blip)
	Citizen.Wait(0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
			local playerPed = GetPlayerPed(-1)
			local playerPos = GetEntityCoords(playerPed)
			local rentedboat

			local playerVehicle = GetVehiclePedIsIn(playerPed, false)

			for k,b in pairs(rented_boats) do
				if GetVehicleNumberPlateText(playerVehicle) == b.plate then
					rentedboat = GetVehiclePedIsIn(playerPed)
					rentalprice = b.rentalprice
				end
			end

			local boatrentalReturn = vector3(1350.4514160156, 4228.8076171875, 30.129796981812)

			if Util.GetVecDist(playerPos, boatrentalReturn.xyz) < 10 then
				if IsPedInAnyVehicle(playerPed, true) then
					if rentedboat ~= nil then
						Util.DrawText3D(boatrentalReturn.x, boatrentalReturn.y, boatrentalReturn.z+0.5, 'Nyomj ~g~[ E ]~w~ gombot, hogy leadd a jármüvet.', {255, 255, 255, 200}, 0.2)
						if IsControlJustPressed(0, Util.GetKeyNumber("E"), IsDisabledControlJustPressed(0, Util.GetKeyNumber("E"))) then
							local maxPassengers = GetVehicleMaxNumberOfPassengers(rentedboat)
							for seat = -1,maxPassengers-1,1 do
								local ped = GetPedInVehicleSeat(rentedboat, seat)
								if ped and ped ~= 0 then TaskLeaveVehicle(ped, rentedboat,16); end
							end
							table.remove(rented_boats,#rented_boats,rentedboat)
							SetEntityAsMissionEntity( rentedboat, false, true )
							DeleteVehicle( rentedboat )
							exports['mythic_notify']:DoCustomHudText('success', 'A hajó sikeresen leadva')
							TriggerEvent('blckhndr_bank:change:walletAdd', rentalprice*0.5)
							SetPedCoordsKeepVehicle(playerPed, 1340.1700439453, 4225.2241210938, 33.915546417236)
							if DoesEntityExist(rentedboat) then SetVehicleUndriveable(rentedboat, true); end
					end
				end
			end
		end
	end
end)