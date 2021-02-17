RegisterNetEvent('blckhndr_criminalmisc:drugs:effects:weed')
RegisterNetEvent('blckhndr_criminalmisc:drugs:effects:meth')
RegisterNetEvent('blckhndr_criminalmisc:drugs:effects:cocaine')
RegisterNetEvent('blckhndr_criminalmisc:drugs:effects:smokeCigarette')

function doScreen(num)
	if num == 1 then
		StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
		Citizen.Wait(8000)
		StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
		Citizen.Wait(8000)
		StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
		StopScreenEffect("DrugsTrevorClownsFight")
		StopScreenEffect("DrugsTrevorClownsFightIn")
		StopScreenEffect("DrugsTrevorClownsFightOut")
	else
		StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
		Citizen.Wait(8000)
		StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
		Citizen.Wait(8000)
		StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
		StopScreenEffect("DrugsMichaelAliensFightIn")
		StopScreenEffect("DrugsMichaelAliensFight")
		StopScreenEffect("DrugsMichaelAliensFightOut")
	end
end


AddEventHandler('blckhndr_criminalmisc:drugs:effects:weed', function()
	ExecuteCommand('me smokes a joint...')
	smokeAnimation()
	Citizen.Wait(2000)
	TriggerEvent('blckhndr_needs:stress:remove', 8)
	--StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
	--Citizen.Wait(6000)
	--StopScreenEffect("DrugsMichaelAliensFightOut")
	AddArmourToPed(GetPlayerPed(-1), 10)
end)

AddEventHandler('blckhndr_criminalmisc:drugs:effects:meth', function()
	ExecuteCommand('me takes meth...')
	SetPedMoveRateOverride(PlayerId(),10.0)
	doScreen(1)
	SetPedMoveRateOverride(PlayerId(),1.0)
end)

AddEventHandler('blckhndr_criminalmisc:drugs:effects:cocaine', function()
	ExecuteCommand('me sniffs a line...')
	SetRunSprintMultiplierForPlayer(PlayerId(),1.49)
	doScreen(2)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
end)

AddEventHandler('blckhndr_criminalmisc:drugs:effects:smokeCigarette', function()
	ExecuteCommand('me smokes a cigarette...')
	smokeAnimation()
	Citizen.Wati(2000)
	TriggerEvent('blckhndr_needs:stress:remove', 5)
end)


--To stop the animation just press f5 then stop animation 
function smokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)

	end)
end