# ARGS:
# - id: The id of this overlay

# CONTEXT:
# - run as the target player

## PASSED THROUGH STORAGE: theblackswitch:overlay

#-------------------------------------------------------
## Process the arguments
#-------------------------------------------------------

# check if we have all arguments
execute unless data storage theblackswitch:overlay id run return:
    @debug << {"text":"Failed to apply overlay, missing field id!"}
    return fail

# check if we are a player
execute unless entity @s[type=minecraft:player] run return:
    @debug << {"text":"Failed to apply overlay to a non player entity!"}
    return fail

#-------------------------------------------------------
## Get the current overlays from the player storage
#-------------------------------------------------------

# get the current data from the player storage
execute store result storage theblackswitch:overlay player_storage.player_id int 1 run scoreboard players get @s tbs.ID
data modify storage theblackswitch:overlay player_storage.path set value "theblackswitch.overlay"
data modify storage theblackswitch:overlay player_storage.result set value "theblackswitch:overlay data"
function theblackswitch:player_storage/get with storage theblackswitch:overlay player_storage
data remove storage theblackswitch:overlay player_storage

#-------------------------------------------------------
## Remove the actual data
#-------------------------------------------------------

with storage theblackswitch:overlay:
    $execute store success score #success temp run data remove storage theblackswitch:overlay data[{id:"$(id)"}]
    $execute if score #success temp matches 1 run @debug << {"text":"Successfully removed overlay $(id)!"}
    $execute if score #success temp matches 0 run @debug << {"text":"Overlay $(id) was already removed!"}

#-------------------------------------------------------
## Put everything back into the player storage
#-------------------------------------------------------

execute store result storage theblackswitch:overlay player_storage.player_id int 1 run scoreboard players get @s tbs.ID
data modify storage theblackswitch:overlay player_storage.path set value "theblackswitch.overlay"
data modify storage theblackswitch:overlay player_storage.source set value "storage theblackswitch:overlay data"
function theblackswitch:player_storage/set_from with storage theblackswitch:overlay player_storage 

#-------------------------------------------------------
## Finally update the overlays
#-------------------------------------------------------

function theblackswitch:overlay/show/update