private ["_vehicle","_player","_clientID","_playerUID","_name","_class","_charID","_damage","_fuel","_hit","_inventory","_query","_array","_hit","_selection","_colour","_colour2","_displayName"];

_vehicle = _this select 0;
_player = _this select 1;
_woGear = _this select 2;
_clientID = owner _player;
_playerUID = getPlayerUID _player;
_name = if (alive _player) then {name _player;} else {"unknown player";};

_class = typeOf _vehicle;
_displayName = getText(configFile >> "cfgVehicles" >> _class >> "displayName");
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

_query = format["INSERT INTO garage (PlayerUID, Name, DisplayName, Classname, CharacterID, Inventory, Hitpoints, Fuel, Damage, Colour, Colour2) VALUES ('%1','%2','%3','%4','%5','%6','%7','%8','%9','%10','%11')",_playerUID,_name,_displayName,_class,_charID,_inventory,_array,_fuel,_damage,_colour,_colour2];

[_query, 1, true] call fn_asyncCall;

PVDZE_storeVehicleResult = true;

if (!isNull _player) then {_clientID publicVariableClient "PVDZE_storeVehicleResult";};

diag_log format["GARAGE: %1 (%2) stored %3 @%4 %5",if (alive _player) then {name _player} else {"DeadPlayer"},_playerUID,_class,mapGridPosition (getPosATL _player),getPosATL _player];