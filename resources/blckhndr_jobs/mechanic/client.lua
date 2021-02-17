local clockloc = vector3(110.52220916748, 6627.5756835938, 31.261184692383)
local carloc = {
  inside = vector4(110.52220916748, 6627.5756835938, 31.261184692383, 255.7982635498),
  out = vector4(118.91361236572, 6619.09375, 31.289211273193, 228.91731262207)
}
local carinfo = {
  inspected = false,
  inspect = vector3(113.09699249268, 6627.0859375, 31.787237167358),
  repair = {
    [1] = vector3(113.09699249268, 6627.0859375, 31.787237167358),
    [2] = vector3(548.60986328125, -176.71714782715, 54.481338500977),
    [3] = vector3(546.12677001953, -178.63162231445, 54.481338500977)
  }
}
local ismech = false
local carinloc = false
local repspot = -1

--[[ Not needed since it checks if you are whitelisted by clocking in on the phone
RegisterNetEvent('blckhndr_jobs:mechanic:toggleduty')
AddEventHandler('blckhndr_jobs:mechanic:toggleduty', function()
  if ismech then
    ismech = false
    TriggerEvent('blckhndr_notify:displayNotification', 'You are no longer a mechanic.', 'centerLeft', 4000, 'error')
    blckhndr_SetJob('Unemployed')
  else
    ismech = true
    TriggerEvent('blckhndr_notify:displayNotification', 'You have signed on duty! Await customers.', 'centerLeft', 4000, 'success')
     blckhndr_SetJob('Mechanic')
  end
end)
]]--

function InspectVehicle()
  if carinloc then
    TriggerEvent('chatMessage', '', {255,255,255}, '^*^3ÉLET |^r^0 MOTOR: '..math.floor(GetVehicleEngineHealth(carinloc))..'/1000')
    TriggerEvent('chatMessage', '', {255,255,255}, '^*^3ÉLET |^r^0 KAROSSZÉRIA: '..math.floor(GetVehicleBodyHealth(carinloc))..'/1000')
    TriggerEvent('chatMessage', '', {255,255,255}, '^*^3ÉLET |^r^0 Tank: '..math.floor(GetVehiclePetrolTankHealth(carinloc))..'/1000')
    carinfo.inspected = true
    repspot = 1
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'Nincs jármü érzékelve!<br>Próbáld meg ujra berakni a garázsba', 'centerLeft', 3000, 'error')
  end
end

