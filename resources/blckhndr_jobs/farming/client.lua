function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local currentTractor = false
local isfarming = false
local hasseeds = false
local farms = {
  ["Great Ocean Hwy / Mount Chiliad"] = {
    job = {
      start = {x=606.887,y=6458.87,z=30.3238},
      starttext = "Nyomj ~INPUT_CONTEXT~ gombot, hogy ~g~kertészkedj",
      spawn = {x=627.958,y=6452.47,z=30.4365},
      seeds = {x=412.134,y=6454.61,z=28.9195},
      seedtext = "Nyomj ~INPUT_CONTEXT~ hogy szerezzhess ~o~magokat",
      field = {x=664.883,y=6476.34,z=30.4847},
      planttext = "Nyomj ~INPUT_CONTEXT~ hogy elültesd a ~o~magokat",
      quittext = "Nyomj ~INPUT_CONTEXT~ hogy ~r~kilépj a ~g~kertészkedésböl",
      finishtext = "Nyomj ~INPUT_CONTEXT~ hogy összeszedd a fizetésed",
    },
    payrate = 300,
    name = "Kertészkedés",
    time = 200000,
    blip = 280,
    tractor = "tractor2",
  },
	["Union Rd / Grapeseed"] = {
    job = {
      start = {x=2258.59,y=5165.61,z=59.1116},
      starttext = "Nyomj ~INPUT_CONTEXT~ gombot, hogy ~g~kertészkedj",
      spawn = {x=2291.34,y=5172.42,z=60.5},
      seeds = {x=2376.69,y=4946.8,z=42.7982},
      seedtext = "Nyomj ~INPUT_CONTEXT~ hogy szerezzhess ~o~magokat",
      field = {x=2308.58,y=5124.1,z=49.6596},
      planttext = "Nyomj ~INPUT_CONTEXT~ hogy elültesd a ~o~magokat",
      quittext = "Nyomj ~INPUT_CONTEXT~ hogy ~r~kilépj a ~g~kertészkedésböl",
      finishtext = "Nyomj ~INPUT_CONTEXT~ hogy összeszedd a fizetésed",
    },
    payrate = 300,
    name = "Kertészkedés",
    time = 208000,
    blip = 280,
    tractor = "tractor2",
  }
}

function SetWaypoint(x,y,z)
  ClearGpsPlayerWaypoint()
  SetNewWaypoint(x,y)
end

function SpawnTractor(tractor,x,y,z)
  local car = GetHashKey(tractor)
  local playerPed = GetPlayerPed(-1)
  RequestModel(car)
  while not HasModelLoaded(car) do
		Citizen.Wait(0)
	end
	currentTractor = CreateVehicle(car, x, y, z, 90.0, true, false)
	--SetEntityHeading(taxi, 0)
  SetVehicleHasBeenOwnedByPlayer(currentTractor,true)
  TaskWarpPedIntoVehicle(playerPed, currentTractor, -1)
  SetEntityAsMissionEntity(currentTractor, true, true)
  TriggerEvent('blckhndr_cargarage:makeMine', currentTractor, GetDisplayNameFromVehicleModel(GetEntityModel(currentTractor)), GetVehicleNumberPlateText(currentTractor))
end

function DeleteTractor()
  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(currentTractor))
	SetEntityCoords(currentTractor, -1000.0, -1000.0, -1000.0, 0.0, 0.0, 0.0, false)
  currentTractor = false
end

