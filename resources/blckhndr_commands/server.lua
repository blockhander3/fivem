local current_characters = {}
AddEventHandler('blckhndr_main:updateCharacters', function(tbl)
  current_characters = tbl
end)

local function getCharacter(source)
  for k, v in pairs(current_characters) do
    if v.ply_id == source then
      return current_characters[k]
    end
  end
end
function blckhndr_SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
local ems_cars = {
  [1] = "ALS5",
  [2] = "fire_ambulance2",
  [3] = "fire1",
  [4] = "Pump",
  [5] = "eng5",
  [6] = "chief",
  [7] = "newtahoe2",
  [8] = "batallionf350",
  [9] = "fiheavy2",
  [10] = "supervolito",
}
local pd_cars = {
  --------------------
  -- LSPD
  --------------------
  [101] = "police",
  [102] = "police2",
  [103] = "police3",
  [104] = "police4",
  [105] = "sheriff",
  [106] = "sheriff2",
  [107] = "tahoe",
  [108] = "charger14",
  [109] = "charger18",
  [110] = "pdbike",
  [111] = "pbus",
  [112] = "PoliceT",
  [113] = "Predator",
  [114] = "eheli",
  [115] = "1raptor",
  [116] = "ram",
  --------------------
  -- SASP
  --------------------
  [201] = "vicb",
  [202] = "taurusb",
  [203] = "capriceb",
  [204] = "fusionb",
  [205] = "explorer13b",
  [206] = "explorer16b",
  [207] = "tahoeb",
  [208] = "charger14b",
  [209] = "charger18b",
  [210] = "f150s",
  [211] = "f150",
  [212] = "bmwbike",
  --------------------
  -- UNMARKED
  --------------------
  [1001] = "fbi",
  [1002] = "fbi2",
  [1003] = "polschafter3",
  [1004] = "plimo",
  --------------------
  -- SUPERCARS
  --------------------
  [2001] = "2015polstang",
  [2002] = "chaleo",
}

local emotes = {
  scenario = {
    ["binoculars"] = "WORLD_HUMAN_BINOCULARS",
    ["slumped"] = "WORLD_HUMAN_BUM_SLUMPED",
    ["bummed"] = "WORLD_HUMAN_BUM_STANDING",
    ["cheering"] = "WORLD_HUMAN_CHEERING",
    ["drinking"] = "WORLD_HUMAN_DRINKING",
    ["clipboard"] = "WORLD_HUMAN_CLIPBOARD",
    ["photo"] = "WORLD_HUMAN_PAPARAZZI",
    ["usemap"] = "WORLD_HUMAN_TOURIST_MAP",
    ["takepicture"] = "WORLD_HUMAN_TOURIST_MOBILE",
    ["record"] = "WORLD_HUMAN_MOBILE_FILM_SHOCKING",
    ["call"] = "WORLD_HUMAN_STAND_MOBILE",
    ["text"] = "WORLD_HUMAN_STAND_MOBILE_UPRIGHT",
    ["guard"] = "WORLD_HUMAN_GUARD_STAND",
    ["hangout"] = "WORLD_HUMAN_HANG_OUT_STREET",
    ["smoke"] = "WORLD_HUMAN_SMOKING",
    ["smokepot"] = "WORLD_HUMAN_SMOKING_POT",
    ["sunbathe1"] = "WORLD_HUMAN_SUNBATHE",
    ["sunbathe2"] = "WORLD_HUMAN_SUNBATHE_BACK",
    ["yoga"] = "WORLD_HUMAN_YOGA",
    ["jogging"] = "WORLD_HUMAN_JOG_STANDING",
    ["leaning"] = "WORLD_HUMAN_LEANING",
    ["cleaning"] = "WORLD_HUMAN_CLEANING",
    ["flexing"] = "WORLD_HUMAN_MUSCLE_FLEX",
    ["partying"] = "WORLD_HUMAN_PARTYING",
    ["sit1"] = "WORLD_HUMAN_PICNIC",
    ["highclass"] = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",
    ["lowclass"] = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS",
    ["impatient1"] = "WORLD_HUMAN_STAND_IMPATIENT",
    ["impatient2"] = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT",
    ["impatient3"] = "PROP_HUMAN_STAND_IMPATIENT",
    ["cop"] = "WORLD_HUMAN_COP_IDLES",
    ["notepad"] = "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
    ["statue"] = "WORLD_HUMAN_HUMAN_STATUE",
    ["bumrail"] = "PROP_HUMAN_BUM_SHOPPING_CART",
    ["chinups"] = "PROP_HUMAN_MUSCLE_CHIN_UPS",
    ["benchpress"] = "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS",
    ["sunlounger"] = "PROP_HUMAN_SEAT_SUNLOUNGER",
    ["kneel1"] = "CODE_HUMAN_MEDIC_KNEEL",
    ["kneel2"] = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
  },
  anim = {
    ["dancem2"] = {"move_clown@p_m_two_idles@", "fidget_short_dance"},
    ["dancem3"] = {"special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag"},
    ["dancem4"] = {"missfbi3_sniping", "dance_m_default"},
    ["dancef1"] = {"mini@strip_club@private_dance@part1", "priv_dance_p1"},
    ["dancef2"] = {"mini@strip_club@private_dance@part2", "priv_dance_p2"},
    ["dancef3"] = {"mini@strip_club@private_dance@part3", "priv_dance_p3"},
    ["dancef4"] = {"mp_am_stripper","lap_dance_girl"},
    ["pole"] = {"mini@strip_club@pole_dance@pole_dance1", "pd_dance_01"},
    ["sit2"] = {"rcm_barry3", "barry_3_sit_loop"},
    ["sit3"] = {"switch@michael@sitting", "idle"},
    ["sit4"] = {"switch@michael@restaurant", "001510_02_gc_mics3_ig_1_base_amanda"},
    ["sit5"] = {"amb@prop_human_seat_deckchair@female@idle_a", "idle_a"},
    ["sit6"] = {"timetable@amanda@ig_12", "amanda_idle_a"},
    ["sit7"] = {"amb@world_human_picnic@female@idle_a", "idle_b"},
    ["sit8"] = {"amb@world_human_picnic@male@idle_a", "idle_b"},
    ["sleep"] = {"timetable@tracy@sleep@", "idle_c"},
    ["meditate"] = {"rcmcollect_paperleadinout@", "meditiate_idle"},
    ["situps"] = {"amb@world_human_sit_ups@male@base", "base"},
    ["pushups"] = {"amb@world_human_push_ups@male@base", "base"},
    ["yoga1"] = {"amb@world_human_yoga@female@base", "base_a"},
    ["yoga2"] = {"amb@world_human_yoga@female@base", "base_b"},
    ["yoga3"] = {"amb@world_human_yoga@female@base", "base_c"},
    ["cry"] = {"missfam4leadinoutmcs2", "tracy_loop"},
    ["shakebutt"] = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper"},
    ["pee"] = {"misscarsteal2peeing", "peeing_loop"},
    ["poo"] = {"missfbi3ig_0", "shit_loop_trev"},
    ["fish"] = {"anim@mp_player_intcelebrationfemale@find_the_fish", "find_the_fish"},
    ["cpr2"] = {"missheistfbi3b_ig8_2", "cpr_loop_paramedic"},
  },
  halfanim = {
    ["wave1"] = {"random@car_thief@victimpoints_ig_3", "arms_waving"},
    ["wave2"] = {"random@gang_intimidation@", "001445_01_gangintimidation_1_female_idle_b"},
    ["hug1"] = {"mp_ped_interaction", "hugs_guy_a"},
    ["hug2"] = {"mp_ped_interaction", "hugs_guy_b"},
    ["kiss1"] = {"mp_ped_interaction", "kisses_guy_a"},
    ["kiss2"] = {"mp_ped_interaction", "kisses_guy_b"},
    ["petsteve"] = {"creatures@rottweiler@tricks@", "petting_franklin"},
    ["dancem1"] = {"misschinese2_crystalmazemcs1_cs", "dance_loop_tao"},
    ["handsup"] = {"random@mugging3", "handsup_standing_base"},
    ["cuffed"] = {"mp_arresting", "idle"},
    ["cross1"] = {"amb@world_human_hang_out_street@male_c@base", "base"},
    ["cross2"] = {"amb@world_human_hang_out_street@female_arms_crossed@base", "base"},
    ["cross3"] = {"amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a"},
    ["cross4"] = {"missfbi_s4mop", "guard_idle_a"},
    ["cross5"] = {"oddjobs@assassinate@construction@", "unarmed_fold_arms"},
    ["mfinger"] = {"anim@mp_player_intselfiethe_bird", "idle_a"},
    ["arse"] = {"mp_player_int_upperarse_pick", "mp_player_int_arse_pick"},
    ["fpalm"] = {"anim@mp_player_intupperface_palm", "idle_a"},
    ["thumbsup1"] = {"anim@mp_player_intcelebrationfemale@thumbs_up", "thumbs_up"},
    ["thumbsup2"] = {"anim@mp_player_intselfiethumbs_up", "idle_a"},
    ["nose"] = {"anim@mp_player_intcelebrationfemale@nose_pick", "nose_pick"},
    ["cash"] = {"anim@mp_player_intcelebrationfemale@raining_cash", "raining_cash"},
    ["fingerkiss"] = {"anim@mp_player_intcelebrationmale@finger_kiss", "finger_kiss"},
    ["jazzhands"] = {"anim@mp_player_intcelebrationmale@jazz_hands", "jazz_hands"},
    ["fistl"] = {"anim@mp_player_intcelebrationpaired@f_f_fist_bump", "fist_bump_left"},
    ["gang1"] = {"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a"},
    ["gang2"] = {"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b"},
    ["thumbsdown"] = {"anim@arena@celeb@flat@solo@no_@", "thumbs_down_a_player_a"},
    ["cpr1"] = {"missheistfbi3b_ig8_2", "cpr_loop_paramedic"},
    --["fapping"] = {"switch@trevor@jerking_off", "trev_jerking_off_loop"},
    ["shakefist"] = {"amb@code_human_in_car_mp_actions@dance@bodhi@ds@base", "idle_a_fp"},
  }
}

