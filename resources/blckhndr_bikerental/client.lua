local guiEnabled = false
local rentalText = true
local returnText = false
local rentalMenuOpen = false

DecorRegister("bikeRental:rented", 3)

  local bikeRentalCoords = { -- Bike Rental Locations/Coords.
     {location="Paleto Bay - Sheriffség", x=-445.56991577148, y=6024.4770507812, z=31.490056991577},
     {location="Paleto Bay - Bank", x=-107.1175994873, y=6449.4213867188, z=31.454442977905},
     {location="Paleto Bay - Kamionos telephely", x=438.58444213864, y=6506.5737304688, z=28.633661270142},
     {location="Autópálya - 15-ös bolt", x=1720.7573242188, y=6425.9692382812, z=33.368713378906},
     {location="Grapeseed - Sheriffség", x=1675.1798095703, y=4889.9267578125, z=42.066745758057},
     {location="Sandy Shores - Sheriffség", x=1894.8151855469, y=3713.2448730469, z=32.772415161133},
     {location="Sandy Shores - Nyugati bolt", x=1385.5067138672, y=3605.4807128906, z=34.894496917725},
  }


Citizen.CreateThread(function()
        for _, v in pairs(bikeRentalCoords) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 226)
            SetBlipColour(v.blip, 3)
            SetBlipScale(v.blip, 0.8)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Kerékpár bérlés")
            EndTextCommandSetBlipName(v.blip)
        end
            while true do
                Citizen.Wait(0)
                for k, v in pairs(bikeRentalCoords) do
                    local playerPed = GetPlayerPed(-1)
                    local playerPos = GetEntityCoords(playerPed, 1)

            if GetDistanceBetweenCoords(v.x, v.y, v.z, playerPos, 1) <= 2 then
                if not IsPedInAnyVehicle(playerPed, false) then
                    if rentalText == true then
                        Util.DrawText3D(playerPos['x'], playerPos['y'], playerPos['z'] + 0.3, '~r~[E] ~w~Kerékpár bérlés', {255, 255, 255, 255}, 0.25) -- Add this for Live Utils.
                    end
                    elseif IsPedInAnyVehicle(playerPed, false) and DecorGetInt(GetVehiclePedIsIn(GetPlayerPed(-1), false), "bikeRental:rented") == 1 then
                        Util.DrawText3D(playerPos['x'], playerPos['y'], playerPos['z'] + 0.3, '~r~[E] ~w~Kerékpár visszaadása', {255, 255, 255, 255}, 0.25) -- Add this for Live Utils.
                        rentalText = false
                        returnText = true
                    else
                        Util.DrawText3D(playerPos['x'], playerPos['y'], playerPos['z'] + 0.3, 'Ez nem egy bérelt kerékpár', {255, 255, 255, 255}, 0.25) -- Add this for Live Utils.
                        rentalText = false
                        returnText = false
                end

                if IsControlJustPressed(1, 38) and rentalText == true then -- [E] Open
                    rentalText = false

                    EnableGui(true)
                    SetNuiFocus(true, true)
                end
            
                if IsControlJustPressed(1, 38) and returnText == true then -- [E] Open
                    deleteCar()
                    TriggerEvent('blckhndr_notify:displayNotification', 'Kerékpár visszaadva', 'centerLeft', 4000, 'success')
                end
            
                if guiEnabled == false then
                    rentalText = true
                end
            end
        end
    end
end)

      -- Vehicle Spawner START --
function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, x, y, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1) -- Teleport into bike seat.
    DecorSetInt(vehicle, "bikeRental:rented", 1)
end
    -- Vehicle Spawner END --

    -- Vehicle Delete START --
function deleteCar()
    if DecorGetInt(GetVehiclePedIsIn(GetPlayerPed(-1), false), "bikeRental:rented") == 1 then -- Check if vehicle is a Rented Bike.    
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetEntityAsMissionEntity(vehicle, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
        rentalText = true
        returnText = false
    else
        print("Not a rented bike.")
    end
end 
    -- Vehicle Delete END --

      -- NUI STUFF --

function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable
    
    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
    SetNuiFocus(false, false)
    rentalText = true
    cb('ok')
end)

RegisterNUICallback('rentBike', function(data, cb)
    if exports["blckhndr_main"]:blckhndr_GetWallet() >= tonumber(data.price) then
        TriggerEvent('blckhndr_bank:change:walletMinus', data.price)
        TriggerEvent('blckhndr_notify:displayNotification', 'Kerékpár kibérelve!', 'centerLeft', 4000, 'success')
        spawnCar(data.model)
        rentalText = true
        EnableGui(false)
        SetNuiFocus(false, false)
        cb('ok')       
        -- print("Rented "..data.model.." for "..data.price) -- debug, remove if yah want.
        -- print("DEBUG: BIKE MODEL="..data.model.." PRICE=$"..data.price)
    else
        TriggerEvent('blckhndr_notify:displayNotification', 'Nincs elég pénzed.', 'centerLeft', 4000, 'error')
    end
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown
    
            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate
    
            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride
    
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                 SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)