local evData
evData = AddEventHandler("playerSpawned", function()
	RemoveEventHandler(evData) -- Only do this once
	DoScreenFadeOut(0)
	--[[DoScreenFadeOut(0)

	-- Display loading prompt
	BeginTextCommandBusyString("STRING")
	AddTextComponentString("Loading your characters")
	EndTextCommandBusyString(3)

	

	RemoveLoadingPrompt()]]
	Citizen.Wait(10*1000)
	if GetPlayerPed(-1) then
		DoScreenFadeIn(2000)
		TriggerEvent("blckhndr_main:charMenu")
	end
end)