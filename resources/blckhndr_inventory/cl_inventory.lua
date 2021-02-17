function invLog(str)
	SendNUIMessage({
		action = 'log',
		string = str
	})
end

--[[
	New inventory shit
]]--
RegisterCommand('inv', function() 
	TriggerEvent('blckhndr_inventory:gui:display', source)
end, false)
RegisterKeyMapping('inv', '[INVENTORY] Inventory', 'keyboard', 'f2')
local beingused = false
local firstInventory = {{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},}
local secondInventory_type = 'ply'
local secondInventory_id = 0
local secondInventory = {}
local isGunstore
function updateGUI()
	SendNUIMessage({
		action = 'update',
		inuse = beingused,
		first = firstInventory,
		second = secondInventory
	})
end

--[[
	Exports
]]--
local max_weight = 40
local secondInventory_limits = {
	["ply"] = 40,
	["trunk"] = 40,
	["glovebox"] = 20,
	--["glovebox"] = 20,
}

function blckhndr_CanCarry(item, amt, weight)
	if exports["blckhndr_police"]:blckhndr_PDDuty() then return true end -- no weight limit for cops, only slot limit
	if presetItems[item] and presetItems[item].data and presetItems[item].data.weight then
		local maff = presetItems[item].data.weight * amt
		if blckhndr_CurrentWeight() + maff <= max_weight then
			return true
		else
			return false
		end
	else
		if item and weight then
			local maff = weight * amt
			if blckhndr_CurrentWeight() + maff <= max_weight then
				return true
			else
				return false
			end
		else
			print('no weight data for '..item)
			return true
		end
	end
end
function blckhndr_CurrentWeight()
	local weight = 0
	for k,v in pairs(firstInventory) do 
		if v.index then
			if v.data and v.data.weight then
				 weight = weight + v.data.weight * v.amt
			end
		end
	end
	print('currently carrying '..weight)
	return weight
end
function blckhndr_HasItem(item)	
	for k,v in pairs(firstInventory) do
		if v.index == item then
			return true
		end
	end
	return false
end
function blckhndr_HasPhone()
	return blckhndr_HasItem('phone')
end
function blckhndr_GetItemAmount(item)
	local amt = 0
	for k,v in pairs(firstInventory) do
		if v.index == item then
			amt = amt + v.amt
		end
	end
	return amt
end
function blckhndr_GetItemDetails(item)
	return presetItems[item]
end
--[[
	Manage item data
]]--
RegisterNUICallback( "viewData", function(data, cb)
	data.slot = data.slot +1
	local strang = ''
	local index = 'default'
	local name = 'default'
	if data.inv == 'playerInventory' then
		local item = firstInventory[data.slot]
		if item then
			index = item.index
			name = item.name
			if item.data then
				strang = strang..'<h2>Item Data</h2>'
				for k, d in pairs(item.data) do
					strang = strang..'<p><span>'..k..':</span> '..d..'</p>'
				end
			end
			if item.customData then
				strang = strang..'<h2>Custom Data</h2>'
				for k, d in pairs(item.customData) do
					d = tostring(d)
					strang = strang..'<p><span>'..k..':</span> '..d..'</p>'
				end
			end
			
		end
	else
		local item = secondInventory[data.slot]
		if item then
			index = item.index
			name = item.name
			if item.data then
				strang = strang..'<h2>Item Data</h2>'
				for k, d in pairs(item.data) do
					strang = strang..'<p><span>'..k..':</span> '..d..'</p>'
				end
			end
			if item.customData then
				strang = strang..'<h2>Custom Data</h2>'
				for k, d in pairs(item.customData) do
					strang = strang..'<p><span>'..k..':</span> '..d..'</p>'
				end
			end
		end
	end
	SendNUIMessage({
		action = 'data',
		index = index,
		name = name,
		html = strang
	})
end)

--[[
	Gun Ownership
]]

local name = ''

AddEventHandler('blckhndr_main:character', function(character)
	name = character.char_fname..' '..character.char_lname
end)

function setItemOwner(shoptype , item)
	if item.customData ~= nil  then
		if item.index == 'WEAPON_STUNGUN' or item.customData.ammotype ~= 'none' then
			if secondInventory_type == 'store_gun' then
				item.customData.Serial = Util.MakeString(6)
				item.customData.Owner = name
			else -- set a dark market and call it here for the following to be used for serial and owner
				item.customData.Serial = 'Illegible'
				item.customData.Owner = 'UNKNOWN'
			end
		end
	end
end

function setItemPolice(armoryid , item)
	if item.customData ~= nil then
		print(item.customData.ammotype)
		print(item.index)
		if item.index == 'WEAPON_STUNGUN' or item.customData.ammotype ~= 'none' then
			item.customData.PDIssued = Util.MakeString(6)
			item.customData.Owner = 'Police: '..name
		end
	end
end

function blckhndr_setDevWeapon(item)
	print(item)
	if item.customData ~= nil then
		if item.index == 'weapon_stungun' or item.customData.ammotype ~= 'none' then
			item.customData.Serial = 'DEV GUN'
			item.customData.Owner = 'DEV: ' .. name
		end
	end
end

--[[
	End Gun Ownership
]]