function RepairVehicle()
  if carinloc and not carinfo.repaired then
    TriggerEvent('blckhndr_fuel:update', carinloc, 100.0)
		SetVehicleEngineHealth(carinloc, 1000)
		SetVehicleFixed(carinloc)
    SetVehicleDirtLevel(carinloc, 0)
    exports['mythic_notify']:DoCustomHudText('success', 'Megjavítottad a jármüvet', 5000)
    carinfo.repaired = true
    carinfo.inspected = false
    carinloc = false
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'Nincs jármü érzékelve!<br>Próbáld meg ujra berakni a garázsba', 'centerLeft', 3000, 'error')
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    if isMech() then
      if carinloc then
        if not carinfo.inspected and Util.GetVecDist(playerPos, carinfo.inspect) < 3 then
          --DrawMarker(1,carinfo.inspect.x, carinfo.inspect.y, carinfo.inspect.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
          if Util.GetVecDist(playerPos, carinfo.inspect) < 2 then
            --SetTextComponentFormat("STRING")
            --AddTextComponentString("Nyomj ~INPUT_PICKUP~ to inspect the vehicle")
            --DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            Util.DrawText3D(carinfo.inspect.x, carinfo.inspect.y, carinfo.inspect.z, 'Nyomj ~g~[ E ] ~s~-t, hogy megvizsgáld a jármüvet', false)
            if IsControlJustPressed(0, 51) then
              SetVehicleDoorOpen(carinloc, 4, false, false)
              
              RequestAnimDict("mini@repair")
              while not HasAnimDictLoaded("mini@repair") do
                Citizen.Wait(0)
              end
            
              TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
              TriggerEvent('blckhndr_notify:displayNotification', 'Vizsgálás...', 'centerLeft', 5000, 'info')
              Citizen.Wait(5000)
              ClearPedTasksImmediately(playerPed)
              InspectVehicle()
            end
          end
        else
          if repspot > 0 then
            local reep = carinfo.repair[repspot]
            if not carinfo.repaired then
              if Util.GetVecDist(playerPos, reep) < 3 then
                --DrawMarker(1,reep.x, reep.y, reep.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
                Util.DrawText3D(reep.x, reep.y, reep.z, 'Nyomj ~p~[ E ] ~s~ -t hogy megjavítsd a jármüvet')
                if IsControlJustPressed(0, Util.GetKeyNumber("E")) then

                  RequestAnimDict("mini@repair")
                  while not HasAnimDictLoaded("mini@repair") do
                      Citizen.Wait(0)
                  end

                  TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                  TriggerEvent('blckhndr_notify:displayNotification', 'Javítás...', 'centerLeft', 5000, 'info')
                  Citizen.Wait(5000)
                  ClearPedTasksImmediately(playerPed)  
                  RepairVehicle()
                end
              end
            end
          end
        end
      end
      if Util.GetVecDist(playerPos, carloc.xyz) < 6 then
        --DrawMarker(1,carloc.out.x, carloc.out.y, carloc.out.z-1,0,0,0,0,0,0,4.001,4.0001,0.4001,0,155,255,175,0,0,0,0)
        if Util.GetVecDist(playerPos, carloc.out) < 5 then
          if IsPedInAnyVehicle(playerPed) then
            --SetTextComponentFormat("STRING")
            --AddTextComponentString("Nyomj ~INPUT_VEH_HEADLIGHT~ to put the car in the garage")
            Util.DrawText3D(carloc.out.x, carloc.out.y, carloc.out.z, 'Nyomj ~b~[ H ] ~s~-t, hogy berakd a jármüvet a garázsba', false)
            --DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(0, 74) then
              carinloc = GetVehiclePedIsUsing(playerPed)
              if carinloc then
                TaskLeaveVehicle(playerPed, carinloc, 16)
                SetVehicleDoorsShut(carinloc, false)
                Citizen.Wait(850)
                SetEntityCollision(carinloc, true, true)
                SetEntityHeading(carinloc, carloc.inside.w)
                SetEntityCoords(carinloc, carloc.inside.x, carloc.inside.y, carloc.inside.z, false, false, false, false)
                FreezeEntityPosition(carinloc, true)
                carinfo.repaired = false
              else
                TriggerEvent('blckhndr_notify:displayNotification', 'Nincs jármü érzékelve!', 'centerLeft', 3000, 'error')
              end
            end
          else
            if carinloc then
              --SetTextComponentFormat("STRING")
              --AddTextComponentString("Nyomj ~INPUT_PICKUP~ to retrieve the vehicle")
              --DisplayHelpTextFromStringLabel(0, 0, 1, -1)
              Util.DrawText3D(carloc.out.x, carloc.out.y, carloc.out.z, 'Nyomj ~y~[ E ] ~s~ -t, hogy kivedd a jármüvet', false)
              if IsControlJustPressed(0, 51) then
                SetVehicleDoorsShut(carinloc, false)
                SetEntityCoords(carinloc, carloc.out.x, carloc.out.y, carloc.out.z, false, false, false, false)
                SetEntityHeading(carinloc, carloc.out.w)
                SetEntityCollision(carinloc, true, true)
                FreezeEntityPosition(carinloc, false)
                carinfo.inspected = false
                carinloc = false
              end
            end
          end
        end
      end
    end
    --[[if isMech() then
    --if GetDistanceBetweenCoords(clockloc.x, clockloc.y, clockloc.z, GetEntityCoords(PlayerPedId()), true) < 10 then
      --DrawMarker(1,clockloc.x, clockloc.y, clockloc.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
      --if GetDistanceBetweenCoords(clockloc.x, clockloc.y, clockloc.z, GetEntityCoords(PlayerPedId()), true) < 1 then
      if Util.GetVecDist(playerPos, clockloc.xyz) < 3 then
        if isMech() then
            --SetTextComponentFormat("STRING")
            --AddTextComponentString("Nyomj ~INPUT_PICKUP~ to ~r~quit")
            --DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            Util.DrawText3D(clockloc.x, clockloc.y, clockloc.z, 'Nyomj ~r~[ E ] ~s~ to quit', false)
            if IsControlJustPressed(0, 51) then
              TriggerServerEvent('blckhndr_jobs:mechanic:toggle')
            end
          else
            --SetTextComponentFormat("STRING")
           -- AddTextComponentString("Nyomj ~INPUT_PICKUP~ to become a ~g~mechanic")
            --DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            Util.DrawText3D(clockloc.x, clockloc.y, clockloc.z, 'Nyomj ~g~[ E ] ~s~ to go on duty', false)
            if IsControlJustPressed(0, 51) then
              TriggerServerEvent('blckhndr_jobs:mechanic:toggle')
            end
          end
        end
      else
        --exports['mythic_notify']:DoCustomHudText('error', 'You need to be whitelisted for this job!', 5000)
      end]]
  end
end)

function isMech()
  if isWhitelistClockedIn(2) then
    return true
  else
    return false
  end
end

--[[
function MechLevel()
  if isMech() and 
]]

-- Volagn Mechanic Decor inspect/repair. Commented out for now.
--[[  vehicleDecors = {
    ["Fuel Level"] = {damage = 'fuelLevel', name ="FuelLevel"},
    ["Electronics"] = {damage = 'vehDMG:electronics', name ="Electronics"},
    ["Clutch"] = {damage = 'vehDMG:clutch', name ="Clutch"},
    ["Gearbox"] = {damage = 'vehDMG:gearbox', name ="Gearbox"},
    ["Brakes"] = {damage = 'vehDMG:brakes', name ="Brakes"},
    ["Transmission"] = {damage = 'vehDMG:transmission', name ="Transmission"},
    ["Axle"] = {damage = 'vehDMG:axle', name ="Axle"},
    ["Fuel Injectors"] = {damage = 'vehDMG:fuel_injectors', name ="FuelInjectors"},
    ["Fuel Tank"] = {damage = 'vehDMG:fuel_tank', name ="FuelTank"},
    ["Tire Depth"] = {damage = 'vehDMG:tyre_depth', name ="TireDepth"}
  }


 
 -- Inspection and Repair for Mechanics Chat Commands \\ Debug
RegisterCommand('vehinspect', function(source, args)
  if ismech == true then
   if IsPedInAnyVehicle(PlayerPedId(), false) then
      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
      for item_name in pairs(vehicleDecors) do
      local decorInt = DecorGetInt(GetVehiclePedIsIn(PlayerPedId(), false), vehicleDecors[item_name].damage)
      TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, item_name..' is '..decorInt.."%")
      end
    end
  end
end, false)
 
RegisterCommand('vehrepair', function(source, args)
  if ismech == true then
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local decorArgs = args[1]
    for item_name in pairs(vehicleDecors) do
  if args[1] == vehicleDecors[item_name].name then decorArgs = vehicleDecors[item_name].damage
     mechanicRepair(decorArgs)
    end
  end
  end
end, false)

function mechanicRepair(part)
  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed, 1)
  local coordA = GetEntityCoords(PlayerPedId(), 1)
  local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
  local vehiclePos = getVehicleInDirection(coordA, coordB)
    if vehiclePos ~= nil then
      if DoesEntityExist(vehiclePos) and IsEntityAVehicle(vehiclePos) then
        if GetDistanceBetweenCoords(coordB, playerPos, 1) <= 4 then
  
          local currentValue = DecorGetInt(vehiclePos, part)
  
          if part == "vehDMG:electronics" and currentValue ~= 100 then
            print("Repairing Electronics")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 9 Electronics and 7 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:clutch" and currentValue ~= 100 then
            print("Repairing Clutch")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:gearbox" and currentValue ~= 100 then
            print("Repairing Gearbox")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:brakes" and currentValue ~= 100 then
            print("Repairing Brakes")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:transmission" and currentValue ~= 100 then
            print("Repairing Transmission")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:axle" and currentValue ~= 100 then
            print("Repairing Axle")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:fuel_injectors" and currentValue ~= 100 then
            print("Repairing Fuel Injectors")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:fuel_tank" and currentValue ~= 100 then
            print("Repairing Fuel Tank")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          elseif part == "vehDMG:tyre_depth" and currentValue ~= 100 then
            print("Repairing 'Tyre Depth'")
            TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Taken 6 Metal and 4 Plastic; blablablaa")
            -- Take items from inventory
          end
    if currentValue >= 100 then  -- if DecorInt is 100 or greater do nothing. Sets Int to 100 just incase of exploit.
      TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, part.." is/are already fully repaired.")
      DecorSetInt(vehiclePos, part, 100)
      -- No progress bar
    elseif currentValue >= 88 then  -- else if DecorInt is 88 or higher automatically repair to 100%.
      TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, part.." repaired from "..currentValue.."% to 100%")
      DecorSetInt(vehiclePos, part, 100)
      -- Add progress bar
    else -- else add +12 int to the current value of the part.
    DecorSetInt(vehiclePos, part, currentValue + 12)
    TriggerEvent('chatMessage', '^1DEBUG', {255, 255, 255}, "Repairing "..part) -- DEBUG \\ Remove me later
    -- Add progress bar
          end
        end
      end
    end
  end
  
  function getVehicleInDirection(coordFrom, coordTo)
      local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
      local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
      return vehicle
  end --]]

  local Blips = {
    
    Mechanic = {
		  Zone = 'Mechanic',
		  Sprite = 446,
		  Scale = 0.8,
		  Display = 4,
		  Color = 4,
      Pos = {x = 110.52220916748, y = 6627.5756835938, z = 31.261184692383},
    },
    
}

function AddBlips()
	for key, val in pairs(Blips) do
    local blip = AddBlipForCoord(val.Pos.x, val.Pos.y, val.Pos.z)
    SetBlipHighDetail           (blip, true)
    SetBlipSprite               (blip, val.Sprite)
    SetBlipDisplay              (blip, val.Display)
    SetBlipScale                (blip, val.Scale)
    SetBlipColour               (blip, val.Color)
    SetBlipAsShortRange         (blip, true)
    BeginTextCommandSetBlipName ("STRING")
    AddTextComponentString      (val.Zone)
    EndTextCommandSetBlipName   (blip)
	end
end

function resourceStart(resource)
	if (resource == GetCurrentResourceName()) then
		Citizen.Trace("mechanic: Initialized script (1.0.0)\n");
		AddBlips();
	end
end
AddEventHandler("onClientResourceStart", resourceStart);