Citizen.CreateThread(function()
  while true do
    Citizen.Wait( 0 )
    HideHudComponentThisFrame( 14 ) -- Crosshair
  end
end)

-- blckhndr_main:gui:money:changeAmount
-- blckhndr_main:gui:money:addMoney
-- blckhndr_main:gui:bank:changeAmount
-- blckhndr_main:gui:bank:addMoney
-- blckhndr_main:gui:minusMoney
-- blckhndr_main:gui:bank:minusMoney
-- blckhndr_main:gui:money:display
-- blckhndr_main:gui:bank:display


RegisterNetEvent('blckhndr_main:gui:both:display')
AddEventHandler('blckhndr_main:gui:both:display', function(money, bank)
  SendNUIMessage({
    type = 'gui',
    display = 'both',
    moneyAmount = money,
    bankAmount = bank
  })
end)

RegisterNetEvent('blckhndr_main:gui:money:change')
AddEventHandler('blckhndr_main:gui:money:change', function(money, change)
  SendNUIMessage({
    type = 'gui',
    display = 'moneyChange',
    moneyAmount = money,
    changeAmount = change
  })
end)

RegisterNetEvent('blckhndr_main:gui:bank:change')
AddEventHandler('blckhndr_main:gui:bank:change', function(bank, change)
  SendNUIMessage({
    type = 'gui',
    display = 'bankChange',
    bankAmount = bank,
    changeAmount = change
  })
end)
