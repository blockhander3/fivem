--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

client_script 'cl_carstore.lua'
client_script 'cl_menu.lua'
server_script 'vehshop_server.lua'
server_script 'sv_carstore.lua'

export 'ShowVehshopBlips'

