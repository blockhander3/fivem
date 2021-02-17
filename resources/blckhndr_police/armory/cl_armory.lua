local armories = {
    {pos = vector3(447.99652, -983.1278686, 30.68959426), id = 'lspd_armory', busy = false },
    {pos = vector3(-425.30169677734, 5997.4404296875, 31.716529846191), id = 'paleto_armory', busy = false },
    {pos = vector3(1845.7867431641, 3692.5383300781, 34.257640838623), id = 'bcso_armory', busy = false}
}


Util.Tick(function()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed, true)

    --print(policelevel)

    for k, armory in pairs(armories) do
        local dist = Util.GetVecDist(playerPos, armory.pos.xyz)
        local nearestDist, nearestPos = Util.PositionCheck(playerPos, armory.pos.xyz)
        local distance = 10.0
        local drawDistance = 2.0

        if dist < distance then
           nearestDist, nearestPos = Util.PositionCheck(playerPos, armory.pos.xyz)


            if nearestDist < distance and pdonduty then
                DrawMarker(27, armory.pos.x, armory.pos.y, armory.pos.z-1, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.4001, 255, 255, 255, 175, 0, 0, 0, 0)
                if nearestDist < drawDistance then
                    if not armory.busy then
                        Util.DrawText3D(armory.pos.x, armory.pos.y, armory.pos.z, '[E] Raktár', false)
                        if IsControlJustReleased(0, Util.GetKeyNumber('E')) then
                            --print(armory.id)
                            TriggerServerEvent('blckhndr_police:armory:request', armory.id, policelevel)
                        end
                    else
                        Utils.DrawText3D(armory.pos.x, armory.pos.y, armory.pos.z, '~r~A raktár már használatban van.\nPróbáld meg késöbb.', false)
                    end
                end
            end

        end
    end
end)


RegisterNetEvent('blckhndr_police:armory:request')
AddEventHandler('blckhndr_police:armory:request', function (armory_id)
    TriggerServerEvent('blckhndr_police:armory:request', armory_id, policelevel)
end)
