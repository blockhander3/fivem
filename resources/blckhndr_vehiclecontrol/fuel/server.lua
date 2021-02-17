RegisterServerEvent('blckhndr_fuel:update')
AddEventHandler('blckhndr_fuel:update', function(veh, fuel)
  TriggerClientEvent('blckhndr_fuel:update', -1, veh, fuel)
end)
