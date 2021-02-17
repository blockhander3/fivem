onduty_ems = {}
local bandw = false
local pulsing = false
RegisterNetEvent('blckhndr_ems:update')
AddEventHandler('blckhndr_ems:update', function(ems)
  onduty_ems = ems
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsEntityDead(GetPlayerPed(-1)) then
      SetEntityHealth(GetPlayerPed(-1), 150)
      TriggerEvent('blckhndr_ems:killMe')
    end
  end
end)

currenttime = 0
local deathtime = currenttime
local amidead = false
local canRespawn = false

function blckhndr_IsDead()
  return amidead
end
--blckhndr_ems:reviveMe:force
RegisterNetEvent('blckhndr_ems:reviveMe:force')
AddEventHandler('blckhndr_ems:reviveMe:force', function()
  amidead = false
  deathtime = 0
  NetworkResurrectLocalPlayer(GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, 0, false, false)
  TriggerEvent('blckhndr_inventory:use:drink', 100)
  TriggerEvent('blckhndr_inventory:use:food', 100)
  TriggerEvent('blckhndr_needs:stress:remove', 100)
  ClearTimecycleModifier()
  SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
end)

RegisterNetEvent('blckhndr_ems:reviveMe')
AddEventHandler('blckhndr_ems:reviveMe', function()
  amidead = false
  pulsing = false
  deathtime = 0
  NetworkResurrectLocalPlayer(GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, 0, false, false)
  TriggerEvent('blckhndr_inventory:use:drink', 100)
  TriggerEvent('blckhndr_inventory:use:food', 100)
  TriggerEvent('blckhndr_needs:stress:remove', 100)
  ClearTimecycleModifier()
  SetEntityHealth(GetPlayerPed(-1), 105)
  if inbed then
    SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
	SetEntityCoords(GetPlayerPed(-1), beds[mybed].bed.x, beds[mybed].bed.y, beds[mybed].bed.z)
	SetEntityHeading(GetPlayerPed(-1), beds[mybed].bed.h)
	ExecuteCommand("e sleep")
  end
end)


DecorRegister("deadPly")
RegisterNetEvent('blckhndr_ems:killMe')
AddEventHandler('blckhndr_ems:killMe', function()
  if not amidead then
	DecorSetBool(GetPlayerPed(-1), "deadPly", true)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
  		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      TaskLeaveVehicle(GetPlayerPed(-1), veh, 4160)
    end
    if exports.blckhndr_police:blckhndr_PDDuty() then
      local pos = GetEntityCoords(GetPlayerPed(-1))
      local coords = {
        x = pos.x,
        y = pos.y,
        z = pos.z
      }
      TriggerServerEvent('blckhndr_police:dispatch', coords, 4)
    end
    TriggerServerEvent('blckhndr_police:CAD:10-43', x, y, z)
    TriggerServerEvent('blckhndr_ems:CAD:10-43', x, y, z)
    amidead = true
    deathtime = currenttime
	SetTimecycleModifier("dying")
	SetTimecycleModifierStrength(1.0)
	bandw = false
	pulsing = true
  else
	DecorSetBool(GetPlayerPed(-1), "deadPly", false)
  end
end)

-- thread to check if im dead
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if amidead then
      SetPedToRagdoll(GetPlayerPed(-1), 1, 1000, 0, 0, 0, 0)
      local def = deathtime + 300
      if def > currenttime then
       -- (text,font,centre,x,y,scale,r,g,b,a)
        drawTxt('Várj '..tostring(def - currenttime)..' másodperc hogy ujraéledhess ~b~||~w~ Várd meg a mentöket',4,1,0.5,0.90,0.6,255,255,255,255)
        drawTxt('~r~NE HASZNÁLJ SEMMILYEN JÁTÉKMECHANIKÁT',4,1,0.5,0.20,0.6,255,255,255,255)
      else
        if #onduty_ems > 0 then
          drawTxt('Használd a /airlift parancsot, hogy ujraéledj ($5000)',4,1,0.5,0.90,0.6,255,255,255,255)
          canRespawn = true
        else
          drawTxt('Használd a /airlift parancsot, hogy ujraéledj (~b~FREE~w~)',4,1,0.5,0.90,0.6,255,255,255,255)
          canRespawn = true
        end
        drawTxt('~r~NE ÉLEDJ UJRA EGY RP SZITUÁCIÓ KÖZBEN',4,1,0.5,0.20,0.6,255,255,255,255)
      end
    end
  end
end)

-- thread to check if im dead
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    currenttime = currenttime + 1
  end
end)

