blips = {}
RegisterNetEvent('blckhndr_main:blip:add')
AddEventHandler('blckhndr_main:blip:add', function(whofor, blipname, blipid, x,y,z)
	print 'trying to add blip'
	if whofor == "police" and exports["blckhndr_police"]:blckhndr_PDDuty() then
		addBlip(blipname, blipid, x, y, z, 3, 90, whofor)
	end
	if whofor == "ems" and exports["blckhndr_ems"]:blckhndr_EMSDuty() then
		addBlip(blipname, blipid, x, y, z, 1, 90, whofor)
	end
	if whofor == "tow" and exports["blckhndr_jobs"]:blckhndr_GetJob() == 'Mechanic' then
		addBlip(blipname, blipid, x, y, z, 17, 300, whofor)
	end
end)

function addBlip(text, blipid, x, y, z, color, ttl, whofor)
	local blip = AddBlipForCoord(x, y, 0.01)
	SetBlipSprite(blip, blipid)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	PulseBlip(blip)
	SetBlipFlashes(blip, true)
	SetBlipFlashInterval(blip, 650)
	SetBlipColour(blip, color)

	local removeTime = GetNetworkTime() + (ttl * 1000)
	blips[#blips+1] = {blipObject = blip, location = {x, y, z}, type = whofor, timeToDelete = removeTime, active = true}
end

Citizen.CreateThread(function()
	while true do
		Wait(5000)
		for i, _ in pairs(blips) do
			if blips[i].timeToDelete < GetNetworkTime() or not blips[i].active then
				RemoveBlip(blips[i].blipObject)
				blips[i] = nil
			end
		end
	end
end)

RegisterNetEvent('blckhndr_main:blip:clear')
AddEventHandler('blckhndr_main:blip:clear', function()
  print 'clearing blip'
  for k, v in pairs(blips) do
    if v.active then
      if v.whofor == "police" and exports["blckhndr_police"]:blckhndr_PDDuty() then
        if GetDistanceBetweenCoords(v.location[1], v.location[2], v.location[3], GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
          RemoveBlip(v.blipObject)
          v.active = false
          TriggerEvent('blckhndr_notify:displayNotification', 'POLICE: Blip cleared.', 'centerLeft', 6000, 'info')
        end
      end
      if v.whofor == "ems" and exports["blckhndr_ems"]:blckhndr_EMSDuty() then
        if GetDistanceBetweenCoords(v.location[1], v.location[2], v.location[3], GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
          RemoveBlip(v.blipObject)
          v.active = false
          TriggerEvent('blckhndr_notify:displayNotification', 'EMS: Blip cleared.', 'centerLeft', 6000, 'info')
        end
      end
      if v.whofor == "tow" and exports["blckhndr_jobs"]:blckhndr_GetJob() == 'Mechanic' then
        if GetDistanceBetweenCoords(v.location[1], v.location[2], v.location[3], GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
          RemoveBlip(v.blipObject)
          v.active = false
          TriggerEvent('blckhndr_notify:displayNotification', 'TOW: Blip cleared.', 'centerLeft', 6000, 'info')
        end
      end
    end
  end
end)