Citizen.CreateThread(function()
	for k,v in pairs(farms) do
		local blip = AddBlipForCoord(v.job.field.x, v.job.field.y, v.job.field.z)
		SetBlipSprite(blip, v.blip)
		BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip, true)
	end
  ------------------------------------------------------- START
  while true do
    Citizen.Wait(0)
    for k, v in pairs(farms) do
      if GetDistanceBetweenCoords(v.job.start.x,v.job.start.y,v.job.start.z,GetEntityCoords(GetPlayerPed(-1))) < 40 then
        DrawMarker(1,v.job.start.x,v.job.start.y,v.job.start.z-1,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false and GetDistanceBetweenCoords(v.job.start.x,v.job.start.y,v.job.start.z,GetEntityCoords(GetPlayerPed(-1))) < 2 then
					if isfarming == false then
						DisplayHelpText(v.job.starttext)
						if IsControlJustNyomjed(1,51) then
              isfarming = true
              SpawnTractor(v.tractor,v.job.spawn.x,v.job.spawn.y,v.job.spawn.z)
              SetWaypoint(v.job.seeds.x,v.job.seeds.y,v.job.seeds.z)
              TriggerEvent('pNotify:SendNotification', {text = "Menj az úticélhoz, hogy kapj <span style='color:orange'>Magokat",
                layout = "centerRight",
                timeout = 600,
                progressBar = true,
                type = "info"
              })
						end
					else
            if finished == false then
              DisplayHelpText(v.job.quittext)
  						if IsControlJustNyomjed(1,51) then
                isfarming = false
                finished = false
                hasseeds = false
                DeleteTractor()
  						end
            else
              DisplayHelpText(v.job.finishtext)
  						if IsControlJustNyomjed(1,51) then
                isfarming = false
                finished = false
                hasseeds = false
                --TriggerServerEvent('jFarm:payme', v.payrate)
                TriggerEvent('blckhndr_bank:change:walletAdd', math.random(v.payrate-100, v.payrate+250))
                DeleteTractor()
  						end
            end
					end
				end
      end
    end
    if isfarming then
      for k, v in pairs(farms) do
        if GetDistanceBetweenCoords(v.job.seeds.x,v.job.seeds.y,v.job.seeds.z,GetEntityCoords(GetPlayerPed(-1))) < 40 then
          DrawMarker(1,v.job.seeds.x,v.job.seeds.y,v.job.seeds.z-1,0,0,0,0,0,0,5.001,5.0001,0.4001,0,155,255,175,0,0,0,0)
          if IsPedInAnyVehicle(GetPlayerPed(-1), true) and GetDistanceBetweenCoords(v.job.seeds.x,v.job.seeds.y,v.job.seeds.z,GetEntityCoords(GetPlayerPed(-1))) < 2 then
  					if hasseeds == false then
  						DisplayHelpText(v.job.seedtext)
  						if IsControlJustNyomjed(1,51) then
                TriggerEvent('pNotify:SendNotification', {text = "Magok szerzése...",
                  layout = "centerRight",
                  timeout = 15000,
                  progressBar = true,
                  type = "info"
                })
                Citizen.Wait(15000)
                TriggerEvent('pNotify:SendNotification', {text = "Összeszedve [20X] <span style='color:orange;font-weight:bold;'>Mag",
                  layout = "centerRight",
                  timeout = 600,
                  progressBar = true,
                  type = "success"
                })
                hasseeds = true
                SetWaypoint(v.job.field.x, v.job.field.y, v.job.field.z)
                TriggerEvent('pNotify:SendNotification', {text = "Menj az úticélhoz, hogy elkezdhess kertészkedni",
                  layout = "centerRight",
                  timeout = 600,
                  progressBar = true,
                  type = "info"
                })
  						end
  					else
              DisplayHelpText("~r~Már vannak magjaid!")
  					end
  				end
        end
      end
      for k, v in pairs(farms) do
        if GetDistanceBetweenCoords(v.job.field.x,v.job.field.y,v.job.field.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
          DrawMarker(1,v.job.field.x,v.job.field.y,v.job.field.z-1,0,0,0,0,0,0,45.001,45.0001,0.4001,0,155,255,175,0,0,0,0)
          if IsPedInAnyVehicle(GetPlayerPed(-1), true) and GetDistanceBetweenCoords(v.job.field.x,v.job.field.y,v.job.field.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
  					if hasseeds then
  						DisplayHelpText(v.job.planttext)
  						if IsControlJustNyomjed(1,51) then
                TriggerEvent('pNotify:SendNotification', {text = "Magok ültetése...",
                  layout = "centerRight",
                  timeout = 33000,
                  progressBar = true,
                  type = "info"
                })
                Citizen.Wait(33000)
                TriggerEvent('pNotify:SendNotification', {text = "Összeszedve [20X] <span style='color:orange;font-weight:bold;'>Mag",
                  layout = "centerRight",
                  timeout = 600,
                  progressBar = true,
                  type = "success"
                })
                hasseeds = true
                SetWaypoint(v.job.start.x, v.job.start.y, v.job.start.z)
                TriggerEvent('pNotify:SendNotification', {text = "Menj vissza, hogy kaphass fizetést",
                  layout = "centerRight",
                  timeout = 600,
                  progressBar = true,
                  type = "info"
                })
                hasseeds = false
                finished = true
  						end
  					else
              DisplayHelpText("~r~Nincsenek magjaid!")
  					end
  				end
        end
      end
    end
  end
end)