local clipsets = {
  ["reset"] = 'reset',
  ["franklin"] = 'move_characters@michael@fire',
  ["flee"] = 'move_f@flee@a',
  ["scared"] = 'move_f@scared',
  ["sexy"] = 'move_f@sexy@a',
  ["sexy"] = 'move_f@sexy@a',
  ["tazered"] = 'MOVE_M@BAIL_BOND_TAZERED',
  ["drunk1"] = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
  ["drunk2"] = "MOVE_M@DRUNK@MODERATEDRUNK",
  ["drunk3"] = "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP",
  ["drunk4"] = "MOVE_M@DRUNK@VERYDRUNK",
  ["gangster1"] = 'move_m@gangster@var_i',
  ["gangster2"] = 'move_m@gangster@var_e',
  ["gangster3"] = 'move_m@gangster@var_f',
  ["jog"] = 'move_m@JOG@',
  ["femme"] = 'MOVE_M@FEMME@',
  ["posh"] = 'MOVE_M@POSH@',
  ["tough"] = 'MOVE_M@TOUGH_GUY@'
}

function tobool(val)
  if val == 'true' then
    return true
  else
    return false
  end
end

local onduty_police = {}
AddEventHandler('blckhndr_police:update', function(tbl)
  onduty_police = tbl
end)
function blckhndr_policeOnDuty(id)
  for k, v in pairs(onduty_police) do
    if v.ply_id == id then
      return true
    end
  end
  return false
end
function blckhndr_policeCommand(id)
  for k, v in pairs(onduty_police) do
    if v.ply_id == id then
      if v.ply_lvl > 6 then
        return true
      else
        return false
      end
    end
  end
  return false
end

local onduty_ems = {}
AddEventHandler('blckhndr_ems:update', function(tbl)
  onduty_ems = tbl
end)
function blckhndr_emsOnDuty(id)
  for k, v in pairs(onduty_ems) do
    if v.ply_id == id then
      return true
    end
  end
  return false
end
function blckhndr_emsCommand(id)
  for k, v in pairs(onduty_ems) do
    if v.ply_id == id then
      if v.ply_lvl > 6 then
        return true
      else
        return false
      end
    end
  end
  return false
end

function blckhndr_isDeveloper(source)
  local devid = {
    'steam:110000115656753',
    'steam:110000115dc71e1',
    'steam:1100001160a1d63',
  }
  local steamid = GetPlayerIdentifiers(source)[1]
  return table.contains(devid, steamid)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

RegisterServerEvent('blckhndr_commands:me')
AddEventHandler('blckhndr_commands:me', function(action, players)
  local source_char = getCharacter(source)
  local msg = action
  for _, ply in pairs(players) do
    TriggerClientEvent('blckhndr_commands:me:3d', ply, source, msg)
  end
end)

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end
local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

local hdc = randomString(6)
RegisterServerEvent('blckhndr_commands:requestHDC')
AddEventHandler('blckhndr_commands:requestHDC', function()
  TriggerClientEvent('blckhndr_commands:getHDC', source, hdc)
end)

local pings = {}
RegisterServerEvent('blckhndr_commands:service:addPing')
AddEventHandler('blckhndr_commands:service:addPing', function(xyz, to)
	local idee = #pings+1
	table.insert(pings, idee, {
		loc = xyz,
		from = source,
		isfor = to,
		handled = false,
	})
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Your ping was sent to '..to })
	TriggerClientEvent('mythic_notify:client:SendAlert', to, { type = 'inform', text = 'You received a new ping from ['..source..'], use "/ping accept '..idee..'" or "/ping decline '..idee})
end)

