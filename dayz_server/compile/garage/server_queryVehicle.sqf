private ["_player","_query","_result","_clientID","_playerUID"];

_player = _this select 0;
_clientID = owner _player;
_playerUID = if (count _this > 1) then {_this select 1} else {getPlayerUID _player};

_query = format["SELECT id, classname, Inventory, CharacterID,DateStored FROM garage WHERE PlayerUID='%1' ORDER BY DisplayName",_playerUID];

_result = [_query,2,true] call fn_asyncCall;

PVDZE_queryVehicleResult = _result;

if (!isNull _player) then {_clientID publicVariableClient "PVDZE_queryVehicleResult";};
