seatbelt = false
cruise = false
notified = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped) then
			if not notified then
				TriggerEvent('blckhndr_notify:displayNotification', 'Nyomd meg a <span style="color:#42f486;font-weight:bold">LSHIFT + S</span> gombot hogy becsatold az öved!', 'centerLeft', 4500, 'info')
				notified = true
			end
			if IsControlPressed(0, 21) then
				if IsControlJustPressed(0, 33) then
					if seatbelt then
						if not exports["blckhndr_police"]:blckhndr_PDDuty() then SetPedConfigFlag(ped, 32, true) end
						TriggerEvent('blckhndr_notify:displayNotification', 'Kicsatoltad az öved!', 'centerLeft', 4500, 'info')
						seatbelt = false
						notified = false
					else
						if not exports["blckhndr_police"]:blckhndr_PDDuty() then SetPedConfigFlag(ped, 32, false) end
						TriggerEvent('blckhndr_notify:displayNotification', 'Becsatoltad az öved!', 'centerLeft', 4500, 'info')
						seatbelt = true
					end
				end
			end
			if IsControlJustPressed(0, 73) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
				if cruise then
					SetEntityMaxSpeed(GetVehiclePedIsUsing(ped, true), 154.6465)
					cruise = false
					TriggerEvent('blckhndr_notify:displayNotification', 'Speed limiter: <span style="color:red;font-weight:bold">KIKAPCSOLVA</span>', 'centerLeft', 2000, 'info')
				else
					if math.floor(GetEntitySpeed(GetVehiclePedIsUsing(ped, true))* 2.236936) >= 30 then
						SetEntityMaxSpeed(GetVehiclePedIsUsing(ped, true), GetEntitySpeed(GetVehiclePedIsUsing(ped, true)))
						cruise = true
						TriggerEvent('blckhndr_notify:displayNotification', 'Speed limiter: <span style="color:green;font-weight:bold">BEKAPCSOLVA</span>', 'centerLeft', 2000, 'info')
					else
						TriggerEvent('blckhndr_notify:displayNotification', 'A speed limiter nem haznalható 30 kph alatt.', 'centerLeft', 2000, 'info')
					end
				end
			end
		else
			if seatbelt then
				seatbelt = false
			end
			if cruise then
				cruise = false
			end
			if notified then
				notified = false
			end
		end
	end
end)
------------------------------------------------------------------------------

local speedBuffer  = {}
local velBuffer    = {}
local wasInCar     = false

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		if car ~= 0 and (wasInCar or IsCar(car)) and not exports["blckhndr_police"]:blckhndr_PDDuty() then
			wasInCar = true
			if seatbelt then DisableControlAction(0, 75) end
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			if speedBuffer[2] ~= nil
			   and not seatbelt
			   and GetEntitySpeedVector(car, true).y > 1.0
			   and speedBuffer[1] > 19.25
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then

				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				PlaySound(-1, "10_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				if IsPointOnRoad(GetEntityCoords(GetPlayerPed(-1)), GetVehiclePedIsIn(GetPlayerPed(-1))) then
					local pos = GetEntityCoords(GetPlayerPed(-1))
					local coords = {
					 x = pos.x,
					 y = pos.y,
					 z = pos.z
				   }
				   TriggerServerEvent('blckhndr_police:dispatch', coords, 17)
				end
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(GetPlayerPed(-1), 1, 1000, 0, 0, 0, 0)
			end
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
		elseif wasInCar then
			wasInCar = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)
