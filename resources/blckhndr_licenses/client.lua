local licenses = {}
local name = 'steve the mushroom'
local charid = 0

AddEventHandler('blckhndr_main:character', function(char)
  if char.char_licenses ~= '' then
    licenses = json.decode(char.char_licenses)
  else
    licenses = {}
  end
  name = char.char_fname..' '..char.char_lname
  charid = char.char_id
  if licenses["driver"] then
    TriggerServerEvent('blckhndr_licenses:check', 'driver', licenses['driver'].infractions, licenses['driver'].date, GetNetworkTime())
  end
end)

function blckhndr_NearestPlayersC(x, y, z, radius)
	local players = {}
	for _, id in ipairs(GetActivePlayers()) do
		local ppos = GetEntityCoords(GetPlayerPed(id))
		if GetDistanceBetweenCoords(ppos.x, ppos.y, ppos.z, x, y, z) < radius then
			table.insert(players, #players+1, GetPlayerServerId(id))
		end
	end
  return players
end

RegisterNetEvent('blckhndr_licenses:update')
AddEventHandler('blckhndr_licenses:update', function(type, status)

  TriggerEvent('blckhndr_notify:displayNotification', 'YOUR '..type..' LICENSE HAS BEEN '..status, 'centerLeft', 10000, 'alert')
  licenses[type].status = status
  TriggerServerEvent('blckhndr_licenses:update', charid, json.encode(licenses))
end)

RegisterNetEvent('blckhndr_licenses:showid')
AddEventHandler('blckhndr_licenses:showid', function()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  TriggerServerEvent('blckhndr_licenses:chat', name, {
    type = 'id',
    charid = charid,
    job = exports.blckhndr_jobs:blckhndr_GetJob(),
  }, blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
end)

RegisterNetEvent('blckhndr_licenses:infraction')
AddEventHandler('blckhndr_licenses:infraction', function(type, amt)
  licenses[type].infractions = licenses[type].infractions + amt
  TriggerServerEvent('blckhndr_licenses:update', charid, json.encode(licenses))
  TriggerServerEvent('blckhndr_licenses:check', type, licenses[type].infractions, licenses[type].date, GetNetworkTime())
end)

RegisterNetEvent('blckhndr_licenses:setinfractions')
AddEventHandler('blckhndr_licenses:setinfractions', function(type, amt)
  if amt <= 15 then
    licenses[type].status = 'AKTÍV'
  else
    licenses[type].status = 'BEVONVA'
  end
  licenses[type].infractions = amt
  TriggerServerEvent('blckhndr_licenses:update', charid, json.encode(licenses))
end)

RegisterNetEvent('blckhndr_licenses:display')
AddEventHandler('blckhndr_licenses:display', function(type)
  local pos = GetEntityCoords(GetPlayerPed(-1))
  if type == 'all' then
    for k,v in pairs(licenses) do
      if licenses["driver"] then
        TriggerServerEvent('blckhndr_licenses:chat', name, licenses["driver"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
      end
      if licenses["pilot"] then
        TriggerServerEvent('blckhndr_licenses:chat', name, licenses["pilot"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
      end
      if licenses["weapon"] then
        TriggerServerEvent('blckhndr_licenses:chat', name, licenses["weapon"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
      end
    end
  elseif type == 'driver' then
    if licenses["driver"] then
      TriggerServerEvent('blckhndr_licenses:chat', name, licenses["driver"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You do not have a drivers license.', 'centerLeft', 4000, 'error')
    end
  elseif type == 'pilot' then
    if licenses["pilot"] then
      TriggerServerEvent('blckhndr_licenses:chat', name, licenses["pilot"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You do not have a pilots license.', 'centerLeft', 4000, 'error')
    end
  elseif type == 'weapon' then
    if licenses["weapon"] then
      TriggerServerEvent('blckhndr_licenses:chat', name, licenses["weapon"], blckhndr_NearestPlayersC(pos.x, pos.y, pos.z, 5))
    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You do not have a weapons license.', 'centerLeft', 4000, 'error')
    end
  end
end)

RegisterNetEvent('blckhndr_licenses:police:give')
AddEventHandler('blckhndr_licenses:police:give', function(type)
  licenses[type] = {}
  licenses[type].date = GetNetworkTime()
  licenses[type].type = type
  licenses[type].infractions = 0
  licenses[type].status = 'ACTIVE'
  TriggerServerEvent('blckhndr_licenses:update', charid, json.encode(licenses))
end)

function blckhndr_hasLicense(type)
  print('checking license type: '..tostring(type))
  if licenses[type] then
    return true
  else
    return false
  end
end

function blckhndr_getLicensePoints(type)
	if licenses[type] then
    return licenses[type].infractions
  else
    return 100
  end
end

---------------------------------------------------------- BUY PLACE
local blip = {x = 237.59239196777, y = -406.15228271484, z = 47.924365997314}
local license_stores = {
  {
    loc = {x = 233.22550964355, y = -410.34426879883, z = 48.11198425293},
    store = 'driver',
    cost = 500,
    text = 'Press ~INPUT_PICKUP~ to buy a drivers license (~g~$500~w~)'
  },
  {
    loc = {x = 238.16859436035, y = -412.05615234375, z = 48.11194229126},
    store = 'pilot',
    cost = 75000,
    text = 'Press ~INPUT_PICKUP~ to buy a pilots license (~g~$75,000~w~)'
  },
}
local function buyLicense(index)
  local store = license_stores[index]
  if store.store == 'driver' then
    if tonumber(exports.blckhndr_main:blckhndr_GetWallet()) >= store.cost then
      if licenses['driver'] then
        if licenses['driver'].status ~= 'EXPIRED' then
          TriggerEvent('blckhndr_notify:displayNotification', 'Your current license cannot be replaced', 'centerLeft', 4000, 'error')
        else
          TriggerEvent('blckhndr_bank:change:walletMinus', 250)
          TriggerEvent('blckhndr_notify:displayNotification', 'You updated your current license for <span style="color:limegreen">$250', 'centerLeft', 6000, 'success')

          licenses['driver'].date = GetNetworkTime()
          licenses['driver'].infractions = 0
          licenses['driver'].status = 'ACTIVE'
        end
      else
        licenses['driver'] = {}
        licenses['driver'].date = GetNetworkTime()
        licenses['driver'].type = 'driver'
        licenses['driver'].infractions = 0
        licenses['driver'].status = 'ACTIVE'

        TriggerEvent('blckhndr_bank:change:walletMinus', 500)
        TriggerEvent('blckhndr_notify:displayNotification', 'You bought a new license for <span style="color:limegreen">$500', 'centerLeft', 6000, 'success')

        TriggerServerEvent('blckhndr_licenses:update', charid, json.encode(licenses))
      end
    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You do not have enough cash.', 'centerLeft', 4000, 'error')
    end
  elseif store.store == 'pilot' then
    if tonumber(exports.blckhndr_main:blckhndr_GetWallet()) >= store.cost then

    else
      TriggerEvent('blckhndr_notify:displayNotification', 'You do not have a enough cash.', 'centerLeft', 4000, 'error')
    end
  end
end
Citizen.CreateThread(function()
  local bleep = AddBlipForCoord(blip.x, blip.y, blip.z)
  SetBlipSprite(bleep, 498)
  SetBlipAsShortRange(bleep, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("License Center")
  EndTextCommandSetBlipName(bleep)
  while true do
    Citizen.Wait(0)
    for k, v in pairs(license_stores) do
      if GetDistanceBetweenCoords(v.loc.x,v.loc.y,v.loc.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
        DrawMarker(1,v.loc.x,v.loc.y,v.loc.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
        if GetDistanceBetweenCoords(v.loc.x,v.loc.y,v.loc.z,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
          SetTextComponentFormat("STRING")
          AddTextComponentString(v.text)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if IsControlJustPressed(0,38) then
            buyLicense(k)
          end
        end
      end
    end
  end
end)
