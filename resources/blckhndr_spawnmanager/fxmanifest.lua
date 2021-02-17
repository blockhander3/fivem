fx_version 'adamant'
games { 'gta5' }

--[[/	:FSN:	\]]--
client_scripts { 
    '@blckhndr_main/cl_utils.lua',
    '@blckhndr_main/server_settings/sh_settings.lua'
}
server_scripts { 
    '@blckhndr_main/sv_utils.lua',
    '@blckhndr_main/server_settings/sh_settings.lua',
    '@mysql-async/lib/MySQL.lua'
}
--[[/	:FSN:	\]]--

ui_page 'nui/index.html'
files {
    'nui/index.html',
    'nui/index.css',
    'nui/index.js',
}

client_scripts {
	'client.lua',
}