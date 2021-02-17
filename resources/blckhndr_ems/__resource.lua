--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

client_script 'client.lua'
client_script 'cl_advanceddamage.lua'
client_script 'cl_volunteering.lua'
client_script 'cl_carrydead.lua'
client_script 'beds/client.lua'
client_script 'blip.lua'

server_script 'server.lua'
server_script 'sv_carrydead.lua'
server_script 'beds/server.lua'

exports({
  'blckhndr_IsDead',
  'blckhndr_EMSDuty',
  'blckhndr_getEMSLevel',
  'blckhndr_Airlift',
  'ems_isBleeding',
  'isCrouching',
  'carryingWho'
})