private ["_player","_query","_result","_clientID","_playerUID"];

_player = _this;
_clientID = owner _player;
_playerUID = getPlayerUID _player;

_query = format["SELECT id, classname, Inventory, CharacterID FROM garage WHERE PlayerUID='%1' ORDER BY DisplayName",_playerUID];

_result = [_query,2,true] call fn_asyncCall;

PVDZE_queryVehicleResult = _result;

if (!isNull _player) then {_clientID publicVariableClient "PVDZE_queryVehicleResult";};
