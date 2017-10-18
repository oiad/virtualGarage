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