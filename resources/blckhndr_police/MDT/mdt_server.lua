RegisterServerEvent('blckhndr_police:database:CPIC')
AddEventHandler('blckhndr_police:database:CPIC', function(data)
  --[[
    "suspectID":$("#booking-player-id").val(),
		"suspectName":$("#booking-player-name").val(),
		"officerName":$("#booking-officer-name").val(),
		"charges":$("#booking-charges-textarea").val(),
	  "jailTime":$("#booking-jail").val(),
    "jailFine":$("#booking-fine").val(),
  ]]--
  local officerID = exports.blckhndr_main:blckhndr_CharID(source)
  local suspectID = exports.blckhndr_main:blckhndr_CharID(tonumber(data.suspectID))
  MySQL.Async.execute('INSERT INTO `blckhndr_tickets` (`ticket_id`, `officer_id`, `officer_name`, `receiver_id`, `ticket_amount`, `ticket_jailtime`, `ticket_charges`, `ticket_date`) VALUES (NULL, @officer_id, @officer_name, @receiver_id, @ticket_amount, @ticket_jailtime, @ticket_charges, @ticket_time)', {
    ["@officer_id"] = officerID,
    ["@officer_name"] = data.officerName,
    ["@receiver_id"] = suspectID,
    ["@ticket_amount"] = data.jailFine,
    ["@ticket_jailtime"] = data.jailTime,
    ["@ticket_charges"] = data.charges,
    ["@ticket_time"] = os.time()
  }, function(rowsChanged) end)
end)

RegisterServerEvent('blckhndr_police:database:CPIC:search')
AddEventHandler('blckhndr_police:database:CPIC:search', function(id)
  local res = {}
  local src = source
  local idee = exports.blckhndr_main:blckhndr_CharID(id)
  print(':blckhndr_police: Running CPIC for : (C: '..idee..' / S: '..id)
  MySQL.Async.fetchAll('SELECT * FROM `blckhndr_tickets` WHERE `receiver_id` = @id', {['@id'] = idee}, function(results)
    for k, v in pairs(results) do
      local ass = os.date("*t", v.ticket_date)
      v.ticket_date = ass.hour..':'..ass.min..' '..ass.month..'/'..ass.day..'/'..ass.year
    end
    TriggerClientEvent('blckhndr_police:database:CPIC:search:result', src, results)
  end)
end)

RegisterServerEvent('blckhndr_police:MDT:warrant')
AddEventHandler('blckhndr_police:MDT:warrant', function(tbl)
  MySQL.Async.execute('INSERT INTO `blckhndr_warrants` (`war_id`, `suspect_name`, `officer_name`, `war_charges`, `war_times`, `war_fine`, `war_desc`, `war_status`, `war_date`) VALUES (NULL, @suspect_name, @officer_name, @war_charges, @war_times, @war_fine, @war_desc, @war_status, @war_time)', {
    ['@suspect_name'] = tbl.suspectName,
    ['@officer_name'] = tbl.officerName,
    ['@war_charges'] = tbl.charges,
    ['@war_times'] = tbl.jailTime,
    ['@war_fine'] = tbl.jailFine,
    ['@war_desc'] = tbl.situationDesc,
    ['@war_status'] = 'ACTIVE',
    ['@war_time'] = os.time()
  }, function(rowsChanged) end)
  TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^7MDT |^0 Warrant submitted. Refresh warrants if required.')
  TriggerClientEvent('blckhndr_police:911', -1, 'NIL', 'DISPATCH', 'A new warrant has been submitted for: ^*'..tbl.suspectName..'^r check your MDT for details.')
end)

RegisterServerEvent('blckhndr_police:MDT:requestwarrants')
AddEventHandler('blckhndr_police:MDT:requestwarrants', function(name)
  local src = source
  if name ~= false then
    name = '%'..name..'%'
    MySQL.Async.fetchAll('SELECT * FROM `blckhndr_warrants` WHERE `suspect_name` LIKE @name AND `war_status` = "ACTIVE"', {['@name'] = name}, function(results)
      TriggerClientEvent('blckhndr_police:MDT:receivewarrants', src, results)
      
    end)
  else
    MySQL.Async.fetchAll('SELECT * FROM `blckhndr_warrants` WHERE `war_status` = "ACTIVE"', {['@name'] = name}, function(results)
      TriggerClientEvent('blckhndr_police:MDT:receivewarrants', src, results)
      
    end)
  end
end)

RegisterServerEvent('blckhndr_police:MDT:requestapplys')
AddEventHandler('blckhndr_police:MDT:requestapplys', function(name)
  local src = source
  local frac = "sheriff"
  if name ~= false then
    name = '%'..name..'%'
    MySQL.Async.fetchAll('SELECT `id`, `char_name`, `char_phone`, `char_email` FROM `blckhndr_fracapplys` WHERE `frac` LIKE @frac AND `char_name` LIKE @name' , {['@frac'] = frac, ['@name'] = name}, function(results)
      TriggerClientEvent('blckhndr_police:MDT:receiveapplys', src, results)
    end)
  else
    MySQL.Async.fetchAll('SELECT `id`, `char_name`, `char_phone`, `char_email` FROM `blckhndr_fracapplys` WHERE `frac` LIKE @frac', {['@frac'] = frac}, function(results)
      TriggerClientEvent('blckhndr_police:MDT:receiveapplys', src, results)
    end)
  end
end)

RegisterServerEvent('blckhndr_police:MDTremovewarrant')
AddEventHandler('blckhndr_police:MDTremovewarrant', function(id)
    MySQL.Async.execute('DELETE FROM `blckhndr_warrants` WHERE `blckhndr_warrants`.`war_id` = @id', {['@id'] = id})
end)

RegisterServerEvent('blckhndr_police:MDTremoveapply')
AddEventHandler('blckhndr_police:MDTremoveapply', function(id)
    MySQL.Async.execute('DELETE FROM `blckhndr_fracapplys` WHERE `blckhndr_fracapplys`.`id` = @id', {['@id'] = id})
end)

