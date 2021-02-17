--[[/ :FSN: \]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/ :FSN: \]]--

client_script 'client.lua'
client_script 'dispatch.lua'
server_script 'server.lua'

client_script 'radar/client.lua'
client_script 'dispatch/client.lua'
client_script 'pedmanagement/client.lua'
client_script 'evidencelocker/client.lua'
client_script 'cl_volunteering.lua'

client_script 'armory/cl_armory.lua'
server_script 'armory/sv_armory.lua'

client_script 'MDT/mdt_client.lua'
server_script 'MDT/mdt_server.lua'
ui_page 'MDT/gui/index.html'

client_script 'tackle/client.lua'
server_script 'tackle/server.lua'

client_script 'K9/client.lua'
server_script 'K9/server.lua'

files({
  'MDT/gui/index.html',
  'MDT/gui/index.css',
  'MDT/gui/index.js',
  'MDT/gui/images/base_pc.png',
  'MDT/gui/images/win_icon.png',
  'MDT/gui/images/background.png',
  'MDT/gui/images/icons/booking.png',
  'MDT/gui/images/icons/cpic.png',
  'MDT/gui/images/icons/dmv.png',
  'MDT/gui/images/icons/warrants.png',
  'MDT/gui/images/pwr_icon.png'
})

server_script 'evidencelocker/server.lua'

exports({
  'blckhndr_getIllegalItems',
  'blckhndr_PDDuty',
  'blckhndr_getPDLevel',
  'blckhndr_getCopAmt'
})