local nineoneones = {}
local nineoneone = 0
AddEventHandler('chatMessage', function(source, auth, msg)
  local split = blckhndr_SplitString(string.lower(msg), ' ')
  local origSplit = blckhndr_SplitString(msg, ' ')
  TriggerEvent('blckhndr_main:logging:addLog', source, 'chat', 'Player('..source..') ran command: '..msg)
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- NEWS COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/news' then
	if split[2] == 'role' then
		TriggerClientEvent('blckhndr_jobs:news:role:Set', source, split[3])
	end
	if split[2] == 'toggle' then
		TriggerClientEvent('blckhndr_jobs:news:role:Toggle', source)
	end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- MONEY COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/givecash' or split[1] == '/gc' then
	if split[2] and split[3] then
		--AddEventHandler('blckhndr_main:money:wallet:Set', function(src, ply, amt)
    TriggerEvent('blckhndr_main:money:wallet:GiveCash', source, split[2], split[3])
    --TriggerServerEvent('blckhndr_main:logging:addLog', source, 'money', 'Character('..getCharacter(source)..') gave $'..split[3]..' to Character('..getCharacter(split[2])..')')
	else
		TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Usage: /givecash {PLAYER} {AMOUNT}')
	end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- CLOTHING COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/mask' or split[1] == '/m' then
    TriggerClientEvent('blckhndr_commands:clothing:mask', source)
  end
  if split[1] == '/hat' or split[1] == '/h' then
    TriggerClientEvent('blckhndr_commands:clothing:hat', source)
  end
  if split[1] == '/glasses' or split[1] == '/g' then
    TriggerClientEvent('blckhndr_commands:clothing:glasses', source)
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- SERVICE COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/ping' then
	if split[2] == 'accept' then 
		local ping = pings[tonumber(split[3])]
		if ping then
			if ping.handled == false and ping.isfor == source then
				TriggerClientEvent('blckhndr_commands:service:pingAccept', source, ping)
				TriggerClientEvent('mythic_notify:client:SendAlert', ping.from, { type = 'success', text = 'Ping Accepted' })
				ping.handled = true
			else
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r This ping has expired, request a new one.')
			end
		else
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Unknown ping')
		end		
	elseif split[2] == 'decline' then
		local ping = pings[tonumber(split[3])]
		if ping then
			if ping.handled == false and ping.isfor == source then
				TriggerClientEvent('mythic_notify:client:SendAlert', ping.from, { type = 'error', text = 'Ping Declined' })
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Ping Declined' })
				ping.handled = true
			else
				TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r This ping has expired, request a new one.')
			end
		else
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Unknown ping')
		end	
	else
		if tonumber(split[2]) then
			TriggerClientEvent('blckhndr_commands:service:pingStart', source, tonumber(split[2]))
			TriggerClientEvent('blckhndr_commands:me', source, 'hits ping button')
		else
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Provide a target!')
		end
	end
  end
  if split[1] == '/service' then
    if split[2] == 'request' then
      if split[3] == 'taxi' then
        TriggerClientEvent('blckhndr_commands:service:request', source, 'taxi')
      end
      if split[3] == 'ems' then
        TriggerClientEvent('blckhndr_commands:service:request', source, 'ems')
      end
      if split[3] == 'tow' then
        TriggerClientEvent('blckhndr_commands:service:request', source, 'tow')
      end
    end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- CHAT COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/playerinfo' then
    if split[2] and tonumber(split[2]) then
      local char = getCharacter(tonumber(split[2]))
      if char then
        if GetPlayerName(tonumber(split[2])) then
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0 '..GetPlayerName(tonumber(split[2]))..'#'..split[2]..'^r | SteamID: '..GetPlayerIdentifiers(tonumber(split[2]))[1]..' | CharID: '..char.char_id)
        else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0 '..char.ply_name..'#'..split[2]..'^r | SteamID: ^8DISCONNECTED^0 | CharID: '..char.char_id)
        end
      else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Cannot find that character?????.')
      end
    else
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r There was an issue with the arguments you provided.')
    end
  end
  if split[1] == '/911' then
    local char = getCharacter(source)
    local at = char.char_fname..' '..string.sub(char.char_lname, 1, 1)
    local msg = table.concat(origSplit, " ", 2, #origSplit)
    nineoneone = nineoneone + 1
    table.insert(nineoneones, nineoneone, source)
    TriggerClientEvent('blckhndr_emotecontrol:phone:call1', source)
    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^*^1 911 |^r^0 '..msg)
    TriggerClientEvent('blckhndr_police:911', -1, nineoneone, at, msg)
    TriggerClientEvent('blckhndr_ems:911', -1, nineoneone, at, msg)
  end
  if split[1] == '/911r' then
    if blckhndr_emsOnDuty(source) or blckhndr_policeOnDuty(source) then
      local char = getCharacter(source)
      local at = char.char_fname..' '..string.sub(char.char_lname, 1, 1)
      local src = nineoneones[tonumber(split[2])]
      local msg = table.concat(origSplit, " ", 3, #origSplit)
      if src then
        TriggerClientEvent('chatMessage', src, '', {255,255,255}, '^*^1 911 Responder |^r^0 '..msg)
        TriggerClientEvent('blckhndr_police:911r', -1, split[2], at, msg)
        TriggerClientEvent('blckhndr_ems:911r', -1, split[2], at, msg)
      else
        TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Could not find this 911 call.', 'centerRight', 4000, 'error')
      end
    else
      TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You are not on duty.', 'centerRight', 4000, 'error')
    end
  end
  if split[1] == '/walktype' then
	TriggerClientEvent('blckhndr_ems:set:WalkType', source, split[2])
  end
  if split[1] == '/destroyweapon' then
	if blckhndr_policeOnDuty(source) then
		TriggerClientEvent('blckhndr_criminalmisc:weapons:destroy', source)
	end
  end
  if split[1] == '/dropweapon' then
    TriggerClientEvent('blckhndr_criminalmisc:weapons:drop', source)
  end
  if split[1] == '/weaponinfo' then
    TriggerClientEvent('blckhndr_criminalmisc:weapons:info', source)
  end
  --[[if split[1] == '/phone' or split[1] == '/p' then
    TriggerClientEvent('blckhndr_phone:togglePhone', source)
    TriggerClientEvent('blckhndr_phones:USE:Phone', source)
  end--]]
  if split[1] == '/phonenumber' or split[1] == '/pn' then
    TriggerClientEvent('blckhndr_phone:displayNumber', source)
    TriggerClientEvent('blckhndr_phones:UTIL:displayNumber', source)
  end
  if split[1] == '/sit' or split[1] == '/s' then
    TriggerClientEvent('blckhndr_emotecontrol:sit', source)
  end
  if split[1] == '/me' or split[1] == '/m' then
    local action = table.concat( split, ' ', 2, #split )
    TriggerClientEvent('blckhndr_commands:me', source, action)
  end
  if split[1] == '/roll' or split[1] == '/dice' then
	if split[2] then
		if tonumber(split[2]) then
			if tonumber(split[2]) < 2 or tonumber(split[2]) > 12 then
				TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Provide a number between 2-12', 'centerRight', 4000, 'error')
			else
				local num = math.random(1, tonumber(split[2]))
				TriggerClientEvent('blckhndr_commands:me', source, 'rolled a dice: '..num..' / '..split[2])
				TriggerClientEvent('blckhndr_emotecontrol:dice:roll', source)
			end
		else
			TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Arguments need to be a number', 'centerRight', 4000, 'error')
		end
	else
		TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Provide a number between 2-12', 'centerRight', 4000, 'error')
	end
  end
  if split[1] == '/ooc' or split[1] == '/looc' then
    local action = table.concat( origSplit, ' ', 2, #origSplit )
    TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^*ooc '..GetPlayerName(source)..'#'..source..' | ^r'.. action)
  end
  if split[1] == '/airlift' then
    TriggerClientEvent('blckhndr_commands:airlift', source)
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- MISC COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/door' or split[1] == '/d' then
	--[[
	0 = Front Left Door  
	1 = Front Right Door  
	2 = Back Left Door  
	3 = Back Right Door  
	4 = Hood  
	5 = Trunk  
	6 = Back  
	7 = Back2
	]]--
	local doors = {
		["fl"] = 0,
		["fr"] = 1,
		["rl"] = 2,
		["rr"] = 3,
		["hood"] = 4,
		["trunk"] = 5,
		["back1"] = 6,
		["back2"] = 7,
	}
	if split[2] == 'open' or split[2] == 'o' then
		if doors[split[3]] then
			TriggerClientEvent('blckhndr_commands:vehdoor:open', source, doors[split[3]])
		elseif tonumber(split[3]) and table.contains(doors, tonumber(split[3])) then
			TriggerClientEvent('blckhndr_commands:vehdoor:open', source, tonumber(split[3]))
		else
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^r:FSN:^0^* There was an issue with the arguments you provided.')
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^r:FSN:^0^* FL/0 => Front Left | FR/1 => Front Right | RL/2 => Rear Left | RR/3 => Rear Right | HOOD/4 => Hood | TRUNK/5 => Trunk | BACK1/6 => Back Left | BACK2/7 => Back Right')
		end
	elseif split[2] == 'close' or split[2] == 'c' then
		if doors[split[3]] then
			TriggerClientEvent('blckhndr_commands:vehdoor:close', source, doors[split[3]])
		elseif tonumber(split[3]) and table.contains(doors, tonumber(split[3])) then
			TriggerClientEvent('blckhndr_commands:vehdoor:close', source, tonumber(split[3]))
		else
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^r:FSN:^0^* There was an issue with the arguments you provided.')
		end
	end
  end
  if split[1] == '/glovebox' or split[1] == '/gb' then
	TriggerClientEvent('blckhndr_inventory:veh:glovebox', source)
  end
  if split[1] == '/window' or split[1] == '/win' then
	TriggerClientEvent('blckhndr_commands:window', source)
  end
  if split[1] == '/clear' or split[1] == '/104' then
	TriggerClientEvent('blckhndr_main:blip:clear', source)
  end
  if split[1] == '/emote' or split[1] == '/e' then
    if emotes.scenario[split[2]] then
      TriggerClientEvent('blckhndr_emotecontrol:play', source, 'scenario', emotes.scenario[split[2]])
    elseif emotes.anim[split[2]] then
      TriggerClientEvent('blckhndr_emotecontrol:play', source, 'anim', emotes.anim[split[2]][1], emotes.anim[split[2]][2])
    elseif emotes.halfanim[split[2]] then
      TriggerClientEvent('blckhndr_emotecontrol:play', source, 'halfanim', emotes.halfanim[split[2]][1], emotes.halfanim[split[2]][2])
    else
      local str1 = '^*^4Emotes (1/3) | ^0^r '
      for k, v in pairs(emotes.scenario) do
        str1 = str1..', '..k
      end
      local str2 = '^*^4Emotes (2/3) | ^0^r '
      for k, v in pairs(emotes.anim) do
        str2 = str2..', '..k
      end
      local str3 = '^*^4Emotes (3/3) | ^0^r '
      for k, v in pairs(emotes.halfanim) do
        str3 = str3..', '..k
      end
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, str1)
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, str2)
      TriggerClientEvent('chatMessage', source, '', {255,255,255}, str3)
    end
  end
  if msg == '/money' then
    TriggerClientEvent('blckhndr_main:displayBankandMoney', source)
  end
  if msg == '/quit' then
    TriggerClientEvent('blckhndr_jobs:quit', source)
    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You have quit your job.', 'centerRight', 5000, 'success')
  end
  if msg == '/save' then
    TriggerClientEvent('blckhndr_main:characterSaving', source)
  end
  if split[1] == '/animations' or split[1] == '/anims' then
    TriggerClientEvent('chatMessage', source, ':FSN Animations (1/3)', {255,0,0}, 'holster, aim1-3, copcrowd, copcrowd2, rally, freeze, come, go, yes, fwd, busted, tiedfloor, hostage, collect, kick, kick2,')
    TriggerClientEvent('chatMessage', source, ':FSN Animations (2/3)', {255,0,0}, 'guard, earpiece, leanwall, leanwall2, sit-3, shower-3, swing-4, meditate, squat-2, help, taxi, wipe, hunchback, car, key, id, lockpick, check, sniff, sassy-2, tired, kneel, lean')
    TriggerClientEvent('chatMessage', source, ':FSN Animations (3/3)', {255,0,0}, 'salute, finger-2, palm, damn, gang, no, grabcrotch, peace, slowclap, cheer, nod, nod2, talk-4, wave-2, impatient-3, preach-2, crazy-3, sad, think, lapdance, dance2 - dance39, salsa, salsa2')
  end
  if msg == '/props' then
    TriggerClientEvent('chatMessage', source, ':FSN Props (1/2)', {255,0,0}, 'notes, callphone-2, umbrella, brief-2, cigar-2, joint, cig, holdcigar, holdcig, holdjoint, box, pizza, drug-3, wine, beer, shopping, soda, burger-2, burgershot-5,')
    TriggerClientEvent('chatMessage', source, ':FSN Props (2/2)', {255,0,0}, 'shot, boxing, drill, pot, smoke, coffee, bong, rose, cane, protext, backpack, dead-4, bum hurt-3, layfront, layback, bumper-2, tire-3, toolbox-3')
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- INVENTORY COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/use' then
    if split[2] then
      if split[2] == 'repair_kit' or split[2] == 'repair' then
        TriggerClientEvent('blckhndr_vehiclecontrol:damage:repair', source)
      end
    end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- HANDCUFFS COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/hdc' or split[1] == '/'..hdc then
    if split[1] == '/hdc' then
      if not blckhndr_isDeveloper(source) then
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^r:FSN:^0^* You are not a developer, /hdc is not available to you')
        return
      end
      if split[2] == 'toggle' then
        local target = tonumber(split[3])
        TriggerClientEvent('blckhndr_police:handcuffs:hard', target, target)
      end
      if split[2] == 'escort' then
        TriggerClientEvent('blckhndr_police:toggleDrag', tonumber(split[3]), source)
      end
      if split[2] == 'search' then
        local char = getCharacter(source)
        local officername = char.char_fname..' '..char.char_lname
        TriggerClientEvent('blckhndr_police:search:start:inventory', tonumber(split[3]), source)
        TriggerClientEvent('blckhndr_police:search:start:weapons', tonumber(split[3]), source)
        TriggerClientEvent('blckhndr_police:search:start:money', tonumber(split[3]), source)
        TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Searching everything of: <b>'..tonumber(split[3]), 'centerRight', 7000, 'info')
        TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[3]), 'Everything is being searched by: <b>'..officername..'</b><br><i>Money, weapons and inventory', 'centerRight', 7000, 'info')
      end
      if split[2] == 'rob' then
        local char = getCharacter(source)
        local officername = char.char_fname..' '..char.char_lname
        TriggerClientEvent('blckhndr_commands:hc:rob', tonumber(split[4]), source)
      end
      if split[2] == 'takephone' then
        TriggerClientEvent('blckhndr_commands:hc:takephone', tonumber(split[3]))
      end
    end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- DEVELOPER COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/dev' and blckhndr_isDeveloper(source) then
    if split[2] then
	  if split[2] == 'tuner' then
		TriggerClientEvent('xgc-tuner:openTuner', source)
	  end
	  if split[2] == 'inv' then
		TriggerClientEvent('blckhndr_inventory:ply:request', tonumber(split[3]), source)
	  end
	  if split[2] == 'softlog' then
		TriggerClientEvent('blckhndr_main:charMenu', source)
	  end
	  if split[2] == 'pedrevive' then
		TriggerClientEvent('blckhndr_commands:police:pedrevive', source)
	  end
	  if split[2] == 'pedcarry' then
		TriggerClientEvent('blckhndr_commands:police:pedcarry', source)
	  end
	  if split[2] == 'addmoney' then
		TriggerClientEvent('blckhndr_bank:change:walletAdd', source, tonumber(split[3]))
	  end
      if split[2] == 'pdduty' then
        if split[3] then
          TriggerClientEvent('blckhndr_police:command:duty', tonumber(split[3]))
        else
          TriggerClientEvent('blckhndr_police:command:duty', source)
        end
      end
      if split[2] == 'setinfractions' then
        TriggerClientEvent('blckhndr_licenses:setinfractions', split[3], split[4], tonumber(split[5]))
        TriggerClientEvent('blckhndr_notify:displayNotification', split[3], ':FSN: A developer ('..source..') set your '..split[4]..' license infractions to '..split[5], 'centerLeft', 8000, 'info')
        TriggerClientEvent('blckhndr_notify:displayNotification', source, ':FSN: You set '..split[3]..'\'s '..split[4]..' infractions to '..split[5], 'centerRight', 8000, 'success')
      end
      if split[2] == 'debug' then
        TriggerClientEvent('blckhndr_dev:debug', source)
      end
	  if split[2] == 'insdbg' then
        TriggerClientEvent('blckhndr_apartments:instance:debug', source)
      end
      if split[2] == 'mdt' then
        TriggerClientEvent('blckhndr_police:MDT:toggle', source)
      end
      if split[2] == 'revive' then
        TriggerClientEvent('blckhndr_ems:reviveMe:force', source)
      end
      if split[2] == 'xyz' then
        TriggerClientEvent('blckhndr_commands:sendxyz', source)
      end
      if split[2] == 'car' then
        if split[3] then
          TriggerClientEvent('blckhndr_commands:dev:spawnCar', source, split[3])
        end
      end
      if split[2] == 'weapon' then
        if split[3] then
          TriggerClientEvent('blckhndr_commands:dev:weapon', source, split[3], split[4])
        end
      end
      if split[2] == 'fix' then
        TriggerClientEvent('blckhndr_commands:dev:fix', source)
      end
      if split[2] == 'giveitem' then
        if split[3] then
          if split[4] then
            TriggerClientEvent('blckhndr_inventory:item:add', source, split[3], tonumber(split[4]))
          end
        end
      end
      if split[2] == 'kill' then
        if split[3] then
            TriggerClientEvent('blckhndr_ems:killMe', tonumber(split[3]))
        else
          TriggerClientEvent('blckhndr_ems:killMe', source)
        end
      end
      if split[2] == 'tpm' then
        TriggerClientEvent('blckhndr_teleporters:teleport:waypoint', source)
      end
      if split[2] == 'tpc' then
        TriggerClientEvent('blckhndr_teleporters:teleport:coordinates', source, tonumber(split[3]), tonumber(split[4]), tonumber(split[5]))
      end
      if split[2] == 'noclip' then
        TriggerClientEvent('blckhndr_dev:noClip:enabled', source)
      end
      if split[2] == 'impound' then
        TriggerClientEvent('blckhndr_commands:police:impound', source)
      end
    end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- EMS COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/ems' then
    if blckhndr_emsOnDuty(source) then
	  if split[2] == 'inspect' then 
		if tonumber(split[3]) then
		  TriggerClientEvent('blckhndr_ems:adamage:request', tonumber(split[3]), source)
		else
		  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
		end
	  end
	  if split[2] == 'item' then
		if split[3] == 'bandage' or split[3] == 'b' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'bandage', 1)
		end
		if split[3] == 'morphine' or split[3] == 'm' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'morphine', 1)
		end
		if split[3] == 'painkillers' or split[3] == 'pk' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'painkillers', 1)
		end
	  end
	  if split[2] == 'frevive' then
		TriggerClientEvent('blckhndr_ems:reviveMe:force', tonumber(split[3]))
	  end
	  if split[2] == 'tow' then
			if split[3] then
				if split[3] == 'target' or split[3] == 't' then
					TriggerClientEvent('blckhndr_commands:police:towMark', source)
				else
					TriggerEvent('blckhndr_jobs:tow:mark', tostring(split[3]), source)
					TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You marked <b>'..split[3]..'</b> for tow, remember to request tow', 'centerRight', 7000, 'info')
				end
			else
				TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'Provide a plate to mark, or type "target"/"t" to mark the car you\'re looking at.')
			end
		end
	  if split[2] == 'extra' then
          if split[3] then
            if split[3] == 'all' then
              TriggerClientEvent('blckhndr_commands:police:extra', source, 'all', split[4])
              return
            end
            if tonumber(split[3]) then
              TriggerClientEvent('blckhndr_commands:police:extra', source, tonumber(split[3]))
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
          end
        end
	  if split[2] == 'livery' then
          if split[3] then
            if tonumber(split[3]) then
              TriggerClientEvent('blckhndr_commands:police:livery', source, tonumber(split[3]))
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')``
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
          end
        end
	  if split[2] == 'impound' then
        TriggerClientEvent('blckhndr_commands:police:impound', source)
      end
	  if split[2] == 'ped' then
		if split[3] == 'carry' then
			TriggerClientEvent('blckhndr_commands:police:pedcarry', source)
		end
		if split[3] == 'revive' then
			TriggerClientEvent('blckhndr_commands:police:pedrevive', source)
		end
	end
      if split[2] == 'car' then
        if tonumber(split[3]) then
          TriggerClientEvent('blckhndr_commands:police:car', source, ems_cars[tonumber(split[3])])
        else
          TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
        end
      end
      if split[2] == 'command' then
        if blckhndr_emsCommand(source) then
          if split[3] == 'level' then
            if tonumber(split[4]) then
              if tonumber(split[5]) then
                if exports.blckhndr_main:blckhndr_CharID(tonumber(split[4])) then
                  TriggerClientEvent('blckhndr_ems:updateLevel', tonumber(split[4]), tonumber(split[5]))
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You set '..tonumber(split[4])..'\'s (#'..exports.blckhndr_main:blckhndr_CharID(tonumber(split[4]))..') EMS level to <b>'..tonumber(split[5]), 'centerRight', 7000, 'info')
                  MySQL.Sync.execute("UPDATE `blckhndr_characters` SET `char_ems` = @popo WHERE `char_id` = @id", {['@id'] = exports.blckhndr_main:blckhndr_CharID(tonumber(split[4])), ['@popo'] = tonumber(split[5])})
                else
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, ':FSN: We\'re having issues finding that person.', 'centerRight', 7000, 'error')
                end
              else
                TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a level.')
              end
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
        else
          TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You are not EMS command.')
        end
      end
      if split[2] == 'escort' then
        TriggerClientEvent('blckhndr_police:toggleDrag', tonumber(split[3]), source)
      end
      if split[2] == 'vehicle' then
        if split[3] and tonumber(split[3]) then
          TriggerClientEvent('blckhndr_police:putMeInVeh', split[3])
        end
      end
      if split[2] == 'revive' then
        if split[3] then
          if split[3] ~= source then
            TriggerClientEvent('blckhndr_ems:reviveMe', tonumber(split[3]))
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You are not a god. You cannot revive yourself.')
          end
        else
          TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
        end
      end
    end
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------
  -- POLICE COMMANDS
  -------------------------------------------------------------------------------------------------------------------------------------------------
  if split[1] == '/ar' or split[1] == '/rifle' then
	if blckhndr_policeOnDuty(source) then
		TriggerClientEvent('blckhndr_commands:police:rifle', source)
	end
  end
  if split[1] == '/sg' or split[1] == '/shotgun' then
	if blckhndr_policeOnDuty(source) then
		TriggerClientEvent('blckhndr_commands:police:shotgun', source)
	end
  end
  if split[1] == '/police' or split[1] == '/pd' then
    if blckhndr_policeOnDuty(source) then
      if split[2] then
		if split[2] == 'inspect' then 
			if tonumber(split[3]) then
			  TriggerClientEvent('blckhndr_ems:adamage:request', tonumber(split[3]), source)
			else
			  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
			end
		  end
	  if split[2] == 'item' then
		if split[3] == 'bandage' or split[3] == 'b' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'bandage', 1)
		end
		if split[3] == 'morphine' or split[3] == 'm' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'morphine', 1)
		end
		if split[3] == 'painkillers' or split[3] == 'pk' then
			TriggerClientEvent('blckhndr_inventory:item:add', source, 'painkillers', 1)
		end
	  end
		if split[2] == 'fine' then
			if tonumber(split[3]) then
				if tonumber(split[4]) then
					local char = getCharacter(source)
					local officername = char.char_fname..' '..char.char_lname
					
					local char = getCharacter(tonumber(split[3]))
					local perpname = char.char_fname..' '..char.char_lname
					
					TriggerClientEvent('chatMessage', -1, '', {255,255,255}, perpname..' was fined ^4$'..split[4]..'^0 by: '..officername)
					TriggerEvent('blckhndr_police:ticket', tonumber(split[3]), tonumber(split[4]))
				else
					TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'Provide a fine')
				end
			else
				TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'Provide a fine')
			end
		end
		if split[2] == 'mdt' then
			TriggerClientEvent('blckhndr_police:MDT:toggle', source)
			TriggerClientEvent('blckhndr_emotecontrol:police:tablet', source, "open")
		end
		if split[2] == 'gsr' then
			TriggerClientEvent('blckhndr_commands:police:gsrMe', tonumber(split[3]), source)
		end
		if split[2] == 'tow' then
			if split[3] then
				if split[3] == 'target' or split[3] == 't' then
					TriggerClientEvent('blckhndr_commands:police:towMark', source)
				else
					TriggerEvent('blckhndr_jobs:tow:mark', tostring(split[3]), source)
					TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You marked <b>'..split[3]..'</b> for tow, remember to request tow', 'centerRight', 7000, 'info')
				end
			else
				TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'Provide a plate to mark, or type "target"/"t" to mark the car you\'re looking at.')
			end
		end
		if split[2] == 'ped' then
			if split[3] == 'carry' then
				TriggerClientEvent('blckhndr_commands:police:pedcarry', source)
			end
			if split[3] == 'revive' then
				TriggerClientEvent('blckhndr_commands:police:pedrevive', source)
			end
		end
        if split[2] == 'radar' then
          TriggerClientEvent('blckhndr_police:radar:toggle', source)
        end
        if split[2] == 'emote' or split[2] == 'e' then
          if split[3] == 'ticket' then
            TriggerClientEvent('blckhndr_emotecontrol:police:ticket', source)
          end
        end
        if split[2] == 'cpic' then
          TriggerClientEvent('blckhndr_commands:police:cpic:trigger', source, split[3])
        end
        if split[2] == 'search' then
          if split[3] == 'all' then
            if split[4] then
              local char = getCharacter(source)
              local officername = char.char_fname..' '..char.char_lname
              --TriggerClientEvent('blckhndr_police:search:start:inventory', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_police:search:start:weapons', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_police:search:start:money', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Searching everything of: <b>'..tonumber(split[4]), 'centerRight', 7000, 'info')
              TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'Everything is being searched by: <b>'..officername..'</b><br><i>Money, weapons and inventory', 'centerRight', 7000, 'info')
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
          if split[3] == 'inventory' then
            if split[4] then
              local char = getCharacter(source)
              local officername = char.char_fname..' '..char.char_lname
              --TriggerClientEvent('blckhndr_police:search:start:inventory', tonumber(split[4]), source)
			  TriggerClientEvent('blckhndr_inventory:ply:request', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Searching <b>'..tonumber(split[4]), 'centerRight', 7000, 'info')
              TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You are being searched by officer <b>'..officername..'</b><br><i>This search is for inventory items', 'centerRight', 7000, 'info')
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
          if split[3] == 'weapons' then
            if split[4] then
              local char = getCharacter(source)
              local officername = char.char_fname..' '..char.char_lname
              TriggerClientEvent('blckhndr_police:search:start:weapons', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Patting down <b>'..tonumber(split[4]), 'centerRight', 7000, 'info')
              TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You are being patted down by officer <b>'..officername..'</b><br><i>This search is for weapons', 'centerRight', 7000, 'info')
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
          if split[3] == 'money' then
            if split[4] then
              local char = getCharacter(source)
              local officername = char.char_fname..' '..char.char_lname
              TriggerClientEvent('blckhndr_police:search:start:money', tonumber(split[4]), source)
              TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Bank check <b>'..tonumber(split[4]), 'centerRight', 7000, 'info')
              TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'Your money is being checked by <b>'..officername..'</b><br><i>This does not include dirty money', 'centerRight', 7000, 'info')
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
          if split[3] == 'strip' then
            if split[4] then
              local char = getCharacter(source)
              local officername = char.char_fname..' '..char.char_lname
              TriggerClientEvent('blckhndr_police:search:strip', tonumber(split[4]))
              TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Strip searching <b>'..tonumber(split[4]), 'centerRight', 7000, 'info')
              TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You have been strip searched by <b>'..officername..'</b><br><i>Weapons, Inventory & cash', 'centerRight', 7000, 'info')
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
        end
        if split[2] == 'k9' then
          if split[3] == 'search' then
            if split[4] == 'person' then
              TriggerClientEvent('blckhndr_police:k9:search:person:me', tonumber(split[5]), source)
            elseif split[4] == 'vehicle' then

            end
          end
        end
        if split[2] == 'command' then
          if blckhndr_policeCommand(source) then
            if split[3] == 'givelicense' then
              if tonumber(split[4]) then
                if split[5] == 'driver' or split[5] == 'drivers' then
                  TriggerClientEvent('blckhndr_licenses:police:give', tonumber(split[4]), 'driver')
                  TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You were granted a <b>Drivers License</b> with 0 infractions', 'centerRight', 7000, 'info')
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You granted '..split[4]..' a <b>Drivers License', 'centerRight', 7000, 'info')
                elseif split[5] == 'weapon' or split[5] == 'weapons' then
                  TriggerClientEvent('blckhndr_licenses:police:give', tonumber(split[4]), 'weapon')
                  TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You were granted a <b>Weapons License</b> with 0 infractions', 'centerRight', 7000, 'info')
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You granted '..split[4]..' a <b>Weapons License', 'centerRight', 7000, 'info')
                elseif split[5] == 'pilot' or split[5] == 'pilots' then
                  TriggerClientEvent('blckhndr_licenses:police:give', tonumber(split[4]), 'pilot')
                  TriggerClientEvent('blckhndr_notify:displayNotification', tonumber(split[4]), 'You were granted a <b>Pilots License</b> with 0 infractions', 'centerRight', 7000, 'info')
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You granted '..split[4]..' a <b>Pilots License', 'centerRight', 7000, 'info')
                else
                  TriggerClientEvent('blckhndr_notify:displayNotification', source, ':FSN: That is not a valid license type.', 'centerRight', 7000, 'error')
                end
              end
            end
            if split[3] == 'duty' then
              if tonumber(split[4]) then
                TriggerClientEvent('blckhndr_police:command:duty', tonumber(split[4]))
              else
                TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
              end
            end
            if split[3] == 'level' then
              if tonumber(split[4]) then
                if tonumber(split[5]) then
                  if exports.blckhndr_main:blckhndr_CharID(tonumber(split[4])) then
                    TriggerClientEvent('blckhndr_police:updateLevel', tonumber(split[4]), tonumber(split[5]))
                    TriggerClientEvent('blckhndr_notify:displayNotification', source, 'You set '..tonumber(split[4])..'\'s (#'..exports.blckhndr_main:blckhndr_CharID(tonumber(split[4]))..') police level to <b>'..tonumber(split[5]), 'centerRight', 7000, 'info')
                    MySQL.Sync.execute("UPDATE `blckhndr_characters` SET `char_police` = @popo WHERE `char_id` = @id", {['@id'] = exports.blckhndr_main:blckhndr_CharID(tonumber(split[4])), ['@popo'] = tonumber(split[5])})
                  else
                    TriggerClientEvent('blckhndr_notify:displayNotification', source, ':FSN: We\'re having issues finding that person.', 'centerRight', 7000, 'error')
                  end
                else
                  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a level.')
                end
              else
                TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
              end
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You are not a command member.')
          end
        end
        if split[2] == 'license' then
          if split[3] == 'infraction' then
            if split[4] then
              if split[5] then
                TriggerClientEvent('blckhndr_licenses:infraction', split[4], split[5], split[6])
                TriggerClientEvent('blckhndr_notify:displayNotification', split[4], split[6]..' points have been added to your '..split[5]..' license', 'centerLeft', 6000, 'info')
                TriggerClientEvent('blckhndr_notify:displayNotification', source, split[6]..' points have been added to '..split[4]..'\'s '..split[5]..' license', 'centerLeft', 6000, 'info')
              else
                TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide an amount.')
              end
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
            end
          end
          if split[3] == 'take' then
            if split[4] then
              if split[4] == 'driver' then
                if split[5] then
                  TriggerClientEvent('blckhndr_licenses:display', tonumber(split[5]), 'driver')
                else
                  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
                end
              end
              if split[4] == 'pilot' then
                if split[5] then
                  TriggerClientEvent('blckhndr_licenses:display', tonumber(split[5]), 'pilot')
                else
                  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
                end
              end
              if split[4] == 'all' then
                if split[5] then
                  TriggerClientEvent('blckhndr_licenses:display', tonumber(split[5]), 'all')
                else
                  TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
                end
              end
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a license.')
            end
          end
        end
        if split[2] == 'dispatch' then
          TriggerClientEvent('blckhndr_police:dispatch:toggle', source)
        end
        if split[2] == 'runplate' then
          if split[3] then
            TriggerEvent('blckhndr_police:runplate', source, split[3])
          else
            TriggerClientEvent('blckhndr_police:runplate:target', source)
          end
        end
        if split[2] == 'revive' then
			if #onduty_ems > 0 then
			TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'EMS may be online, reach them on the radio.')
			end
			if split[3] then
				if split[3] ~= source then
					TriggerClientEvent('blckhndr_ems:reviveMe', tonumber(split[3]))
				else
					TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You are not a god. You cannot revive yourself.')
				end
			else
				TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
			end
        end
        if split[2] == 'softcuff' or split[2] == 'sc' then
          if split[3] then
            local target = tonumber(split[3])
            if target then
              TriggerClientEvent('blckhndr_police:handcuffs:soft', target, target) --
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
          end
        end
        if split[2] == 'cuff' or split[2] == 'c' then
          if split[3] then
            local target = tonumber(split[3])
            if target then
              TriggerClientEvent('blckhndr_police:handcuffs:hard', target, target) --
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
          end
        end
        if split[2] == 'livery' then
          if split[3] then
            if tonumber(split[3]) then
              TriggerClientEvent('blckhndr_commands:police:livery', source, tonumber(split[3]))
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')``
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
          end
        end
        if split[2] == 'extras' then
          TriggerClientEvent('blckhndr_commands:police:extras', source)
        end
        if split[2] == 'extra' then
          if split[3] then
            if split[3] == 'all' then
              TriggerClientEvent('blckhndr_commands:police:extra', source, 'all', split[4])
              return
            end
            if tonumber(split[3]) then
              TriggerClientEvent('blckhndr_commands:police:extra', source, tonumber(split[3]))
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
          end
        end
        if split[2] == 'escort' then
          if split[3] and tonumber(split[3]) then
            TriggerClientEvent('blckhndr_police:toggleDrag', split[3], source)
          end
        end
        if split[2] == 'boot' then
          TriggerClientEvent('blckhndr_commands:police:boot', source)
        end
        if split[2] == 'unboot' then
          TriggerClientEvent('blckhndr_commands:police:unboot', source)
        end
        if split[2] == 'putinveh' then
          if split[3] and tonumber(split[3]) then
            TriggerClientEvent('blckhndr_police:putMeInVeh', split[3])
          end
        end
        if split[2] == 'car' then
          if tonumber(split[3]) then
			if tonumber(split[3]) < 2000 then
				TriggerClientEvent('blckhndr_commands:police:car', source, pd_cars[tonumber(split[3])])
			else
				if blckhndr_policeCommand(source) then
					TriggerClientEvent('blckhndr_commands:police:car', source, pd_cars[tonumber(split[3])])
				else
					TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You do not have the right level to drive this vehicle.')
				end
			end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
          end
        end
        if split[2] == 'fix' then
          TriggerClientEvent('blckhndr_commands:police:fix', source)
          local char = getCharacter(source)
          local officername = char.char_fname..' '..char.char_lname
          for k, v in pairs(onduty_police) do
            TriggerClientEvent('chatMessage', v.ply_id, '^5^*:blckhndr_police:^0^r '..officername..' used /fix', {255,255,255}, '')
          end
        end
        if split[2] == 'impound' then
          TriggerClientEvent('blckhndr_commands:police:impound', source)
        end
        if split[2] == 'impound2' then
          TriggerClientEvent('blckhndr_commands:police:impound2', source)
        end
        if split[2] == 'jail' then
          if split[3] then
            if split[4] then
              if tonumber(split[3]) and tonumber(split[4]) then
                local jailtime = tonumber(split[4])*60
				
				local char = getCharacter(source)
				local officername = char.char_fname..' '..char.char_lname
				
				local char = getCharacter(tonumber(split[3]))
				local perpname = char.char_fname..' '..char.char_lname
				
				TriggerClientEvent('chatMessage', -1, '', {255,255,255}, perpname..' was jailed for ^4'..split[4]..'^0 months by: '..officername)
                TriggerEvent('blckhndr_jail:sendsuspect', source, split[3], jailtime)
              else
                TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
              end
            else
              TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a time.')
            end
          else
            TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You need to provide a target.')
          end
        end
      else
        TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'There was an issue with the arguments you provided.')
      end
    else
      TriggerClientEvent('chatMessage', source, ':FSN:', {255,0,0}, 'You are not signed in on duty as a police officer.')
    end
  end
