itemUses = {
	["crowbar"] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_criminalmisc:houserobbery:try')
		end,
	},
	["scuba"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:rebreather:use')
		end,
	},
	["id"] = {
		takeItem = false,
		use = function(item)
			local players = {}
			for _, ply in pairs(GetActivePlayers()) do
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(ply)),GetEntityCoords(GetPlayerPed(-1)),true) < 5 then
					players[#players+1] = GetPlayerServerId(ply)
				end
			end
			TriggerServerEvent('blckhndr_licenses:id:display', players, item.customData.Name, item.customData.Occupation, item.customData.DOB, item.customData.Issue, item.customData.CharID)
		end,
	},
	["painkillers"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('mythic_hospital:client:UsePainKiller', 2)
		end
	},
	["morphine"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('mythic_hospital:client:UsePainKiller', 6)
		end
	},
	["bandage"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('mythic_hospital:client:RemoveBleed')
			TriggerEvent('blckhndr_ems:ad:stopBleeding')
			TriggerEvent('blckhndr_evidence:ped:addState', 'Has bandage', 'UPPER_BODY', 20)
			if GetEntityHealth(GetPlayerPed(-1)) < 131 then
				TriggerEvent('blckhndr_inventory:item:take', 'bandage', 1)
				while ( not HasAnimDictLoaded( "oddjobs@assassinate@guard" ) ) do
					RequestAnimDict( "oddjobs@assassinate@guard" )
					Citizen.Wait( 5 )
				end
				TaskPlayAnim(GetPlayerPed(-1), "oddjobs@assassinate@guard", "unarmed_fold_arms", 8.0, 1.0, 2500, 2, 0, 0, 0, 0 )  
				Citizen.Wait(1500)
				SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1))+15)
			else
				TriggerEvent('blckhndr_notify:displayNotification', 'Nincs szükséged kötözésre!<br>Keress egy orvost, hogy gyogyíthass magadon.', 'centerLeft', 3500, 'error')
			end
		end
	},
	["repair_kit"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_vehiclecontrol:damage:repairkit')
		end
	},
	["beef_jerky"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 15)
		end
	},
	["cupcake"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 5)
		end
	},
	["cupcake"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 5)
			if math.random(1, 100) < 5 then
				TriggerEvent('blckhndr_evidence:ped:addState', 'Crumbs down chest', 'UPPER_BODY')
			end
		end
	},
	["tuner_chip"] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('xgc-tuner:openTuner')
		end
	},
	["burger"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 23)
		end
	},
	["microwave_burrito"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 15)
		end
	},
	["panini"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:food', 13)
		end
	},
	["pepsi"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:drink', 10)
		end
	},
	["pepsi_max"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:drink', 10)
		end
	},
	["water"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:drink', 20)
		end
	},
	["coffee"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:drink', 25)
		end
	},
	["lockpick"] = {
		takeItem = false,
		use = function(item)
			print'uselockpick'
			TriggerEvent('blckhndr_criminalmisc:lockpicking')
		end
	},
	["phone"] = {
		takeItem = false,
		use = function(item)
			ExecuteCommand('p')
		end
	},
	["joint"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_criminalmisc:drugs:effects:weed')
			TriggerEvent('blckhndr_evidence:ped:addState', 'Seems agitated', 'UPPER_BODY')
		end
	},
	["meth_rocks"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_criminalmisc:drugs:effects:meth')
			TriggerEvent('blckhndr_evidence:ped:addState', 'Red eyes', 'HEAD')
			TriggerEvent('mythic_hospital:client:UseAdrenaline')
		end
	},
	["meth_rocks"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_criminalmisc:drugs:effects:cocaine')
			TriggerEvent('blckhndr_evidence:ped:addState', 'Grinding jaw', 'HEAD')
		end
	},
	["cigarette"] = {
		takeItem = true,
		use = function(item)
		TriggerEvent('blckhndr_criminalmisc:drugs:effects:smokeCigarette')
		end
	},
	["binoculars"] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('binoculars:Activate')
		end
	},
	["ecola_drink"] = {
		takeItem = true,
		use = function(item)
			TriggerEvent('blckhndr_inventory:use:drink', 50)
		end
	},
	["empty_canister"] = {
		takeItem = true,
		use = function(item)
			if GetDistanceBetweenCoords(3563.146484375, 3673.47265625, 28.121885299683, GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
				TriggerEvent('blckhndr_inventory:item:take', 'empty_canister', 1)
				TriggerEvent('blckhndr_inventory:item:add', 'gas_canister', 1)
			else
				TriggerEvent('blckhndr_notify:displayNotification', 'Itt nem csinalhatsz ezzel semmit', 'centerLeft', 3000, 'error')
			end
		end
	},
	["gas_canister"] = {
		takeItem = true,
		use = function(item)
			local gasuse = {x = -628.78393554688, y = -226.52185058594, z = 55.901119232178}
			if GetDistanceBetweenCoords(gasuse.x, gasuse.y, gasuse.z, GetEntityCoords(GetPlayerPed(-1)), true) < 1 then
				TriggerEvent('blckhndr_notify:displayNotification', 'Úgy látszik a szellőző zárva van...', 'centerLeft', 3000, 'info')
			else
				TriggerEvent('blckhndr_notify:displayNotification', 'Itt nem csinalhatsz ezzel semmit', 'centerLeft', 3000, 'error')
			end
		end
	},
	['ammo_pistol'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_pistol')
		end
	},
	['ammo_pistol_large'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_pistol_large')
		end
	},
	['ammo_shotgun'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_shotgun')
		end
	},
	['ammo_shotgun_large'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_shotgun_large')
		end
	},
	['ammo_rifle'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_rifle')
		end
	},
	['ammo_rifle_large'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_rifle_large')
		end
	},
	['ammo_smg'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_smg')
		end
	},
	['ammo_smg_large'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_smg_large')
		end
	},
	['ammo_sniper'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_sniper')
		end
	},
	['ammo_sniper_large'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useAmmo', 'ammo_sniper_large')
		end
	},
	['armor'] = {
		takeItem = false,
		use = function(item)
			TriggerEvent('blckhndr_inventory:useArmor')
		end
	},
}