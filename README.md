# Virtual Garage
Virtual Garage script rewritten by salival (https://github.com/oiad)

* Discussion URL: https://epochmod.com/forum/topic/44280-release-virtual-garage-for-1061/

* Tested as working on a blank Epoch 1.0.6.2
* This adds support for briefcases, gems and coins.
* Supports dynamic pricing and vehicle limits
* More secure than the original scripts
* Requires [click Actions](https://github.com/mudzereli/DayZEpochDeployableBike) or [Advanced Alchemical Crafting v3.3](https://epochmod.com/forum/topic/43460-release-advanced-alchemical-crafting-v33-updated-for-1061/) to deploy / build the HeliHCivil for the heli pad.

# Credits:
* [GZA] David for the original version of the script
* Torndeco for extDB
* Epoch Mod for code relating to Advanced Trading
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

* [Remove old version](https://github.com/oiad/virtualGarage#removing-the-older-version-and-starting-fresh)
* [Mission folder install](https://github.com/oiad/virtualGarage#mission-folder-install)
* [click Actions config install](https://github.com/oiad/virtualGarage#click-actions-config-install)
* [dayz_server folder install](https://github.com/oiad/virtualGarage#dayz_server-folder-install)
* [mysql database setup fresh install](https://github.com/oiad/virtualGarage#mysql-database-setup-fresh-install)
* [mysql database update from previous virtual garage](https://github.com/oiad/virtualGarage#mysql-database-update-from-previous-virtual-garage)
* [infistar setup](https://github.com/oiad/virtualGarage#infistar-setup)
* [Adding HeliPad to maintaining array](https://github.com/oiad/virtualGarage#adding-helipad-to-maintaining-array)
* [Battleye filter install](https://github.com/oiad/virtualGarage#battleye-filter-install)
* [Remove old version](https://github.com/oiad/virtualGarage/blob/master/uninstall%20old%20version.md)

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible.

# IMPORTANT!! If you are upgrading from the OLD version (i.e the one TheDuke77 released) I encourage you to uninstall it completely: [Remove Old version](https://github.com/oiad/virtualGarage/blob/master/uninstall%20old%20version.md)

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

6. Download the <code>stringTable.xml</code> file linked below from the [Community Localization GitHub](https://github.com/oiad/communityLocalizations) and copy it to your mission folder, it is a community based localization file and contains translations for major community mods including this one.

**[>> Download stringTable.xml <<](https://github.com/oiad/communityLocalizations/blob/master/stringtable.xml)**

# Click Actions config install:

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

2. (optional) Add a consumable cost to the deploying of the heli pad:
	```sqf
	["ItemToolbox",[0,9,2],5,0.9,true,true,false,true,true,false,true,["HeliHCivil"],[],["ItemRuby"],"true"],
	```
	This will force the player to spend an "ItemRuby" for as a cost for deploying the heli pad, Obviously you can subsitute it for anything (VaultStorage, ItemBriefcase100oz etc)

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

# extDB uninstall:

1. Remove @extDB from your mod line. For example ```"-mod=@extDB;@DayZ_Epoch;@DayZ_Epoch_Server"``` becomes ```"-mod=@DayZ_Epoch;@DayZ_Epoch_Server"```
2. Optionally, also delete your @extDB folder (with a backup as needed)
3. in your DayZ_Server\Compiles\garage folder remove fn_async.sqf, overwrite other files

# mysql database setup fresh install:

1. If you are only allowed access to your main epoch database from your hosting provider, you can import the <code>SQL\virtualGarage.sql</code> file without editing it.

2. Open your HiveExt.ini and edit the [Objects] section, add or modify the following code to this section. If needed configure the [ObjectDB] section for external object database settings

```
; Table name for the virtual garage data to be stored in, default table is 'garage'
;VGTable = garage
; Days for a stored vehicle to be cleaned up after, if set to -1 this feature is disabled. Default 35 days
;CleanupVehStoredDays = 35
; Log object cleanup DELETE statements (per object), including virtual garage. Default is false
;LogObjectCleanup = false
```

# mysql database update from previous virtual garage:

1. If you are updating from a previous authors version (i.e TheDuke) please remove the comments (/* */) on line 5 and 8 in <code>SQL\virtualGarageUpdate.sql</code> so that it looks like this:
	```sqf
	ALTER TABLE `garage` ADD `Name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `PlayerUID`;
	ALTER TABLE `garage` ADD `displayName` VARCHAR(50) NOT NULL DEFAULT '' AFTER `Name`;
	```

2. Import the <code>SQL\virtualGarageUpdate.sql</code> file overtop of your garage database, this will update it to the latest version.

3. Virtual Garage includes a custom HiveExt.dll with a customizable table name and stored vehicle cleanup days

4. remove the cleanup procedure from your DB ```DROP EVENT IF EXISTS `RemoveOldVG`;```

5. open your HiveExt.ini and edit the [Objects] section, add or modify the following code to this section. If needed configure the [ObjectDB] section for external object database settings

# Infistar setup:

1. If you have <code>_CSA = true;</code> in your AHconfig.sqf: Add 2800 to the end of your _ALLOWED_Dialogs array, i.e:
	```sqf
	_ALLOWED_Dialogs = _ALLOWED_Dialogs + [81000,88890,20001,20002,20003,20004,20005,20006,55510,55511,55514,55515,55516,55517,55518,55519,555120,118338,118339,571113,2800]; // adding some others from community addons
	```

2. If you have <code>_CUD =  true;</code> in your AHconfig.sqf: Add "s_garage_dialog" to the end of your _dayzActions array, i.e:
	```sqf
	"Tow_settings_dlg_CV_btn_fermer","Tow_settings_dlg_CV_titre","unpackRavenAct","vectorActions","wardrobe","s_garage_dialog"
	```

# Adding HeliPad to Maintaining array:

1. If you are running heli pads at players bases, you will need to add the heli pad to your maintain array so players can maintain it and the server wont remove it. In your custom <code>variables.sqf</code> find this line:
	```sqf
	//Player self-action handles
	```
	Add this line before it:
	```sqf
	DZE_maintainClasses = DZE_maintainClasses + ["HeliHCivil"];
	```
	
# Battleye filter install:

1. This assumes you are running the DEFAULT epoch filters.

2. On line 2 of <code>config\<yourServerName>\Battleye\createVehicle.txt</code> add <code>!="HeliHCivil"</code> to the end of the line so it looks like this:
	```sqf
	5 !(^DZ_|^z_|^pz_|^WeaponHolder|Box|dog|PZombie_VB|^Smoke|^Chem|^._40mm|_DZ$|^Trap) <REMOVED SOME FILTERS TO MAKE SMALLER> !="Fin" !="Pastor" !="HeliHCivil"
	```

3. On line 2 of <code>config\<yourServerName>\Battleye\publicVariable.txt</code> add <code>!="PVDZE_(query|store|spawn)Vehicle"</code> to the end of the line so it looks like this:
	```sqf
	5 !=(remExField|remExFP) <REMOVED SOME FILTERS TO MAKE SMALLER> !="PVDZE_(query|store|spawn)Vehicle"
	```

4. On line 12 of <code>config\<yourServerName>\Battleye\scripts.txt</code>: <code>5 createDialog</code> add this to the end of it:
	```sqf
	!="createDialog \"virtualGarage\";"
	```
	
	So it will then look like this for example:

	```sqf
	5 createDialog <CUT> !="createDialog \"virtualGarage\";"
	```

5. On line 51 of <code>config\<yourServerName>\Battleye\scripts.txt</code>: <code>5 toString</code> add this to the end of it:
	```sqf
	!"_input = parseNumber (toString (_input));"
	```

	So it will then look like this for example:

	```sqf
	5 toString <CUT> !"_input = parseNumber (toString (_input));"
	```	
