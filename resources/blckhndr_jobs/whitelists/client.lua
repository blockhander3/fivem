local myCharID = 0
local Whitelists = {}

function isWhitelisted(groupid)
	local _wl = Whitelists[groupid]
	local _me = exports['blckhndr_main']:blckhndr_CharID()
	
	if _wl.owner == _me then -- or table.contains(_wl.access, _me) then
		print(_me..' is whitelisted in '.._wl.title..' (owned by: '.._wl.owner..')')
		return true
	else
		for k, v in pairs(_wl.access) do
			if v.charid == _me then
				print(_me..' is whitelisted in '.._wl.title..' (owned by: '.._wl.owner..')')
				return true
			end
		end
		print(_me..' is not whitelisted in '.._wl.title..' (owned by: '.._wl.owner..')')
		return false
	end
end

function getWhitelistDetails(groupid)
	TriggerServerEvent('blckhndr_jobs:whitelist:request')
	return Whitelists[groupid]
end

function inAnyWhitelist()
	local myWhitelists = {}
	for k, _wl in pairs(Whitelists) do
		if isWhitelisted(k) then
			table.insert(myWhitelists, #myWhitelists+1, k)
		end
	end
	if myWhitelists == {} then
		return false
	else
		return myWhitelists
	end
end

function addToWhitelist(wlid, charid, level)
	if Whitelists[wlid].owner == exports["blckhndr_main"]:blckhndr_CharID() then
		if level > 0 then
			TriggerServerEvent('blckhndr_jobs:whitelist:add', wlid, charid, level)
			exports['mythic_notify']:DoCustomHudText('inform', 'Adding '..charid..' to '..Whitelists[wlid].title..' at '..level, 4000)
		else
			TriggerServerEvent('blckhndr_jobs:whitelist:remove', wlid, charid)
			exports['mythic_notify']:DoCustomHudText('inform', 'Removing '..charid..' from '..Whitelists[wlid].title, 4000)
		end
	else
		exports['mythic_notify']:DoCustomHudText('error', 'ERROR: WL owned by '..Whitelists[wlid].owner, 4000)
	end
end 

----------------------------------------------
-- CLOCKIN SHIT
----------------------------------------------
local current_clockid = 0
function toggleWhitelistClock(id)
	print('toggling clock for id '..id)
	if current_clockid == 0 then
		-- not clocked in
		TriggerServerEvent('blckhndr_jobs:whitelist:clock:in', exports["blckhndr_main"]:blckhndr_CharID(), id)
	else
		-- is clocked in 
		TriggerServerEvent('blckhndr_jobs:whitelist:clock:out', exports["blckhndr_main"]:blckhndr_CharID(), current_clockid)
	end
end
function isWhitelistClockedIn(id)
	if current_clockid == id then
		return true
	else
		return false
	end
end

RegisterNetEvent('blckhndr_jobs:whitelist:clock:in')
AddEventHandler('blckhndr_jobs:whitelist:clock:in', function(id)
	
	current_clockid = id

	--[[
	Set your whitelists ids here for example whitelist id 1 is PDM 2 is mechanic etc etc. 
	This can be found in the whitelists/server.lua and your database under blckhndr_whitelists
	]]--
	if current_clockid == 1 then
		blckhndr_SetJob('CarDealer')
	
	elseif current_clockid == 2 then
		blckhndr_SetJob("Mechanic")
	
	elseif current_clockid == 3 then
		blckhndr_SetJob('Rancher')
	
	elseif current_clockid == 4 then
		blckhndr_SetJob('BoatDealer')
	end

end)
RegisterNetEvent('blckhndr_jobs:whitelist:clock:out')
AddEventHandler('blckhndr_jobs:whitelist:clock:out', function()
	current_clockid = 0

	blckhndr_SetJob('Unemployed')

end)

RegisterNetEvent('blckhndr_jobs:whitelist:update')
AddEventHandler('blckhndr_jobs:whitelist:update', function(tbl)
	Whitelists = tbl
end)

TriggerServerEvent('blckhndr_jobs:whitelist:request')