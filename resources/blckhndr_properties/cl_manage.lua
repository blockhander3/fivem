local myKeys = {}
RegisterNetEvent('blckhndr_properties:keys:give')
AddEventHandler('blckhndr_properties:keys:give', function(id)
	table.insert(myKeys, #myKeys+1, id)
end)

function hasPropKeys(id)
	for k,v in pairs(myKeys) do
		return true
	end
	return false
end