// Written by salival (https://github.com/oiad)

private ["_hasAccess","_heliPad","_objectID","_objectUID","_plotCheck"];

closeDialog 0;

_plotCheck = [player, false] call FNC_find_plots;
_hasAccess = [player,_plotCheck select 2] call FNC_check_access;

if ((_hasAccess select 0) or (_hasAccess select 2) or (_hasAccess select 3) or (_hasAccess select 4)) then {
	_heliPad = nearestObjects [player,vg_heliPads,Z_VehicleDistance];
	
	{
		_objectID = _x getVariable ["ObjectID","0"];
		_objectUID = _x getVariable ["ObjectUID","0"];

		PVDZ_obj_Destroy = [_objectID,_objectUID,player,_x,dayz_authKey];
		publicVariableServer "PVDZ_obj_Destroy";

		deleteVehicle _x;
		systemChat format ["Removed heliPad: %1",typeOf _x];
	} count _heliPad;
} else {
	systemChat localize "STR_EPOCH_PLAYER_134";
};