function blckhndr_Airlift()
  if amidead and canRespawn == true then
    canRespawn = false
    DoScreenFadeOut(200)
    TriggerEvent('blckhndr_bank:change:bankandwallet', 0, false)
    TriggerEvent('blckhndr_inventory:items:emptyinv')
		
    local hospital = {
      {x = 1835.6804199219, y = 3679.6550292969, z = 34.270065307617}
      
    }
    hospital = hospital[math.random(1, #hospital)]
    amidead = false
    deathtime = 0
    NetworkResurrectLocalPlayer(hospital.x, hospital.y, hospital.z, 0, false, false)
    TriggerEvent('blckhndr_inventory:use:drink', 100)
    TriggerEvent('blckhndr_inventory:use:food', 100)
    TriggerEvent('blckhndr_needs:stress:remove', 100)
    TriggerEvent('mythic_hospital:client:ResetLimbs') -- reset limbs/limp
    TriggerEvent('mythic_hospital:client:RemoveBleed') -- remove bleed
    Citizen.Wait(2000)
    DoScreenFadeIn(1500)
    ClearPedBloodDamage(GetPlayerPed(-1))
    if #onduty_ems > 0 then
      TriggerEvent('blckhndr_bank:change:bankMinus', 5000)
      TriggerEvent("pNotify:SendNotification", {text = "5000$ volt a kezelésed ára.",
        layout = "centerRight",
        timeout = 5000,
        progressBar = true,
        type = "info",
      })
    else
      TriggerEvent("pNotify:SendNotification", {text = "Az állam fizette a kezelésedet.",
        layout = "centerRight",
        timeout = 5000,
        progressBar = true,
        type = "info",
      })
    end
  end
end

------------------------------------------------- EMS system
amiems = true
emsonduty = false ----------------- REMEMBER TO CHANGE THESE
emslevel = 0

RegisterNetEvent('blckhndr_ems:911r')
AddEventHandler('blckhndr_ems:911r', function(nineoneone, at, msg)
  if emsonduty then
    TriggerEvent('chatMessage', '', {255,255,255}, '^*^1 911R #'..nineoneone..' ('..at..') | ^0^r'..msg)
  end
end)

RegisterNetEvent('blckhndr_ems:911')
AddEventHandler('blckhndr_ems:911', function(nineoneone, at, msg)
  if emsonduty then
    TriggerEvent('chatMessage', '', {255,255,255}, '^*^1 911 #'..nineoneone..' ('..at..') | ^0^r'..msg)
  end
end)

function blckhndr_EMSDuty()
  return emsonduty
end

function blckhndr_getEMSLevel()
  return emslevel
end
AddEventHandler('blckhndr_main:character', function(char)
  TriggerServerEvent('blckhndr_ems:requestUpdate')
  if char.char_ems > 0 then
    amiems = true
    emslevel = char.char_ems
  else
    amiems = true
    emslevel = 3
  end
end)

RegisterNetEvent('blckhndr_ems:updateLevel')
AddEventHandler('blckhndr_ems:updateLevel', function(emslvl)
  TriggerServerEvent('blckhndr_ems:requestUpdate')
  if emslvl > 0 then
    TriggerEvent('blckhndr_notify:displayNotification', 'Your <span>EMS</span> whitelist has been updated to: '..emslvl, 'centerLeft', 6000, 'info')
    amiems = true
    emslevel = emslvl
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'Your <span style="color:#72a8ff;font-weight:bold">EMS</span> whitelist has been removed.', 'centerLeft', 6000, 'error')
    amiems = false
    emslevel = 0
  end
end)
local clockInStations = {
{x = 1839.0538330078, y = 3690.207519312, z = 34.27004219434},
{x = 310.27493286133, y = -599.16485595703, z = 43.291816711426}
}
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    for k, hosp in pairs(clockInStations) do
      if GetDistanceBetweenCoords(hosp.x,hosp.y,hosp.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 and amiems then
        DrawMarker(1,hosp.x,hosp.y,hosp.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
        if GetDistanceBetweenCoords(hosp.x,hosp.y,hosp.z,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
          if emsonduty then
            SetTextComponentFormat("STRING")
          	AddTextComponentString("Nyomj ~INPUT_PICKUP~ gombot hogy ~r~leadd~w~ a szolgálatot: ~p~EMS")
          	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          else
            SetTextComponentFormat("STRING")
          	AddTextComponentString("Nyomj ~INPUT_PICKUP~ gombot hogy ~r~felvedd~w~ a szolgálatot: ~p~EMS")
          	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          end
          if IsControlJustPressed(0,38) then
            if emsonduty then
              emsonduty = false
              TriggerEvent('blckhndr_notify:displayNotification', 'Köszönjük a szolgálatot!', 'centerLeft', 2000, 'info')
              TriggerServerEvent('blckhndr_ems:offDuty')
              exports.blckhndr_jobs:blckhndr_SetJob('Unemployed')
            else
              emsonduty = true
              TriggerEvent('blckhndr_notify:displayNotification', 'Szolgálatba léptél: <span style="color: #f45942">EMS</span> (lvl: '..emslevel..')', 'centerLeft', 6000, 'info')
              TriggerServerEvent('blckhndr_ems:onDuty', emslevel)
              exports.blckhndr_jobs:blckhndr_SetJob('EMS')
            end
          end
        end
      end
    end
  end
end)

local dispatch_calls = {}
local disp_id = 0
local last_disp = 0
RegisterNetEvent('blckhndr_jobs:ems:request')
AddEventHandler('blckhndr_jobs:ems:request', function(tbl)
  if exports.blckhndr_police:blckhndr_PDDuty() then
    if #onduty_ems < 2 then
      TriggerEvent('blckhndr_police:dispatchcall', tbl, 9)
    end
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local sname = GetStreetNameFromHashKey(var1)
    TriggerEvent('chatMessage', '', {255,255,255}, '^1^*:DISPATCH:^0^r (10-47) EMS szükséges @ ^4'..sname)
  end
  if emsonduty then
    local x = tbl.x
    local y = tbl.y
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local sname = GetStreetNameFromHashKey(var1)
    TriggerEvent('chatMessage', '', {255,255,255}, '^1^*:DISPATCH:^0^r (10-47) EMS szükséges @ ^4'..sname)
    disp_id = #dispatch_calls+1
    last_disp = currenttime
    table.insert(dispatch_calls, disp_id, {
      type = 'ems call',
      cx = x,
      cy = y
    })
    SetNotificationTextEntry("STRING");
    AddTextComponentString('Location: ~y~'..sname);
    SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 1, "DISPATCH", "");
    DrawNotification(false, true);
	TriggerEvent("blckhndr_main:blip:add", "ems", "ALERT: EMS szükség", 310, x, y, z)
  end
end)
Citizen.CreateThread(function()
   while true do
     Citizen.Wait(0)
     if disp_id ~= 0 then
       if last_disp + 10 > currenttime then
         SetTextComponentFormat("STRING")
         AddTextComponentString("Nyomj ~INPUT_MP_TEXT_CHAT_TEAM~ gombot hogy ~g~elfogadd~w~ a hivást\nNyomj ~INPUT_PUSH_TO_TALK~ gombot hogy ~r~elutasítsd~w~ a hívást")
         DisplayHelpTextFromStringLabel(0, 0, 1, -1)
         if IsControlJustPressed(0, 246) then
           SetNewWaypoint(dispatch_calls[disp_id].cx, dispatch_calls[disp_id].cy)
           last_disp = 0
         end
         if IsControlJustPressed(0, 249) then
           last_disp = 0
         end
       end
     end
   end
end)

local hospitals = {
  {
    name = 'Crusade Road Emergency Unit',
    x = 295.42825317383,
    y = -1446.8900146484,
    z = 29.966619491577
  }
}
local healing = false
local healstart = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    for k, hosp in pairs(hospitals) do
      if GetDistanceBetweenCoords(hosp.x,hosp.y,hosp.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 and not healing then
        DrawMarker(1,hosp.x,hosp.y,hosp.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
        if GetDistanceBetweenCoords(hosp.x,hosp.y,hosp.z,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
          SetTextComponentFormat("STRING")
		  if #onduty_ems > 0 then
          AddTextComponentString("Nyomj ~INPUT_PICKUP~ gombot hogy láthasson egy orvos (FREE)")
		  else
        	AddTextComponentString("Nyomj ~INPUT_PICKUP~ gombot hogy láthasson egy orvos ($5000)")		  
		  end
        	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if IsControlJustPressed(0,38) then
			  if #onduty_ems > 0 then
				TriggerEvent('blckhndr_notify:displayNotification', 'Nincs mentős, ezért az állam fizette az ellátasodat.', 'centerLeft', 6000, 'info')
				TriggerEvent('blckhndr_ems:reviveMe')
			  else
				TriggerEvent('blckhndr_notify:displayNotification', 'Van mentős, ezért az ellátásod ára: $5000', 'centerLeft', 6000, 'info')  
				TriggerEvent('blckhndr_ems:reviveMe')
				TriggerEvent('blckhndr_bank:change:bankMinus', 5000)
			  end
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	if pulsing then
		DoScreenFadeOut(1000)
		Citizen.Wait(1500)
		DoScreenFadeIn(1000)
		Citizen.Wait(20000)
	end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	if GetEntityHealth(GetPlayerPed(-1)) < 130 then
		if not bandw then
			SetTimecycleModifier("dying")
			SetTimecycleModifierStrength(1.0)
			bandw = true
		end
	else
		if not amidead then
			ClearTimecycleModifier()
			bandw = false
			pulsing = false
		end
	end
  end
end)
