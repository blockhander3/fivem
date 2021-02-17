policelevel = 0

--[[
    Armory
]]

local armories = {
    ['lspd_armory'] = {
        id = 'lspd_armory',
        busy = false,
        stock = {},
    },
    ['paleto_armory'] = {
        id = 'paleto_armory',
        busy = false,
        stock = {},
    },
    ['bcso_armory'] = {
        id = 'bcso_armory',
        busy = false,
        stock = {},
    },
}


local recruitStock = {
    weapon_stungun          = {amt = 999, price = 1},
    weapon_flare            = {amt = 999, price = 1},
    weapon_nightstick       = {amt = 999, price = 1},
    weapon_flashlight       = {amt = 999, price = 1},
    weapon_fireextinguisher = {amt = 999, price = 1},
    armor                   = {amt = 999, price = 1},
}

local officerStock = {
    weapon_stungun          = {amt = 999, price = 1},
    weapon_flare            = {amt = 999, price = 1},
    weapon_nightstick       = {amt = 999, price = 1},
    weapon_flashlight       = {amt = 999, price = 1},
    weapon_fireextinguisher = {amt = 999, price = 1},
    weapon_pistol           = {amt = 999, price = 1},
    armor                   = {amt = 999, price = 1},
    ammo_pistol             = {amt = 999, price = 1},
    ammo_pistol_large       = {amt = 999, price = 1},
    ammo_shotgun            = {amt = 999, price = 1},
    ammo_shotgun_large      = {amt = 999, price = 1},
    ammo_rifle              = {amt = 999, price = 1},
    ammo_rifle_large        = {amt = 999, price = 1},
    scuba_gear              = {amt = 999, price = 1},
}

local sergeantStock = {
    weapon_stungun          = {amt = 999, price = 1},
    weapon_flare            = {amt = 999, price = 1},
    weapon_nightstick       = {amt = 999, price = 1},
    weapon_flashlight       = {amt = 999, price = 1},
    weapon_fireextinguisher = {amt = 999, price = 1},
    weapon_pistol           = {amt = 999, price = 1},
    weapon_carbinerifle     = {amt = 999, price = 1},
    weapon_pumpshotgun      = {amt = 999, price = 1},
    armor                   = {amt = 999, price = 1},
    ammo_pistol             = {amt = 999, price = 1},
    ammo_pistol_large       = {amt = 999, price = 1},
    ammo_shotgun            = {amt = 999, price = 1},
    ammo_shotgun_large      = {amt = 999, price = 1},
    ammo_rifle              = {amt = 999, price = 1},
    ammo_rifle_large        = {amt = 999, price = 1},
    scuba_gear              = {amt = 999, price = 1},

}



local items = {}


RegisterNetEvent('blckhndr_police:armory:request')
AddEventHandler('blckhndr_police:armory:request', function(armory_id, policelevel)
    --local policelevel = policelevel
    print(items)
    local a = armories[armory_id]
    if a then
        if a.busy == false then
            local inv = {}
            a.busy = source
            if policelevel == 1 then
                for k, s in pairs(recruitStock) do
                    if items[k] then
                        local item = items[k]
                        
                        if item.data then
                            item.data.price = s.price
                        else
                            item.data = {price=s.price}
                        end

                        item.amt = s.amt

                        item.data.weight = items[k].data.weight
                        
                        table.insert(inv, #inv+1, item)
                    else
                        print('ERROR (blckhndr_police) :: Tárgy: '..k..' nincs megadva a server.lua-ban')
                    end
                end

                TriggerClientEvent('blckhndr_inventory:police_armory:recieve', source, armory_id, inv)

            elseif policelevel <= 4 then
                for k, s in pairs(officerStock) do
                    if items[k] then
                        local item = items[k]
                            
                        if item.data then
                            item.data.price = s.price
                        else
                            item.data = {price=s.price}
                        end

                        item.amt = s.amt

                        item.data.weight = items[k].data.weight
                            
                        table.insert(inv, #inv+1, item)
                    else
                        print('ERROR (blckhndr_police) :: Tárgy: '..k..' nincs megadva a server.lua-ban')
                    end  
                end

                TriggerClientEvent('blckhndr_inventory:police_armory:recieve', source, armory_id, inv)

            elseif policelevel >=5 then
                for k, s in pairs(sergeantStock) do
                    if items[k] then
                        local item = items[k]
                    
                        if item.data then
                            item.data.price = s.price
                        else
                            item.data = {price=s.price}
                        end

                        item.amt = s.amt

                        item.data.weight = items[k].data.weight
                    
                        table.insert(inv, #inv+1, item)
                    else
                        print('ERROR (blckhndr_police) :: Tárgy: '..k..' nincs megadva a server.lua-ban')
                    end
                end

                print(inv)
                TriggerClientEvent('blckhndr_inventory:police_armory:recieve', source, armory_id, inv)

            end
        else
            TriggerClientEvent('blckhndr_notify:displayNotification', source, 'A tároló már használatban van egy másik játékos által: '..a.busy, 'centerRight', 8000, 'error')
        end
    else
        TriggerClientEvent('blckhndr_notify:displayNotification', source, 'HIBA: Ez a tároló nem létezik', 'centerRight', 8000, 'error')
    end
end)

RegisterServerEvent('blckhndr_police:armory:boughtOne')
AddEventHandler('blckhndr_police:armory:boughtOne', function(armory_id, item)
	local a = armories[armory_id]
	if a then
		--if armories[armory_id]['stock'][item] then
			--stores[store_id]['stock'][item].amt = stores[store_id]['stock'][item].amt - 1
			--TriggerEvent('blckhndr_main:logging:addLog', source, 'weapons', '[GUNSTORE] Player('..source..') purchased '..item..' from '..store_id)
		--else
			--TriggerClientEvent('blckhndr_notify:displayNotification', source, 'ERROR: This store does not have that item - please speak to a developer', 'centerRight', 8000, 'error')
		--end
	else
		TriggerClientEvent('blckhndr_notify:displayNotification', source, 'HIBA: Ez a tároló nem létezik', 'centerRight', 8000, 'error')
	end
end)

RegisterServerEvent('blckhndr_police:armory:closedArmory')
AddEventHandler('blckhndr_police:armory:closedArmory', function(armory_id)
	local a = armories[armory_id]
	if a then
		a.busy = false
	else 
		TriggerClientEvent('blckhndr_notify:displayNotification', source, 'HIBA: Ez a tároló nem létezik', 'centerRight', 8000, 'error')
	end
end)

RegisterNetEvent('blckhndr_police:armory:recieveItemsForArmory')
AddEventHandler('blckhndr_police:armory:recieveItemsForArmory', function(presetItems)
    items = presetItems
end)

AddEventHandler('playerDropped', function()
	for k,v in pairs(armories) do
		if v.busy == source then
			v.busy = false
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^6' .. resourceName .. ' elindult. Recieving presetItems for stock^0')
    TriggerEvent('blckhndr_inventory:sendItemsToArmory')
  end)

--[[
    End Events
]]