local boat_spots = {
	[1] =  {x = 1342.5803222656, y = 4269.5932617188, z = 29.407333374023, h = 164.64520263672,  boat = {} }, 
	[2] =  {x = 1326.9340820312, y = 4271.9135742188, z = 29.932802200317, h = 188.7762298584,  boat = {} }, 
}

local boats = {
		{name = "Dinghy 4 Seater", costs = 85000, rentalprice = 17000, description = {}, model = "dinghy"},
		{name = "SeaShark", costs = 15000, rentalprice = 3000, description = {}, model = "seashark"},
		{name = "SeaShark Yacht", costs = 18000, rentalprice = 32000, description = {}, model = "seashark3"},
		{name = "Speeder", costs = 105000, rentalprice = 21000, description = {}, model = "speeder"},
		{name = "Squalo", costs = 110000, rentalprice = 22000, description = {}, model = "squalo"},
		{name = "SunTrap", costs = 75000, rentalprice = 15000, description = {}, model = "suntrap"},
		{name = "Toro", costs = 150000, rentalprice = 30000, description = {}, model = "Toro"},
		{name = "Toro Yacht", costs = 155000, rentalprice = 31000, description = {}, model = "Toro2"},
		{name = "Tropic", costs = 175000, rentalprice = 35000, description = {}, model = "tropic"},
		{name = "Tropic Yacht", costs = 178000, rentalprice = 35600, description = {}, model = "tropic2"},
		{name = "Dinghy 2 Seater", costs = 90000, rentalprice = 18000, description = {}, model = "dinghy2"},
		{name = "Jetmax", costs = 140000, rentalprice = 28000, description = {}, model = "jetmax"},
		{name = "Marquis", costs = 250000, rentalprice = 100000, description = {}, model = "marquis"},
		
}

RegisterServerEvent('blckhndr_boatshop:floor:Request')
AddEventHandler('blckhndr_boatshop:floor:Request', function()
	--local i = 1
	for k, v in pairs(boat_spots) do
		if not v.boat.model then
			local boat = boats[math.random(1, #boats)]
			-- no vehicle is set, adding default value!
			v.boat = { model = boat.model, name = boat.name, buyprice = boat.costs, rentalprice = boat.rentalprice, commission = 15, color = {math.random(1, 159),math.random(1,159)}, object = false, updated = false }
			print(':blckhndr_boatstore: setting boat '..k..' to '..boat.model)
			--i = i+1
		end
	end
	
	TriggerClientEvent('blckhndr_boatshop:floor:Update', source, boat_spots)
end)

function WorksAtStore(id)
	return exports["blckhndr_jobs"]:isPlayerClockedInWhitelist(id, 4)
end
AddEventHandler('chatMessage', function(source, auth, msg)
	local split = Util.SplitString(msg, ' ')
	if WorksAtStore(source) then
		if split[1] == '/comm' then
			if tonumber(split[2]) and tonumber(split[2]) <= 30 and tonumber(split[2]) > 0 then
				TriggerClientEvent('blckhndr_boatshop:floor:commission', source, tonumber(split[2]))
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Usage: /comm {number: 0-30}' })
			end
		end
		if split[1] == '/color1' then
			if tonumber(split[2]) and tonumber(split[2]) <= 159 and tonumber(split[2]) > 0 then
				TriggerClientEvent('blckhndr_boatshop:floor:color:One', source, tonumber(split[2]))
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Usage: /color1 {number: 0-159}' })
			end
		end
		if split[1] == '/color2' then
			if tonumber(split[2]) and tonumber(split[2]) <= 159 and tonumber(split[2]) > 0 then
				TriggerClientEvent('blckhndr_boatshop:floor:color:Two', source, tonumber(split[2]))
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Usage: /color2 {number: 0-159}' })
			end
		end
		if split[1] == '/testdrive' then
			if split[2] then
				if split[2] == 'end' then
					TriggerClientEvent('blckhndr_boatshop:testdrive:end', source)
				end
			else
				TriggerClientEvent('blckhndr_boatshop:testdrive:start', source)
			end
		end
	end
end)

function getVehicleFromModel(mdl)
	for k, boat in pairs(boats) do
		if boat.model == mdl then
			return boat
		end
	end
end

RegisterServerEvent('blckhndr_boatshop:floor:color:One')
AddEventHandler('blckhndr_boatshop:floor:color:One', function(boatnum, col)
	boat_spots[boatnum]['boat']['color'][1] = col
	boat_spots[boatnum]['boat']['updated'] = false
	TriggerClientEvent('blckhndr_boatshop:floor:Updateboat', -1, boatnum, boat_spots[boatnum])
	print('Player('..source..') is updating '..boat_spots[boatnum]['boat']['model']..' color1 to '..col)
end)
RegisterServerEvent('blckhndr_boatshop:floor:color:Two')
AddEventHandler('blckhndr_boatshop:floor:color:Two', function(boatnum, col)
	boat_spots[boatnum]['boat']['color'][1] = col
	boat_spots[boatnum]['boat']['updated'] = false
	TriggerClientEvent('blckhndr_boatshop:floor:Updateboat', -1, boatnum, boat_spots[boatnum])
	print('Player('..source..') is updating '..boat_spots[boatnum]['boat']['model']..' color2 to '..col)
end)
RegisterServerEvent('blckhndr_boatshop:floor:commission')
AddEventHandler('blckhndr_boatshop:floor:commission', function(boatnum, amt)
	boat_spots[boatnum]['boat']['commission'] = amt
	boat_spots[boatnum]['boat']['updated'] = false
	TriggerClientEvent('blckhndr_boatshop:floor:Updateboat', -1, boatnum, boat_spots[boatnum])
	print('Player('..source..') is updating '..boat_spots[boatnum]['boat']['model']..' commission to '..amt)
end)
RegisterServerEvent('blckhndr_boatshop:floor:ChangeBoat')
AddEventHandler('blckhndr_boatshop:floor:ChangeBoat', function(boatnum, mdl)
	local newboat = getVehicleFromModel(mdl)
	boat_spots[boatnum]['boat']['model'] = newboat.model
	boat_spots[boatnum]['boat']['name'] = newboat.name
	boat_spots[boatnum]['boat']['buyprice'] = newboat.costs
	boat_spots[boatnum]['boat']['rentalprice'] = newboat.rentalprice
	boat_spots[boatnum]['boat']['updated'] = false
	TriggerClientEvent('blckhndr_boatshop:floor:Updateboat', -1, boatnum, boat_spots[boatnum])
	print('Player('..source..') is updating '..boat_spots[boatnum]['boat']['model']..' model to '..mdl)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You updated boat pos '..boatnum..' to '..mdl })
end)

