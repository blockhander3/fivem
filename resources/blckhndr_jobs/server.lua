Citizen.CreateThread(function()
  while true do
    Citizen.Wait(600000)
    print(':blckhndr_jobs: Paycheck time babies')
    TriggerClientEvent('blckhndr_jobs:paycheck', -1)
  end
end)
