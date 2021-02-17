local evidence = {}

RegisterServerEvent('blckhndr_evidence:request')
AddEventHandler('blckhndr_evidence:request', function()
	TriggerClientEvent('blckhndr_evidence:receive', source, evidence)
end)

RegisterServerEvent('blckhndr_evidence:collect')
AddEventHandler('blckhndr_evidence:collect', function(id)
	local e = evidence[id]
	if e then
		TriggerClientEvent('blckhndr_evidence:display', source, e)
		evidence[id] = nil
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Ez a nyom már eltünt.' })
	end
	TriggerClientEvent('blckhndr_evidence:receive', -1, evidence)
end)

RegisterServerEvent('blckhndr_evidence:destroy')
AddEventHandler('blckhndr_evidence:destroy', function(id)
	local e = evidence[id]
	if e then
		evidence[id] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Elpusztítottad a nyomot!' })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Ez a nyom már eltünt.' })
	end
	TriggerClientEvent('blckhndr_evidence:receive', -1, evidence)
end)

-- evidence dropping
RegisterServerEvent('blckhndr_evidence:drop:casing')
AddEventHandler('blckhndr_evidence:drop:casing', function(wep,loc)
	--print('adding casing('..wep.ammoType..') for weapon '..wep.name..' at '..loc.x..','..loc.y..','..loc.z)
	evidence[#evidence+1] = {
		e_type = 'casing',
		loc = loc,
		details = {
			ammoType = wep.ammotype,
			serial = wep.Serial,
			owner = wep.Owner
		},
		expire = os.time() + 300,
	}
	--print(wep.Serial)
	--TriggerClientEvent('blckhndr_evidence:receive', -1, evidence)
end)

RegisterServerEvent('blckhndr_evidence:drop:blood')
AddEventHandler('blckhndr_evidence:drop:blood', function(charid,loc)
	--print('adding casing('..wep.ammoType..') for weapon '..wep.name..' at '..loc.x..','..loc.y..','..loc.z)
	evidence[#evidence+1] = {
		e_type = 'blood',
		loc = loc,
		details = {
			dnastring = charid
		},
		expire = os.time() + 300,
	}
	--TriggerClientEvent('blckhndr_evidence:receive', -1, evidence)
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(1000)
		if #evidence > 1 then
			for k, e in pairs(evidence) do
				if e.expire <= os.time() then
					print(k..' has expired')
					evidence[k] = nil
				end
			end
			TriggerClientEvent('blckhndr_evidence:receive', -1, evidence)
		end
	end
end)