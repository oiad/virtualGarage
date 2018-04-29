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

	Remove this function from your custom <code>compiles.sqf</code>:
	```sqf
	vehicle_gear_count = {
		private["_counter"];
		_counter = 0;
		{
			_counter = _counter + _x;
		} count _this;
		_counter
	};
	```

	(OPTIONAL) And the following functions if no other scripts require them (SC_fnc_removeCoins and SC_fnc_addCoins):
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
