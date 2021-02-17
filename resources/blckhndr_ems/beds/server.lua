local beds = {
	{
		enter = {x = 1826.4929199219, y = 3677.5776367188, z = 34.270034790039},
		bed = {x = 1825.5493164062, y = 3678.2749023438, z = 35.184803009033, h = 10.98306274414},
		occupied = {false, 0, false, {0,0}},
	},	
	{
		enter = {x = 1828.8057861328, y = 3675.744140625, z = 34.270034790039},
		bed = {x = 1829.845703125, y = 3676.2006835938, z = 35.184803009033, h = 120.98306274414},
		occupied = {false, 0, false, {0,0}},
	},
	{
		enter = {x = 1819.7227783203, y = 3672.1752929688, z = 34.270065307617},
		bed = {x = 1820.1375732422, y = 3671.5026855469, z = 35.184803009033, h = 10.98306274414},
		occupied = {false, 0, false, {0,0}},
	},
}

RegisterNetEvent('blckhndr_ems:bed:occupy')
RegisterNetEvent('blckhndr_ems:bed:leave')
RegisterNetEvent('blckhndr_ems:bed:restraintoggle')
RegisterNetEvent('blckhndr_ems:bed:health')

AddEventHandler('blckhndr_ems:bed:health', function(bed, current, maximum)
	beds[bed].occupied[4][1] = current
	beds[bed].occupied[4][2] = maximum
	TriggerClientEvent('blckhndr_ems:bed:update', -1, bed, beds[bed])
end)

AddEventHandler('blckhndr_ems:bed:restraintoggle', function(bed)
	beds[bed].occupied[3] = not beds[bed].occupied[3]
	TriggerClientEvent('blckhndr_ems:bed:update', -1, bed, beds[bed])
end)

AddEventHandler('blckhndr_ems:bed:occupy', function(bed)
	beds[bed].occupied[1] = not beds[bed].occupied[1]
	beds[bed].occupied[2] = source
	TriggerClientEvent('blckhndr_ems:bed:update', -1, bed, beds[bed])
end)

AddEventHandler('blckhndr_ems:bed:leave', function(bed)
	beds[bed].occupied[1] = not beds[bed].occupied[1]
	beds[bed].occupied[2] = 0
	TriggerClientEvent('blckhndr_ems:bed:update', -1, bed, beds[bed])
end)