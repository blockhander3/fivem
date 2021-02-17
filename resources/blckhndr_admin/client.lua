RegisterNetEvent('blckhndr_admin:requestXYZ')
AddEventHandler('blckhndr_admin:requestXYZ', function(sendto)
  local coords = {x=GetEntityCoords(GetPlayerPed(-1)).x, y=GetEntityCoords(GetPlayerPed(-1)).y, z=GetEntityCoords(GetPlayerPed(-1)).z}
  TriggerServerEvent('blckhndr_admin:sendXYZ', sendto, coords)
end)

RegisterNetEvent('blckhndr_admin:recieveXYZ')
AddEventHandler('blckhndr_admin:recieveXYZ', function(xyz)
  SetEntityCoords(GetPlayerPed(-1), xyz.x, xyz.y, xyz.z, 1, 0, 0, 1)
end)

local frozen = false
RegisterNetEvent('blckhndr_admin:FreezeMe')
AddEventHandler('blckhndr_admin:FreezeMe', function(adminID)
  if frozen then
    TriggerEvent('chatMessage', '', {255,255,255}, '^1^*:ADMIN PANEL:^r^0 Kilettel olvasztva: '..GetPlayerName(adminID))
    frozen = false
  else
    TriggerEvent('chatMessage', '', {255,255,255}, '^1^*:ADMIN PANEL:^r^0 Lelettel fagyasztva: '..GetPlayerName(adminID))
    frozen = true
  end
end)
