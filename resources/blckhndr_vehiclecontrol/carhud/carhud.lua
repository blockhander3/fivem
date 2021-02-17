
-- ###################################
--
--        C   O   N   F   I   G
--
-- ###################################



-- show/hide compoent
local HUD = {

	Speed 			= 'kmh', -- kmh or mph

	DamageSystem 	= false,

	SpeedIndicator 	= true,

	ParkIndicator 	= false,

	Top 			= true, -- ALL TOP PANAL ( oil, dsc, plate, fluid, ac )

	Plate 			= false, -- only if Top is false and you want to keep Plate Number

}

-- move all ui
local UI = {

	x =  0.000 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y

}





-- ###################################
--
--             C   O   D   E
--
-- ###################################



Citizen.CreateThread(function()
	while true do Citizen.Wait(1)


		local MyPed = GetPlayerPed(-1)

		if(IsPedInAnyVehicle(MyPed, false))then
			DisplayRadar(true)
			local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
			local VehStopped = IsVehicleStopped(MyPedVeh)
			local VehEngineHP = GetVehicleEngineHealth(MyPedVeh)
			local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)
			local VehBurnout = IsVehicleInBurnout(MyPedVeh)

			if HUD.Speed == 'kmh' then
				Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
			elseif HUD.Speed == 'mph' then
				Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			else
				Speed = 000.0
				if Speed >= 10 then
					Speed = 010.0
				elseif Speed >= 100 then
					Speed = 100.0
				end
				
			end
			if seatbelt then
				drawTxt(UI.x + 0.517, UI.y + 1.305, 1.0,1.0,0.4, "~g~BIZTONSÁGI ÖV", 66, 220, 244, 255)
			else
				drawTxt(UI.x + 0.517, UI.y + 1.305, 1.0,1.0,0.4, "~r~BIZTONSÁGI ÖV", 66, 220, 244, 255)
			end
			if HUD.SpeedIndicator then
				if HUD.Speed == 'mph' then
					drawRct(UI.x + 0.124, 	UI.y + 0.932, 0.046,0.03,0,0,0,150) -- Speed panel
					drawTxt(UI.x + 0.625, 	UI.y + 1.42, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
					if math.ceil(Speed) == 0 then
						drawTxt(UI.x + 0.647, 	UI.y + 1.428, 1.0,1.0,0.4, "~w~ mph", 255, 255, 255, 255)
					elseif math.ceil(Speed) < 45 then
						drawTxt(UI.x + 0.647, 	UI.y + 1.428, 1.0,1.0,0.4, "~g~ mph", 255, 255, 255, 255)
					elseif math.ceil(Speed) < 80 then
						drawTxt(UI.x + 0.647, 	UI.y + 1.428, 1.0,1.0,0.4, "~o~ mph", 255, 255, 255, 255)
					else
						drawTxt(UI.x + 0.647, 	UI.y + 1.428, 1.0,1.0,0.4, "~r~ mph", 255, 255, 255, 255)
					end
					-- 0.33 difference
					if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
						drawRct(UI.x + 0.124, 	UI.y + 0.899, 0.046,0.03,0,0,0,150) -- Speed panel
						drawTxt(UI.x + 0.625, 	UI.y + 1.387, 1.0,1.0,0.64 , "~w~" .. math.floor(fuel_amount), 255, 255, 255, 255)
						drawTxt(UI.x + 0.647, 	UI.y + 1.395, 1.0,1.0,0.4, "~w~  fuel", 255, 255, 255, 255)
					end
				elseif HUD.Speed == 'kmh' then
					drawRct(UI.x + 0.111, 	UI.y + 0.778, 0.046,0.03,0,0,0,100) -- Speed panel
					drawTxt(UI.x +  0.613, 	UI.y + 1.267, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
					if math.ceil(Speed) == 0 then
						drawTxt(UI.x + 0.632, 	UI.y + 1.277, 1.0,1.0,0.4, "~w~ kmh", 255, 255, 255, 255)
					elseif math.ceil(Speed) < 73 then
						drawTxt(UI.x +  0.632, 	UI.y + 1.277, 1.0,1.0,0.4, "~g~ kmh", 255, 255, 255, 255)
					elseif math.ceil(Speed) < 129 then
						drawTxt(UI.x +  0.632, 	UI.y + 1.277, 1.0,1.0,0.4, "~o~ kmh", 255, 255, 255, 255)
					else
						drawTxt(UI.x +  0.632, 	UI.y + 1.277, 1.0,1.0,0.4, "~r~ kmh", 255, 255, 255, 255)
					end
					-- 0.33 difference
					if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
						drawRct(UI.x + 0.014, 	UI.y + 0.778, 0.070,0.03,0,0,0,100) -- Speed panel
						drawTxt(UI.x + 0.517, 	UI.y + 1.267, 1.0,1.0,0.64 , "~w~" .. math.floor(fuel_amount), 255, 255, 255, 255)
						drawTxt(UI.x + 0.539, 	UI.y + 1.277, 1.0,1.0,0.4, "~w~L ÜZEMANYAG", 255, 255, 255, 255)
					end
				else
					drawTxt(UI.x + 0.81, 	UI.y + 1.42, 1.0,1.0,0.64 , [[Carhud ~r~ERROR~w~ ~c~in ~w~HUD Speed~c~ config (something else than ~y~'kmh'~c~ or ~y~'mph'~c~)]], 255, 255, 255, 255)
				end
			end
		else
			DisplayRadar(false)
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end
