// Written by icomrade (https://github.com/icomrade)

private ["_hasAccess","_heliPad","_objectID","_objectUID","_plotCheck"];

closeDialog 0;

_itemText = if (Z_SingleCurrency) then { CurrencyName } else { [vg_maintainCost,true] call z_calcCurrency };
_enoughMoney = false;
_moneyInfo = [false, [], [], [], 0];
_wealth = player getVariable[Z_MoneyVariable,0];

if (Z_SingleCurrency) then {
	_enoughMoney = (_wealth >= vg_maintainCost);
} else {
	Z_Selling = false;
	_moneyInfo = vg_maintainCost call Z_canAfford;
	_enoughMoney = _moneyInfo select 0;
};

_success = true;
if (vg_maintainCost > 0) then {
	_success = if (Z_SingleCurrency) then {_enoughMoney} else {[player,vg_maintainCost,_moneyInfo,false,0] call Z_payDefault};
};

if (!_success && _enoughMoney) exitWith { systemChat localize "STR_EPOCH_TRADE_GEAR_AND_BAG_FULL"; };

if (_enoughMoney || vg_maintainCost < 1) then {
	if (Z_SingleCurrency) then {
		player setVariable[Z_MoneyVariable,(_wealth - vg_maintainCost),true];
	};
	(localize "STR_VG_MAINTAINSUCCESS") call dayz_rollingMessages;
	if (vg_tiedToPole) then {
		_plotCheck = [player,false] call FNC_find_plots;
		_ownerPUID = if (_plotCheck select 1 > 0) then {(_plotCheck select 2) getVariable ["ownerPUID","0"]} else {dayz_playerUID};
		PVDZE_maintainGarage = [player,_ownerPUID];
	} else {
		PVDZE_maintainGarage = [player];
	};
	publicVariableServer "PVDZE_maintainGarage";
} else {
	(localize "STR_VG_MAINTAINFAIL") call dayz_rollingMessages;
};