# if the tick function is still running, reset it and evaluate if this is still the latest version
schedule clear theblackswitch:v2.0/patch-0/v2.0/patch-0/tick

execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail

# Check for debug players
scoreboard players set #tbs-patch-0.debug_enabled tbs.server_data 0
execute if entity @a[tag=tbs.debug] run scoreboard players set #tbs-v2.0.debug_enabled tbs.server_data 1

# Debug startup message
execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] ["",{"text":"[Debug]: ","color":"yellow"},{"text":" Switch-Lib v2.0 patch-0 loaded!"}]

# Inits
function theblackswitch:v2.0/patch-0/player_id/init
function theblackswitch:v2.0/patch-0/slow_tick/init
#function theblackswitch:v2.0/patch-0/easing/internal/load

# scoreboards
scoreboard objectives add temp dummy
scoreboard objectives add tbs.server_data dummy
scoreboard objectives add tbs.math dummy

# useful teams
team add tbs.no_collide
team modify no_collide collisionRule never

# this is the latest version so we can start the tick function
schedule function theblackswitch:v2.0/patch-0/v2.0/patch-0/tick 1t
