

##Reset Versions:
data remove storage theblackswitch:versions lib
data remove storage theblackswitch:versions packs

##Init tick function
function theblackswitch:version_control/init

##Inits
function theblackswitch:player_id/init
function theblackswitch:slow_tick/init
function theblackswitch:easing/internal/load

##scoreboards
scoreboard objectives add temp dummy
scoreboard objectives add tbs.server_data dummy
scoreboard objectives add math dummy

team add no_collide
team modify no_collide collisionRule never