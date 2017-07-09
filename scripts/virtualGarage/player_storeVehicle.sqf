// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
// Rewritten by salival (https://github.com/oiad)

private ["_amount","_backPackCount","_backPackGear","_charID","_control","_counter","_display","_enoughMoney","_gearCount","_hasKey","_isLimitArray","_itemText","_items","_keyColor","_keyName","_limit","_magazineCount","_matchedCount","_moneyInfo","_name","_overLimit","_storedVehicles","_success","_typeName","_typeOf","_vehicle","_vehicleID","_vehicleUID","_wealth","_weaponsCount","_woGear"];

disableSerialization;

_display = findDisplay 2800;
_control = ((findDisplay 2800) displayCtrl 2802);

_vehicle = vg_vehicleList select (lbCurSel _control);
_typeOf = typeOf _vehicle;
_isLimitArray = typeName vg_limit == "ARRAY";

_overLimit = false;
_matchedCount = 0;
_storedVehicles = [];

if (_typeOf in vg_blackListed) exitWith {localize "STR_VG_BLACKLISTED" call dayz_rollingMessages;};

{
	if (typeName _x == "ARRAY") then {
		 _storedVehicles set [count _storedVehicles,_x select 1];
	};
} count vg_vehicleList;

_gearCount = {
	private ["_counter"];
	_counter = 0;
	{_counter = _counter + _x;} count _this;
	_counter
};

if (_isLimitArray) then {
	{
		_typeName = _x select 0;
		_limit = _x select 1;
		if (typeName _x == "ARRAY") then {
			if (_typeOf isKindOf _typeName) then {
				{
					if (_x isKindOf _typeName) then {_matchedCount = _matchedCount +1};
					if (_matchedCount >= _limit) then {_overLimit = true;};
				} count _storedVehicles;
			};
		};
		if (_overLimit) exitWith {};
	} count vg_limit;
} else {
	if (count _storedVehicles >= vg_limit) then {_overLimit = true;};
};

if (_overLimit) exitWith {
	if (_isLimitArray) then {
		systemChat localize "STR_VG_LIMIT_ARRAY";
	} else {
		systemChat localize "STR_VG_LIMIT_NUMBER";
	};
};

vg_vehicleList = nil;

_woGear = _this select 0;
closeDialog 0;

_charID	= _vehicle getVariable ["CharacterID","0"];
_vehicleID = _vehicle getVariable ["ObjectID","0"];
_vehicleUID	= _vehicle getVariable ["ObjectUID","0"];
_weaponsCount = ((getWeaponCargo _vehicle) select 1) call _gearCount;
_magazineCount = ((getMagazineCargo _vehicle) select 1) call _gearCount;
_backPackCount = ((getBackpackCargo _vehicle) select 1) call _gearCount;

if (_vehicleID == "1" || _vehicleUID == "1") exitWith {localize "STR_VG_STORE_MISSION" call dayz_rollingMessages;};
if (isNull DZE_myVehicle || !local DZE_myVehicle) exitWith {systemChat localize "STR_EPOCH_PLAYER_245";};

_hasKey = false;
_keyColor = ["ItemKeyYellow","ItemKeyBlue","ItemKeyRed","ItemKeyGreen","ItemKeyBlack"];

_items = items player;
dayz_myBackpack = unitBackpack player;

if (!isNull dayz_myBackpack) then {
	_backPackGear = (getWeaponCargo dayz_myBackpack) select 0;
	_items = _items + _backPackGear;
};

if (_charID != "0") then {
	{
		if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in _keyColor) then {
			if (str(getNumber(configFile >> "CfgWeapons" >> _x >> "keyid")) == _charID) then {
				_keyName = _x;
				_hasKey = true;
			};
		};
	} count _items;
} else {
	_hasKey = true;
};

if (vg_requireKey && {!_hasKey}) exitWith {localize "STR_VG_REQUIRE_KEY" call dayz_rollingMessages;};

_name = getText(configFile >> "cfgVehicles" >> _typeOf >> "displayName");

_amount = if (_woGear) then {
	{
		if (_typeOf isKindOf (_x select 0)) exitWith {_x select 1};
	} forEach vg_price;
} else {
	(_weaponsCount + _magazineCount + _backPackCount) * vg_pricePer
};
_amount = if (z_singleCurrency) then {_amount * 10} else {_amount};

_enoughMoney = false;
_moneyInfo = [false,[],[],[],0];
_wealth = player getVariable[Z_MoneyVariable,0];

if (Z_SingleCurrency) then {
	_enoughMoney = if (_wealth >= _amount) then {true} else {false};
} else {
	Z_Selling = false;
	if (Z_AllowTakingMoneyFromVehicle) then {false call Z_checkCloseVehicle};
	_moneyInfo = _amount call Z_canAfford;
	_enoughMoney = _moneyInfo select 0;
};

_success = if (Z_SingleCurrency) then {true} else {[player,_amount,_moneyInfo,true,0] call Z_payDefault};

if (!_success && {_enoughMoney}) exitWith {systemChat localize "STR_EPOCH_TRADE_GEAR_AND_BAG_FULL"}; // Not enough room in gear or bag to accept change

if (_enoughMoney) then {
	_success = if (Z_SingleCurrency) then {_amount <= _wealth} else {[player,_amount,_moneyInfo,false,0] call Z_payDefault};
	if (_success) then {
		if (Z_SingleCurrency) then {player setVariable[Z_MoneyVariable,(_wealth - _amount),true];};

		[_vehicle,true] call local_lockUnlock;
		DZE_myVehicle = objNull; // Reset the players last vehicle here so if things lag out, you can't double store a vehicle and dupe it.

		PVDZE_storeVehicle = [_vehicle,player,_woGear];
		publicVariableServer "PVDZE_storeVehicle";
		waitUntil {!isNil "PVDZE_storeVehicleResult"};

		PVDZ_obj_Destroy = [_vehicleID,_vehicleUID,player];
		publicVariableServer "PVDZ_obj_Destroy";

		deleteVehicle _vehicle;

		PVDZE_storeVehicle = nil;
		PVDZE_storeVehicleResult = nil;

		format [localize "STR_VG_VEHICLE_STORED",_name] call dayz_rollingMessages;
		if (vg_removeKey && {_charID != "0"}) then {[player,_keyName,1] call BIS_fnc_invRemove;};
	} else {
		systemChat localize "STR_EPOCH_TRADE_DEBUG";
	};
} else {
	_itemText = if (Z_SingleCurrency) then {CurrencyName} else {[_amount,true] call z_calcCurrency};
	if (Z_SingleCurrency) then {
		systemChat format [localize "STR_VG_NEED_COINS",[_amount] call BIS_fnc_numberText,_itemText,_name];
	} else {
		systemChat format [localize "STR_VG_NEED_BRIEFCASES",_itemText,_name];
	};
};