------------------------- me handcuff
local amicuffed = false
DecorRegister("crim_cuff")
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2500)
		if amicuffed then
			if IsPedRunning(GetPlayerPed(-1)) then
				SetPedToRagdoll(GetPlayerPed(-1), 1, 1000, 0, 0, 0, 0)
				Citizen.Wait(math.random(2000,5000))
			end
		end
	end
end)

local escorted = false
local escortedto = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if escorted then
			if IsPedRagdoll(crimPed) then
				DetachEntity(GetPlayerPed(-1), true, false)
				escorted = false
				escortedto = false
			end
			if DecorGetBool(crimPed, "deadPly") then
				DetachEntity(GetPlayerPed(-1), true, false)
				escorted = false
				escortedto = false
			end
		end 
	end
end)

local dragtime = 0
RegisterNetEvent('blckhndr_criminalmisc:toggleDrag')
AddEventHandler('blckhndr_criminalmisc:toggleDrag', function(crim)
  if not escorted then
	local maff = dragtime + 3
	if maff < myTime or dragtime == 0 then
		local myPed = GetPlayerPed(-1)
		local crimPed = GetPlayerPed(GetPlayerFromServerId(crim))
		escortedto = crimPed
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		  TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1)), 16)
		end
		AttachEntityToEntity(myPed, crimPed, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		escorted = true
		dragtime = myTime
	end
  else
	local maff = dragtime + 3
	if dragtime < myTime then
		DetachEntity(GetPlayerPed(-1), true, false)
		escorted = false
		escortedto = false
		dragtime = myTime
	end
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if amicuffed then
			DecorSetBool(GetPlayerPed(-1), "crim_cuff", true)
			DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 250, true)
			DisableControlAction(1, 263, true)
			DisableControlAction(1, 310, true)
			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)
			DisableControlAction(0, 63, false)
			DisableControlAction(0, 64, false)
			DisableControlAction(0, 59, false)
			DisableControlAction(0, 278, false)
			DisableControlAction(0, 279, false)
			DisableControlAction(0, 68, false)
			DisableControlAction(0, 69, false)
			DisableControlAction(0, 75, false)
			DisableControlAction(0, 76, false)
			DisableControlAction(0, 102, false)
			DisableControlAction(0, 81, false)
			DisableControlAction(0, 82, false)
			DisableControlAction(0, 83, false)
			DisableControlAction(0, 84, false)
			DisableControlAction(0, 85, false)
			DisableControlAction(0, 86, false)
			DisableControlAction(0, 106, false)
			DisableControlAction(0, 25, false)
			while not HasAnimDictLoaded('mp_arresting') do
				RequestAnimDict('mp_arresting')
				Citizen.Wait(5)
			end
			if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 3) and not IsPedRagdoll(GetPlayerPed(-1)) then
				TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
			end
		else
			DecorSetBool(GetPlayerPed(-1), "crim_cuff", false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, id in ipairs(GetActivePlayers()) do
			if NetworkIsPlayerActive(id) then
				  local ped = GetPlayerPed(id)
				  if GetDistanceBetweenCoords(GetEntityCoords(ped, false), GetEntityCoords(GetPlayerPed(-1),false), true) < 2 and DecorGetBool(ped, "crim_cuff") then
						if ped ~= GetPlayerPed(-1) then
							blckhndr_drawText3D(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, '~r~Megkötözve, nyomj~g~\n[H] gombot hogy elvágd,\n[E] gombot hogy elvidd,\n[X] gombot, hogy kirabold.')
							if IsControlJustPressed(0, 304) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
								TriggerServerEvent('blckhndr_criminalmisc:handcuffs:requestunCuff', GetPlayerServerId(id))
							end
							if IsControlJustPressed(0, 38) then
								if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"), false) then
									--print('attempting to uncuff '..GetPlayerServerId(id))
									TriggerServerEvent('blckhndr_criminalmisc:handcuffs:toggleEscort', GetPlayerServerId(id)) 
									Citizen.Wait(1000)
								else
									TriggerEvent('blckhndr_notify:displayNotification', 'Nincs késed, hogy el tudd vágni.', 'centerLeft', 4000, 'error')
								end
							end
							if IsControlJustPressed(0, 73) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
								--TriggerServerEvent('blckhndr_criminalmisc:robbing:requesRob', GetPlayerServerId(id)) 
								TriggerEvent('blckhndr_criminalmisc:robbing:startRobbing', id)
							end
						else
							blckhndr_drawText3D(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, '~r~Ziptied')
						end
				  end
			end 
		end
	end
end)

