private ["_player","_playerUID","_key"];
_player = _this select 0;
_playerUID = if (count _this > 1) then {_this select 1} else {getPlayerUID _player};

_key = format["CHILD:803:%1:",_playerUID];
_key call server_hiveWrite;
Diag_Log format["VG Maintain by player with UID: %1, of vehicles linked to PlayerUID %2, at coordinates: %3",getPlayerUID _player, _playerUID, (mapGridPosition _player)];