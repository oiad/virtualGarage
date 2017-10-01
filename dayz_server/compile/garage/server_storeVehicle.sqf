private ["_vehicle","_player","_clientID","_playerUID","_name","_fnc_sanitizeInput","_class","_charID","_damage","_fuel","_hit","_inventory","_query","_array","_hit","_selection","_colour","_colour2","_displayName","_key","_result","_outcome","_date","_year","_month","_day","_dateFormat"];

_vehicle = _this select 0;
_player = _this select 1;
_woGear = _this select 2;
_clientID = owner _player;
_playerUID = getPlayerUID _player;

_key = "CHILD:307:";
_result = _key call server_hiveReadWrite;
_outcome = _result select 0;
if (_outcome == "PASS") then {
	_date = _result select 1;
	_year = _date select 0;
	_month = _date select 1;
	_day = _date select 2;
	_dateFormat = format ["%1-%2-%3",_day,_month,_year];
};

_fnc_sanitizeInput = {
	private ["_input","_badChars"];

	_input = _this;
	_input = toArray (_input);
	_badChars = [60,62,38,123,125,91,93,59,58,39,96,126,44,46,47,63,124,92,34];

	{
		_input = _input - [_x];
	} forEach _badChars;
	
	_input = toString (_input);
	_input
};

_class = typeOf _vehicle;
_displayName = (getText(configFile >> "cfgVehicles" >> _class >> "displayName")) call _fnc_sanitizeInput;
_name = if (alive _player) then {(name _player) call _fnc_sanitizeInput;} else {"unknown player";};

_charID = _vehicle getVariable ["CharacterID","0"];
_damage = damage _vehicle;
_fuel = fuel _vehicle;
_colour = _vehicle getVariable ["Colour","0"];
_colour2 = _vehicle getVariable ["Colour2","0"];

_array = [];
_inventory = [[[],[]],[[],[]],[[],[]]];

if (isNil "_colour") then {_colour = "0";};
if (isNil "_colour2") then {_colour2 = "0";};

_hitpoints = _vehicle call vehicle_getHitpoints;

{
	_hit = [_vehicle,_x] call object_getHit;
	_selection = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "HitPoints" >> _x >> "name");
	if (_hit > 0) then {_array set [count _array,[_selection,_hit]]};
} count _hitpoints;

if (!_woGear) then {_inventory = [getWeaponCargo _vehicle,getMagazineCargo _vehicle,getBackpackCargo _vehicle];};

_query = format["INSERT INTO garage (PlayerUID, Name, DisplayName, Classname, Datestamp, CharacterID, Inventory, Hitpoints, Fuel, Damage, Colour, Colour2) VALUES ('%1','%2','%3','%4','%5','%6','%7','%8','%9','%10','%11','%12')",_playerUID,_name,_displayName,_class,_dateFormat,_charID,_inventory,_array,_fuel,_damage,_colour,_colour2];

[_query, 1, true] call fn_asyncCall;

PVDZE_storeVehicleResult = true;

if (!isNull _player) then {_clientID publicVariableClient "PVDZE_storeVehicleResult";};

diag_log format["GARAGE: %1 (%2) stored %3 @%4 %5",_name,_playerUID,_class,mapGridPosition (getPosATL _player),getPosATL _player];
