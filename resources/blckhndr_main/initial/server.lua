AddEventHandler('blckhndr_main:validatePlayer', function()

end)
---------------------------- Character Shit
cur_chars = {}
playerNames = {}
AddEventHandler('playerDropped', function()
	for k, v in pairs(cur_chars) do
		if v.ply_id == source then
			cur_chars[k] = nil
		end
	end
  for k, v in pairs(playerNames) do
    if v.id == GetPlayerServerId(player) then
      table.remove(playerNames, v.id)
    end
  end
end)



RegisterServerEvent('blckhndr_main:updateCharacters')
RegisterServerEvent('blckhndr_main:createCharacter')
AddEventHandler('blckhndr_main:createCharacter', function(data)
  local source = source
  print(':blckhndr_main: got character information')
  for k, v in pairs(data) do
    print('> '..k..' = '..v)
  end
  local steamid = GetPlayerIdentifiers(source)
  steamid = steamid[1]
  MySQL.Sync.execute("INSERT INTO `blckhndr_characters` (`char_id`, `steamid`, `char_fname`, `char_lname`, `char_dob`, `char_desc`, `char_licenses`, `char_contacts`, `char_money`, `char_bank`, `char_model`, `mdl_extras`, `char_inventory`, `char_weapons`, `char_police`, `char_ems`) VALUES (NULL, @steamid, @char_fname, @char_lname, @char_dob, @char_desc, '{}', '{}', '500', '5000', '{}', '[]', '[]', '[]', '0', '0')", {['@steamid'] = steamid, ['@char_fname'] = data.char_fname, ['@char_lname'] = data.char_lname, ['@char_dob'] = data.char_dob, ['@char_desc'] = data.char_desc })
  local characters = MySQL.Sync.fetchAll("SELECT * FROM `blckhndr_characters` WHERE `steamid` = '"..steamid.."'")
  TriggerClientEvent('blckhndr_main:sendCharacters', source, characters)
end)
--[[
AddEventHandler('playerDropped', function()
  for k, v in pairs(cur_chars) do
    if v.ply_id == source then
      print('REMOVING '..v.char_fname..v.char_lname..' FROM CHARACTERS TABLE')
      table.remove(cur_chars, k)
      table.concat(cur_chars,", ",1,#cur_chars)
    end
  end
  TriggerEvent('blckhndr_main:updateCharacters', cur_chars)
end)
]]
RegisterServerEvent('blckhndr_main:requestCharacters')
AddEventHandler('blckhndr_main:requestCharacters', function()
  local source = source
  local steamid = GetPlayerIdentifiers(source)
  steamid = steamid[1]
  local characters = MySQL.Sync.fetchAll("SELECT * FROM `blckhndr_characters` WHERE `steamid` = '"..steamid.."'")
  for k, v in pairs(players) do
  	if v.steamid == steamid then
  		if v.banned then
  			 print(':FSN: '..v.name..' is BANNED for: '..v.banned_r)
  			 DropPlayer(source, ':FSN: You are BANNED: '..v.banned_r)
  			 CancelEvent()
  		end
  	end
  end
  TriggerClientEvent('blckhndr_main:sendCharacters', source, characters)
  updateIdentifiers(source)
end)

RegisterServerEvent('blckhndr_main:update:myCharacter')
AddEventHandler('blckhndr_main:update:myCharacter', function(index, char)
  for k, v in pairs(cur_chars) do
    if v.ply_id == source then
      v = char
    end
  end
  --cur_chars[index] = char
end)
--[[RegisterServerEvent('blckhndr_main:getCharacterFromID')
AddEventHandler('blckhndr_main:getCharacterFromID', function(id)
  local char_id = blckhndr_CharID(id)

local char2 = MySQL.Sync.fetchAll("SELECT * FROM `blckhndr_characters` WHERE `char_id` = '"..char_id.."'")

    --[[
    for k, v in pairs(cur_chars) do
      if v.ply_id == source then
        table.remove(cur_chars, k)
      end
    end
    for k, v in pairs(cur_chars) do
      if v.ply_id == source then
        table.remove(cur_chars,k)
      end
    end
    
    chars2[#chars2+1] = {
      ply_id2        = source,
      ply_name2     = GetPlayerName(source),
      char2_id        = char2[1].char_id,
      char2_fname     = char2[1].char_fname,
      char2_lname     = char2[1].char_lname,
      char2_dob       = char2[1].char_dob,
      char2_phone     = char2[1].char_phone,
      char2_contacts  = char2[1].char_contacts,
      char2_police    = char2[1].char_police,
      char2_ems       = char2[1].char_ems,
      char2_twituname = char2[1].char_twituname
    }
    print(char2_fname, char2_lname, char2_id)
    TriggerClientEvent('blckhndr_menu:plyidabovehead', char2_fname, char2_lname, char2_id)
end)--]]
RegisterServerEvent('blckhndr_main:getCharacter')
AddEventHandler('blckhndr_main:getCharacter', function(char_id)
  local source = source
  local steamid = GetPlayerIdentifiers(source)
  steamid = steamid[1]
  -- TODO: Investigate if the steamid check can be put into the MySQL query
  local char = MySQL.Sync.fetchAll("SELECT * FROM `blckhndr_characters` WHERE `char_id` = '"..char_id.."'")
  if char[1].steamid == steamid then
    TriggerClientEvent('blckhndr_main:initiateCharacter', source, char)
    


    
    cur_chars[#cur_chars+1] = {
      ply_id         = source,
      ply_name       = GetPlayerName(source),
      char_id        = char[1].char_id,
      char_fname     = char[1].char_fname,
      char_lname     = char[1].char_lname,
      char_dob       = char[1].char_dob,
      char_phone     = char[1].char_phone,
      char_contacts  = char[1].char_contacts,
      char_police    = char[1].char_police,
      char_ems       = char[1].char_ems,
      char_twituname = char[1].char_twituname
    }
    --local cn = char[1].char_fname.. ' ' ..char[1].char_lname
   -- table.insert(playerNames, {id = source, name = cn})
   -- TriggerClientEvent('blckhndr_menu:plyidabovehead', playerNames)
    TriggerEvent('blckhndr_main:money:initChar', source, char[1].char_id, char[1].char_money, char[1].char_bank)
    
    TriggerClientEvent('blckhndr_main:updateCharacters', -1, cur_chars)
    TriggerEvent('blckhndr_main:updateCharacters', cur_chars)
    TriggerEvent('blckhndr_main:getCharacterFromID', source)
  else
    DropPlayer(source, ':FSN: You tried to load a character you do not own.')
  end
end)

AddEventHandler('blckhndr_main:updateCharacters', function(char)
  print(':DEBUG: Character Update')
  for k, c in pairs(char) do
    print(c.ply_id..'> F: '..c.char_fname..', L: '..c.char_lname)
    
  end

end)

function blckhndr_GetPlayerFromCharacterId(id)
  local idee = 0
  for k, v in pairs(cur_chars) do
    if v.char_id == tonumber(id) then
      idee = v.ply_id
    end
  end
  return idee
end

function blckhndr_GetCharacterInfo(id)
	local idee = false
	for k, v in pairs(cur_chars) do
		if v.char_id == tonumber(id) then
		  idee = v
		end
	end
	return idee
end


function blckhndr_CharID(src)
  local charid = 0
  for k, v in pairs(cur_chars) do
    if v.ply_id == tonumber(src) then
      charid = v.char_id
    end
  end
  return charid
end

function blckhndr_CharNamesF(src)
  local fname = 'hiba'
  for k, v in pairs(cur_chars) do
    if v.ply_id == tonumber(src) then
      fname = v.char_fname
    end
  end
  return fname
end
function blckhndr_CharNamesF(src)
  local lname = 'hiba'
  for k, v in pairs(cur_chars) do
    if v.ply_id == tonumber(src) then
      lname = v.char_lname
    end
  end
  return lname
end

function blckhndr_CharInfos(src)
  local charID = src
  for k, v in pairs(cur_chars) do
    if v.char_id == tonumber(charID) then
      fname = v.char_fname
      lname = v.char_lname
    end
  end
  return fname
end

--[[RegisterNetEvent('blckhndr_main:charinfos')
AddEventHandler('blckhndr_main:charinfos', function(src)
  for k, c in pairs(char) do
    local fname = c.char_fname
  TriggerClientEvent('blckhndr_menu:plyidabovehead', -1, c.char_fname, c.char_lname, c.char_id, c.char_phone)
  print(c.char_fname)
end
end)--]]

function blckhndr_GetPlayerFromPhoneNumber(num)
  local idee = 0
  for k, v in pairs(cur_chars) do
    if v.char_phone == num then
      idee = v.ply_id
    end
  end
  return idee
end

function blckhndr_GetPlayerPhoneNumber(ply)
  local idee = 0
  for k, v in pairs(cur_chars) do
    if v.ply_id == tonumber(ply) then
      idee = v.char_phone
    end
  end
  return idee
end
RegisterServerEvent('blckhndr_main:playerPhoneNumber')
AddEventHandler('blckhndr_main:playerPhoneNumber', function(ply)
  local number = blckhndr_GetPlayerPhoneNumber(ply)
  --TriggerClientEvent('blckhndr_ems:voluntieering_number', number)
end)

RegisterServerEvent('blckhndr_main:updateCharNumber')
AddEventHandler('blckhndr_main:updateCharNumber', function(charid, number)
  for k, v in pairs(cur_chars) do
    if v.char_id == tonumber(charid) then
      v.char_phone = number
      print(v.char_id..' updated phone number to: '..v.char_phone)
    end
  end
end)

-------------------------------------------- inventory saving
RegisterServerEvent('blckhndr_inventory:database:update')
AddEventHandler('blckhndr_inventory:database:update', function(inv)
  local charid = 0
  for k, v in pairs(cur_chars) do
    if v.ply_id == source then
      charid = v.char_id
    end
  end
  inv = json.encode(inv)
  MySQL.Sync.execute("UPDATE `blckhndr_characters` SET `char_inventory` = @inventory WHERE `blckhndr_characters`.`char_id` = @id", {['@id'] = charid, ['@inventory'] = inv})
end)
-------------------------------------------- vehicle shit
RegisterServerEvent('blckhndr_cargarage:buyVehicle')
AddEventHandler('blckhndr_cargarage:buyVehicle', function(charid, displayname, spawnname, plate, details, finance, vehtype, status)
  details = json.encode(details)
  finance = json.encode(finance)
  plate = string.upper(plate)
  MySQL.Async.execute("INSERT INTO `blckhndr_vehicles` (`veh_id`, `char_id`, `veh_displayname`, `veh_spawnname`, `veh_plate`, `veh_inventory`, `veh_details`, `veh_finance`, `veh_type`, `veh_status`, `veh_garage`) VALUES (NULL, @charid, @displayname, @spawnname, @plate, '{}', @details, @finance, @vehtype, @status, 0);", {
	--@charid, @displayname, @spawnname, @plate, @details, @finance, @status
	['@charid'] = charid,
	['@displayname'] = displayname,
	['@spawnname'] = spawnname,
	['@plate'] = plate,
	['@details'] = details,
	['@finance'] = finance,
	['@vehtype'] = vehtype,
	['@status'] = status,
  }, function(rowsChanged) end)
end)
-------------------------------------------- Character Saving
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(300000)
    local plys = GetPlayers()
    print(':blckhndr_main: Saving '..#plys..' player(s) data')
    for k, player in pairs(plys) do
      TriggerClientEvent('blckhndr_main:characterSaving', player)
    end
  end
end)
RegisterServerEvent('blckhndr_main:saveCharacter')
AddEventHandler('blckhndr_main:saveCharacter', function(charid, model, vars, weapons)
  local source = source
  MySQL.Sync.execute("UPDATE `blckhndr_characters` SET `char_model` = @model, `mdl_extras` = '"..vars.."', `char_weapons` = @weapons WHERE `blckhndr_characters`.`char_id` = @id", {['@id'] = charid, ['@model'] = model, ['@weapons'] = weapons})
  print(':FSN: Character information for '..GetPlayerName(source)..' updated!')
  checkBan(source, false)
end)
------------------------------------------------------ POLICE
RegisterServerEvent('blckhndr_police:chat:ticket')
AddEventHandler('blckhndr_police:chat:ticket', function(suspectID, jailFine, jailTime, charges)
  for k, v in pairs(cur_chars) do
    if v.ply_id then
      --print(v.ply_id..' != '..suspectID)
      if v.ply_id == tonumber(suspectID) then
        if tonumber(jailTime) > 0 then
          TriggerClientEvent('chatMessage', -1, '', {255,255,255}, v.char_fname..' '..v.char_lname.. ' has been JAILED for ^3'..jailTime..'^0 months for ^1'..charges)
        end
        if tonumber(jailFine) > 0 then
          TriggerClientEvent('chatMessage', -1, '', {255,255,255}, v.char_fname..' '..v.char_lname.. ' has been FINED ^3$'..jailFine..'^0 for ^1'..charges)
        end
      end
    end
  end
end)
------------------------------------------------------------- version control stuff
-------------------------------------------------------------
SetGameType(':FSN: Framework')
