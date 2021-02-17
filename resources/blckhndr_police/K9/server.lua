RegisterServerEvent('blckhndr_police:k9:search:person:end')
AddEventHandler('blckhndr_police:k9:search:person:end', function(Found, OfficerId)
    TriggerClientEvent('blckhndr_police:k9:search:person:finish', OfficerId, Found)
end)