--[[
	Manage slots
]]--
RegisterNUICallback( "dragToSlot", function(data, cb)
	-- store charging & stock handling.
	local using_store = false
	if secondInventory_type == 'store' or secondInventory_type == 'store_gun' then
		using_store = true
	end
	if using_store and data.fromInv == 'playerInventory' then
		if data.toInv == 'otherInventory' then
			invLog('<span style="color:red">Nem rakhatsz be valamit a boltba!</span>')
			return
		end
	elseif using_store and data.fromInv == 'otherInventory' then
		if data.toInv == 'otherInventory' then
			invLog('<span style="color:red">Nem rendezheted át a polcokat</span>')
			return
		end
		if secondInventory_type == 'store' then
			if secondInventory[data.fromSlot].data.price then
				if blckhndr_CanCarry(secondInventory[data.fromSlot].index, data.amt, secondInventory[data.fromSlot].data.weight) then
					if exports['blckhndr_main']:blckhndr_GetWallet() >= secondInventory[data.fromSlot].data.price then
						TriggerEvent('blckhndr_bank:change:walletMinus', tonumber(secondInventory[data.fromSlot].data.price * data.amt))
						-- remove item from store stock
						TriggerServerEvent('blckhndr_store:boughtOne', secondInventory_id, secondInventory[data.fromSlot].index)
						TriggerEvent('blckhndr_main:characterSaving')
					else
						exports['mythic_notify']:DoHudText('error', 'Nincs elég pénzed!')
						invLog('<span style="color:red">Nincs elég pénzed!</span>')
						return
					end
				else
					invLog('<span style="color:blue">Túl nehéz, próbáld meg az inventoryd súlyát csökkenteni</span>')
				end
			else
				invLog('<span style="color:red">Nincs ára, visszalépes</span>')
				return
			end
		end
		if secondInventory_type == 'store_gun' then
			data.amt = 1 -- only buy 1 at a time!
			if secondInventory[data.fromSlot].data.price then
				if blckhndr_CanCarry(secondInventory[data.fromSlot].index, data.amt, secondInventory[data.fromSlot].data.weight) then
					if exports['blckhndr_main']:blckhndr_GetWallet() >= secondInventory[data.fromSlot].data.price then
						TriggerEvent('blckhndr_bank:change:walletMinus', tonumber(secondInventory[data.fromSlot].data.price * data.amt))
						-- remove item from store stock
						TriggerServerEvent('blckhndr_store:boughtOne', secondInventory_id, secondInventory[data.fromSlot].index)
						setItemOwner(secondInventory_type, secondInventory[data.fromSlot])
						-- Maybe there is a better way to do this in order for serials to not duplicate when buying more than one gun in a session?
						-- For now this will do though
						TriggerServerEvent('blckhndr_store:closedStore', secondInventory_id)
						TriggerServerEvent('blckhndr_store:request', secondInventory_id, isGunstore)
						isGunstore = false
						-- Save the inventory on buying
						TriggerEvent('blckhndr_main:characterSaving')
					else
						exports['mythic_notify']:DoHudText('error', 'Nincs elég pénzed!')
						invLog('<span style="color:red">Nincs elég pénzed!</span>')
						return
					end
				else
					invLog('<span style="color:blue">Túl nehéz, próbáld meg az inventoryd súlyát csökkenteni</span>')
				end
			else
				invLog('<span style="color:red">Nincs ára, visszalépes</span>')
				return
			end
		end
	end
	if secondInventory_type == 'armories' then
		data.amt = 1 -- only buy 1 at a time!
		if secondInventory[data.fromSlot].amt then
			if blckhndr_CanCarry(secondInventory[data.fromSlot].index, data.amt, secondInventory[data.fromSlot].data.weight) then
				--if exports['blckhndr_main']:blckhndr_GetWallet() >= secondInventory[data.fromSlot].data.price then
					--TriggerEvent('blckhndr_bank:change:walletMinus', tonumber(secondInventory[data.fromSlot].data.price * data.amt))
					-- remove item from store stock
					TriggerServerEvent('blckhndr_police:armory:boughtOne', secondInventory_id, secondInventory[data.fromSlot].index)
					setItemPolice(secondInventory_id, secondInventory[data.fromSlot])
					-- Maybe there is a better way to do this in order for serials to not duplicate when buying more than one gun in a session?
					-- For now this will do though
					TriggerServerEvent('blckhndr_police:armory:closedArmory', secondInventory_id)
					TriggerEvent('blckhndr_police:armory:request', secondInventory_id)
					-- Save the inventory on buying
					TriggerEvent('blckhndr_main:characterSaving')
				--else
					--exports['mythic_notify']:DoHudText('error', 'You cannot afford this!')
					--invLog('<span style="color:red">You cannot afford this item</span>')
					--return
				--end
			else
				invLog('<span style="color:blue">Túl nehéz, próbáld meg az inventoryd súlyát csökkenteni</span>')
			end
		else
			invLog('<span style="color:red">Nincs ára, visszalépes</span>')
			return
		end
	end
	if data.toSlot == data.fromSlot and data.fromInv == data.toInv then
		invLog('<span style="color:red">Nem mozgathatod ezt oda</span>')
		return
	end
	if data.fromInv == 'playerInventory' then
		local oldSlot = firstInventory[data.fromSlot]
		if oldSlot.inuse then 
			invLog('<span style="color:red">Használat közben nem mozgathatod a fegyvert!</span>')
			return
		end
		if data.amt > oldSlot.amt or data.amt == -99 then
			data.amt = oldSlot.amt
		end
		if data.toInv == 'playerInventory' then	
			if firstInventory[data.toSlot].index then
				if firstInventory[data.toSlot].index ~= oldSlot.index then
					invLog('<span style="color:red">Ez a slot már foglalt</span>')
					return
				end
				if firstInventory[data.toSlot].customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
				if oldSlot.customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
			end
		else
			if secondInventory_limits[secondInventory_type] then
				-- check if it can carry
				local cur_weight = 0
				for k, v in ipairs(secondInventory) do
					if v.index ~= false and v.data and v.data.weight then
						local maff = v.data.weight * v.amt
						cur_weight = cur_weight + maff
					end
				end
				if oldSlot.data and oldSlot.data.weight then
					local new_maff = oldSlot.data.weight * data.amt
					local newer_maff = cur_weight + new_maff
					if newer_maff > secondInventory_limits[secondInventory_type] then
						invLog('<span style="color:red">Nincs több hely ebben az inventoryban: '..secondInventory_limits[secondInventory_type]..'</span>')
						return
					else
						invLog('Régi súly: '..cur_weight..' | Új súly: '..newer_maff..' | Added: '..new_maff..' ('..oldSlot.data.weight..' * '..data.amt..')')
					end
				end
			end
			if secondInventory[data.toSlot].index then
				if secondInventory[data.toSlot].index ~= oldSlot.index then
					invLog('<span style="color:red">A slot már foglalt</span>')
					return
				end
				if secondInventory[data.toSlot].customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
				if oldSlot.customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
			end
		end
		if data.amt == oldSlot.amt or data.amt == -99 then -- if moving all of item
			if data.toInv == 'playerInventory' then	
				-- moving all of the stack around in my inv
				if firstInventory[data.toSlot].index == oldSlot.index then
					firstInventory[data.toSlot].amt = firstInventory[data.toSlot].amt + oldSlot.amt
				else
					firstInventory[data.toSlot] = firstInventory[data.fromSlot]
				end
			else
				-- moving all of the stack to their inv
				if secondInventory[data.toSlot].index == oldSlot.index then
					secondInventory[data.toSlot].amt = secondInventory[data.toSlot].amt + oldSlot.amt
				else
					secondInventory[data.toSlot] = firstInventory[data.fromSlot]
				end
			end
			firstInventory[data.fromSlot] = {}
		else -- if moving part of the stack
			if data.toInv == 'playerInventory' then
				-- moving part of the stack around in my inv
				if firstInventory[data.toSlot].index == firstInventory[data.fromSlot].index then
					firstInventory[data.toSlot].amt = firstInventory[data.toSlot].amt + data.amt
				else
					firstInventory[data.toSlot] = {
						index = firstInventory[data.fromSlot].index,
						name = firstInventory[data.fromSlot].name,
						amt = data.amt,
						data = firstInventory[data.fromSlot].data,
						customData = firstInventory[data.fromSlot].customData,
					}
				end
				firstInventory[data.fromSlot].amt = firstInventory[data.fromSlot].amt - data.amt
			else
				-- moving part of the stack to their inv
				if secondInventory[data.toSlot].index == firstInventory[data.fromSlot].index then
					secondInventory[data.toSlot].amt = secondInventory[data.toSlot].amt + data.amt
				else
					secondInventory[data.toSlot] = {
						index = firstInventory[data.fromSlot].index,
						name = firstInventory[data.fromSlot].name,
						amt = data.amt,
						data = firstInventory[data.fromSlot].data,
					}
				end
				firstInventory[data.fromSlot].amt = firstInventory[data.fromSlot].amt - data.amt
			end
		end
	elseif data.fromInv == 'otherInventory' then
		-- moving something from their inv
		local oldSlot = secondInventory[data.fromSlot]
		if oldSlot.inuse then 
			invLog('<span style="color:red">Használat közben nem mozgathatod a fegyvert!</span>')
			return
		end
		if data.amt > oldSlot.amt then
			data.amt = oldSlot.amt
		end
		if data.toInv == 'playerInventory' then
			if data.amt == oldSlot.amt or data.amt == -99 then -- moving entire stack
				if not blckhndr_CanCarry(oldSlot.index, oldSlot.amt) then
					invLog('<span style="color:red">Nem viheted ezt!</span>')
					return
				end
				
				local cur_weight = 0
				for k, v in pairs(firstInventory) do
					if v.index ~= false and v.data and v.data.weight then
						local maff = v.data.weight * v.amt
						cur_weight = cur_weight + maff
					end
				end
				if oldSlot.data and oldSlot.data.weight and not exports["blckhndr_police"]:blckhndr_PDDuty() then
					local new_maff = oldSlot.data.weight * oldSlot.amt
					local newer_maff = cur_weight + new_maff
					if newer_maff > max_weight then
						invLog('<span style="color:red">A tároló nem bír ennél többet: 30</span>')
						return
					else
						invLog('Old weight: '..cur_weight..' | New weight: '..newer_maff..' | Added: '..new_maff..' ('..oldSlot.data.weight..' * '..data.amt..')')
					end
				end
			else	
				if not blckhndr_CanCarry(oldSlot.index, data.amt) then
					invLog('<span style="color:red">Nem viheted ezt</span>')
					return
				end
				
				local cur_weight = 0
				for k, v in pairs(firstInventory) do
					if v.index ~= false and v.data and v.data.weight then
						local maff = v.data.weight * v.amt
						cur_weight = cur_weight + maff
					end
				end
				if oldSlot.data and oldSlot.data.weight and not exports["blckhndr_police"]:blckhndr_PDDuty() then
					local new_maff = oldSlot.data.weight * data.amt
					local newer_maff = cur_weight + new_maff
					if newer_maff > max_weight then
						invLog('<span style="color:red">A tároló nem bír ennél többet: 30</span>')
						return
					else
						invLog('Old weight: '..cur_weight..' | New weight: '..newer_maff..' | Added: '..new_maff..' ('..oldSlot.data.weight..' * '..data.amt..')')
					end
				end
			end
			if firstInventory[data.toSlot].index then
				if firstInventory[data.toSlot].index ~= oldSlot.index then
					invLog('<span style="color:red">A slot foglalt</span>')
					return
				end
				if firstInventory[data.toSlot].customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
				if oldSlot.customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
			end
		else
			if secondInventory[data.toSlot].index then
				if secondInventory[data.toSlot].index ~= oldSlot.index then
					invLog('<span style="color:red">A slot foglalt</span>')
					return
				end
				if secondInventory[data.toSlot].customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
				if oldSlot.customData then
					invLog('<span style="color:red"Nem rakhatod egy slotra a custom tárgyakat</span>')
					return
				end
			end
		end
		if data.amt == oldSlot.amt or data.amt == -99 then -- if moving all of item
			if data.toInv == 'playerInventory' then	
				-- moving all of item to my inv
				if firstInventory[data.toSlot].index == oldSlot.index then
					firstInventory[data.toSlot].amt = firstInventory[data.toSlot].amt + oldSlot.amt
				else
					firstInventory[data.toSlot] = secondInventory[data.fromSlot]
				end
			else
				-- moving all of item to somewhere else in their inv
				if secondInventory[data.toSlot].index == oldSlot.index then
					secondInventory[data.toSlot].amt = secondInventory[data.toSlot].amt + oldSlot.amt
				else
					secondInventory[data.toSlot] = secondInventory[data.fromSlot]
				end
			end
			secondInventory[data.fromSlot] = {}
		else -- if moving part of the stack
			if data.toInv == 'playerInventory' then
				-- moving part of the stack to my inv
				if firstInventory[data.toSlot].index == secondInventory[data.fromSlot].index then
					firstInventory[data.toSlot].amt = firstInventory[data.toSlot].amt + data.amt
				else
					firstInventory[data.toSlot] = {
						index = secondInventory[data.fromSlot].index,
						name = secondInventory[data.fromSlot].name,
						amt = data.amt,
						customData = secondInventory[data.fromSlot].customData,
					}
					if secondInventory[data.fromSlot].data and secondInventory[data.fromSlot].data.weight then
						if not firstInventory[data.toSlot].data then firstInventory[data.toSlot].data = {} end
						firstInventory[data.toSlot].data.weight = secondInventory[data.fromSlot].data.weight
					end
				end
				secondInventory[data.fromSlot].amt = secondInventory[data.fromSlot].amt - data.amt
			else
				-- moving part of the stack around in their inv
				if secondInventory[data.toSlot].index == secondInventory[data.fromSlot].index then
					secondInventory[data.toSlot].amt = secondInventory[data.toSlot].amt + data.amt
				else
					secondInventory[data.toSlot] = {
						index = secondInventory[data.fromSlot].index,
						name = secondInventory[data.fromSlot].name,
						amt = data.amt,
					}
				end
				secondInventory[data.fromSlot].amt = secondInventory[data.fromSlot].amt - data.amt
			end
		end
	else
		exports['mythic_notify']:DoCustomHudText('error', 'Inventory ('..data.fromInv..') nem található!', 4000)
	end
	--if player send them update
	if secondInventory_type == 'ply' and secondInventory_id ~= 0 then
		TriggerServerEvent('blckhndr_inventory:ply:update', secondInventory_id, secondInventory)
	end
	-- send server vehicle update
	if secondInventory_type == 'trunk' or secondInventory_type == 'glovebox' then
		TriggerServerEvent('blckhndr_inventory:veh:update', secondInventory_type, secondInventory_id, secondInventory)
	end
	if secondInventory_type == 'apt' then
		TriggerEvent('blckhndr_apartments:inv:update', secondInventory)
	end
	if secondInventory_type == 'prop' then
		TriggerEvent('blckhndr_properties:inv:update', secondInventory)
	end
	updateGUI()
end)

