local yogaStartKey = Util.GetKeyNumber("E")
local yogaEndKey = Util.GetKeyNumber("DELETE")

local doingYoga
local drawTextDist = 2.0
local distance = 10.0
local yogaLocation = vector3(174.32490539551, 6496.794921875, 31.544374465942)
local yogaSpots = {

	[1] = vector3(174.32490539551, 6496.794921875, 31.544374465942),
	[2] = vector3(174.32490539551, 6496.794921875, 31.544374465942),
	[3] = vector3(181.16284179688, 6502.4536132812, 31.544357299805)  

}

local Blips = {
    
    YogaBliss = {
		Zone = 'Yoga Bliss',
		Sprite = 480,
		Scale = 1.0,
		Display = 4,
		Color = 7,
		Pos = {x = -1224.85, y = -1547.37, z = 4.62 },
    },
    
}

-- Draw the blips
Citizen.CreateThread(function()
    
    for key, val in pairs(Blips) do
        --[[local blip = AddBlipForCoord(val.Pos.x, val.Pos.y, val.Pos.z)
        SetBlipHighDetail           (blip, true)
        SetBlipSprite               (blip, val.Sprite)
        SetBlipDisplay              (blip, val.Display)
        SetBlipScale                (blip, val.Scale)
        SetBlipColour               (blip, val.Color)
        SetBlipAsShortRange         (blip, true)
        BeginTextCommandSetBlipName ("STRING")
        AddTextComponentString      (val.Zone)
        EndTextCommandSetBlipName   (blip)--]]
    end

end)

-- Lets start some YOGA
Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerPos = GetEntityCoords(playerPed)
		local nearestDist, nearestPos = PositionCheck(playerPos)
        local dist = Util.GetVecDist(playerPos, yogaLocation)

        if dist < distance then
            nearestDist,nearestPos = PositionCheck(playerPos)

            if nearestDist < drawTextDist then
                Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~g~[ E ] ~s~ to begin yoga', {255, 0, 0, 255}, 0.2)
                if (IsControlJustPressed(0, yogaStartKey, IsDisabledControlJustPressed(0, yogaStartKey))) then
                    doingYoga = true
                    DoYoga(playerPed)
                end
            end
        end
    end
end)

-- Cancel Yoga
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerPos = GetEntityCoords(playerPed)
		local nearestDist,nearestPos = PositionCheck(playerPos)
        local dist = Util.GetVecDist(playerPos, yogaLocation)

        if dist < distance then
            nearestDist,nearestPos = PositionCheck(playerPos)

            if nearestDist < drawTextDist then
                if doingYoga then
                    Util.DrawText3D(nearestPos.x, nearestPos.y, nearestPos.z, 'Press ~r~[ DELETE ] ~s~ to cancel yoga', {255, 0, 0, 255}, 0.2)
                    if (IsControlJustPressed(0, yogaEndKey, IsDisabledControlJustPressed(0, yogaEndKey))) then
                        doingYoga = false
                        cancelledYoga(playerPed)
                    end
                end
            end
        end
    end
end)

function cancelledYoga(playerPed)
    
    exports['mythic_notify']:DoCustomHudText('inform', 'You ended your yoga session early and now are resting for 15 seconds.', 3000)

    doingYoga = false
    ClearPedTasksImmediately(playerPed)

end

function PositionCheck(playerPos)

	local nearestDist,nearestPos
	
	for k,v in pairs(yogaSpots) do
		local curDist = Util.GetVecDist(playerPos, v.xyz)
		if not nearestDist or curDist < nearestDist then
			nearestDist = curDist
			nearestPos = v
		end
	end
	
	if not nearestDist then return false; end
	return nearestDist,nearestPos
	
end

function DoYoga(playerPed)

	local playerPos = GetEntityCoords(playerPed)

	exports['mythic_notify']:DoCustomHudText('inform', 'Preparing the exercise...', 1000)
	
	Citizen.Wait(1000)
	TaskStartScenarioInPlace(playerPed, "world_human_yoga", 0, true)
	Citizen.Wait(15000)
	TriggerEvent('blckhndr_yoga:checkStress')
	ClearPedTasksImmediately(playerPed)

end

RegisterNetEvent('blckhndr_yoga:checkStress')
AddEventHandler('blckhndr_yoga:checkStress', function()
	local playerPed = GetPlayerPed(-1)
	
	if doingYoga then
		TriggerEvent('blckhndr_needs:stress:remove', 10)
		doingYoga = false
	else
		doingYoga = false
	end
end)
