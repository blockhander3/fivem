RegisterServerEvent('blckhndr_bank:database:update')
AddEventHandler('blckhndr_bank:database:update', function(charid, wallet, bank)
  if bank ~= false then
    MySQL.Sync.execute("UPDATE blckhndr_characters SET char_bank=@bank WHERE char_id=@char_id", {['@char_id'] = charid, ['@bank'] = bank})
  end
  if wallet ~= false then
    MySQL.Sync.execute("UPDATE blckhndr_characters SET char_money=@wallet WHERE char_id=@char_id", {['@char_id'] = charid, ['@wallet'] = wallet})
  end
  --else
  --  MySQL.Sync.execute("UPDATE blckhndr_characters SET char_money=@wallet, char_bank=@bank WHERE char_id=@char_id", {['@char_id'] = charid, ['@wallet'] = wallet, ['@bank'] = bank})
  --end
end)

RegisterServerEvent('blckhndr_bank:transfer')
AddEventHandler('blckhndr_bank:transfer', function(receive, amount)
  if GetPlayerName(receive) then
    TriggerClientEvent('blckhndr_bank:change:bankAdd', receive, amount)
    TriggerClientEvent('blckhndr_bank:change:bankMinus', source, amount)
  else
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'We cannot find this account!', 'centerRight', 4000, 'error')
  end
end)
