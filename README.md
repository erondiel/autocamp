# autocamp
Autocamp Lua for Everquest
This lua is intended to camp your toon to desktop after a timer has run out.
It will take some class specific actions like killed macros and pausing class plugins.
To run the Lua:
/lua run autocamp <time> <gatemethod> (minimum accepted time 10 minutes)
The time can be entered as seconds, minutes or HH:MM format. If no unit is provided it will interpret it as seconds. For Example
600(seconds)
600s (seconds)
60m (minutes)
2:30 2 hours 30 minutes

Gate
If you don't provide any gate method when starting the timer. It will use the default gate method for each class.
Caster = Gate spell on gem 8 (will memorize it and cast)
meelee = Throne of Heroes AA
You can specify the gate method to be used when starting the Lua.
Primary - Will use your primary anchor
Secondary - Will use your secondary anchor
AAGate - Will you your AA gate
Gate - Default Caster
Throne of Heroes - Default Meelee

Basic funcitoning.
When the timer reachs 5 minutes remaining
If your class is Paladin or Warrior it wil set your plugin to Tank mode.
If your class is Monk it will set your plugin to Assist mode
When there is 2 minutes remaining on the timer it will pause your plugin and gate
When the timer ends it will camp to desktop
The timer prints a message with the remaining time every 10 minutes.
On the last minute prints the message every 10 seconds.


