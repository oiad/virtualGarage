if (isServer) then {
	diag_log "Loading custom server compiles";
};

if (!isDedicated) then {
	diag_log "Loading custom client compiles";

	fnc_usec_selfactions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";
};
