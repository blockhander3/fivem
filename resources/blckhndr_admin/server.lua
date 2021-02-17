local admins = {'steam:110000115656753'}
local moderators = {}
local duty = false
function blckhndr_SplitString(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end
function blckhndr_isAdmin(src)
  local sid = GetPlayerIdentifiers(src)
  sid = sid[1]
  for k, v in pairs(admins) do
    if v == sid then
      return true
    end
  end
  return false
end
function blckhndr_GetAdminID(src)
  local sid = GetPlayerIdentifiers(src)
  sid = sid[1]
  for k, v in pairs(admins) do
    if v == sid then
      return k
    end
  end
end
function blckhndr_isModerator(src)
  local sid = GetPlayerIdentifiers(src)
  sid = sid[1]
  for k, v in pairs(moderators) do
    if v == sid then
      return true
    end
  end
  return false
end
function blckhndr_GetModeratorID(src)
  local sid = GetPlayerIdentifiers(src)
  sid = sid[1]
  for k, v in pairs(moderators) do
    if v == sid then
      return k
    end
  end
end

function blckhndr_duty(src)

if duty == false then
  duty = true
  return true
else
  duty = false
    return false
  end
end
AddEventHandler('chatMessage', function(source, auth, msg)
  local split = blckhndr_SplitString(msg, ' ')
  if split[1] == '/ad' then
    if blckhndr_isAdmin(source) then
      for _, ply in pairs(GetPlayers()) do
        if blckhndr_isAdmin(ply) then
          if blckhndr_duty() then
          print('duty')
          else
            print('noduty')
          end

        end
      end
    end
  end
  if split[1] == '/ac' then
    if blckhndr_isAdmin(source) then
      for _, ply in pairs(GetPlayers()) do
        if blckhndr_isAdmin(ply) then
          local msg = table.concat(split, " ", 2, #split)
          TriggerClientEvent('chatMessage', ply, '', {255,255,255}, '^1^*:ADMIN PANEL: ^8[aID#'..blckhndr_GetAdminID(source)..']^0^r '..msg)
        end
      end
    end
  end
  if split[1] == '/am' or split[1] == '/amenu' then
    if blckhndr_isAdmin(source) then
      TriggerClientEvent('blckhndr_admin:menu:toggle', source)
    end
  end
  if split[1] == '/admin' then
    if blckhndr_isAdmin(source) then
      if split[2] == 'freeze' then
        if tonumber(split[3]) then
          TriggerClientEvent('blckhndr_admin:FreezeMe', tonumber(split[3]), source)
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^r^0 You toggled the frozen status of '..GetPlayerName(split[3]))
        end
      end
      if split[2] == 'menu' then
        TriggerClientEvent('blckhndr_admin:menu:toggle', source)
      end
      if split[2] == 'announce' then
        local msg = table.concat(split, " ", 3, #split)
        TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^1^*:ADMIN PANEL:^0 ^8[ANNOUNCEMENT] ^r^0'..msg)
      end
      if split[2] == 'goto' then
        if tonumber(split[3]) then
          TriggerClientEvent('blckhndr_admin:requestXYZ', tonumber(split[3]), source, tonumber(split[3]))
          TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r ^2'..source..'^0 teleported to ^2'..split[3])
        else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r There is an issue with the arguments you provided.')
        end
      end
      if split[2] == 'bring' then
        if tonumber(split[3]) then
          TriggerClientEvent('blckhndr_admin:requestXYZ', source, tonumber(split[3]), source)
          TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r ^2'..source..'^0 brought ^2'..split[3])
        else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r There is an issue with the arguments you provided.')
        end
      end
      if split[2] == 'kick' then
        if tonumber(split[3]) then
          local reason = table.concat(split, " ", 4, #split)
          DropPlayer(tonumber(split[3]), "You have been kicked by aID#"..blckhndr_GetAdminID(source).." for: "..reason)
          TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r ^2'..source..'^0 kicked ^2'..split[3]..'^0 for: '..reason)
        else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r There is an issue with the arguments you provided.')
        end
      end
      if split[2] == 'ban' then
        if tonumber(split[3]) then
          local times = {
            ['1d']=86400,
            ['2d']=172800,
            ['3d']=259200,
            ['4d']=354600,
            ['5d']=432000,
            ['6d']=518400,
            ['1w']=604800,
            ['2w']=1209600,
            ['3w']=1814400,
            ['1m']=2629743,
            ['2m']=529486,
            ['perm'] = 999999999999999999
          }
          if times[split[4]] then
            local unbantime = os.time() + times[split[4]]
            local reason = table.concat(split," ",5,#split)
            local steamid = GetPlayerIdentifiers(tonumber(split[3]))[1]
            MySQL.Async.execute('UPDATE `blckhndr_users` SET `banned` = @unban, `banned_r` = @reason WHERE `steamid` = @steamid', {['@unban']=unbantime, ['@reason']=reason, ['@steamid']=steamid}, function(rowsChanged)end)
            DropPlayer(tonumber(split[3]), "You have been BANNED ("..split[4]..") by aID#"..blckhndr_GetAdminID(source).." for: "..reason)
          else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r Time options: 1d, 2d, 3d, 4d, 5d, 6d, 1w, 2w, 3w, 1m, 2m, perm')
          end
        else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r There is an issue with the arguments you provided.')
        end
      end
    else
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r You aren\'t an admin.')
    end
  end
  if split[1] == '/mod' then
    if blckhndr_isModerator(source) then

    else
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:ADMIN PANEL:^0^r You aren\'t a moderator, cunt.')
    end
  end
end)

RegisterServerEvent('blckhndr_admin:sendXYZ')
AddEventHandler('blckhndr_admin:sendXYZ', function(sendto, xyz)
  TriggerClientEvent('blckhndr_admin:recieveXYZ', sendto, xyz)
end)

RegisterNetEvent('blckhndr_admin:spawnCar')
AddEventHandler('blckhndr_admin:spawnCar', function(car)
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey(car)
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end
  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, true)
  SetVehicleOnGroundProperly(spawned_car)
  SetModelAsNoLongerNeeded(vehicle)
	SetEntityAsMissionEntity(spawned_car, false, true)
  Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	TriggerEvent('blckhndr_cargarage:makeMine', spawned_car, GetDisplayNameFromVehicleModel(GetEntityModel(spawned_car)), GetVehicleNumberPlateText(spawned_car))
	TriggerEvent('blckhndr_notify:displayNotification', 'Mostantól tiéd a jarmű!', 'centerLeft', 4000, 'success')
	TriggerEvent('blckhndr_notify:displayNotification', 'Lespawnoltal egy '..car '-t', 'centerLeft', 2000, 'info')
end)

RegisterNetEvent('blckhndr_admin:fix')
AddEventHandler('blckhndr_admin:fix', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
	end
end)
