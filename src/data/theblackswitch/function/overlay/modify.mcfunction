# ARGS:
# - id: The id of this overlay
# - texture: The new replacement texture

# CONTEXT:
# - run as the target player

##-------ENANBLE-EVERYTHING-------
function theblackswitch:overlay/enable

#-------------------------------------------------------
## Process the arguments
#-------------------------------------------------------

# check if we have all arguments
execute unless data storage theblackswitch:overlay id run return:
    @debug << {"text":"Failed to apply overlay, missing field id!"}
    return fail

# check if we have all arguments
execute unless data storage theblackswitch:overlay texture run return:
    @debug << {"text":"Failed to apply overlay, missing field texture!"}
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
## Modify the actual data
#-------------------------------------------------------

with storage theblackswitch:overlay:
    $execute unless data storage theblackswitch:overlay data[{id:"$(id)"}] run return run \
        @debug << [{"text":"Failed to modify overlay '"},{"nbt":"id","storage":"theblackswitch:overlay"},{"text":"', no such overlay!"}]

    $data modify storage theblackswitch:overlay data[{id:"$(id)"}].texture set from storage theblackswitch:overlay texture

    # increase the version
    $execute store result score #version temp run data get storage theblackswitch:overlay data[{id:"$(id)"}].version
    $execute store result storage theblackswitch:overlay data[{id:"$(id)"}].version int 1 run scoreboard players add #version temp 1

    $@debug << {"text":"Successfully modified overlay $(id)!"}

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