function blckhndr_SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
AddEventHandler('chatMessage', function(source, auth, msg)
	local split = blckhndr_SplitString(string.lower(msg), ' ')
	local origSplit = blckhndr_SplitString(msg, ' ')
	--if split[1] == '/getinv' then
	--	TriggerClientEvent('blckhndr_inventory:ply:request', tonumber(split[2]), source)
	--end
	if split[1] == '/inv' then
		
	end
end)



RegisterServerEvent('blckhndr_inventory:sys:request')
AddEventHandler('blckhndr_inventory:sys:request', function(to, from)
	TriggerClientEvent('blckhndr_inventory:ply:request', to, from)
end)

RegisterServerEvent('blckhndr_inventory:sys:send')
AddEventHandler('blckhndr_inventory:sys:send', function(to, tbl)
	print('got inventory from '..source..' for '..to)
	TriggerClientEvent('blckhndr_inventory:ply:recieve', to, source, tbl)
end)

RegisterServerEvent('blckhndr_inventory:ply:update')
AddEventHandler('blckhndr_inventory:ply:update', function(to, tbl)
	TriggerClientEvent('blckhndr_inventory:me:update', to, tbl)
end)

RegisterServerEvent('blckhndr_inventory:ply:finished')
AddEventHandler('blckhndr_inventory:ply:finished', function(ply)
	TriggerClientEvent('blckhndr_inventory:ply:done', ply)
end)

RegisterServerEvent('blckhndr_licenses:id:display')
AddEventHandler('blckhndr_licenses:id:display', function(plytbl, name, job, dob, issue, id)
	for _, ply in pairs(plytbl) do
		TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6*-----------------------------------------------------------')
		TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 '..name..' | '..job..' | '..dob..'/születési dátum | '..issue..'/ok')
		if id then
			TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 CharID: '..id..' | ServerID: '..source)
		else
			TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 ServerID: '..source)
			TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 Ez az ID hibás, kérj a városházán másikat')
		end
		TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6*-----------------------------------------------------------')
	end
end)