RegisterNUICallback("dropSlot", function(data, cb)
	if data.fromInv ~= 'playerInventory' then
		invLog('<span style="color:red">Csak az inventorydból dobhatsz el itemeket</span>')
		return
	end
	local slot = firstInventory[data.fromSlot]
	if data.amt >= slot.amt or data.amt == -99 then
		data.amt = slot.amt
	end
	if data.amt == slot.amt then
		-- start dropping -- 
		local coords = GetEntityCoords(PlayerPedId())
		local xyz = {x=coords.x, y=coords.y, z=coords.z}
		TriggerServerEvent('blckhndr_inventory:drops:drop', xyz, slot)
		-- end dropping --
		firstInventory[data.fromSlot] = {}
		updateGUI()
	else
		local item = {
			index=firstInventory[data.fromSlot].index,
			name=firstInventory[data.fromSlot].name,
			amt=data.amt,
			data = firstInventory[data.fromSlot].data,
			customData = firstInventory[data.fromSlot].customData
		}
		firstInventory[data.fromSlot].amt = firstInventory[data.fromSlot].amt - data.amt
		-- start dropping -- 
		local coords = GetEntityCoords(PlayerPedId())
		local xyz = {x=coords.x, y=coords.y, z=coords.z}
		TriggerServerEvent('blckhndr_inventory:drops:drop', xyz, item)
		-- end dropping --
		updateGUI()
	end
end)

