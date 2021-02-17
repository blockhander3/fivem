-- path for live server
local datastorePath = 'resources/'..GetCurrentResourceName()..'/datastore/'

local dbg = false -- misc notifications for the client
if dbg then
	-- path for james' pc
	datastorePath = 'F:/FiveM/zblckhndr_fxs-server/resources/[fsn]/blckhndr_phones/datastore/'
end

function createNumber()
	local created = false
	local num = 'not-defined-number'
	while not created do --Citizen.Wait(0)
		num = math.random(0,9)..math.random(0,9)..math.random(0,9)..'-'..math.random(0,9)..math.random(0,9)..math.random(0,9)..'-'..math.random(0,9)..math.random(0,9)..math.random(0,9)
		if not io.open(datastorePath..'contacts/'..num..'.txt', 'r') then
			
			local contactFile, err = io.open(datastorePath..'contacts/'..num..'.txt', 'a')
			if not contactFile then return print(err) end
			contactFile:write('[]')
			contactFile:close()
			
			local messagesFile = io.open(datastorePath..'messages/'..num..'.txt', 'a')
			messagesFile:write('[]')
			messagesFile:close()
			
			created = true
		end
	end
	if created then
		return num
	end
end

RegisterServerEvent('blckhndr_phones:SYS:request:details')
AddEventHandler('blckhndr_phones:SYS:request:details', function(num, details)
	local deets = {}
	
    local f = assert(io.open(datastorePath..details..'/'..num..'.txt', "rb"))
    local content = f:read("*all")
    f:close()

	deets = json.decode(content)
	
	TriggerClientEvent('blckhndr_phones:SYS:recieve:details', source, details, deets)
end)

RegisterServerEvent('blckhndr_phones:SYS:set:details')
AddEventHandler('blckhndr_phones:SYS:set:details', function(num, details, tbl)
	local detailsFile = io.open(datastorePath..details..'/'..num..'.txt', 'w')
	detailsFile:write(json.encode(tbl))
	detailsFile:close()
	
	if dbg then
		TriggerClientEvent('blckhndr_phones:GUI:notification', source, 'img/Apple/Contact.png', 'DEBUG', 'Your '..details..' have been updated.', true)
	end
end)

RegisterServerEvent('blckhndr_phones:SYS:requestGarage')
AddEventHandler('blckhndr_phones:SYS:requestGarage', function()
	local char_id = exports["blckhndr_main"]:blckhndr_CharID(source)
	local src = source
	MySQL.Async.fetchAll("SELECT * FROM blckhndr_vehicles where char_id = @charid", {['@charid'] = char_id }, function(tbl)
		TriggerClientEvent('blckhndr_phones:SYS:receiveGarage', src, tbl)
    end)
end)

--TriggerEvent('blckhndr_phones:SYS:set:details', '504-262-425', 'contacts', {{name='james',number='999-999-999'},{name='james',number='999-999-999'},{name='james',number='999-999-999'}})

RegisterServerEvent('blckhndr_phones:SYS:newNumber')
AddEventHandler('blckhndr_phones:SYS:newNumber', function(charid)
  local src = source
  local number = createNumber()
  MySQL.Async.execute('UPDATE `blckhndr_characters` SET `char_phone` = @number WHERE `blckhndr_characters`.`char_id` = @charid;', {['@charid'] = charid, ['@number'] = number}, function(rowsChanged)
    TriggerClientEvent('blckhndr_phones:SYS:updateNumber', src, number)
	TriggerEvent('blckhndr_main:updateCharNumber', charid, number)
	TriggerClientEvent('blckhndr_phones:GUI:notification', src, 'img/Apple/Contact.png', 'PHONE', 'Your phone number has been updated to:<br><b>'..number..'</b>', true)
    TriggerClientEvent('blckhndr_phones:USE:Email', src, {
		subject = 'Welcome to LifeInvader!',
		image = 'https://vignette.wikia.nocookie.net/gtawiki/images/b/b6/Lifeinvader-GTAV-Logo.png/revision/latest/scale-to-width-down/350?cb=20150929201009',
		body = 'Hi,<br><br>Welcome to LifeInvader, the home of all things technology. We\'ve just processed your request for a new mobile number and have charged your account $250.<br><br><b>New number: </b>'..number..'<br><br>Regards,<br>LifeInvader Team',
    })
  end)
end)

RegisterServerEvent('blckhndr_phones:UTIL:chat')
AddEventHandler('blckhndr_phones:UTIL:chat', function(str, players)
  for k, v in pairs(players) do
    TriggerClientEvent('chatMessage', v, '', {255,255,255}, str)
  end
end)

RegisterServerEvent('blckhndr_phones:USE:sendMessage')
AddEventHandler('blckhndr_phones:USE:sendMessage', function(msg)
	TriggerClientEvent('blckhndr_phones:USE:Message', -1, msg)
end)

RegisterServerEvent('blckhndr_phones:SYS:sendTweet')
AddEventHandler('blckhndr_phones:SYS:sendTweet', function(twt)
	twt.datetime = os.time()
	TriggerClientEvent('blckhndr_phones:USE:Tweet', -1, twt)
end)

local ads = {}
RegisterServerEvent('blckhndr_phones:USE:requestAdverts')
AddEventHandler('c', function()
	TriggerClientEvent('blckhndr_phones:SYS:updateAdverts', source, ads)
end)

RegisterServerEvent('blckhndr_phones:USE:sendAdvert')
AddEventHandler('blckhndr_phones:USE:sendAdvert', function(ad, name, num)
	for k, v in pairs(ads) do
		if v.playerid == source then
			ads[k] = nil
		end
	end
	table.insert(ads, #ads+1, {
		playerid = source,
		name = name,
		advert = ad,
		number = num
	})
	TriggerClientEvent('blckhndr_phones:SYS:updateAdverts', -1, ads)
end)
AddEventHandler('playerDropped', function()
	for k, v in pairs(ads) do
		if v.playerid == source then
			ads[k] = nil
			TriggerClientEvent('blckhndr_phones:SYS:updateAdverts', -1, ads)
		end
	end
end)