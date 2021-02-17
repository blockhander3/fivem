--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

client_script 'gui_manager.lua'

client_script 'facial/client.lua'
client_script 'tattoos/config.lua'
client_script 'tattoos/client.lua'

server_script 'facial/server.lua'
server_script 'tattoos/server.lua'

export 'GetPreviousTattoos'
export 'GetTattooCategory'

ui_page 'gui/ui.html'

files({
  'gui/ui.html',
  'gui/ui.css',
  'gui/ui.js'
})