RegisterNUICallback("useSlot", function(data, cb)
	while invBusy do Citizen.Wait(1); print('invBusy') end
	if data.fromInv ~= 'playerInventory' then
		invLog('<span style="color:red">Csak az inventorydból dobhatsz el itemeket</span>')
		return
	end
	invBusy = true
	local slot = firstInventory[data.fromSlot]
	if slot.index then
		if itemUses[slot.index] then
			toggleGUI()
			Citizen.Wait(100)
			itemUses[slot.index].use(slot)
			if itemUses[slot.index].takeItem then
				if firstInventory[data.fromSlot].amt ~= 1 then
					firstInventory[data.fromSlot].amt = firstInventory[data.fromSlot].amt-1
				else
					firstInventory[data.fromSlot] = {}
				end
				exports['mythic_notify']:DoHudText('success', 'Elhasználtál 1: '..slot.name)
				updateGUI()
			else
				exports['mythic_notify']:DoHudText('success', 'Elhasználtál: '..slot.name)
			end
		else
			invLog('<span style="color:red">Ezt a tárgyat nem használhatod</span>')
			exports['mythic_notify']:DoHudText('error', 'Ezt a tárgyat nem használhatod')
			invBusy = false
			return
		end
	end
	invBusy = false
end)

--[[
	Manage GUI
]]--
local gui = false
function toggleGUI()
	if gui then
		if secondInventory_type == 'ply' and secondInventory_id ~= 0 then
			TriggerServerEvent('blckhndr_inventory:ply:finished', secondInventory_id)
		end
		if secondInventory_type == 'trunk' or secondInventory_type == 'glovebox' then
			TriggerServerEvent('blckhndr_inventory:veh:finished', secondInventory_id)
			if secondInventory_type == 'trunk' then
				ExecuteCommand('d c 5')
			end
		end
		if secondInventory_type == 'prop' then
			TriggerEvent('blckhndr_properties:inv:closed', secondInventory_id)
		end
		if secondInventory_type == 'pd_locker' then
			TriggerServerEvent('blckhndr_inventory:locker:save', secondInventory)
		end
		if secondInventory_type == 'store_gun' then
			TriggerServerEvent('blckhndr_store:closedStore', secondInventory_id)
		end
		if secondInventory_type == 'armories' then
			TriggerServerEvent('blckhndr_police:armory:closedArmory', secondInventory_id)
		end
		if secondInventory_type == 'store' then
			TriggerServerEvent('blckhndr_store:closedStore', secondInventory_id)
		end
		secondInventory_type = 'ply'
		secondInventory_id = 0
		secondInventory = {}
		SetNuiFocus( false )
		SendNUIMessage({
			action = 'display',
			val = false
		})
		gui = false
	else
		SetNuiFocus( true, true )
		SendNUIMessage({
			action = 'display',
			val = true
		})
		updateGUI()
		gui = true
	end
