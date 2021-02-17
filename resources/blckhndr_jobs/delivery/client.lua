local startpos = {x = 78.926086425781, y = 111.87384033203, z = 81.168174743652}
local vanpos = {x = 62.564468383789, y = 122.1368560791, z = 79.058258056641}

local isdelivering = false
local mystops = 0
local donestops = 0
local myvan = false
local packageinhand = false

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
		if GetDistanceBetweenCoords(startpos.x,startpos.y,startpos.z,GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
			DrawMarker(1,startpos.x,startpos.y,startpos.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
			if GetDistanceBetweenCoords(startpos.x,startpos.y,startpos.z,GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
				if isdelivering then
					SetTextComponentFormat("STRING")
					AddTextComponentString("~r~Jelenleg már szállítassz, fejezd be, es próbáld meg ujra.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				else
				SetTextComponentFormat("STRING")
				AddTextComponentString("Nyomj ~INPUT_PICKUP~ gombot, hogy elkezdd a kiszállítást")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					if IsControlJustPressed(0,38) then
						if exports["blckhndr_licenses"]:blckhndr_hasLicense("driver") then
							local res = 0
							Citizen.CreateThread(function()
							  DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "#ID NUMBER", "", "", "", "", 10)
							  local editOpen = true
							  while UpdateOnscreenKeyboard() == 0 or editOpen do
								Wait(0)
								drawTxt('Hányszor fogsz ma megállni?',4,1,0.5,0.30,0.7,255,255,255,255)
								drawTxt('~b~Átlagosan~g~$350~b~-t kapnak a kézbesítőink csomagonként',4,1,0.5,0.35,0.4,255,255,255,255)
								drawTxt('~r~MEG LESZEL BÜNTETVE A CSOMAGOKÉRT, AMIKET NEM SZÁLLITÁSSZ KI!',4,1,0.5,0.49,0.4,255,255,255,255)
								if UpdateOnscreenKeyboard() ~= 0 then
								  editOpen = false
								  if UpdateOnscreenKeyboard() == 1 then
									if tonumber(GetOnscreenKeyboardResult()) then
										res = tonumber(GetOnscreenKeyboardResult())
										mystops = res
										if mystops > 0 then
											local model = 'boxville2'
											RequestModel(model)
											while not HasModelLoaded(model) do
												Wait(1)
											end
											local personalvehicle = CreateVehicle(model, vanpos.x, vanpos.y, vanpos.z, vanpos.h, true, false)
											TriggerEvent('blckhndr_fuel:update', GetVehicleNumberPlateText(personalvehicle), 100)
											myvan = personalvehicle
											SetModelAsNoLongerNeeded(model)
											SetVehicleOnGroundProperly(personalvehicle)
											SetVehicleHasBeenOwnedByPlayer(personalvehicle, true)
											local id = NetworkGetNetworkIdFromEntity(personalvehicle)
											SetNetworkIdCanMigrate(id, true)
											TriggerEvent('blckhndr_notify:displayNotification', 'Hozd ki a kocsit a garázsból!', 'centerRight', 4000, 'info')
											TriggerEvent('blckhndr_cargarage:makeMine', myvan, GetDisplayNameFromVehicleModel(GetEntityModel(myvan)), GetVehicleNumberPlateText(myvan))
											isdelivering = true
											blckhndr_SetJob('GoPostal Driver')
										end
									else
										mystops = 0
										TriggerEvent('blckhndr_notify:displayNotification', 'Be kell írnod egy számot', 'centerRight', 4000, 'error')
									end
								  end
								  break
								end
							  end
							end)
						else
							TriggerEvent('blckhndr_notify:displayNotification', 'Kell egy jogosítvány, hogy ezt a munkát csinélhasd', 'centerRight', 4000, 'error')
						end
					end
				end
			end
		end
	end
end)