end)

RegisterServerEvent('blckhndr_commands:service:sendrequest')
AddEventHandler('blckhndr_commands:service:sendrequest', function(type, tbl)
  TriggerClientEvent('blckhndr_notify:displayNotification', source, 'Notification sent to all '..type..' workers.', 'centerLeft', 8000, 'info')
  if type == 'taxi' then
    TriggerClientEvent('blckhndr_jobs:taxi:request', -1, tbl)
  end
  if type == 'tow' then
    TriggerClientEvent('blckhndr_jobs:tow:request', -1, tbl)
  end
  if type == 'ems' then
    TriggerClientEvent('blckhndr_jobs:ems:request', -1, tbl)
  end
end)

RegisterServerEvent('blckhndr_commands:printxyz')
AddEventHandler('blckhndr_commands:printxyz', function(x,y,z,h)
  print('')
  print('XYZ Lua table:')
  print("{x = "..x..", y = "..y..", z = "..z.."}")
  print('')
  
  print('')
  print('XYZ JSON table:')
  print(json.encode({x=x,y=y,z=z}))
  
  print('')
  print('XYZH Lua table:')
  print("{x = "..x..", y = "..y..", z = "..z..", h = "..h.."}")
  
  print('')
  print('XYZH JSON table:')
  print(json.encode({x=x,y=y,z=z,h=h}))
  
  print('')
  print('XYZ GetCoords format:')
  print(x..", "..y..", "..z)
  print('')
end)

