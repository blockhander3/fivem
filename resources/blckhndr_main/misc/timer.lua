-- Investigate viability of https://runtime.fivem.net/doc/natives/#_0x9CD27B0045628463
blckhndr_time = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		blckhndr_time = blckhndr_time + 1
	end
end)

function blckhndr_GetTime()
	return blckhndr_time
end