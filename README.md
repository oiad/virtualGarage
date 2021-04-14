# Virtual Garage for Epoch 1.0.7
Virtual Garage script rewritten by salival updated for Epoch 1.0.7 by Airwaves Man (https://github.com/oiad)

* Discussion URL: https://epochmod.com/forum/topic/44280-release-virtual-garage-for-1061/

* Tested as working on a blank Epoch 1.0.7
* This adds support for briefcases, gems and coins.
* Supports dynamic pricing and vehicle limits
* More secure than the original scripts
* Requires [click Actions](https://github.com/mudzereli/DayZEpochDeployableBike) or [Advanced Alchemical Crafting v3.3](https://epochmod.com/forum/topic/43460-release-advanced-alchemical-crafting-v33-updated-for-1061/) to deploy / build the HeliHCivil for the heli pad.

# Credits:
* [GZA] David for the original version of the script
* Torndeco for extDB
* Epoch Mod for code relating to Advanced Trading
* @icomrade for supplying the HiveExt changes
* TheDuke for updating this script to 1.0.6+
* DAmNRelentless for german translations
* Dscha for german translations
* Snowman for russian translations
* Ghostis for russian translations
* Panzer Mad for French translations

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Index:

* [Mission folder install](https://github.com/oiad/virtualGarage#mission-folder-install)
* [dayz_server folder install](https://github.com/oiad/virtualGarage#dayz_server-folder-install)
* [mySQL database setup fresh install](https://github.com/oiad/virtualGarage#mySQL-database-setup-fresh-install)
* [Building Helipads](https://github.com/oiad/virtualGarage#building-helipads)
* [Battleye Filter Install](https://github.com/oiad/virtualGarage#battleye-filter-install)
* [Old Releases](https://github.com/oiad/virtualGarage#old-releases)

# Install:

* This install basically assumes you have a custom variables.sqf, compiles.sqf and fn_selfActions.sqf.

**[>> Download <<](https://github.com/oiad/virtualGarage/archive/master.zip)**

# Mission folder install:

1. Copy the <code>scripts</code> folder to your mission folder preserving the directory structure.

2. Open your fn_selfactions.sqf and search for:

	```sqf
	// ZSC
	if (Z_singleCurrency) then {
	```

	Add this code lines above:
	
	```sqf	
	if (_typeOfCursorTarget in vg_List) then {
		if (s_garage_dialog < 0) then {
			local _hasAccess = [player,_cursorTarget] call FNC_check_access;
			local _plotCheck = [player, false] call FNC_find_plots;
			local _isNearPlot = ((_plotCheck select 1) > 0);

			if ((_isNearPlot && ((_hasAccess select 0) || (_hasAccess select 2) || (_hasAccess select 3) || (_hasAccess select 4))) || !_isNearPlot) then {
				s_garage_dialog = player addAction [format["<t color='#0059FF'>%1</t>",localize "STR_CL_VG_VIRTUAL_GARAGE"],"scripts\virtualGarage\virtualGarage.sqf",_cursorTarget,3,false,true];
			};
		};
	} else {
		player removeAction s_garage_dialog;
		s_garage_dialog = -1;
	};
	```	
3. In fn_selfactions search for this codeblock:

	```sqf
	player removeAction s_bank_dialog3;
	s_bank_dialog3 = -1;
	player removeAction s_player_checkWallet;
	s_player_checkWallet = -1;	
	```	
	And add this below:
	
	```sqf
	player removeAction s_garage_dialog;
	s_garage_dialog = -1;	
	```
4. Open your variables.sqf and search for:

	```sqf
	s_bank_dialog3 = -1;
	s_player_checkWallet = -1;	
	```
	And add this below:
	
	```sqf
	s_garage_dialog = -1;
	```	
	
5. Open your variables.sqf and search for:	

	```sqf
	if (!isDedicated) then {
	```
	
	And add this inside the square brackets so it looks like this:
	
	```sqf
	if (!isDedicated) then {
		vg_list = ["Plastic_Pole_EP1_DZ"]; // List of objects/traders that are allowed to interact with virtual garage. i.e: ["Plastic_Pole_EP1_DZ","Worker2"];
		vg_blackListed = []; // Array of vehicle config classes as well as vehicle classnames that are blacklisted from being stored, i.e ["All","Land","Air","Ship","StaticWeapon","AH1Z","MTVR"]
		vg_heliPads = ["Helipad_Civil_DZ","Helipad_Rescue_DZ","Helipad_Army_DZ","Helipad_Cross_DZ","Helipad_ParkBorder_DZ"]; // Array of heli pad classnames
		vg_removeKey = true; // Remove the key from the players inventory after storing vehicle?
		vg_requireKey = true; // Require the player to have the key when storing a locked vehicle.
		vg_storeWithGear = true; // Allow storing vehicles with gear?
		vg_tiedToPole = true; // Tie the virtual garage to a local plot pole? If no plot pole is present (i.e a communal garage at a trader etc) the players UID will be used.
		vg_pricePer = 100; // Price in worth to store a vehicle per gear item, use 0 if you want it to be free.
		vg_maintainCost = 10000; //cost is 1000 per 10oz gold, gem cost is as defined in DZE_GemWorthArray; if you use ZSC then this is an amount of coins. This is a flate rate for all vehicles in the garage/per player depending on vg_tiedToPole
		vg_price = [["Land",500],["Air",500],["Ship",500]];
		/*
			vg_price can be an array of vehicle config classes as well as vehicle classnames, you need to put these in order of what you prefer to get checked first.
			Price is in worth for briefcases or coins for gold based servers (10,000 worth is considered 1 briefcase, 100,000 coins is considered 1 briefcase)

			i.e:
			vg_price = [["Land",500],["Air",300],["Ship",100]];
			vg_price = [["350z_red",200],["Land",500],["AH1Z",1000],["Air",300],["Ship",100]];
		*/
		vg_limit = [["Land",5],["Air",5],["Ship",5]];
		/*
			vg_limit can be an array of vehicle config classes and classnames to narrow down what players can store or it can be a numerical value for a total limit.
			These can be classnames as well as config classnames, you need to put these in order of what you prefer to get checked first.

			i.e:
			vg_limit = [["Land",5],["Air",3],["Ship",1]];
			vg_limit = [["350z_red",2],["Land",5],["AH1Z",1],["Air",3],["Ship",1]];
			vg_limit = 5;
		*/
	};	
	```
	
6. Open your variables.sqf and search for:	

	```sqf
	if (isServer) then {
	```
	
	And add this inside the square brackets so it looks like this:
	
	```sqf
	if (isServer) then {
		vg_clearAmmo = true; // Clear the ammo of vehicles spawned during the same restart they are stored? (stops users storing a vehicle for a free rearm)
		vg_disableThermal = []; // Array of vehicle config classes as well as vehicle classnames to disable thermal on when being spawned. i.e: ["All","Land","Air","Ship","StaticWeapon","AH1Z","MTVR"];
		vg_sortColumn = 0; //0 or an out of range value sorts by the default column 'DisplayName', otherwise 1 = 'DateStored', 2 = 'id', 3 = 'Name' (of storing player), 4 = 'DateMaintained'
	};	
	
	```		
	
6. In mission\description.ext add the following line directly at the bottom:

	```sqf
	#include "scripts\virtualGarage\virtualGarage.hpp"
	```

# dayz_server folder install:

1. In <code>dayz_server\init\server_functions.sqf</code> find this line:
	```sqf
	spawn_vehicles = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_vehicles.sqf";
	```
	Add this line after it:
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\init.sqf";
	```

2. Copy the <code>dayz_server\compile\garage</code> folder to your dayz_server directory so it becomes <code>dayz_server\compile\garage</code>

# mySQL database setup fresh install:

1. If you are only allowed access to your main epoch database from your hosting provider, you can import the <code>SQL\virtualGarage.sql</code> file without editing it.

2. Virtual Garage includes a custom<code>HiveExt.dll</code> with a customizable table name and stored vehicle cleanup days, this needs to replace your current/official Epoch <code>HiveExt.dll</code> copy the supplied <code>HiveExt.dll</code> from <code>@DayZ_Epoch_Server</code> to your <code>Arma2 OA\@DayZ_Epoch_Server</code> folder.

3. Open your HiveExt.ini and edit the [Objects] section, add or modify the following code to this section. If needed configure the [ObjectDB] section for external object database settings

```
; Table name for the virtual garage data to be stored in, default table is 'garage'
;VGTable = garage
; Days for a stored vehicle to be cleaned up after, if set to -1 this feature is disabled. Default 35 days
;CleanupVehStoredDays = 35
; Log object cleanup DELETE statements (per object), including virtual garage. Default is false
;LogObjectCleanup = false
```

# Building Helipads:

1. Add those items to the game, for example to Traders or Loot, so players are able to build a helipad:

```
helipad_civil_kit, helipad_rescue_kit, helipad_army_kit, helipad_cross_kit, helipad_parkborder_kit
```

# Battleye Filter Install
	
**Battleye script.txt:**

1. In your config\<yourServerName>\Battleye\scripts.txt around line 22: <code>1 compile</code> add this to the end of it:

	```sqf
	!="isplCtl\"];\n\nif (isNil \"vg_init\") then {\nplayer_getVehicle = compile preprocessFileLineNumbers \"scripts\\virtualGarage\\player_getV"
	```

	So it will then look like this for example:

	```sqf
	1 compile <CUT> !="isplCtl\"];\n\nif (isNil \"vg_init\") then {\nplayer_getVehicle = compile preprocessFileLineNumbers \"scripts\\virtualGarage\\player_getV"
	```
	
2. In your config\<yourServerName>\Battleye\scripts.txt around line 24: <code>5 createDialog</code> add this to the end of it:

	```sqf
	!="gress = true;\n\ndisableSerialization;\n\nvg_hasRun = false;\n\ncreateDialog \"virtualGarage\";\n\n{ctrlShow [_x,false]} count [2803,2830,"
	```

	So it will then look like this for example:

	```sqf
	5 createDialog <CUT> !="gress = true;\n\ndisableSerialization;\n\nvg_hasRun = false;\n\ncreateDialog \"virtualGarage\";\n\n{ctrlShow [_x,false]} count [2803,2830,"
	```	
	
3. In your config\<yourServerName>\Battleye\scripts.txt around line 50: <code>5 lbSet</code> add this to the end of it:

	```sqf
	!=" 1) >> \"displayName\");\n_control lbAdd _displayName;\n_control lbSetData [(lbSize _control)-1,str(_x)];\nvg_vehicleList set [count "
	```

	So it will then look like this for example:

	```sqf
	5 lbSet <CUT> !=" 1) >> \"displayName\");\n_control lbAdd _displayName;\n_control lbSetData [(lbSize _control)-1,str(_x)];\nvg_vehicleList set [count "
	```	
	
4. In your config\<yourServerName>\Battleye\scripts.txt around line 53: <code>1 nearEntities</code> add this to the end of it:

	```sqf
	!="esult = nil;\n\n_localVehicles = ([player] call FNC_getPos) nearEntities [[\"Air\",\"LandVehicle\",\"Ship\"],Z_VehicleDistance];\n_heliPa"
	```

	So it will then look like this for example:

	```sqf
	1 nearEntities <CUT> !="esult = nil;\n\n_localVehicles = ([player] call FNC_getPos) nearEntities [[\"Air\",\"LandVehicle\",\"Ship\"],Z_VehicleDistance];\n_heliPa"
	```	

5. In your config\<yourServerName>\Battleye\scripts.txt around line 54: <code>1 nearestObject</code> add this to the end of it:

	```sqf
	!="ir\",\"LandVehicle\",\"Ship\"],Z_VehicleDistance];\n_heliPad = nearestObjects [if (_isNearPlot) then {_plotCheck select 2} else {playe"
	```

	So it will then look like this for example:

	```sqf
	1 nearestObject <CUT> !="ir\",\"LandVehicle\",\"Ship\"],Z_VehicleDistance];\n_heliPad = nearestObjects [if (_isNearPlot) then {_plotCheck select 2} else {playe"
	```
	
6. In your config\<yourServerName>\Battleye\scripts.txt around line 17: <code>5 cashMoney</code> add this to the end of it:

	```sqf
	!="= [false, [], [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_Single"
	```

	So it will then look like this for example:

	```sqf
	5 cashMoney <CUT> !="= [false, [], [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_Single"
	```	
	
7. In your config\<yourServerName>\Battleye\scripts.txt around line 43: <code>5 globalMoney</code> add this to the end of it:

	```sqf
	!=" [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_SingleCurrency) the"
	```

	So it will then look like this for example:

	```sqf
	5 globalMoney <CUT> !=" [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_SingleCurrency) the"
	```	
	
8. In your config\<yourServerName>\Battleye\scripts.txt around line 49: <code>5 lbCurSel</code> add this to the end of it:

	```sqf
	!="2800) displayCtrl 2802);\n\n_vehicle = vg_vehicleList select (lbCurSel _control);\n_typeOf = typeOf _vehicle;\n_isLimitArray = typeN"
	```

	So it will then look like this for example:

	```sqf
	5 lbCurSel <CUT> !="2800) displayCtrl 2802);\n\n_vehicle = vg_vehicleList select (lbCurSel _control);\n_typeOf = typeOf _vehicle;\n_isLimitArray = typeN"
	```	
	
9. In your config\<yourServerName>\Battleye\scripts.txt around line 53: <code>5 addWeapon</code> add this to the end of it:

	```sqf
	!="CK\",_keyName] call dayz_rollingMessages;};\n} else {\nplayer addWeapon _keyID;\nformat[localize \"STR_CL_VG_ADDED_INVENTORY\",_keyNam"
	```

	So it will then look like this for example:

	```sqf
	5 addWeapon <CUT> !="CK\",_keyName] call dayz_rollingMessages;};\n} else {\nplayer addWeapon _keyID;\nformat[localize \"STR_CL_VG_ADDED_INVENTORY\",_keyNam"
	```	

10. In your config\<yourServerName>\Battleye\scripts.txt around line 22: <code>1 compile</code> add this to the end of it:

	```sqf
	!="heck\",\"_sign\",\"_vehicle\"];\n\ncloseDialog 0;\n_vehicle = (call compile format[\"%1\",lbData[2802,(lbCurSel 2802)]]);\n\nif (vg_removeKe"
	```

	So it will then look like this for example:

	```sqf
	1 compile <CUT> !="heck\",\"_sign\",\"_vehicle\"];\n\ncloseDialog 0;\n_vehicle = (call compile format[\"%1\",lbData[2802,(lbCurSel 2802)]]);\n\nif (vg_removeKe"
	```
	
11. In your config\<yourServerName>\Battleye\scripts.txt around line 49: <code>5 lbCurSel</code> add this to the end of it:

	```sqf
	!="Dialog 0;\n_vehicle = (call compile format[\"%1\",lbData[2802,(lbCurSel 2802)]]);\n\nif (vg_removeKey && {_vehicle select 3 != 0} && "
	```

	So it will then look like this for example:

	```sqf
	5 lbCurSel <CUT> !="Dialog 0;\n_vehicle = (call compile format[\"%1\",lbData[2802,(lbCurSel 2802)]]);\n\nif (vg_removeKey && {_vehicle select 3 != 0} && "
	```	
	
12. In your config\<yourServerName>\Battleye\scripts.txt around line 53: <code>1 nearEntities</code> add this to the end of it:

	```sqf
	!="ation;\n\nif (surfaceIsWater _location && {count (_location nearEntities [\"Ship\",8]) > 0}) then {\ndeleteVehicle _sign;\nlocalize \"S"
	```

	So it will then look like this for example:

	```sqf
	1 nearEntities <CUT> !="ation;\n\nif (surfaceIsWater _location && {count (_location nearEntities [\"Ship\",8]) > 0}) then {\ndeleteVehicle _sign;\nlocalize \"S"
	```	
	
13. In your config\<yourServerName>\Battleye\scripts.txt around line 54: <code>1 nearestObject</code> add this to the end of it:

	```sqf
	!="ts;\n_isNearPlot = (_plotCheck select 1) > 0;\n\n_heliPad = nearestObjects [if (_isNearPlot) then {_plotCheck select 2} else {playe"
	```

	So it will then look like this for example:

	```sqf
	1 nearestObject <CUT> !="ts;\n_isNearPlot = (_plotCheck select 1) > 0;\n\n_heliPad = nearestObjects [if (_isNearPlot) then {_plotCheck select 2} else {playe"
	```	
	
14. In your config\<yourServerName>\Battleye\scripts.txt around line 54: <code>1 nearestObject</code> add this to the end of it:

	```sqf
	!="ocalize \"STR_CL_VG_HELIPAD_REMOVED\",typeOf _x];\n} count (nearestObjects [_plotCheck select 2,vg_heliPads,Z_VehicleDistance]);\n} "
	```

	So it will then look like this for example:

	```sqf
	1 nearestObject <CUT> !="ocalize \"STR_CL_VG_HELIPAD_REMOVED\",typeOf _x];\n} count (nearestObjects [_plotCheck select 2,vg_heliPads,Z_VehicleDistance]);\n} "
	```		
	
**Battleye publicVariable.txt:**

1. In your config<yourServerName>\Battleye\publicVariable.txt on line 2: <code>5 !=remEx(Field|FP)</code> add this to the end of it:

	```sqf
	!=PVDZE_(query|store|spawn)Vehicle
	```

	So it will then look like this for example:

	```sqf
	5 !=remEx(Field|FP) <CUT> !=PVDZE_(query|store|spawn)Vehicle
	```
	
# Old Releases:	

**** *Epoch 1.0.6.2* ****
**[>> Download <<](https://github.com/oiad/virtualGarage/archive/refs/tags/Epoch_1.0.6.2.zip)**