RegisterServerEvent('blckhndr_jobs:tow:mark')
AddEventHandler('blckhndr_jobs:tow:mark', function(towPlate, officer)
	if officer == false then officer = source end
	TriggerClientEvent('blckhndr_jobs:tow:marked', -1, towPlate, officer)
end)