fx_version 'bodacious'
games { 'gta5' }

author 'iTzCrutchie'
description 'Activities for the server'
version '0.0.1'

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

    -- Yoga
    'yoga/client.lua',

}