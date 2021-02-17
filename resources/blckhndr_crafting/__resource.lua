--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

ui_page "nui/index.html"
files {
	"nui/index.html",
	"nui/index.css",
	"nui/index.js",
}


client_script 'client.lua'
server_script 'server.lua'
