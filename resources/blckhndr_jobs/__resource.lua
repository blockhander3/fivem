--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

--[[/	:Globals:	\]]--
client_scripts { 
  '@blckhndr_main/cl_utils.lua',
  '@blckhndr_main/server_settings/sh_settings.lua'
}
server_scripts { 
  '@blckhndr_main/sv_utils.lua',
  '@blckhndr_main/server_settings/sh_settings.lua',
  '@mysql-async/lib/MySQL.lua'
}
--[[/	:Globals:	\]]--
--[[/	:FSN:	\]]--

client_scripts { 

--[[/   :Main:  \]]--
'client.lua',
--[[/   :Main:  \]]--

'whitelists/client.lua',
'mechanic/client.lua',
'mechanic/mechmenu.lua',
'trucker/client.lua',
'hunting/client.lua',
'farming/client.lua',
'scrap/client.lua',
'taxi/client.lua',
'garbage/client.lua',

'tow/client.lua',
--'delivery/client.lua'
}

server_scripts { 

--[[/ :Main:  \]]--
'server.lua',
--[[/ :Main:  \]]--

'whitelists/server.lua',
'mechanic/server.lua',
'taxi/server.lua',
'tow/server.lua',
}

exports {
'blckhndr_GetJob',
'blckhndr_SetJob',

-- [WHITELIST THINGS]
'isWhitelisted',
'getWhitelistDetails',
'inAnyWhitelist',
'toggleWhitelistClock',
'isWhitelistClockedIn',
'addToWhitelist'
}

server_export 'isPlayerClockedInWhitelist'