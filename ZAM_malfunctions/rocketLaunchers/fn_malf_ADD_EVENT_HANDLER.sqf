params ["_unit", ["_defaultProbabilities", [0.1,0.3,0.6], [[]], [3]], ["_maxDelays", [1,5], [[]], [2]]];
systemChat "adding eventhandler!";

// set variables to unit, so they can be accessed in eventHandler;
_unit setVariable ["ZAM_malf_DEFAULTS", _defaultProbabilities];
_unit setVariable ["ZAM_malf_MAX_DELAYS", _defaultProbabilities];
_unit addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	systemChat "shot";
	_usedammo = getText (configfile >> "CfgMagazines" >> _magazine >> "ammo");
 
	(_unit getVariable "ZAM_malf_DEFAULTS") params ["_defMalfProb", "_defLiveProb", "_defInertReactProb"];
	private _MALFUNCTION_PROBABILITY= _unit getVariable	["ZAM_malf_MALFUNCTION_PROBABILITY", _defMalfProb]; 
	private _LIVE_ROUND_PROBABILITY= _unit getVariable	["ZAM_malf_LIVE_ROUND_PROBABILITY", _defLiveProb];  
	private _INERT_REACTIVATION_PROBABILITY = _unit getVariable	["ZAM_malf_INERT_REACTION_PROBABILITY", _defInertReactProb];
 
	if(_usedammo isKindOf "RocketCore" OR _usedammo isKindOf "MissileCore" OR _usedammo isKindOf "ShellCore" ) then {
		if((random 1) < _MALFUNCTION_PROBABILITY) then {
			(_unit getVariable "ZAM_malf_MAX_DELAYS") params ["_maxActivationDelay", "_maxReactivationDelay"];
			private _activationDelay = (random _maxActivationDelay);
			private _reactivationDelay = 1 + (random _maxReactivationDelay);

			hint "malfunction";
			0 = [_projectile, _unit, _activationDelay, _LIVE_ROUND_PROBABILITY,_INERT_REACTIVATION_PROBABILITY, _reactivationDelay] spawn {
				params ["_projectile","_unit", "_activationDelay", "_LIVE_ROUND_PROBABILITY","_reactivationProbability", "_reactivationDelay"];
				
				sleep _activationDelay;
				private _model = (getModelInfo _projectile) select 1;
				private _pos = getPos _projectile;
				private _mass = getMass _projectile;
				private _type = typeOf _projectile;
				
				private _obj = _projectile;
				private _dir = (_unit weaponDirection (currentWeapon _unit)) vectorMultiply 1;
				private _force = (random 1)*10 + 2;
				private _velocityPr =  (velocity _projectile) vectorMultiply (random 0.8) ;

				private _isDummy = false;
				if(random 1 > _LIVE_ROUND_PROBABILITY) then {
					deleteVehicle _projectile;
					_obj = createSimpleObject [_model, AGLtoASL _pos];
					_dir = _dir vectorMultiply -1;
					_force = -_force;
					_isDummy = true;
				};

				

				private _ball = createVehicle ["Land_Baseball_01_F", ASLToATL (AGLToASL _pos)]; 
				_ball setPos _pos;
				_ball setMass _mass;
				private _ballUpVector = vectorUp _ball;
				
				_ball setVectorDirAndUp [_dir , _ballUpVector];
				
				//_ball addForce [_dir vectorMultiply _force, [0,0,0]];
				_ball setVelocity _velocityPr;
				_obj attachto [_ball,[0,0,0]];

				

				0 = [_ball, _obj,  diag_tickTime, _type, _isDummy, _reactivationProbability, _reactivationDelay ] spawn {
					params["_ball", "_attached", "_startTime", "_classname", "_isDummy", "_reactivationProbability", "_reactivationDelay"];
					while {((getpos _ball) select 2 > 0) }  do {
						_attached enableSimulation false; 
						sleep 0.00001;
					};

					
					sleep 0.01;
					detach _attached;
					deleteVehicle _ball;
					
					_attached enableSimulation true;
					if(_isDummy) then {
						if((random 1) < _reactivationProbability) then {
							sleep _reactivationDelay;
							private _vecUpAttached = vectorUp _attached;
							private _posAtt = getPos _attached;
							private _dirAtt = (vectorDir _attached) vectorMultiply -1;
							deleteVehicle _attached;
							private _liveR = createVehicle [_classname, ASLToATL (AGLToASL _posAtt)];
							_liveR setPos _posAtt;
							_liveR setVectorDirAndUp [_dirAtt , _vecUpAttached];
						} else {
							 0 = [_attached] spawn {
								 params ["_attached"];
								 sleep 20;
								 deleteVehicle _attached;
							 }
						};
					} else {
						sleep _reactivationDelay;
						_attached setDamage 1;
					};
				};
			};
		};
	}
}]
