RegisterServerEvent('blckhndr_criminalmisc:handcuffs:requestCuff')
AddEventHandler('blckhndr_criminalmisc:handcuffs:requestCuff', function(ply)
	TriggerClientEvent('blckhndr_criminalmisc:handcuffs:startCuffing', source)
	TriggerClientEvent('blckhndr_criminalmisc:handcuffs:startCuffed', ply, source)
end)

RegisterServerEvent('blckhndr_criminalmisc:handcuffs:requestunCuff')
AddEventHandler('blckhndr_criminalmisc:handcuffs:requestunCuff', function(ply)
	TriggerClientEvent('blckhndr_criminalmisc:handcuffs:startunCuffing', source)
	TriggerClientEvent('blckhndr_criminalmisc:handcuffs:startunCuffed', ply, source)
end)

RegisterServerEvent('blckhndr_criminalmisc:handcuffs:toggleEscort')
AddEventHandler('blckhndr_criminalmisc:handcuffs:toggleEscort', function(ply)
	TriggerClientEvent('blckhndr_criminalmisc:toggleDrag', ply, source)
end)