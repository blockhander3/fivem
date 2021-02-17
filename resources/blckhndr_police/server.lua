local onduty_police = {}
local rnd_names = {
  "Anita Knack",
  "Shila Dube",
   "Jean Kies",
   "Sabine Trudell",
   "Mica Behr",
   "Arianna Dunleavy",
   "Santina Mandelbaum",
   "Joana Proto",
   "Neville Beattie",
   "Kenny Brouillard",
   "Berenice Vanbuskirk",
   "Madelyn Toews",
   "Thao Sustaita",
   "Jackelyn Rausch",
   "Ira Gravel",
   "Earnest Karl",
   "Shauna Belknap",
   "Belen Hayne",
   "Paulita Gershman",
   "Hildegarde Mcgahan",
   "Lasandra Kerbs",
   "Alexis Whitworth",
   "Ciara Guillet",
   "Shoshana Youngberg",
   "Thalia Nuss",
   "Mozella North",
   "Mirta Northrop",
   "Casandra Eurich",
   "Christin Maus",
   "Kiara Netzer",
   "Kandy Armentrout",
   "Marquis Nakashima",
   "Marceline Huff",
   "Yer Messing",
   "Masako Sutliff",
   "Taren Kadel",
   "Emilie Conway",
   "Elanor Jessee",
   "Neomi Bethel",
   "Ione Campbell",
   "Mireille Horton",
   "Avril Winkle",
   "Lois Vossler",
   "Carmine Ostrowski",
   "Kiesha Feltz",
   "Livia Kime",
   "Keven Starrett",
   "Chas Penwell",
   "Ilona Wakefield",
   "Abigail Liberty",
}

RegisterServerEvent('blckhndr_police:dispatch')
AddEventHandler('blckhndr_police:dispatch', function(coords, id, chatPrint)
  TriggerClientEvent('blckhndr_police:dispatchcall', -1, coords, id, chatPrint)
end)

RegisterServerEvent('blckhndr_police:runplate::target')
AddEventHandler('blckhndr_police:runplate::target', function(plate)
  TriggerEvent('blckhndr_police:runplate', source, plate)
end)

