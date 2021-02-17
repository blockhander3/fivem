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

client_scripts {
	'cl_gangs.lua',
}

server_scripts {
	'sv_gangs.lua',
}