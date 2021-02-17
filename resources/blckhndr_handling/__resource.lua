--[[/	:FSN:	\]]--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script '@blckhndr_main/cl_utils.lua'
server_script '@blckhndr_main/sv_utils.lua'
client_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@blckhndr_main/server_settings/sh_settings.lua'
server_script '@mysql-async/lib/MySQL.lua'
--[[/	:FSN:	\]]--

dependency "blckhndr_builders"
blckhndr_handling "src/muscle.lua"
blckhndr_handling "src/compact.lua"
blckhndr_handling "src/coupes.lua"
blckhndr_handling "src/sports.lua"
blckhndr_handling "src/suvs.lua"
blckhndr_handling "src/sportsclassics.lua"
blckhndr_handling "src/offroad.lua"
blckhndr_handling "src/vans.lua"
blckhndr_handling "src/sedans.lua"
blckhndr_handling "src/government.lua"
blckhndr_handling "src/super.lua"
--blckhndr_handling "src/motorcycles.lua"

files { 'out/handling.meta', 'data/handling.meta' }
data_file 'HANDLING_FILE' 'out/handling.meta'
data_file 'HANDLING_FILE' 'data/handling.meta'