end
RegisterNetEvent('blckhndr_inventory:gui:display')
AddEventHandler('blckhndr_inventory:gui:display', function()
	toggleGUI()
end)
RegisterNUICallback( "closeGUI", function(data, cb)
	toggleGUI()
end)
RegisterNetEvent('blckhndr_inventory:me:update')
AddEventHandler('blckhndr_inventory:me:update', function(tbl)
	firstInventory = tbl
	updateGUI()
end)
--[[
	Manage second inventory
]]--
RegisterNetEvent('blckhndr_inventory:ply:request')
AddEventHandler('blckhndr_inventory:ply:request', function(to)
	if beingused then
		exports['mythic_notify']:DoHudText('error', 'Az inventoryd nem használható, mert más használja.')
	else
		beingused = true
		updateGUI()
		TriggerServerEvent('blckhndr_inventory:sys:send', to, firstInventory)
	end
end)
RegisterNetEvent('blckhndr_inventory:ply:done')
AddEventHandler('blckhndr_inventory:ply:done', function()
	beingused = false
	updateGUI()
end)
RegisterNetEvent('blckhndr_inventory:ply:recieve')
AddEventHandler('blckhndr_inventory:ply:recieve', function(from, tbl)
	secondInventory_type = 'ply'
	secondInventory_id = from
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received inventory from Player('..from..')')
end)
RegisterNetEvent('blckhndr_inventory:veh:trunk:recieve')
AddEventHandler('blckhndr_inventory:veh:trunk:recieve', function(plate, tbl)
	secondInventory_type = 'trunk'
	secondInventory_id = plate
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received trunk from Vehicle('..plate..')')
	ExecuteCommand('d o 5')
end)
RegisterNetEvent('blckhndr_inventory:veh:glovebox:recieve')
AddEventHandler('blckhndr_inventory:veh:glovebox:recieve', function(plate, tbl)
	secondInventory_type = 'glovebox'
	secondInventory_id = plate
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received glovebox from Vehicle('..plate..')')
end)
RegisterNetEvent('blckhndr_inventory:apt:recieve')
AddEventHandler('blckhndr_inventory:apt:recieve', function(id, tbl)
	secondInventory_type = 'apt'
	secondInventory_id = id
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received inventory from Apartment('..id..')')
end)
RegisterNetEvent('blckhndr_inventory:prop:recieve')
AddEventHandler('blckhndr_inventory:prop:recieve', function(id, tbl)
	secondInventory_type = 'prop'
	secondInventory_id = id
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received inventory from Property('..id..')')
end)
RegisterNetEvent('blckhndr_inventory:pd_locker:recieve')
AddEventHandler('blckhndr_inventory:pd_locker:recieve', function(id, tbl)
	secondInventory_type = 'pd_locker'
	secondInventory_id = id
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received inventory from pd_locker('..id..')')
end)
RegisterNetEvent('blckhndr_inventory:store_gun:recieve')
AddEventHandler('blckhndr_inventory:store_gun:recieve', function(storeid, tbl)
	secondInventory_type = 'store_gun'
	secondInventory_id = storeid
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received data from gunstore('..storeid..')')
end)

RegisterNetEvent('blckhndr_inventory:store:recieve')
AddEventHandler('blckhndr_inventory:store:recieve', function(storeid, tbl, gunstore)
	if not gunstore then
		secondInventory_type = 'store'
		secondInventory_id = storeid
		secondInventory = tbl
		isGunstore = false
		updateGUI()
		if not gui then
			toggleGUI()
		end
		invLog('received data from store('..storeid..')')
		print('your basic ass store bby')
	elseif gunstore then
		secondInventory_type = 'store_gun'
		secondInventory_id = storeid
		secondInventory = tbl
		isGunstore = true
		updateGUI()
		if not gui then
			toggleGUI()
		end
		invLog('received data from gunstore('..storeid..')')
		print('Gun store bby')
	end
end)

