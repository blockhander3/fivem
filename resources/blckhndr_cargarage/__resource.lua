--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

ui_page 'gui/ui.html'

client_script 'client.lua'
server_script 'server.lua'

files({
  'gui/ui.css',
  'gui/ui.html',
  'gui/ui.js'
})

exports({
  'blckhndr_IsVehicleOwner',
  'blckhndr_GetVehicleVehIDP',
  'blckhndr_SpawnVehicle',
  'blckhndr_IsVehicleOwnerP',
  'getCarDetails'
})
