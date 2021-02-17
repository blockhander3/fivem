MDTOpen = false
local MDTStations = {
  {x = 1858.7567138672, y = 3695.0185546875, z = 34.256118774414, h = 13.955870628357},
  {x = 1857.2969970703, y = 3697.7097167969, z = 34.255176544189, h = 226.57662963867},
  {x = 1847.3520507812, y = 3681.0339355469, z = 34.261905670166, h = 346.95205688477},
  {x = -449.99069213867, y = 6020.8676757812, z = 31.716524124146, h = 46.598510742188},
  {x = -438.64263916016, y = 6008.3408203125, z = 31.716529846191, h = 249.32955932617},
  {x = -438.77380371094, y = 6011.5024414062, z = 31.716524124146, h = 301.58599853516},
  {x = -440.83874511719, y = 6010.6552734375, z = 31.716417312622, h = 51.319580078125}
  --{x = 469.33813476563, y = -998.39770507813, z = 24.914745330811},
  --{x = -439.95318603516, y = 6005.4809570313, z = 31.928653717041},
  --{x = 237.5924987793, y = -418.02108764648, z = -118.19964599609}
}

RegisterNetEvent('blckhndr_police:MDT:toggle')
AddEventHandler('blckhndr_police:MDT:toggle', function()
  if MDTOpen then
    SendNUIMessage({
			displayMDT = false
		})
    MDTOpen = false
    SetNuiFocus(false)
  else
    SendNUIMessage({
      displayMDT = true
    })
    MDTOpen = true
    SetNuiFocus(true,true)
  end
end)

RegisterNetEvent('blckhndr_police:database:CPIC:search:result')
AddEventHandler('blckhndr_police:database:CPIC:search:result', function(data)
  if MDTOpen then

  else
    if #data > 0 then
      for k, v in pairs(data) do
        TriggerEvent('chatMessage', '', {255,255,255}, '^*^3CPIC ('..v.receiver_id..') | ^2JAILED: ^r^0'..v.ticket_jailtime..' ^*^2| TICKET:^r^0 $'..v.ticket_amount..' ^*^2| CHARGES:^r^0 '..v.ticket_charges..' ^*^2| OFFICER:^r^0 '..v.officer_name..' ^*^2| DATE:^r^0 '..v.ticket_date)
      end
    else
      TriggerEvent('chatMessage', '', {255,255,255}, '^*^3CPIC | ^r^2No criminal record found.')
    end
  end
end)

RegisterNUICallback("booking-submit-now", function(data, cb)
  TriggerEvent('blckhndr_police:MDT:toggle')
  TriggerServerEvent('blckhndr_police:database:CPIC', data)
  TriggerServerEvent('blckhndr_police:chat:ticket', data.suspectID, data.jailFine, data.jailTime, data.charges)
  -- TICKET
  if tonumber(data.jailFine) > 0 then
    TriggerServerEvent('blckhndr_police:ticket', tonumber(data.suspectID), tonumber(data.jailFine))
  end
  -- JAIL TIME
  if tonumber(data.jailTime) > 0 then
    if tonumber(data.jailTime) <= 100 then
      local jailtime = tonumber(data.jailTime)*60
      TriggerServerEvent('blckhndr_jail:sendsuspect', GetPlayerServerId(PlayerId()), data.suspectID, jailtime)
    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You cannot jail someone for more than 100 minutes - speak to a judge.', 'centerLeft', 5000, 'error')
    end
  end
end)

RegisterNUICallback("booking-submit-warrant", function(data, cb)
  TriggerEvent('blckhndr_police:MDT:toggle')
  --TriggerEvent('chatMessage', '', {255,255,255}, '^6MDT |^0 Warrant submitted. Reference ID: '..)
  TriggerServerEvent('blckhndr_police:MDT:warrant', data)
end)

RegisterNUICallback('mdt-remove-warrant', function(data, cb)
  TriggerServerEvent('blckhndr_police:MDTremovewarrant', data.id)
end)

RegisterNUICallback('mdt-remove-applys', function(data, cb)
  TriggerServerEvent('blckhndr_police:MDTremoveapply', data.id)
end)

RegisterNUICallback('mdt-request-warrants', function(data, cb)
  if data.name ~= '' then
    TriggerServerEvent('blckhndr_police:MDT:requestwarrants', data.name)
  else
    TriggerServerEvent('blckhndr_police:MDT:requestwarrants', false)
  end
end)

RegisterNUICallback('mdt-request-applys', function(data, cb)
  if data.name ~= '' then
    TriggerServerEvent('blckhndr_police:MDT:requestapplys', data.name)
  else
    TriggerServerEvent('blckhndr_police:MDT:requestapplys', false)
  end
end)
RegisterNetEvent('blckhndr_police:MDT:receivewarrants')
AddEventHandler('blckhndr_police:MDT:receivewarrants', function(warrants)
  SendNUIMessage({
    displayMDT = true,
    updateWarrants = true,
    warrants = warrants
  })
end)

RegisterNetEvent('blckhndr_police:MDT:receiveapplys')
AddEventHandler('blckhndr_police:MDT:receiveapplys', function(applys)
  print(warrants)
  SendNUIMessage({
    displayMDT = true,
    updateapplys = true,
    applys = applys
  })
end)

RegisterNUICallback("closeMDT", function(data, cb)
	TriggerEvent('blckhndr_police:MDT:toggle')
	TriggerEvent('blckhndr_emotecontrol:police:tablet', source, "close")
end)

RegisterNUICallback("setWaypoint", function(data, cb)
  SetNewWaypoint(data.x, data.y)
  TriggerEvent('blckhndr_notify:displayNotification', '<b>Waypoint added</b><br>Call: <span style="color:#f9aa43">'..data.tencode..'</span><br>Location: <span style="color:#4286f4">'..data.loc, 'centerRight', 8000, 'info')
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
  --  if IsPedInAnyVehicle(GetPlayerPed(-1)) and amicop then
   --   if IsControlJustPressed(0,244) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18 and IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1))) then
   --     TriggerEvent('blckhndr_police:MDT:toggle')
    --    TriggerEvent('blckhndr_commands:me', 'uses the onboard computer...')
  --    end
 --   end
    for k, stn in pairs(MDTStations) do
      if GetDistanceBetweenCoords(stn.x,stn.y,stn.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 and amicop then
        DrawMarker(23,stn.x,stn.y,stn.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,80,0,0,0,0)
        if GetDistanceBetweenCoords(stn.x,stn.y,stn.z,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
          SetTextComponentFormat("STRING")
          AddTextComponentString(" ~INPUT_INTERACTION_MENU~ gomb - ~p~MDT")
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if IsControlJustPressed(0,244) then
            SetEntityCoords(GetPlayerPed(-1), stn.x,stn.y,stn.z-1)
            SetEntityHeading(GetPlayerPed(-1),stn.h)
            TriggerEvent('blckhndr_police:MDT:toggle')
          end
        end
      end
    end
  end
end)
