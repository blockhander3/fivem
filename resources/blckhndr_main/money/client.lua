local wallet = 0
local bank = 0

function blckhndr_GetWallet()
	return wallet
end

function blckhndr_GetBank()
	return bank
end

function blckhndr_CanAfford(amt)
	return wallet >= amt
end

RegisterNetEvent('blckhndr_main:money:updateSilent')
AddEventHandler('blckhndr_main:money:updateSilent', function(cash, balance)
	wallet = cash
	bank = balance
end)

RegisterNetEvent('blckhndr_main:money:update')
AddEventHandler('blckhndr_main:money:update', function(cash, balance)
	wallet = cash
	bank = balance
	Citizen.Wait(500)
	TriggerEvent('blckhndr_main:gui:both:display', cash, balance)
end)

AddEventHandler('blckhndr_bank:request:both', function()
  TriggerEvent('blckhndr_bank:update:both', wallet, bank)
end)

RegisterNetEvent('blckhndr_main:displayBankandMoney')
AddEventHandler('blckhndr_main:displayBankandMoney', function()
	Citizen.Wait(500)
	TriggerEvent('blckhndr_main:gui:both:display', wallet, bank)
end)

RegisterNetEvent('blckhndr_police:search:start:money')
AddEventHandler('blckhndr_police:search:start:money', function(officerid)
  TriggerServerEvent('blckhndr_police:search:end:money', officerid, {wallet=wallet,bank=bank})
end)

AddEventHandler('blckhndr_bank:change:bankandwallet', function(cash, balance)
  if wallet == false then
	TriggerServerEvent('blckhndr_main:money:wallet:Set', GetPlayerServerId(PlayerId()), wallet)
  else
    TriggerServerEvent('blckhndr_main:money:wallet:Set', GetPlayerServerId(PlayerId()), cash)
  end
  if bank == false then
	TriggerServerEvent('blckhndr_main:money:bank:Set', GetPlayerServerId(PlayerId()), bank)
  else
	TriggerServerEvent('blckhndr_main:money:bank:Set', GetPlayerServerId(PlayerId()), balance)
  end
end)

RegisterNetEvent('blckhndr_bank:change:walletAdd')
RegisterNetEvent('blckhndr_bank:change:walletMinus')
AddEventHandler('blckhndr_bank:change:walletAdd', function(amt)
	TriggerServerEvent('blckhndr_main:money:wallet:Add', GetPlayerServerId(PlayerId()), amt)
	Citizen.Wait(500)
	TriggerEvent('blckhndr_main:gui:money:change', wallet, amt)
end)

AddEventHandler('blckhndr_bank:change:walletMinus', function(amt)
  TriggerServerEvent('blckhndr_main:money:wallet:Minus', GetPlayerServerId(PlayerId()), amt)
  Citizen.Wait(500)
  -- TODO: Investigate if -1 * amt can be used (check if amt is ever a string)
  amt = tonumber('-'..amt)
  TriggerEvent('blckhndr_main:gui:money:change', wallet, amt)
end)

RegisterNetEvent('blckhndr_bank:change:bankAdd')
RegisterNetEvent('blckhndr_bank:change:bankMinus')
AddEventHandler('blckhndr_bank:change:bankAdd', function(amt)
	TriggerServerEvent('blckhndr_main:money:bank:Add', GetPlayerServerId(PlayerId()), amt)
	Citizen.Wait(500)
	TriggerEvent('blckhndr_main:gui:bank:change', bank, amt)
end)

AddEventHandler('blckhndr_bank:change:bankMinus', function(amt)
	TriggerServerEvent('blckhndr_main:money:bank:Minus', GetPlayerServerId(PlayerId()), amt)
	Citizen.Wait(500)
  -- TODO: Investigate if -1 * amt can be used (check if amt is ever a string)
	amt = tonumber('-'..amt)
	TriggerEvent('blckhndr_main:gui:bank:change', current_character.char_bank, amt)
end)

-------------------------------------------- LSCustoms
-- TODO: Move to LSCutsoms?
AddEventHandler("blckhndr_lscustoms:check",function(title, data, cost, value)
  if wallet >= cost then
    TriggerEvent("blckhndr_lscustoms:receive", source, title, data, value)
    TriggerEvent('blckhndr_bank:change:walletMinus', cost)
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'You cannot afford this!', 'centerLeft', 3000, 'error')
  end
end)

AddEventHandler("blckhndr_lscustoms:check2", function(title, data, cost, value, back)
  if wallet >= cost then
    TriggerEvent("blckhndr_lscustoms:receive2", source, title, data, value, back)
    TriggerEvent('blckhndr_bank:change:walletMinus', cost)
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'You cannot afford this!', 'centerLeft', 3000, 'error')
  end
end)

AddEventHandler("blckhndr_lscustoms:check3",function(title, data, cost, mod, back, name, wtype)
  if wallet >= cost then
    TriggerEvent("blckhndr_lscustoms:receive3", source, title, data, mod, back, name, wtype)
    TriggerEvent('blckhndr_bank:change:walletMinus', cost)
  else
    TriggerEvent('blckhndr_notify:displayNotification', 'You cannot afford this!', 'centerLeft', 3000, 'error')
  end
end)