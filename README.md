# Virtual Garage
Virtual Garage script rewritten by salival (https://github.com/oiad)

* Discussion URL: 
	
* Tested as working on a blank Epoch 1.0.6.1
* This adds support for briefcases, gems and coins.
* Supports dynamic pricing and vehicle limits
* More secure than the original scripts
* Requires [click Actions](https://github.com/mudzereli/DayZEpochDeployableBike) or [Advanced Alchemical Crafting v3.3](https://epochmod.com/forum/topic/43460-release-advanced-alchemical-crafting-v33-updated-for-1061/) to deploy / build the HeliHCivil for the heli pad.

# Credits:
* [GZA] David for the original version of the script
* Epoch Mod for code relating to Advanced Trading
* TheDuke for updating this script to 1.0.6+
* DAmNRelentless for german translations
* Dscha for german translations
* Snowman for russian translations
* Ghostis for russian translations

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```
	
# Index:

* [Remove old version](https://github.com/oiad/virtualGarage#removing-the-older-version-and-starting-fresh)
* [Mission folder install](https://github.com/oiad/virtualGarage#mission-folder-install)
* [click Actions config install](https://github.com/oiad/virtualGarage#click-actions-config-install)
* [dayz_server folder install](https://github.com/oiad/virtualGarage#dayz_server-folder-install)
* [extDB install](https://github.com/oiad/virtualGarage#extdb-install)
* [mysql database setup fresh install](https://github.com/oiad/virtualGarage#mysql-database-setup-fresh-install)
* [mysql database update from previous virtual garage](https://github.com/oiad/virtualGarage#mysql-database-update-from-previous-virtual-garage)
* [infistar setup](https://github.com/oiad/virtualGarage#infistar-setup)
* [Battleye filter install](https://github.com/oiad/virtualGarage#battleye-filter-install)

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible.

# IMPORTANT!! If you are upgrading from the OLD version (i.e the one TheDuke77 released) I encourage you to uninstall it completely: [Remove Old version](https://github.com/oiad/virtualGarage#removing-the-older-version-and-starting-fresh)

**[>> Download <<](https://github.com/oiad/virtualGarage/archive/master.zip)**

# Mission folder install:

1. Copy the <code>dayz_code</code> and <code>scripts</code> folder to your mission folder preserving the directory structure.

2. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";</code> and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf";
	```
	
3. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";</code> and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";
	```

4. Replace your original <code>description.ext</code> with the one provided or merge the contents if you have modified your own version.

5. Replace your modified <code>dayz_code\compiles\fn_selfActions.sqf</code> with the one provided or merge the contents if you have modified your own version.

6. If you run ESSv3 spawn script (by [@ebayShopper](https://github.com/ebayShopper/ESSV3)) copy the supplied <code>stringTable - ESS.xml</code> to your mission file directory and rename it to <code>stringTable.xml</code>

7. If you are not running ESSv3 spawn script copy the supplied <code>stringTable.xml</code> to your mission file directory

# click Actions config install:

1. If you want to use HeliPads at bases, in your deployable config file (<code>addons\bike\config.sqf</code>), find this line:
	```sqf
	["ItemToolbox",[0,6,1],5,0.1,false,false,false,false,false,true,true,["MMT_Civ"],[],["ItemToolbox"],"true"],
	```
	Add this line after it:
	```sqf
	["ItemToolbox",[0,9,2],5,0.9,true,true,false,true,true,false,true,["HeliHCivil"],[],[],"true"],
	```
	
	You can substitute <code>ItemToolBox</code> for whatever you would like the player to be able to deploy it with, i.e <code>ItemEtool</code>
	Otherwise if you are using garages at traders, this step is not needed.

# dayz_server folder install:

1. Replace or merge the contents of <code>dayz_server\init\server_functions.sqf</code> provided with your original copy.

2. Copy the <code>dayz_server\compile\garage</code> folder to your dayz_server directory so it becomes <code>dayz_server\compile\garage</code>

# extDB install:

1. Copy the <code>@extDB</code> folder to your main <code>Arma 2 Operation Arrowhead</code> folder (or where you host your server)

2. Edit <code>@extDB\extdb-conf.ini</code> to suit your database settings, mainly the database name, username and password.

3. Edit your server batch file or whatever loads your server to include <code>@extDB</code> in the -mod line, i.e for epoch:
	```sqf
	"-mod=@extDB;DayZ_Epoch;@DayZ_Epoch_Server"
	```
	for overwatch:
	```sqf
	"-mod=@extDB;@DayzOverwatch;@DayZ_Epoch;@DayZ_Epoch_Server"
	```

# mysql database setup fresh install:

1. If you are only allowed access to your main epoch database from your hosting provider, you can import the <code>SQL\virtualGarage.sql</code> file without editing it.

2. If you want to have an external virtual garage database you will need to edit <code>SQL\virtualGarage.sql</code> and uncomment the following lines:
	```sql
	-- CREATE DATABASE IF NOT EXISTS `extdb` /*!40100 DEFAULT CHARACTER SET latin1 */;
	-- USE `extdb`;
	```

	This will create a seperate database called extDB (useful if you have a couple of servers using the same virtual garage database) FWIW: I had to run this import twice for it to work correctly, it only created the external database the first time, the second time I had to run it to create the table.

3. You will need to edit your <code>@extDB\extdb-conf.ini</code> to suit your database settings!

# mysql database update from previous virtual garage:

1. Import the <code>SQL\virtualGarageUpdate.sql</code> file overtop of your garage database, this will update it to the latest version.

# Infistar setup:

1. Add 2800 to your _ALLOWED_Dialogs variable, i.e:
	```sqf
	_ALLOWED_Dialogs = _ALLOWED_Dialogs + [81000,88890,20001,20002,20003,20004,20005,20006,55510,55511,55514,55515,55516,55517,55518,55519,555120,118338,118339,571113,2800]; // adding some others from community addons
	```

# Battleye filter install:

1. This assumes you are running the DEFAULT epoch filters.

2. On line 2 of <code>createVehicle.txt</code> add <code>!="HeliHCivil"</code> to the end of the line so it looks like this:
	```sqf
	5 !(^DZ_|^z_|^pz_|^WeaponHolder|Box|dog|PZombie_VB|^Smoke|^Chem|^._40mm|_DZ$|^Trap) <REMOVED SOME FILTERS TO MAKE SMALLER> !="Fin" !="Pastor" !="HeliHCivil"
	```

3. On line 2 of <code>publicVariable.txt</code> add <code>!="PVDZE_(query|store|spawn)Vehicle"</code> to the end of the line so it looks like this:
	```sqf
	5 !=(remExField|remExFP) <REMOVED SOME FILTERS TO MAKE SMALLER> !="PVDZE_(query|store|spawn)Vehicle"
	```

# Removing the older version and starting fresh:

1. Remove the following lines from your <code>description.ext</code>:
	```sqf
	#include "scripts\garage\common.hpp"
	#include "scripts\garage\vehicle_garage.hpp"
	```

2. Remove these lines from your <code>fn_selfActions.sqf</code>:
	```sqf
	if((_typeOfCursorTarget in DZE_garagist) && (player distance _cursorTarget < 5)) then {
		if (s_garage_dialog2 < 0) then {
			s_garage_dialog2 = player addAction ["Vehicle Garage", "scripts\garage\vehicle_dialog.sqf",_cursorTarget, 3, true, true, "", ""];
		};
		if (s_garage_dialog < 0) then {
			s_garage_dialog = player addAction ["Store Vehicle in Garage", "scripts\garage\vehicle_store_list.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_garage_dialog2;
		s_garage_dialog2 = -1;
		player removeAction s_garage_dialog;
		s_garage_dialog = -1;
	};
	```
	And this line:
	```sqf
	player removeAction s_garage_dialog2;
	s_garage_dialog2 = -1;
	```

3. Remove this line from your custom <code>variables.sqf</code>:
	```sqf
	s_garage_dialog2 = -1;
	```

4. Remove these lines from your custom <code>compiles.sqf</code>:
	```sqf
	player_getVehicle = 			compile preprocessFileLineNumbers "scripts\garage\getvehicle.sqf";
	player_storeVehicle = 			compile preprocessFileLineNumbers "scripts\garage\player_storeVehicle.sqf";
	vehicle_info = compile preprocessFileLineNumbers "scripts\garage\vehicle_info.sqf";
	```
	And the following functions if no other scripts require them (SC_fnc_removeCoins and SC_fnc_addCoins):
	```sqf
	SC_fnc_removeCoins=
	{
		private ["_player","_amount","_wealth","_newwealth", "_result"];
		_player = _this select 0;
		_amount = _this select 1;
		_result = false;
		_wealth = _player getVariable[Z_MoneyVariable,0];  
		if(_amount > 0)then{
		if (_wealth < _amount) then {
		_result = false;
		} else {                         
		_newwealth = _wealth - _amount;
		_player setVariable[Z_MoneyVariable,_newwealth, true];
		_player setVariable ["moneychanged",1,true];    
		_result = true;
		call player_forceSave;        
		};
		}else{
		_result = true;
		};
		_result
	};

	SC_fnc_addCoins = 
	{
		private ["_player","_amount","_wealth","_newwealth", "_result"];			
		_player =  _this select  0;
		_amount =  _this select  1;
		_result = false;	
		_wealth = _player getVariable[Z_MoneyVariable,0];
		_player setVariable[Z_MoneyVariable,_wealth + _amount, true];
		call player_forceSave;
		_player setVariable ["moneychanged",1,true];					
		_newwealth = _player getVariable[Z_MoneyVariable,0];		
		if (_newwealth >= _wealth) then { _result = true; };			
		_result
	};

	vehicle_gear_count = {
		private["_counter"];
		_counter = 0;
		{
			_counter = _counter + _x;
		} count _this;
		_counter
	};
	```

5. If no other mods are using a custom <code>publicEH.sqf</code> (which they shouldn't, it's bad) you can remove it from your mission file.

6. Remove the following line from your <code>init.sqf</code>:
	```sqf
	call compile preprocessFileLineNumbers "scripts\garage\publicEH.sqf";
	```
	And replace it with this:
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
	```

7. Remove the following lines from your <code>dayz_server\init\server_functions.sqf</code>:
	```sqf
	"extDB" callExtension "9:DATABASE:Database2";
	"extDB" callExtension format["9:ADD:DB_RAW_V2:%1",1];
	"extDB" callExtension "9:LOCK";

	server_queryGarageVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_queryGarageVehicle.sqf";
	server_spawnVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_spawnVehicle.sqf";
	server_storeVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_storeVehicle.sqf";
	fn_asyncCall = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\fn_async.sqf";
	```

8. Remove the following filters from your <code>publicVariable.txt</code>:
	```sqf
	!="PVDZE_queryGarageVehicle" !="PVDZE_storeVehicle" !="PVDZE_spawnVehicle" 
	```

9. Remove the following number from your <code>infistar\AHconfig.sqf</code> from your _ALLOWED_Dialogs line:
	```sqf
	3800
	```