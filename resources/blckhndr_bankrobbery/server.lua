local vault_doors = {
  [1] = {'closed'},
  [2] = {'closed'},
  [3] = {'closed'},
  [4] = {'closed'},
  [5] = {'closed'},
}

local banks_payout = {
  [1] = 1500000,
  [2] = 2000000,
  [3] = 800000,
  [4] = 1000000,
  [5] = 1000000
}

local canrob = true
local lastrob = 0
local currenttime = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if currenttime < 1800 or lastrob+1800 < currenttime then
			canrob = true
			TriggerClientEvent('blckhndr_bankrobbery:timer', -1, true)
		else
			canrob = false
			TriggerClientEvent('blckhndr_bankrobbery:timer', -1, false)
		end
		currenttime = currenttime + 1
	end 
end)

AddEventHandler('blckhndr_main:money:bank:Add', function(ply, amt)
	local randomizer = amt / math.random(1,5)
	banks_payout[1] = banks_payout[1] + randomizer
	banks_payout[2] = banks_payout[2] + randomizer
	banks_payout[3] = banks_payout[3] + randomizer
	banks_payout[4] = banks_payout[4] + randomizer
	banks_payout[5] = banks_payout[5] + randomizer
end)

AddEventHandler('blckhndr_main:money:bank:Minus', function(ply, amt)
	local randomizer = amt / math.random(1,5)
	banks_payout[1] = banks_payout[1] - randomizer
	banks_payout[2] = banks_payout[2] - randomizer
	banks_payout[3] = banks_payout[3] - randomizer
	banks_payout[4] = banks_payout[4] - randomizer
	banks_payout[5] = banks_payout[5] - randomizer
end)

RegisterServerEvent('blckhndr_bankrobbery:vault:open')
AddEventHandler('blckhndr_bankrobbery:vault:open', function(id)
  print('attempting to open door '..id)
  vault_doors[id][1] = 'open'
  TriggerClientEvent('blckhndr_bankrobbery:openDoor', -1, id)
end)

RegisterServerEvent('blckhndr_bankrobbery:start')
AddEventHandler('blckhndr_bankrobbery:start', function()
	lastrob = currenttime
end)

RegisterServerEvent('blckhndr_bankrobbery:vault:close')
AddEventHandler('blckhndr_bankrobbery:vault:close', function(id)
  print('attempting to close door '..id)
  vault_doors[id][1] = 'closed'
  TriggerClientEvent('blckhndr_bankrobbery:closeDoor', -1, id)
end)

RegisterServerEvent('blckhndr_bankrobbery:init')
AddEventHandler('blckhndr_bankrobbery:init', function()
  TriggerClientEvent('blckhndr_bankrobbery:init', source, vault_doors)
  TriggerClientEvent('blckhndr_bankrobbery:timer', source, canrob)
end)

RegisterServerEvent('blckhndr_bankrobbery:payout')
AddEventHandler('blckhndr_bankrobbery:payout', function(id)
  if banks_payout[id] > 0 then
    local amt = banks_payout[id] / 6
    amt = amt / math.random(1,8)
    amt = math.floor(amt)
    banks_payout[id] = banks_payout[id] - amt
    print(':blckhndr_bankrobbery: '..source..' robbed bank #'..id..' and took $'..amt..' leaving the bank with $'..banks_payout[id])
    TriggerClientEvent('blckhndr_inventory:item:add', source, 'dirty_money', amt)
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You got $'..amt..'DM from the vault!!', 'centerRight', 8000, 'error')
    TriggerClientEvent('blckhndr_needs:stress:add', 30)
  else
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'This bank has no money left!', 'centerRight', 8000, 'error')
  end
end)