RegisterNetEvent('blckhndr_criminalmisc:handcuffs:startCuffed')
AddEventHandler('blckhndr_criminalmisc:handcuffs:startCuffed', function(srv_id)
	if not amicuffed then
		local crimPed = GetPlayerPed(GetPlayerFromServerId(srv_id))
		SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(crimPed))
		SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(crimPed, 0.0, 0.45, 0.0))
		while not HasAnimDictLoaded('mp_arrest_paired') do
			RequestAnimDict('mp_arrest_paired')
			Citizen.Wait(5)
		end
		TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
		Citizen.Wait(3500)
		amicuffed = true
	else
		--TriggerServerEvent('blckhndr_notify:displayNotification', srv_id, 'Player is already ziptied', 'centerLeft', 4000, 'error')
	end
end)

RegisterNetEvent('blckhndr_criminalmisc:handcuffs:startunCuffed')
AddEventHandler('blckhndr_criminalmisc:handcuffs:startunCuffed', function(srv_id)
	local crimPed = GetPlayerPed(GetPlayerFromServerId(srv_id))
	SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(crimPed))
	SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(crimPed, 0.0, 0.45, 0.0))
	Citizen.Wait(2200)
	escorted = false
	escortedto = false
	amicuffed = false
	Citizen.Wait(500)
	ClearPedTasks(GetPlayerPed(-1))
end)
------------------------- handcuff someone else
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if HasHandcuffs() and not exports["blckhndr_ems"]:blckhndr_IsDead() and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not exports["blckhndr_apartments"]:inInstance() then
			for _, id in ipairs(GetActivePlayers()) do
				if NetworkIsPlayerActive(id) then
				  local ped = GetPlayerPed(id)
				  if not IsPedInAnyVehicle(ped) and GetDistanceBetweenCoords(GetEntityCoords(ped, false), GetEntityCoords(GetPlayerPed(-1),false), true) < 2 and ped ~= GetPlayerPed(-1) then
					if DecorGetBool(GetPlayerPed(id), "crim_cuff") == false then
					  showLoadingPrompt("[SHIFT + Y] ziptie "..GetPlayerServerId(id), 6000, 3)
					end
					if IsControlPressed(0,21) then
					  if IsControlJustPressed(0, 246) then
						TriggerServerEvent('blckhndr_criminalmisc:handcuffs:requestCuff', GetPlayerServerId(id))
						Citizen.Wait(1000)
					  end
					end
				  end
				end
			end
		end
	end
end)

RegisterNetEvent('blckhndr_criminalmisc:handcuffs:startCuffing')
AddEventHandler('blckhndr_criminalmisc:handcuffs:startCuffing', function()
	while not HasAnimDictLoaded('mp_arrest_paired') do
		RequestAnimDict('mp_arrest_paired')
		Citizen.Wait(5)
	end
	TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(2500)	
end)

RegisterNetEvent('blckhndr_criminalmisc:handcuffs:startunCuffing')
AddEventHandler('blckhndr_criminalmisc:handcuffs:startunCuffing', function()
	while not HasAnimDictLoaded('mp_arresting') do
		RequestAnimDict('mp_arresting')
		Citizen.Wait(5)
	end
	TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "a_uncuff", 8.0, -8, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(2500)	
end)
