 local onduty_ems = {}

 RegisterServerEvent('blckhndr_ems:update')
 RegisterServerEvent('blckhndr_ems:onDuty')
 AddEventHandler('blckhndr_ems:onDuty', function(emslevel)
   if emslevel > 2 then
     table.insert(onduty_ems, {ply_id = source, ply_lvl = emslevel})
     TriggerClientEvent('blckhndr_ems:update', -1, onduty_ems)
     TriggerEvent('blckhndr_ems:update', onduty_ems)
     print(':blckhndr_ems: '..source..' has clocked on duty at level '..emslevel)
   else
     print(':blckhndr_ems: '..source..' has clocked in as police, but is not high enough level to contribute.')
   end
 end)

 RegisterServerEvent('blckhndr_ems:offDuty')
 AddEventHandler('blckhndr_ems:offDuty', function()
   for k, v in pairs(onduty_ems) do
     if v.ply_id == source then
       table.remove(onduty_ems, k)
       print(':blckhndr_ems: '..source..' has clocked out.')
     end
   end
   TriggerClientEvent('blckhndr_ems:update', -1, onduty_ems)
   TriggerEvent('blckhndr_ems:update', onduty_ems)
 end)

 AddEventHandler('playerDropped', function()
   for k, v in pairs(onduty_ems) do
     if v.ply_id == source then
       table.remove(onduty_ems, k)
       print(':blckhndr_ems: '..source..' has clocked out and disconnected.')
     end
   end
   TriggerClientEvent('blckhndr_ems:update', -1, onduty_ems)
 end)

 RegisterServerEvent('blckhndr_ems:requestUpdate')
 AddEventHandler('blckhndr_ems:requestUpdate', function()
   TriggerClientEvent('blckhndr_ems:update', source, onduty_ems)
 end)


 RegisterNetEvent('blckhndr_ems:volunteering')
 AddEventHandler('blckhndr_ems:volunteering', function(char_name, char_phone, char_email, char_id)
  local steamid = GetPlayerIdentifiers(source)
  steamid = steamid[1]
  local frac = 'ems'
MySQL.Sync.execute("INSERT INTO `blckhndr_fracapplys` (`id`, `char_name`, `char_phone`, `char_email`, `char_id`, `identifier`, `frac`) VALUES (NULL, @char_name, @char_phone, @char_email, @char_id, @identifier, @frac)", {['@char_name'] = char_name, ['@char_phone'] = char_phone, ['@char_email'] = char_email, ['@char_id'] = char_id, ['@identifier'] = steamid, ['@frac'] = frac })
end)
