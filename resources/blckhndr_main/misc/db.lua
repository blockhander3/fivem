local sql = [[

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE IF NOT EXISTS `blckhndr_apartments` (
  `apt_id` int(11) NOT NULL AUTO_INCREMENT,
  `apt_owner` int(11) NOT NULL,
  `apt_inventory` text NOT NULL,
  `apt_cash` int(11) NOT NULL,
  `apt_outfits` text NOT NULL,
  `apt_utils` text NOT NULL,
  PRIMARY KEY (`apt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_bans` (
  `ban_identifier` varchar(255) NOT NULL,
  `ban_reason` text NOT NULL,
  `ban_id` int(11) NOT NULL,
  `ban_expire` int(11) NOT NULL,
  `ban_date` int(11) NOT NULL,
  `ban_admin` int(11) NOT NULL,
  PRIMARY KEY (`ban_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_characters` (
  `char_id` int(11) NOT NULL AUTO_INCREMENT,
  `steamid` text NOT NULL,
  `char_fname` text NOT NULL,
  `char_lname` text NOT NULL,
  `char_dob` varchar(10) NOT NULL,
  `char_desc` text NOT NULL,
  `char_twituname` varchar(20) NOT NULL DEFAULT 'notset',
  `char_licenses` text NOT NULL,
  `char_phone` text DEFAULT NULL,
  `char_contacts` text NOT NULL,
  `char_jailtime` int(11) NOT NULL DEFAULT 0,
  `char_money` int(11) NOT NULL,
  `char_bank` int(11) NOT NULL,
  `char_model` text NOT NULL,
  `mdl_extras` text NOT NULL,
  `char_details` varchar(65000) NOT NULL DEFAULT '[]',
  `char_inventory` text NOT NULL,
  `char_weapons` text NOT NULL,
  `char_police` int(11) NOT NULL DEFAULT 0,
  `char_ems` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`char_id`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_properties` (
  `property_id` int(11) NOT NULL AUTO_INCREMENT,
  `property_name` text NOT NULL,
  `property_xyz` text NOT NULL,
  `property_owner` int(11) NOT NULL,
  `property_coowners` text NOT NULL,
  `property_inventory` text NOT NULL,
  `property_weapons` text NOT NULL,
  `property_money` int(11) NOT NULL,
  `property_expiry` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_storageboxes` (
  `sbox_id` int(11) NOT NULL AUTO_INCREMENT,
  `sbox_details` text NOT NULL,
  `sbox_content` text NOT NULL,
  PRIMARY KEY (`sbox_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_textmessages` (
  `txt_id` int(11) NOT NULL AUTO_INCREMENT,
  `txt_sender` int(11) NOT NULL,
  `txt_reciever` int(11) NOT NULL,
  `txt_message` text NOT NULL,
  `txt_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`txt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_tickets` (
  `ticket_id` int(11) NOT NULL AUTO_INCREMENT,
  `officer_id` int(11) NOT NULL,
  `officer_name` text NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `ticket_amount` int(11) NOT NULL,
  `ticket_jailtime` int(11) NOT NULL,
  `ticket_charges` text NOT NULL,
  `ticket_date` int(99) NOT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `steamid` text NOT NULL,
  `identifiers` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `admin_lvl` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 0,
  `connections` int(11) NOT NULL,
  `banned` int(99) NOT NULL,
  `banned_r` text NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `user_id_2` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_vehicles` (
  `veh_id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `veh_spawnname` text DEFAULT NULL,
  `veh_plate` text NOT NULL,
  `veh_inventory` text NOT NULL,
  `veh_type` varchar(1) NOT NULL,
  `veh_status` int(11) NOT NULL DEFAULT 1,
  `veh_details` text DEFAULT NULL,
  `veh_displayname` text DEFAULT NULL,
  `veh_finance` text DEFAULT NULL,
  `veh_garage` varchar(50) DEFAULT '0',
  PRIMARY KEY (`veh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_warrants` (
  `war_id` int(11) NOT NULL AUTO_INCREMENT,
  `suspect_name` text NOT NULL,
  `officer_name` text NOT NULL,
  `war_charges` text NOT NULL,
  `war_times` text NOT NULL,
  `war_fine` text NOT NULL,
  `war_desc` text NOT NULL,
  `war_status` text NOT NULL,
  `war_date` int(99) NOT NULL,
  PRIMARY KEY (`war_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `blckhndr_whitelists` (
  `wl_id` int(11) NOT NULL AUTO_INCREMENT,
  `wl_title` text NOT NULL,
  `wl_owner` int(11) NOT NULL,
  `wl_access` text NOT NULL,
  `wl_bank` int(11) NOT NULL,
  PRIMARY KEY (`wl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


]]

local timeout = 10 -- (seconds) you can increase this if your SQL server is really slow
local done = false
local start = 0
MySQL.ready(function ()
	MySQL.Async.execute(sql, {}, function(rc)
		done = true	
	end)
end)

local resources = {
	'blckhndr_spawnmanager',
  'blckhndr_admin',
  'blckhndr_apartments',
  'blckhndr_activities',
	'blckhndr_bank',
	'blckhndr_bankrobbery',
	'blckhndr_bennys',
  'blckhndr_bikerental',
  'blckhndr_boatshop',
	'blckhndr_builders',
	'blckhndr_cargarage',
	'blckhndr_carstore',
	'blckhndr_characterdetails',
	'blckhndr_clothing',
	'blckhndr_commands',
	'blckhndr_crafting',
	'blckhndr_criminalmisc',
	'blckhndr_customanimations',
	'blckhndr_customs',
	'blckhndr_doj',
	'blckhndr_doormanager',
	'blckhndr_emotecontrol',
	'blckhndr_ems',
	'blckhndr_entfinder',
	'blckhndr_errorcontrol',
	'blckhndr_evidence',
	'blckhndr_handling',
	'blckhndr_needs',
	'blckhndr_inventory',
	'blckhndr_inventory_dropping',
	'blckhndr_jail',
	'blckhndr_jewellerystore',
	'blckhndr_jobs',
	'blckhndr_licenses',
	'blckhndr_loadingscreen',
	'blckhndr_menu',
	'blckhndr_newchat',
	'blckhndr_notify',
	'blckhndr_phones',
	'blckhndr_playerlist',
	'blckhndr_police',
	'blckhndr_progress',
	'blckhndr_properties',
	'blckhndr_shootingrange',
	'blckhndr_steamlogin',
	'blckhndr_storagelockers',
	'blckhndr_store',
	--'blckhndr_store_guns',
	'blckhndr_stripclub',
	'blckhndr_teleporters',
	'blckhndr_timeandweather',
	'blckhndr_vehiclecontrol',
	'blckhndr_voicecontrol',
	'blckhndr_weaponcontrol',
}

Citizen.CreateThread(function()
	start = os.time()
	while true do
		Citizen.Wait(0)
		if not done then
			if start+timeout < os.time() then
				print('^1ERROR - MYSQL SERVER DID NOT RESPOND IN TIME - CHECK "mysql-async" IS INSTALLED AND CONFIGURED')
			end
		else
			for k,v in pairs(resources) do
				 ExecuteCommand('start '..v)
			end
			break
		end
	end
end)