RegisterNetEvent('blckhndr_inventory:police_armory:recieve')
AddEventHandler('blckhndr_inventory:police_armory:recieve', function(armoryid, tbl)
	print(armoryid)
	secondInventory_type = 'armories'
	secondInventory_id = armoryid
	secondInventory = tbl
	updateGUI()
	if not gui then
		toggleGUI()
	end
	invLog('received data from armories('..armoryid..')')
end)

--[[
	Manage items
]]--
RegisterNetEvent('blckhndr_inventory:item:take')
AddEventHandler('blckhndr_inventory:item:take', function(item, amt)
	print(':blckhndr_inventory: removing '..amt..' '..item)
	local taken = 0
	for k, v in pairs(firstInventory) do
		if taken < amt then
			local remaining = amt - taken 
			if v.index ~= false then
				if v.index == item then
					print(':blckhndr_inventory: '..v.amt..' '..v.index..' in slot '..k)
					if v.amt == remaining then
						-- take all out of 1 slot
						taken = taken + v.amt
						firstInventory[k] = {index=false}
					elseif v.amt > remaining then
						taken = taken + remaining
						firstInventory[k].amt = firstInventory[k].amt - remaining
					elseif v.amt < remaining then
						taken = taken + firstInventory[k].amt
						firstInventory[k] = {index=false}
					end
				end
			end
		end
	end
	exports['mythic_notify']:DoHudText('inform', 'Taken: '..taken..' '..item)
	updateGUI()
end)
RegisterNetEvent('blckhndr_inventory:items:add')
AddEventHandler('blckhndr_inventory:items:add', function(item)
	local placed = false
	if item.data and item.data.weight then
		local maff = item.data.weight * item.amt
		if blckhndr_CurrentWeight() + maff <= max_weight then
		else
			exports['mythic_notify']:DoHudText('error', 'Nem bírod el:'..item.amt..': '..item.name)
			return
		end
	end
	if blckhndr_CanCarry(item.index, item.amt) then
		for k, slot in pairs(firstInventory) do
			if not placed then 
				if slot.index then
					if not slot.customData then
						if not item.customData then
							if slot.index == item.index then
								firstInventory[k].amt = firstInventory[k].amt + item.amt
								placed = true
							end
						end
					end	
				else
					firstInventory[k] = item
					placed = true
				end
			end
		end
	else
		exports['mythic_notify']:DoHudText('error', 'Nem bírod el:'..item.amt..': '..item.name)
	end
	if not placed then
		exports['mythic_notify']:DoHudText('error', 'Nincs szabad slotod!')
		
		-- start dropping -- 
		local coords = GetEntityCoords(PlayerPedId())
		local xyz = {x=coords.x, y=coords.y, z=coords.z}
		TriggerServerEvent('blckhndr_inventory:drops:drop', xyz, item)
		-- end dropping --
	else
		exports['mythic_notify']:DoHudText('inform', 'Kaptál '..item.amt..' '..item.name)
	end
	updateGUI()
end)
RegisterNetEvent('blckhndr_inventory:items:addPreset')
AddEventHandler('blckhndr_inventory:items:addPreset', function(item, amt)
	if presetItems[item] then
		local insert = presetItems[item]
		insert.amt = amt
		if insert.customData ~= nil then
			if insert.customData.weapon == 'true' then
				blckhndr_setDevWeapon(insert)
				TriggerEvent('blckhndr_inventory:items:add', insert)
			end
		else
			TriggerEvent('blckhndr_inventory:items:add', insert)
		end
	else
		for k,v in pairs(presetItems) do
		print('please')
		end
		exports['mythic_notify']:DoHudText('error', 'Item preset '..item..' seems to be missing')
	end
end)
RegisterNetEvent('blckhndr_inventory:item:add')
AddEventHandler('blckhndr_inventory:item:add', function(item, amount)
	print('legacy adding: '..amount..' '..item)
	TriggerEvent('blckhndr_inventory:items:addPreset', item, amount)
end)

RegisterNetEvent('blckhndr_inventory:items:emptyinv')
AddEventHandler('blckhndr_inventory:items:emptyinv', function()
	firstInventory = {{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},}	
end)

--[[
	CONVERT OLD INV / GIVE ID CARD ON FIRST JOIN
]]--
intiiated = false
function init(charTbl)
	local inventory	= json.decode(charTbl.char_inventory)
	if inventory.firstSpawned == true then
		-- you have the new inv very nice
		firstInventory = inventory.table
		for k, v in pairs(firstInventory) do
			if firstInventory[k].inuse then
				firstInventory[k].inuse = false
			end
		end
		intiiated = true
	else
		firstInventory = {{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},{index=false},}
		Citizen.Wait(500)
		TriggerEvent('blckhndr_licenses:giveID')
		intiiated = true
	end
end
AddEventHandler('blckhndr_main:character', function(charTbl)
	init(charTbl)
end)
--[[
	saving :)
]]--
RegisterNetEvent('blckhndr_main:characterSaving')
AddEventHandler('blckhndr_main:characterSaving', function()	
	if intiiated then
		print(':blckhndr_inventory: [INFO] Saving inventory')
		local inv = {
			firstSpawned = true,
			table = firstInventory,
		}
		TriggerServerEvent('blckhndr_inventory:database:update', inv)
	else
		print(':blckhndr_inventory: [ERROR] Your inventory was not initiated so cannot save.')
	end	
end)


--[[
	Weapons as items
]]--
local currentWeapon = false
local currentHotkey = false
Util.Tick(function()HideHudComponentThisFrame(19,true);DisableControlAction(0, 37, true);end)

