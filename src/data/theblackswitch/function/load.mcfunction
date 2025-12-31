# if the tick function is still running, reset it and evaluate if this is still the latest version
schedule clear theblackswitch:v2.0/patch-0/tick

@resolve # resolve the function's version here (instead of standard at the top) everything after this runs only for the newest instance

# Check for debug players
scoreboard players set #tbs-$patch$.debug_enabled tbs.server_data 0
execute if entity @a[tag=tbs.debug] run scoreboard players set #tbs-v2.0.debug_enabled tbs.server_data 1

# Debug startup message
@debug >> {"text":" Switch-Lib v2.0 patch-0 loaded!"}

# Inits
function theblackswitch:player_id/init
function theblackswitch:slow_tick/init
#function theblackswitch:easing/internal/load

# scoreboards
scoreboard objectives add temp dummy
scoreboard objectives add tbs.server_data dummy
scoreboard objectives add tbs.math dummy

# useful teams
team add tbs.no_collide
team modify no_collide collisionRule never

# this is the latest version so we can start the tick function
schedule function theblackswitch:v2.0/patch-0/tick 1t