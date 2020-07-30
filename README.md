# ZAM_malfunctions

Mission for testing the malfunctions script.

The mission requires RHS and CUP units, the script itself doesn't need anything.

## what the script does

It adds the possibility of a rocket-like projectile (from rocket launchers etc) to malfunction while being fired.
Malfuncions manifest in a possibility of a rocket launcher unkindly ejecting a "possibly live" projectile somewhere around your legs. 

The malfunctioned projectile can either be live or inert. If inert, the projectile can re-activate.



## Usage of the script

Copy "ZAM_malfunctions" folder and the "CfgFunctions" part of description.ext into your mission.

For each unit you wish this script to work for add:

    [unit, probabilities, delays] call ZAM_fnc_malf_ADD_EVENT_HANDLER;

Where:
* unit -  unit to add the malfunction possibility to;
* probabilities - optional  array of size 3 (default: [0.1, 0.3, 0.6]):
  1. default malfunction probability (from 0 to 1)  
  1. default malfunctioned live round probability (from 0 to 1)
  1. default inert round re-activation probability (from 0 to 1)
* delays - optional  array of size 2 (default: [1, 5]):
  1. maximum malfunction "start" delay (any positive Number)
  1. maximum re-activation delay (any positive Number)

### Per unit probabilities

Each unit can have it's own probabilities of malfunction.
These can be changed anytime and are read when the unit fires.

With "addvariable" add these variables to the unit:
* ZAM_malf_MALFUNCTION_PROBABILITY
* ZAM_malf_LIVE_ROUND_PROBABILITY
* ZAM_malf_INERT_REACTION_PROBABILITY

If any of these 3 variables isn't defined on the unit, the default for that probability is used.


Which units have the script activated on is up to the mission maker.
Check this mission for example.
