local current_characters = {}
AddEventHandler('blckhndr_main:updateCharacters', function(tbl)
  current_characters = tbl
end)
RegisterServerEvent('blckhndr_jail:spawn')
AddEventHandler('blckhndr_jail:spawn', function(char_id)
  local src = source
	MySQL.Async.fetchAll("SELECT * FROM `blckhndr_characters` WHERE char_id = @id", { ['@id'] = char_id}, function (result)
    if(result[1] == nil) then
			print('we dont have a fucking clue')
		else
      print(char_id..' HAS '..result[1].char_jailtime..' LEFT IN JAIL')
			TriggerClientEvent('blckhndr_jail:spawn:recieve', src, result[1].char_jailtime)
		end
	end)
end)

RegisterServerEvent('blckhndr_jail:sendsuspect')
AddEventHandler('blckhndr_jail:sendsuspect', function(src, player, time)
  local character = 0
  for k, v in pairs(current_characters) do
    if v.ply_id == player then
      character = v.char_id
    end
  end
  MySQL.Async.execute("UPDATE `blckhndr_characters` SET `char_jailtime` = '"..time.."' WHERE `char_id` = '"..character.."';", {})
  TriggerClientEvent('pNotify:SendNotification', src, {text = "You jailed "..player.." for " ..math.floor(time/60).. "mins.",
    layout = "centerRight",
    timeout = 300,
    progressBar = true,
    type = "success"
  })
  TriggerClientEvent('blckhndr_jail:spawn:recieve', player, time)
end)

RegisterServerEvent('blckhndr_jail:update:database')
AddEventHandler('blckhndr_jail:update:database', function(time)
  for k, v in pairs(current_characters) do
    if v.ply_id == source then
      char_id = v.char_id
    end
  end
  MySQL.Async.execute("UPDATE `blckhndr_characters` SET `char_jailtime` = '"..time.."' WHERE `char_id` = '"..char_id.."';", {})
  TriggerClientEvent('pNotify:SendNotification', source, {text = "Jailtime updated to "..time,
    layout = "centerRight",
    timeout = 300,
    progressBar = true,
    type = "success"
  })
end)
