"extDB" callExtension "9:DATABASE:Database";
"extDB" callExtension "9:ADD:DB_RAW_V2:1";
"extDB" callExtension "9:LOCK";

diag_log "extDB: Connected to database.";

server_queryVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_queryVehicle.sqf";
server_spawnVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_spawnVehicle.sqf";
server_storeVehicle = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_storeVehicle.sqf";
fn_asyncCall = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\fn_async.sqf";

"PVDZE_queryVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_queryVehicle};
"PVDZE_spawnVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_spawnVehicle};
"PVDZE_storeVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_storeVehicle};

// Thanks to icomrade/DayZ Epoch for this code: https://github.com/EpochModTeam/DayZ-Epoch/commit/8035df0ba0cd928b84085e288c5cb88260870a3e#diff-ad0636fc2328a27bd80bad9f46126307
vg_serverKey = [];
_randomInput = toArray "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
for "_i" from 0 to 8 do {
	vg_serverKey set [count vg_serverKey, (_randomInput call BIS_fnc_selectRandom)];
};
vg_serverKey = toString vg_serverKey;
