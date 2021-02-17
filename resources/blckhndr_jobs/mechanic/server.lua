local mechanic = -1

RegisterServerEvent('blckhndr_jobs:mechanic:toggle')
AddEventHandler('blckhndr_jobs:mechanic:toggle', function()
  if mechanic == -1 then
    TriggerClientEvent('blckhndr_jobs:mechanic:toggleduty', source)
    mechanic = source
  else
    if mechanic == source then
      TriggerClientEvent('blckhndr_jobs:mechanic:toggleduty', source)
      mechanic = -1
    else
      TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Már van szerelő szolgálatban!<br>Jelenlegi szerelő: <b>'..mechanic, 'centerRight', 4000, 'error')
    end
  end
end)
