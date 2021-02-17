local huntingzones = {
--{x = -2331.1481933594, y = 1317.0661621094, z = 329.26376342773},
{x = 1150.9182128906, y = 5711.0874023438, z = 503.03448486328},
--{x = 2260.9885253906, y = -1772.0008544922, z = 120.99961853027}
}
local canhunt = false
Citizen.CreateThread(function()
  for k, v in pairs(huntingzones) do
	  local bleep = AddBlipForCoord(v.x, v.y, v.z)
	  SetBlipSprite(bleep, 10)
	  SetBlipColour(bleep, 1)
	  SetBlipScale(bleep, 0.8)
	  SetBlipAsShortRange(bleep, true)
	  BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vadászzóna")
	  EndTextCommandSetBlipName(bleep)
  end
  while true do
	Citizen.Wait(0)
	for k, v in pairs(huntingzones) do
		if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1)), false) < 200 then
			canhunt = true
		else
			if canhunt then
				canhunt = false
			end
		end
	end
  end
end)

local animal = -1
local droppeditems = {}
local hashes = {
    ['1689136297'] = 4,
    ['-832573324'] = 4,
    ['-2125992519'] = 1,
    ['-1430839454'] = 1,
    ['-2098044544'] = 1,
    ['1457690978'] = 1,
    ['2064779084'] = 1,
    ['402729631'] = 1,
    ['-1837301661'] = 3,
    ['-1469565163'] = 3,
    ['709452327'] = 8,
    ['-50684386'] = 8,
    ['1903324290'] = 4,
    ['1682622302'] = 4,
    ['1647367445'] = 4,
    ['-664053099'] = 4,
    ['-383047997'] = 1,
    ['802685111'] = 1,
    ['-815316634'] = 1,
    ['1794449327'] = 1,
    ['-2053253046'] = 3,
    ['-1323586730'] = 3,
    ['307287994'] = 3,
}
local harvesting = false
local harvestingstart = 0
local cooking = false
local cookingend = 0
local cookingadd = 0
function blckhndr_drawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
Citizen.CreateThread(function()
  --144.10649108887, -1480.7464599609, 29.357044219971
  --[[local bleep = AddBlipForCoord(144.10649108887, -1480.7464599609, 29.357044219971)
  SetBlipSprite(bleep, 439)
  SetBlipScale(bleep, 0.8)
  SetBlipAsShortRange(bleep, true)
  BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lucky Plucker")
  EndTextCommandSetBlipName(bleep)
  local bleep = AddBlipForCoord(974.604, -2165.881, 29.16)
  SetBlipSprite(bleep, 273)
  SetBlipScale(bleep, 0.8)
  SetBlipAsShortRange(bleep, true)
  BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Butchers")
  EndTextCommandSetBlipName(bleep)--]]
  while true do
    Citizen.Wait(0)
    if GetDistanceBetweenCoords(144.10649108887, -1480.7464599609, 29.357044219971, GetEntityCoords(GetPlayerPed(-1)), true) < 10 then
      DrawMarker(1,144.10649108887, -1480.7464599609, 28.357044219971,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
      if GetDistanceBetweenCoords(144.10649108887, -1480.7464599609, 29.357044219971, GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
        SetTextComponentFormat("STRING")
        AddTextComponentString("Nyomj ~INPUT_PICKUP~ hogy eladd a ~p~Sült húst")
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        if IsControlJustNyomjed(0,51) then
          if exports.blckhndr_inventory:blckhndr_HasItem('cooked_meat') then
            if exports.blckhndr_police:blckhndr_getCopAmt() < 1 then
              TriggerEvent('blckhndr_inventory:item:add', 'dirty_money', math.random(50, 150) * exports.blckhndr_inventory:blckhndr_GetItemAmount('cooked_meat'))
              TriggerEvent('blckhndr_notify:displayNotification', 'Nincs elég rendőr a városban, ezért az ár meg van felezve', 'centerLeft', 4000, 'error')
            else
              TriggerEvent('blckhndr_inventory:item:add', 'dirty_money', math.random(25, 75) * exports.blckhndr_inventory:blckhndr_GetItemAmount('cooked_meat'))
            end
            TriggerEvent('blckhndr_inventory:item:take', 'cooked_meat', exports.blckhndr_inventory:blckhndr_GetItemAmount('cooked_meat'))
            cookingend = GetNetworkTime() + cookingadd
            cooking = true
          else
            TriggerEvent('blckhndr_notify:displayNotification', 'Nincs sült húsod', 'centerLeft', 4000, 'error')
          end
        end
      end
    end
    if GetDistanceBetweenCoords(974.604, -2165.881, 29.16, GetEntityCoords(GetPlayerPed(-1)), true) < 3 then
      if not cooking then
        blckhndr_drawText3D(974.604, -2165.881, 29.16, 'Nyomj [~g~E~w~]-t, hogy megsüsd a húst')
        if IsControlJustNyomjed(0,51) then
          if exports.blckhndr_inventory:blckhndr_HasItem('uncooked_meat') then
            cookingadd = 2200 * exports.blckhndr_inventory:blckhndr_GetItemAmount('uncooked_meat')
            TriggerEvent('blckhndr_inventory:item:take', 'uncooked_meat', exports.blckhndr_inventory:blckhndr_GetItemAmount('uncooked_meat'))
            cookingend = GetNetworkTime() + cookingadd
            cooking = true
          else
            TriggerEvent('blckhndr_notify:displayNotification', 'Nincs eleg nyers húsod', 'centerLeft', 4000, 'error')
          end
        end
      else
        local divid = cookingadd / 2
        if cookingend - GetNetworkTime() < divid then
          blckhndr_drawText3D(974.604, -2165.881, 29.16, '~p~Hús sütése...')
          if GetNetworkTime() > cookingend then
            cooking = false
            TriggerEvent('blckhndr_inventory:item:add', 'cooked_meat', cookingadd / 2200)
          end
        else
          blckhndr_drawText3D(974.604, -2165.881, 29.16, '~o~Felkeszülés a sütésre...')
        end
      end
    end
    for k, v in pairs(droppeditems) do
      if GetDistanceBetweenCoords(GetEntityCoords(v[1]), GetEntityCoords(GetPlayerPed(-1)), true) < 5 then
        if v[2] == nil then
          if not harvesting then
			if canhunt then
				blckhndr_drawText3D(GetEntityCoords(v[1]).x,GetEntityCoords(v[1]).y,GetEntityCoords(v[1]).z, 'Nyomj [~g~E~w~]-t, hogy összeszedd')
			else
				blckhndr_drawText3D(GetEntityCoords(v[1]).x,GetEntityCoords(v[1]).y,GetEntityCoords(v[1]).z, '~r~Nem vagy vadászzónában')
			end
            if IsControlJustNyomjed(0,51) then
			  if canhunt then
				  TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 1)
				  harvesting = true
				  harvestingstart = GetNetworkTime()
			  else
				blckhndr_drawText3D(GetEntityCoords(v[1]).x,GetEntityCoords(v[1]).y,GetEntityCoords(v[1]).z, '~r~Nem vagy vadászzónában')
			  end
            end
          else
            blckhndr_drawText3D(GetEntityCoords(v[1]).x,GetEntityCoords(v[1]).y,GetEntityCoords(v[1]).z, 'Összeszedés...')
            if harvestingstart + 6000 < GetNetworkTime() then
              TriggerEvent('blckhndr_inventory:item:add', 'uncooked_meat', math.random(2,5))
              v[2] = true
              harvesting = false
              harvestingstart = 0
            end
          end
        else
          blckhndr_drawText3D(GetEntityCoords(v[1]).x,GetEntityCoords(v[1]).y,GetEntityCoords(v[1]).z, '~r~Már összeszedve')
        end
      end
    end
    if IsPedShooting(GetPlayerPed(-1)) then
      animal, ass = Citizen.InvokeNative(0x2975c866e6713290, PlayerId(), Citizen.PointerValueIntInitialized(0))
      if IsEntityAPed(animal) then
        for k, v in pairs(hashes) do
          if tostring(GetEntityModel(animal)) == k then
            if IsEntityDead(animal) then
              if not table.contains(droppeditems, animal) then
                table.insert(droppeditems,#droppeditems+1, {animal, nil})
              end
            end
          end
        end
      end
    end
  end
end)
