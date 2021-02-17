--TriggerServerEvent("blckhndr_cargarage:updateVehicle", plate, table.tostring(vehiclecol), table.tostring(extracol), table.tostring(neoncolor), plateindex, table.tostring(mods), GetVehicleNumberPlateTextIndex(veh), wheeltype);
RegisterServerEvent('blckhndr_cargarage:updateVehicle')
AddEventHandler('blckhndr_cargarage:updateVehicle', function(tbl)
  
  local details = json.encode(tbl)
  print('updating Vehicle('..tbl.plate..') to Details('..details..')')
  MySQL.Sync.execute("UPDATE `blckhndr_vehicles` SET `veh_details` = @details WHERE `veh_plate` = @plate", {
    ['@plate'] = tbl.plate,
    ['@details'] = details,
  })
end)

RegisterServerEvent('blckhndr_cargarage:reset')
AddEventHandler('blckhndr_cargarage:reset', function(charid)
  MySQL.Sync.execute('UPDATE `blckhndr_vehicles` SET `veh_status` = 0 WHERE `veh_status` = 1 AND `char_id` = @charid', {['@charid'] = charid})
end)

--------------------------------------------------------------------------------
RegisterServerEvent('blckhndr_cargarage:requestVehicles')
AddEventHandler('blckhndr_cargarage:requestVehicles', function(type, charid, grg)
  local player = source
  if type == 'cars' then
    MySQL.Async.fetchAll('SELECT * FROM `blckhndr_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "c"', {['@char_id'] = charid}, function(vehicles)
      local vehtbl = {}
        for k, v in pairs(vehicles) do
			if v.veh_garage == grg or v.veh_garage == '0' then
				print(v.veh_garage..' is '..grg)
				table.insert(vehtbl,#vehtbl+1,v)
			else
				print(v.veh_garage..' is not '..grg)
			end
        end

        TriggerClientEvent('blckhndr_cargarage:receiveVehicles', player, 'cars', vehtbl)
    end)
  elseif type == 'aircrafts' then
    MySQL.Async.fetchAll('SELECT * FROM `blckhndr_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "a"', {['@char_id'] = charid}, function(vehicles)
      vehtbl = {}
      for k, v in pairs(vehicles) do
        if v.veh_garage == grg or v.veh_garage == '0' then
          print(v.veh_garage..' is '..grg)
          table.insert(vehtbl,#vehtbl+1,v)
        else
          print(v.veh_garage..' is not '..grg)
        end
          end
  
          TriggerClientEvent('blckhndr_cargarage:receiveVehicles', player, 'aircrafts', vehtbl)
    end)
  elseif type == 'boats' then
    MySQL.Async.fetchAll('SELECT * FROM `blckhndr_vehicles` WHERE `char_id` = @char_id AND `veh_type` = "b"', {['@char_id'] = charid}, function(vehicles)
      vehtbl = {}
      for k, v in pairs(vehicles) do
        --if v.veh_garage == grg or v.veh_garage == '0' then
          --print(v.veh_garage..' is '..grg)
          table.insert(vehtbl,#vehtbl+1,v)
        --else
         -- print(v.veh_garage..' is not '..grg)
       -- end
          end
  
          TriggerClientEvent('blckhndr_cargarage:receiveVehicles', player, 'boats', vehtbl)
    end)
  else
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Something is wrong with this garage!', 'centerLeft', 3000, 'error')
  end
end)

--TriggerServerEvent('blckhndr_cargarage:impound', GetVehicleNumberPlateText(car))
RegisterServerEvent('blckhndr_cargarage:impound')
AddEventHandler('blckhndr_cargarage:impound', function(plate)
  local status = 2
  MySQL.Async.execute('UPDATE `blckhndr_vehicles` SET `veh_status` = @status WHERE `veh_plate` = @plate', {['@plate'] = plate, ['@status'] = status}, function() end)
end)

RegisterServerEvent('blckhndr_cargarage:vehicle:toggleStatus')
AddEventHandler('blckhndr_cargarage:vehicle:toggleStatus', function(plate, status, grg)
  TriggerClientEvent('blckhndr_cargarage:vehicleStatus', source, plate, status, grg)
  MySQL.Async.execute('UPDATE `blckhndr_vehicles` SET `veh_status` = @status, `veh_garage` = @garage WHERE `veh_plate` = @plate', {['@plate'] = plate, ['@status'] = status, ['@garage'] = grg}, function() end)
end)

RegisterServerEvent('blckhndr_garages:vehicle:update')
AddEventHandler('blckhndr_garages:vehicle:update', function(details)
	TriggerEvent('blckhndr_cargarage:updateVehicle', details)
end)
