local lock = false
local droppedItems = {}

RegisterNetEvent('blckhndr_inventory:drops:request')
AddEventHandler('blckhndr_inventory:drops:request', function()
	TriggerClientEvent('blckhndr_inventory:drops:send', source, droppedItems)
end)

RegisterNetEvent('blckhndr_inventory:drops:collect')
AddEventHandler('blckhndr_inventory:drops:collect', function(id)
	local start = os.time()
	while lock do
		Citizen.Wait(1)
		if os.time() >= start+300 then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Inventory időtúllépés...,' })
			print'tablelocktimeout'
			break
		end
	end
	if not lock then
		lock = true
		if droppedItems[id] then
			TriggerClientEvent('blckhndr_inventory:items:add', source, droppedItems[id].item)
			
			droppedItems[id] = nil
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'A tárgy már nincs itt, talán más felvette?' })
		end
		TriggerClientEvent('blckhndr_inventory:drops:send', -1, droppedItems)
		lock = false
	else
		print 'something broke the lock script'
	end
end)

RegisterNetEvent('blckhndr_inventory:drops:drop')
AddEventHandler('blckhndr_inventory:drops:drop', function(xyz, it)
	local start = os.time()
	while lock do
		Citizen.Wait(1)
		if os.time() >= start+300 then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Inventory időtúllépés...,' })
			print'tablelocktimeout'
			break
		end
	end
	if not lock then
		droppedItems[#droppedItems+1] = {
			loc = xyz,
			item = it
		}
		--Citizen.Wait(500)
		TriggerClientEvent('blckhndr_inventory:drops:send', -1, droppedItems)
	end
end)