RegisterServerEvent('blckhndr_commands:police:booted')
AddEventHandler('blckhndr_commands:police:booted', function(plate, model)
  TriggerClientEvent('blckhndr_commands:police:updateBoot', -1, plate, model, true)
end)

RegisterServerEvent('blckhndr_commands:police:unbooted')
AddEventHandler('blckhndr_commands:police:unbooted', function(plate, model)
  TriggerClientEvent('blckhndr_commands:police:updateBoot', -1, plate, model, false)
end)

RegisterServerEvent('blckhndr_commands:police:gsrResult')
AddEventHandler('blckhndr_commands:police:gsrResult', function(officer, result)
	if result == true then
		if math.random(1,100) > 5 then
			TriggerClientEvent('chatMessage', officer, '', {255,255,255}, '^1^*GSR |^0^r The test begins to turn blue.')
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*GSR |^0^r The test begins to turn blue.')
		else
			TriggerClientEvent('chatMessage', officer, '', {255,255,255}, '^1^*GSR |^0^r The test is inconclusive.')
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*GSR |^0^r The test is inconclusive.')
		end
	else
		TriggerClientEvent('chatMessage', officer, '', {255,255,255}, '^1^*GSR |^0^r The test does nothing.')
		TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*GSR |^0^r The test does nothing.')
	end
end)
RegisterServerEvent('blckhndr_commands:ems:adamage:inspect')
AddEventHandler('blckhndr_commands:ems:adamage:inspect', function(parts, bleeding, bldtbl, dmgtbl, doctor)
	local limping = false
	for k, v in pairs(parts) do
		if v.isDamaged then
			TriggerClientEvent('chatMessage', doctor, '', {255,255,255}, '^1^*EMS |^0^r '..v.label..' is damaged: '..dmgtbl[v.severity])
			TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*EMS |^0^r '..v.label..' is damaged: '..dmgtbl[v.severity])
		end
		if v.causeLimp then
			limping = true
		end
	end
	if limping then
		TriggerClientEvent('chatMessage', doctor, '', {255,255,255}, '^1^*EMS |^0^r The individual is limping')
		TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*EMS |^0^r The individual is limping')
	end
	if bleeding > 0 then
		TriggerClientEvent('chatMessage', doctor, '', {255,255,255}, '^1^*EMS |^0^r The individual is bleeding! Severity: '..bldtbl[bleeding])
		TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*EMS |^0^r The individual is bleeding! Severity: '..bldtbl[bleeding])
	end
end)





