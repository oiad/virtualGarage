// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
// Rewritten by salival (https://github.com/oiad)

private ["_backPack","_charID","_dir","_heliPad","_inventory","_isOK","_keyID","_keyName","_location","_sign","_totalTools","_vehicle"];

closeDialog 0;
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format["%1",_vehicle]);
_isOK = true;

if (_vehicle select 3 != 0) then {
	_totalTools = 0;
	{
		if (getNumber (configFile >> "CfgWeapons" >> _x >> "type") == 131072) then {_totalTools = _totalTools + 1;};
	} count (weapons player);
	if (_totalTools == 12) then {_isOK = false};
};

if (!_isOK) exitWith {localize "str_epoch_player_107" call dayz_rollingMessages;};

_dir = round(random 360);
_backPack = [];
_heliPad = nearestObjects [player,vg_heliPads,vg_distance];
if ((count _heliPad == 0) && ((_vehicle select 1) isKindOf "Air")) exitWith {localize "STR_VG_NEED_heliPad" call dayz_rollingMessages;};
if (count _heliPad > 0) then {
	_location = [(_heliPad select 0)] call FNC_GetPos;
} else {
	_location = [(position player),0,20,1,0,2000,0] call BIS_fnc_findSafePos;
	_location set [2,(position player) select 2];
};

_sign = "Sign_arrow_down_large_EP1" createVehicleLocal [0,0,0];
_sign setPos _location;
_location = [_sign] call FNC_GetPos;

if (surfaceIsWater _location && {count (_location nearEntities ["Ship",8]) > 0}) then {
	deleteVehicle _sign;
	localize "STR_EPOCH_TRADE_OBSTRUCTED" call dayz_rollingMessages;
} else {
	[_vehicle select 1,_sign] call fn_waitForObject;
};

PVDZE_spawnVehicle = [[_dir,_location],player,_vehicle select 0];
publicVariableServer "PVDZE_spawnVehicle";

waitUntil {!isNil "PVDZE_spawnVehicleResult"};

if (PVDZE_spawnVehicleResult != "0") then {
	_keyID = "";
	_charID = parseNumber PVDZE_spawnVehicleResult;
	if ((_charID > 0) && (_charID <= 2500)) then {_keyID = format["ItemKeyGreen%1",_charID];};
	if ((_charID > 2500) && (_charID <= 5000)) then {_keyID = format["ItemKeyRed%1",_charID-2500];};
	if ((_charID > 5000) && (_charID <= 7500)) then {_keyID = format["ItemKeyBlue%1",_charID-5000];};
	if ((_charID > 7500) && (_charID <= 10000)) then {_keyID = format["ItemKeyYellow%1",_charID-7500];};
	if ((_charID > 10000) && (_charID <= 12500)) then {_keyID = format["ItemKeyBlack%1",_charID-10000];};
	_keyName = getText(configFile >> "CfgWeapons" >> _keyID >> "displayName");

	_inventory = weapons player;
	dayz_myBackpack = unitBackpack player;
	if (!isNull dayz_myBackpack) then {_backPack = (getWeaponCargo dayz_myBackpack) select 0;};
	if !(isClass(configFile >> "CfgWeapons" >> _keyID)) then {
		if (_keyID in (_inventory+_backPack)) then {
			if (_keyID in _inventory) then {format[localize "STR_VG_IN_INVENTORY",_keyName] call dayz_rollingMessages;};
			if (_keyID in _backPack) then {format[localize "STR_VG_IN_BACKPACK",_keyName] call dayz_rollingMessages;};
		} else {
			player addWeapon _keyID;
			format[localize "STR_VG_ADDED_INVENTORY",_keyName] call dayz_rollingMessages;
			localize "STR_VG_VEHICLE_SPAWNED" call dayz_rollingMessages;
		};
	} else {
		localize "str_epoch_player_107" call dayz_rollingMessages;
	};
};

PVDZE_spawnVehicle = nil;
PVDZE_spawnVehicleResult = nil;
vg_vehicleList = nil;
