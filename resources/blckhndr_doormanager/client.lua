local policeDoors = {}
local propertyDoors = {}
local amipolice = true
function blckhndr_drawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.2, 0.2)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('blckhndr_doormanager:doorLocked')
AddEventHandler('blckhndr_doormanager:doorLocked', function(doorType, doorID)
  if doorType == 'police' then
    local door = policeDoors[doorID]
    door["locked"] = true
  end
end)

RegisterNetEvent('blckhndr_doormanager:doorUnlocked')
AddEventHandler('blckhndr_doormanager:doorUnlocked', function(doorType, doorID)
  if doorType == 'police' then
    local door = policeDoors[doorID]
    door["locked"] = false
  end
end)
RegisterNetEvent('blckhndr_doormanager:sendDoors')
AddEventHandler('blckhndr_doormanager:sendDoors', function(police, property)
  policeDoors = police
  propertyDoors = property
end)
----------------------------------------
AddEventHandler('blckhndr_police:init', function(policeLevel)
  if policeLevel > 0 then
    amipolice = true
  else
    amipolice = false
  end
  TriggerServerEvent('blckhndr_doormanager:requestDoors')
end)
TriggerServerEvent('blckhndr_doormanager:requestDoors')
----------------------------------------
function blckhndr_doorUnlockSound()
  Citizen.CreateThread(function()
    PlaySound(-1, "10_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "10_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  end)
end

function blckhndr_loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    for k, v in pairs(policeDoors) do
      local closestDoor = GetClosestObjectOfType(v.x, v.y, v.z, 1.0, v.objName, false, false, false)
      local doorCoords = GetEntityCoords(closestDoor)
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, v.x, v.y, v.z, true) < 10 then
        if v.locked then
          FreezeEntityPosition(closestDoor, true)
        else
          FreezeEntityPosition(closestDoor, false)
        end
      end
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, v.x, v.y, v.z, true) < 2 then
        if amipolice then
          if v.locked then
            blckhndr_drawText3D(v.txtX, v.txtY, v.txtZ, "[E] hogy ~g~kinyisd az ajtót")
            FreezeEntityPosition(closestDoor, true)
          else
            blckhndr_drawText3D(v.txtX, v.txtY, v.txtZ, "[E] hogy ~r~bezárd az ajtót")
            FreezeEntityPosition(closestDoor, false)
          end
          if IsControlJustPressed(1,51) then
			if v.locked then
              --TaskPlayAnim(GetPlayerPed(-1), 'missheistfbisetup1', 'unlock_enter_janitor', 8.0, -1, false, false, false, false)
              blckhndr_loadAnimDict( "gestures@f@standing@casual" )
              TaskPlayAnim(GetPlayerPed(-1), "gestures@f@standing@casual", "gesture_hand_down", 8.0, 1.0, 3, 2, 0, 0, 0, 0 )
              blckhndr_doorUnlockSound()
              TriggerServerEvent('blckhndr_doormanager:unlockDoor', 'police', k)
              FreezeEntityPosition(closestDoor, false)
            else
              blckhndr_loadAnimDict( "gestures@f@standing@casual" )
              TaskPlayAnim(GetPlayerPed(-1), "gestures@f@standing@casual", "gesture_hand_down", 8.0, 1.0, 3, 2, 0, 0, 0, 0 )
              blckhndr_doorUnlockSound()
              TriggerServerEvent('blckhndr_doormanager:lockDoor', 'police', k)
              FreezeEntityPosition(closestDoor, true)
            end
					end
        else
          if v.locked then
            blckhndr_drawText3D(v.txtX, v.txtY, v.txtZ, "~r~ZÁRVA")
          else
            blckhndr_drawText3D(v.txtX, v.txtY, v.txtZ, "~g~NYITVA")
          end
        end
      end
    end
  end
end)
