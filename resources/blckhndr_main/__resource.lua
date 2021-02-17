resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

--client_script "debug/cl_subframetime.js"
--client_script "debug/sh_scheduler.lua"
--server_script "debug/sh_scheduler.lua"
client_script 'server_settings/sh_settings.lua'
client_script "debug/sh_debug.lua"
server_script "debug/sh_debug.lua"
-- Client scripts
client_script "cl_utils.lua"
client_script 'initial/client.lua'
client_script 'money/client.lua'
client_script 'hud/client.lua'
client_script 'hud/playerhud.lua'
client_script 'playermanager/client.lua'
client_script 'misc/exports.lua'
client_script 'misc/blips.lua'
client_script 'misc/weapondrop.lua'
client_script 'misc/servername.lua'
client_script 'misc/shitlordjumping.lua'
client_script 'misc/timer.lua'

-- gui stuffs
ui_page 'gui/index.html'
files({
  'gui/index.html',
  'gui/index.js',
  'gui/motd.txt',
  'gui/logo.png',
  'gui/spin.js',
  'gui/pdown.ttf'
})

-- Server scripts
server_script '@mysql-async/lib/MySQL.lua'
server_script 'misc/db.lua'
server_script 'server_settings/sh_settings.lua'
server_script 'initial/server.lua'
server_script 'money/server.lua'
server_script 'playermanager/server.lua'
server_script 'misc/logging.lua'
server_script 'misc/version.lua'
server_script 'banmanager/sv_bans.lua'


-- exports
exports {
	"blckhndr_GetWallet",
	"blckhndr_GetBank",
	"blckhndr_CanAfford",
	"blckhndr_CharID",
	"blckhndr_FindNearbyPed",
	"blckhndr_FindPedNearbyCoords",
	"blckhndr_GetTime",
	"blckhndr_GetCharacterInfo",
	"blckhndr_CharNamesF",
	"blckhndr_CharNamesL",
	"blckhndr_GetPlayerPhoneNumber"
}
server_export 'blckhndr_GetPlayerFromCharacterId'
server_export 'blckhndr_GetCharacterInfo'
server_export 'blckhndr_CharInfos'
server_export 'blckhndr_GetPlayerFromPhoneNumber'
server_export 'blckhndr_GetPlayerPhoneNumber'
server_export 'blckhndr_CharID'
server_export 'blckhndr_CharNamesF'
server_export 'blckhndr_CharNamesL'
server_export 'blckhndr_GetWallet'
server_export 'blckhndr_GetBank'