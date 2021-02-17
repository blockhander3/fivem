RegisterServerEvent('blckhndr_vehiclecontrol:trunk:forceIn')
AddEventHandler('blckhndr_vehiclecontrol:trunk:forceIn', function(ply, netid)
	print(source..' is forcing '..ply..' into trunk of '..netid)
	TriggerClientEvent('blckhndr_vehiclecontrol:trunk:forceIn', ply, netid)
end)
print'ass'