function equipWeapon(item, key)
	if invBusy then Citizen.Wait(1);print'invBusy'; end
	invBusy = true
	if item and item.index and not item.inuse then
		RemoveAllPedWeapons(PlayerPedId())
		print(item.index)
		GiveWeaponToPed(PlayerPedId(), GetHashKey(item.index), item['customData'].ammo, 1, 0)
		SetCurrentPedWeapon(PlayerPedId(), item.index, 0)
		
		currentWeapon = item
		currentHotkey = key
		firstInventory[key].inuse = true

		RequestAnimDict("rcmjosh4")
		while not HasAnimDictLoaded("rcmjosh4") do Citizen.Wait(1) end
		RequestAnimDict("reaction@intimidation@cop@unarmed")
		while not HasAnimDictLoaded("reaction@intimidation@cop@unarmed") do Citizen.Wait(1) end

		DisablePlayerFiring(PlayerPedId(), true)
		SetPedCurrentWeaponVisible(PlayerPedId(), 1, 1, 1, 1)
		TaskPlayAnim(PlayerPedId(), "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		Citizen.Wait(800)
		DisablePlayerFiring(PlayerPedId(), false)
		ClearPedTasks(PlayerPedId())
		TriggerServerEvent('blckhndr_main:logging:addLog', GetPlayerServerId(PlayerId()), 'weapons', 'Player('..GetPlayerServerId(PlayerId())..') equipped '..item.index..' with '..item['customData'].ammo..' ammo.')
		TriggerEvent('blckhndr_evidence:weaponInfo', item.customData)
	else
		if firstInventory[currentHotkey].inuse == false then
			exports['mythic_notify']:DoHudText('error', 'Slot '..currentHotkey..' nem üres! Csatlakozz ujra, hogy használhasd az inventoryd!')
			invBusy = false
			return
		end
		local weapon, hash = GetCurrentPedWeapon(PlayerPedId(), 1)
        if(weapon) then
            local _,ammoInClip = GetAmmoInClip(PlayerPedId(), hash)
            local totalAmmo = GetAmmoInPedWeapon(PlayerPedId(), hash)
            currentWeapon['customData'].ammo = totalAmmo
        else
        	currentWeapon['customData'].ammo = 0
        	exports['mythic_notify']:DoHudText('error', 'Fegyver nem talalható.')
        end

		RemoveAllPedWeapons(PlayerPedId())

		ResetPedMovementClipset(PlayerPedId()) -- cant remember why im resetting this
		ResetPedStrafeClipset(PlayerPedId()) -- cant remember why im resetting this
		ResetPedWeaponMovementClipset(PlayerPedId()) -- cant remember why im resetting this
		ClearPedTasksImmediately(PlayerPedId()) -- cant remember why im resetting this

		GiveWeaponToPed(PlayerPedId(), '2725352035', 0, 1, 0)
		SetCurrentPedWeapon(PlayerPedId(), '2725352035', 0)
		
		TriggerServerEvent('blckhndr_main:logging:addLog', GetPlayerServerId(PlayerId()), 'weapons', 'Player('..GetPlayerServerId(PlayerId())..') holstered '..currentWeapon.index..' with '..currentWeapon['customData'].ammo..' ammo.')

		firstInventory[currentHotkey].inuse = false

		currentWeapon = false
		currentHotkey = false
	end
	invBusy = false
end


--[[
	Hotkeys
]]--
local hotkeys = {
	157, -- number 1
	158, -- number 2
	160, -- number 3
	164, -- number 4
	165  -- number 5
}
local ammo_table = {
	'ammo_pistol',
	'ammo_shotgun',
	'ammo_rifle',
	'ammo_smg',
	'ammo_pistol_large',
	'ammo_shotgun_large',
	'ammo_rifle_large',
	'ammo_smg_large'
}
local lastTab = 0

function handleHotkeys( number )
		local used_item = firstInventory[number]
		--[[if currentWeapon then
			-- if weapon is equipped, put it away
			equipWeapon(false,number)
			return
		end]]
		if used_item and used_item.index ~= false then
			if Util.TableHasValue(ammo_table, used_item.index) then
				-- it is an ammo
				itemUses[used_item.index].use(used_item)
			elseif used_item['customData'] and used_item['customData'].weapon then
				-- it is a weapon
				if currentWeapon then
					-- if weapon is equipped, put it away
					equipWeapon(false,number)
					return
				end
				if used_item['customData'].ammo and used_item['customData'].ammotype and used_item['customData'].quality then
					equipWeapon(used_item, number)
				else
					exports['mythic_notify']:DoHudText('error', 'ERROR: Old weapon')
					return
				end
			else
				if currentWeapon then
					-- if weapon is equipped, put it away
					equipWeapon(false,number)
					return
				end
				-- is not ammo is not weapon
				if itemUses[used_item.index] then
					itemUses[used_item.index].use(used_item)
					if itemUses[used_item.index].takeItem then
						if firstInventory[number].amt ~= 1 then
							firstInventory[number].amt = firstInventory[number].amt-1
						else
							firstInventory[number] = {}
						end
						exports['mythic_notify']:DoHudText('success', 'Használtál 1: '..used_item.name)
						updateGUI()
					else
						exports['mythic_notify']:DoHudText('success', 'Használtál: '..used_item.name)
					end
				else
					invLog('<span style="color:red">Ez a tárgy nem használható</span>')
					exports['mythic_notify']:DoHudText('error', 'Ez a tárgy nem használható')
					return
				end
			end
		else
			invLog('<span style="color:red">Hiányzó item</span>')
			exports['mythic_notify']:DoHudText('error', 'Hiányzó item')
			return
		end
end

Util.Tick(function()
	if IsDisabledControlJustPressed(0,37) then
		if lastTab+500 > GetGameTimer() then
			toggleGUI()
			lastTab=0
		else
			local itms = {}
			local count = 1
			for k, v in ipairs(firstInventory) do
				if count < 6 then	
					itms[count] = v
					count = count + 1
				end
			end
			SendNUIMessage({
				actionbar = true,
				display = true,
				items = itms
			})
		end
		lastTab = GetGameTimer()
	end
	if IsDisabledControlJustReleased(0,37) then
		SendNUIMessage({
			actionbar = true,
			display = false,
		})
	end
	if not beingused and not gui then -- cant use if gui is open or someone else is using inv
		for number, control in pairs(hotkeys) do
			if IsControlJustReleased(1, control) or IsDisabledControlJustReleased(1, control) then
				handleHotkeys(number)
			end
		end
	end
end)

ammoTypes = {
    {
        name = 'ammo_pistol',
        weapons = {
            'WEAPON_PISTOL',
            'WEAPON_APPISTOL',
			'WEAPON_SNSPISTOL',
            'WEAPON_COMBATPISTOL',
            'WEAPON_HEAVYPISTOL',
            'WEAPON_MACHINEPISTOL',
            'WEAPON_MARKSMANPISTOL',
            'WEAPON_PISTOL50',
            'WEAPON_VINTAGEPISTOL'
        },
        count = 30
    },
    {
        name = 'ammo_pistol_large',
        weapons = {
            'WEAPON_PISTOL',
            'WEAPON_APPISTOL',
			'WEAPON_SNSPISTOL`',
            'WEAPON_COMBATPISTOL',
            'WEAPON_HEAVYPISTOL',
            'WEAPON_MACHINEPISTOL',
            'WEAPON_MARKSMANPISTOL',
            'WEAPON_PISTOL50',
            'WEAPON_VINTAGEPISTOL'
        },
        count = 60
    },
	{
        name = 'ammo_shotgun',
        weapons = {
            'WEAPON_ASSAULTSHOTGUN',
	    	'WEAPON_AUTOSHOTGUN',
            'WEAPON_BULLPUPSHOTGUN',
	    	'WEAPON_DBSHOTGUN',
            'WEAPON_HEAVYSHOTGUN',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_SAWNOFFSHOTGUN'
        },
        count = 12
    },
	{
        name = 'ammo_shotgun_large',
        weapons = {
            'WEAPON_ASSAULTSHOTGUN',
	    	'WEAPON_AUTOSHOTGUN',
            'WEAPON_BULLPUPSHOTGUN',
	    	'WEAPON_DBSHOTGUN',
            'WEAPON_HEAVYSHOTGUN',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_SAWNOFFSHOTGUN'
        },
        count = 18
    },
	{
        name = 'ammo_smg',
        weapons = {
            'WEAPON_ASSAULTSMG',
	    	'WEAPON_MICROSMG',
            'WEAPON_MINISMG',
            'WEAPON_SMG'
        },
        count = 45
    },
	{
        name = 'ammo_smg_large',
        weapons = {
            'WEAPON_ASSAULTSMG',
	    	'WEAPON_MICROSMG',
            'WEAPON_MINISMG',
            'WEAPON_SMG'
        },
        count = 65
    },
	{
        name = 'ammo_rifle',
        weapons = {
            'WEAPON_ADVANCEDRIFLE',
	    	'WEAPON_ASSAULTRIFLE',
            'WEAPON_BULLPUPRIFLE',
            'WEAPON_CARBINERIFLE',
	    	'WEAPON_SPECIALCARBINE',
	    	'WEAPON_COMPACTRIFLE'
        },
        count = 45
    },
	{
        name = 'ammo_rifle_large',
        weapons = {
            'WEAPON_ADVANCEDRIFLE',
	    	'WEAPON_ASSAULTRIFLE',
            'WEAPON_BULLPUPRIFLE',
            'WEAPON_CARBINERIFLE',
	    	'WEAPON_SPECIALCARBINE',
	    	'WEAPON_COMPACTRIFLE'
        },
        count = 65
    },
	{
        name = 'ammo_sniper',
        weapons = {
            'WEAPON_SNIPERRIFLE',
	    	'WEAPON_HEAVYSNIPER',
            'WEAPON_MARKSMANRIFLE'
        },
        count = 10
    },
	{
        name = 'ammo_sniper_large',
        weapons = {
            'WEAPON_SNIPERRIFLE',
	    	'WEAPON_HEAVYSNIPER',
            'WEAPON_MARKSMANRIFLE'
        },
        count = 15
	}
}

RegisterNetEvent('blckhndr_inventory:useAmmo')
AddEventHandler('blckhndr_inventory:useAmmo', function(ammoType)
	
	local playerPed = PlayerPedId()
	local weapon

	--print(ammoType)

	local found, currentWeapon = GetCurrentPedWeapon(playerPed, true)
	--print(currentWeapon)
	if found then
		for _, ammo in pairs(ammoTypes) do
			--print(ammo)
			for _, w in pairs (ammo.weapons) do
				if currentWeapon == GetHashKey(w) then
					weapon = w
					break
				else
					weapon = nil
				end
			end
			if ammoType == ammo.name then
				addAmmo = ammo.count
				break
			end
		end

		--print(addAmmo)
		--print(weapon)

		if weapon ~= nil then
			local pedAmmo = GetAmmoInPedWeapon(playerPed, weapon)
			local newAmmo = pedAmmo + addAmmo

			ClearPedTasks(playerPed)

			local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
			if newAmmo < maxAmmo then
				TaskReloadWeapon(playerPed)
				SetPedAmmo(playerPed, weapon, newAmmo)
				TriggerEvent('blckhndr_inventory:item:take', ammoType, 1)
				exports['mythic_notify']:DoCustomHudText('success', 'Ujratöltve')

			else
				exports['mythic_notify']:DoCustomHudText('error', 'Max Ammo')
			end
		else
			exports['mythic_notify']:DoCustomHudText('error', 'Rossz ammo típus!')
		end
	end
end)