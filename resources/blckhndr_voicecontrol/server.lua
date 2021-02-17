local cur_channel = 0
RegisterServerEvent('blckhndr_voicecontrol:call:ring')
AddEventHandler('blckhndr_voicecontrol:call:ring', function(ringnum, ringingnum)
  local ring = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  if ring ~= 0 then
    TriggerClientEvent('blckhndr_voicecontrol:call:ring', ring, ringingnum)
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Ringing #'..ringnum..'...', 'centerRight', 8000, 'info' )
  else
    TriggerClientEvent('blckhndr_voicecontrol:call:end', source)
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'No player found with this phone number!', 'centerRight', 5000, 'error' )
  end
end)

RegisterServerEvent('blckhndr_voicecontrol:call:answer')
AddEventHandler('blckhndr_voicecontrol:call:answer', function(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  cur_channel = cur_channel+1
  TriggerClientEvent('blckhndr_voicecontrol:call:start', source, cur_channel)
  TriggerClientEvent('blckhndr_voicecontrol:call:start', ringing, cur_channel)
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Call connected (C:'..cur_channel..')', 'centerRight', 5000, 'success' )
  TriggerClientEvent('blckhndr_notify:displayNotification', ringing, 'Call connected (C:'..cur_channel..')', 'centerRight', 5000, 'success' )
end)

RegisterServerEvent('blckhndr_voicecontrol:call:decline')
AddEventHandler('blckhndr_voicecontrol:call:decline', function(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('blckhndr_voicecontrol:call:end', source)
  TriggerClientEvent('blckhndr_voicecontrol:call:end', ringing)
  TriggerClientEvent('blckhndr_notify:displayNotification', ringing, 'Call was declined', 'centerRight', 5000, 'error' )
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Call declined', 'centerRight', 5000, 'info' )
end)

RegisterServerEvent('blckhndr_voicecontrol:call:hold')
AddEventHandler('blckhndr_voicecontrol:call:hold', function(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('blckhndr_voicecontrol:call:hold', source, true)
  TriggerClientEvent('blckhndr_voicecontrol:call:hold', ringing, false)
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Call placed on hold', 'centerRight', 5000, 'info' )
  TriggerClientEvent('blckhndr_notify:displayNotification', ringing, 'Call is now on hold', 'centerRight', 5000, 'info' )
end)

RegisterServerEvent('blckhndr_voicecontrol:call:unhold')
AddEventHandler('blckhndr_voicecontrol:call:unhold', function(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('blckhndr_voicecontrol:call:unhold', source)
  TriggerClientEvent('blckhndr_voicecontrol:call:unhold', ringing)
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Call now active', 'centerRight', 5000, 'info' )
  TriggerClientEvent('blckhndr_notify:displayNotification', ringing, 'Call is now active', 'centerRight', 5000, 'info' )
end)


RegisterServerEvent('blckhndr_voicecontrol:call:end')
AddEventHandler('blckhndr_voicecontrol:call:end', function(ringnum)
  local ringing = exports.blckhndr_main:blckhndr_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('blckhndr_voicecontrol:call:end', source)
  TriggerClientEvent('blckhndr_voicecontrol:call:end', ringing)
  TriggerClientEvent('blckhndr_notify:displayNotification', ringing, 'Call was ended', 'centerRight', 5000, 'error' )
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Call ended', 'centerRight', 5000, 'error' )
end)