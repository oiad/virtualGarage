private ["_worldSpace","_player","_id","_query","_return","_class","_characterID","_inventory","_hitpoints","_fuel","_damage","_dir","_location","_uid","_key","_query1","_colour","_colour2","_result"];

_worldSpace = _this select 0;
_player = _this select 1;
_id = _this select 2;

_query = format["SELECT classname, CharacterID, Inventory, Hitpoints, Fuel, Damage, Colour, Colour2 FROM garage WHERE ID='%1'",_id];

_result = [_query,2,true] call fn_asyncCall;
_return = _result select 0;

_class = _return select 0;
_characterID = _return select 1;
_inventory = _return select 2;
_hitpoints = _return select 3;
_fuel = _return select 4;
_damage = _return select 5;
_colour = _return select 6;
_colour2 = _return select 7;

_dir = _worldSpace select 0;
_location = _worldSpace select 1;

_worldSpace = [_dir,_location,_colour,_colour2];

_uid = _worldSpace call dayz_objectUID2;

//Send request
_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance,_class,_damage,_characterID,_worldSpace,_inventory,_hitpoints,_fuel,_uid];
_key call server_hiveWrite;

_query1 = format["DELETE FROM garage WHERE ID='%1'",_id];

[_query1,1,true] call fn_asyncCall;

// Switched to spawn so we can wait a bit for the ID
[_uid,_characterID,_class,_dir,_location,_inventory,_hitpoints,_fuel,_damage,_colour,_colour2,_player] spawn {
   private ["_object","_uid","_characterID","_class","_inventory","_hitpoints","_fuel","_damage","_done","_retry","_key","_result","_outcome","_oid","_selection","_dam","_objWpnTypes","_objWpnQty","_isOK","_countr","_colour","_colour2","_clrinit","_clrinit2","_player","_clientID"];

	_uid = _this select 0;
	_characterID = _this select 1;
	_class = _this select 2;
	//_dir = _this select 3;
	_location = _this select 4;
	_inventory = _this select 5;
	_hitpoints = _this select 6;
	_fuel = _this select 7;
	_damage = _this select 8;
	_colour = _this select 9;
	_colour2 = _this select 10;
	_player = _this select 11;
	_clientID = owner _player;

	_done = false;
	_retry = 0;
	// TODO: Needs major overhaul for 1.1
	while {_retry < 10} do {
		uiSleep 1;
		// GET DB ID
		_key = format["CHILD:388:%1:",_uid];
		#ifdef OBJECT_DEBUG
		diag_log ("HIVE: WRITE: "+ str(_key));
		#endif
		_result = _key call server_hiveReadWrite;
		_outcome = _result select 0;
		if (_outcome == "PASS") then {
			_oid = _result select 1;
			//_object setVariable ["ObjectID", _oid, true];
			#ifdef OBJECT_DEBUG
			diag_log("CUSTOM: Selected " + str(_oid));
			#endif
			_done = true;
			_retry = 100;
		} else {
			#ifdef OBJECT_DEBUG
			diag_log("CUSTOM: trying again to get id for: " + str(_uid));
			#endif
			_done = false;
			_retry = _retry + 1;
		};
	};

	//_object = createVehicle [_class, _location, [], 0, "CAN_COLLIDE"];
	// Don't use setPos or CAN_COLLIDE here. It will spawn inside other vehicles
	_object = _class createVehicle _location;
	if (surfaceIsWater _location && {({_x != _object} count (_location nearEntities ["Ship",8])) == 0}) then {
		//createVehicle "NONE" is especially inaccurate in water
		_object setPos _location;
	};
	
	_object addEventHandler ["HandleDamage",{false}];
	//_object setposATL _location;

	clearWeaponCargoGlobal  _object;
	clearMagazineCargoGlobal  _object;
	// _object setVehicleAmmo DZE_vehicleAmmo;

	_object setFuel _fuel;
	_object setDamage _damage;
	
	 if (count _inventory > 0) then {	
		//Add weapons
		_objWpnTypes = (_inventory select 0) select 0;
		_objWpnQty = (_inventory select 0) select 1;
		_countr = 0;					
		{
			_isOK = isClass(configFile >> "CfgWeapons" >> _x);
			if (_isOK) then {_object addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];};
			_countr = _countr + 1;
		} count _objWpnTypes; 

		//Add Magazines
		_objWpnTypes = (_inventory select 1) select 0;
		_objWpnQty = (_inventory select 1) select 1;
		_countr = 0;
		{
			_isOK = isClass(configFile >> "CfgMagazines" >> _x);
			if (_isOK) then {_object addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];};
			_countr = _countr + 1;
		} count _objWpnTypes;

		//Add Backpacks
		_objWpnTypes = (_inventory select 2) select 0;
		_objWpnQty = (_inventory select 2) select 1;
		_countr = 0;
		{
			_isOK =	isClass(configFile >> "CfgVehicles" >> _x);
			if (_isOK) then {_object addBackpackCargoGlobal [_x,(_objWpnQty select _countr)];};
			_countr = _countr + 1;
		} count _objWpnTypes;
	};

	_object setVariable ["ObjectID", _oid, true];
	_object setVariable ["lastUpdate",time];

	if (_colour != "0") then {
		_object setVariable ["Colour",_colour,true];
		_clrinit = format ["#(argb,8,8,3)color(%1)",_colour];
		_object setVehicleInit "this setObjectTexture [0,"+str _clrinit+"];";
	};

	if (_colour2 != "0") then {			
		_object setVariable ["Colour2",_colour2,true];
		_clrinit2 = format ["#(argb,8,8,3)color(%1)",_colour2];
		_object setVehicleInit "this setObjectTexture [1,"+str _clrinit2+"];";
	};
	
	_characterID = str(_characterID);
	_object setVariable ["CharacterID", _characterID, true];

	if (_characterID != "0" && !(_object isKindOf "Bicycle")) then {_object setVehicleLock "LOCKED";};

	{
		_selection = _x select 0;
		_dam = _x select 1;
		if (_selection in dayZ_explosiveParts && _dam > 0.8) then {_dam = 0.8};
		[_object,_selection,_dam] call fnc_veh_setFixServer;
	} forEach _hitpoints;

	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

	_object call fnc_veh_ResetEH;
	
	// for non JIP users this should make sure everyone has eventhandlers for vehicles.
	PVDZE_veh_Init = _object;
	publicVariable "PVDZE_veh_Init";

	PVDZE_spawnVehicleResult = _characterID;

	if (!isNull _player) then {_clientID publicVariableClient "PVDZE_spawnVehicleResult";};
	
	diag_log format["GARAGE: %1 (%2) retrieved %3 @%4 %5",if (alive _player) then {name _player} else {"DeadPlayer"},getPlayerUID _player,_class,mapGridPosition (getPosATL _player),getPosATL _player];
};