RegisterServerEvent('blckhndr_police:runplate')
AddEventHandler('blckhndr_police:runplate', function(src, plate)
  MySQL.Async.fetchAll('SELECT * FROM `blckhndr_vehicles` WHERE `veh_plate` = @plate', {['@plate'] = plate}, function(vehicle)
    if not vehicle[1] then
      TriggerClientEvent('blckhndr_police:MDT:vehicledetails', src, rnd_names[math.random(1,#rnd_names)], false, false)
    else
      MySQL.Async.fetchAll('SELECT * FROM `blckhndr_characters` WHERE `char_id` = @charid', {['@charid'] = vehicle[1].char_id}, function(char)
        MySQL.Async.fetchAll('SELECT * FROM `blckhndr_warrants` WHERE `suspect_name` LIKE @name AND `war_status` = "active"', {['@name'] = char[1].char_fname..' '..char[1].char_lname}, function(warrants)
          if warrants[1] then
            TriggerClientEvent('blckhndr_police:MDT:vehicledetails', src, char[1].char_fname..' '..char[1].char_lname, true, vehicle[1])
          else
            TriggerClientEvent('blckhndr_police:MDT:vehicledetails', src, char[1].char_fname..' '..char[1].char_lname, false, vehicle[1])
          end
        end)
      end)
    end
  end)
end)

RegisterServerEvent('blckhndr_police:toggleHandcuffs')
AddEventHandler('blckhndr_police:toggleHandcuffs', function(ply)
  TriggerClientEvent('blckhndr_police:handcuffs:toggle', -1, ply)
end)

RegisterServerEvent('blckhndr_police:ticket')
AddEventHandler('blckhndr_police:ticket', function(ply, ticket)
  TriggerClientEvent('blckhndr_bank:change:bankMinus', ply, ticket)
  TriggerClientEvent('blckhndr_notify:displayNotification', ply, 'You have been fined $'..ticket..' by the state.', 'centerLeft', 10000, 'alert')
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You fined '..ply..' $'..ticket, 'centerLeft', 6000, 'info')
end)

RegisterServerEvent('blckhndr_police:update')
RegisterServerEvent('blckhndr_police:onDuty')
AddEventHandler('blckhndr_police:onDuty', function(policelevel)
  if policelevel > 2 then
    table.insert(onduty_police, {ply_id = source, ply_lvl = policelevel})
    TriggerClientEvent('blckhndr_police:update', -1, onduty_police)
    TriggerEvent('blckhndr_police:update', onduty_police)
    print(source..' has clocked on duty at level '..policelevel)
  else
    print(':blckhndr_police: '..source..' has clocked in as police, but is not high enough level to contribute.')
  end
end)

RegisterServerEvent('blckhndr_police:offDuty')
AddEventHandler('blckhndr_police:offDuty', function()
  for k, v in pairs(onduty_police) do
    if v.ply_id == source then
      table.remove(onduty_police, k)
      print(':blckhndr_police: '..source..' has clocked out.')
    end
  end
  TriggerClientEvent('blckhndr_police:update', -1, onduty_police)
  TriggerEvent('blckhndr_police:update', onduty_police)
end)

AddEventHandler('playerDropped', function()
  for k, v in pairs(onduty_police) do
    if v.ply_id == source then
      table.remove(onduty_police, k)
    end
  end
  TriggerClientEvent('blckhndr_police:update', -1, onduty_police)
end)

RegisterServerEvent('blckhndr_police:requestUpdate')
AddEventHandler('blckhndr_police:requestUpdate', function()
  TriggerClientEvent('blckhndr_police:update', source, onduty_police)
end)

RegisterServerEvent('blckhndr_police:search:end:inventory')
AddEventHandler('blckhndr_police:search:end:inventory', function(inv_tbl, officerid)
  local str = ''
  for k, v in pairs(inv_tbl) do
    str = str..'['..v.amount..'X] '..v.display_name..', '
  end
  TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*SEARCH |^0^r '..str)
  TriggerClientEvent('chatMessage', officerid, '', {255,255,255}, '^1^*SEARCH |^0^r '..str)
end)

RegisterServerEvent('blckhndr_police:search:end:weapons')
AddEventHandler('blckhndr_police:search:end:weapons', function(wep_tbl, officerid)
	if #wep_tbl < 1 then
		TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*SEARCH |^0^r No weapons found.')
		TriggerClientEvent('chatMessage', officerid, '', {255,255,255}, '^1^*SEARCH |^0^r No weapons found.')
	else
		for k, v in pairs(wep_tbl) do
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*SEARCH (weapon) |^0^r '..v.name..' | Registered to: '..v.owner.name..' | Serial: '..v.owner.serial)
			TriggerClientEvent('chatMessage', officerid, '', {255,255,255}, '^1^*SEARCH (weapon) |^0^r '..v.name..' | Registered to: '..v.owner.name..' | Serial: '..v.owner.serial)
		end
	end
	--TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*SEARCH |^0^r '..str)
	--TriggerClientEvent('chatMessage', officerid, '', {255,255,255}, '^1^*SEARCH |^0^r '..str)
end)

RegisterServerEvent('blckhndr_police:search:end:money')
AddEventHandler('blckhndr_police:search:end:money', function(officerid, money_tbl)
  TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*SEARCH |^0^r Wallet: ^6$'..money_tbl.wallet..'^0, Bank: ^6$'..money_tbl.bank)
  TriggerClientEvent('chatMessage', officerid, '', {255,255,255}, '^1^*SEARCH |^0^r Wallet: ^6$'..money_tbl.wallet..'^0, Bank: ^6$'..money_tbl.bank)
end)


----------- escorting
RegisterServerEvent('blckhndr_police:cuffs:toggleEscort')
AddEventHandler('blckhndr_police:cuffs:toggleEscort', function(ply)
	TriggerClientEvent('blckhndr_police:ply:toggleDrag', ply, source)
	TriggerClientEvent('blckhndr_police:pd:toggleDrag', source, ply)
end)

------------ cuffing
RegisterServerEvent('blckhndr_police:cuffs:requestCuff')
AddEventHandler('blckhndr_police:cuffs:requestCuff', function(ply)
	TriggerClientEvent('blckhndr_police:cuffs:startCuffing', source)
	TriggerClientEvent('blckhndr_police:cuffs:startCuffed', ply)
end)
RegisterServerEvent('blckhndr_police:cuffs:requestunCuff')
AddEventHandler('blckhndr_police:cuffs:requestunCuff', function(ply)
	TriggerClientEvent('blckhndr_police:cuffs:startunCuffing', ply, source)
	TriggerClientEvent('blckhndr_police:cuffs:startunCuffed', ply, source)
end)
RegisterServerEvent('blckhndr_police:cuffs:toggleHard')
AddEventHandler('blckhndr_police:cuffs:toggleHard', function(ply)
	TriggerClientEvent('blckhndr_police:cuffs:toggleHard', ply)
end)

RegisterNetEvent('blckhndr_police:volunteering')
AddEventHandler('blckhndr_police:volunteering', function(char_name, char_phone, char_email, char_id)
 local steamid = GetPlayerIdentifiers(source)
 steamid = steamid[1]
 local frac = 'sheriff'
MySQL.Sync.execute("INSERT INTO `blckhndr_fracapplys` (`id`, `char_name`, `char_phone`, `char_email`, `char_id`, `identifier`, `frac`) VALUES (NULL, @char_name, @char_phone, @char_email, @char_id, @identifier, @frac)", {['@char_name'] = char_name, ['@char_phone'] = char_phone, ['@char_email'] = char_email, ['@char_id'] = char_id, ['@identifier'] = steamid, ['@frac'] = frac })
end)