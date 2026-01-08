# ARGS:
# - texture: The overlay texture
# - id: The id to call this overlay later when removing
# - priority: The layer one of: persistent - conditional - notification - override
#                               L=> 0        L=> 1         L=> 2          L=> 3

# CONTEXT:
# - run as the target player

## PASSED THROUGH STORAGE: theblackswitch:overlay


#-------------------------------------------------------
## Process the arguments
#-------------------------------------------------------

# check if we have all arguments
execute unless data storage theblackswitch:overlay texture run return:
    @debug << {"text":"Failed to apply overlay, missing field texture!"}
    return fail

execute unless data storage theblackswitch:overlay priority run return:
    @debug << {"text":"Failed to apply overlay, missing field texture!"}
    return fail

execute unless data storage theblackswitch:overlay id run return:
    @debug << {"text":"Failed to apply overlay, missing field id!"}
    return fail

data modify storage theblackswitch:overlay curr_overlay.texture set from storage theblackswitch:overlay texture
data modify storage theblackswitch:overlay curr_overlay.priority set from storage theblackswitch:overlay priority
data modify storage theblackswitch:overlay curr_overlay.id set from storage theblackswitch:overlay id
data modify storage theblackswitch:overlay curr_overlay.version set value 0

# check if we are a player
execute unless entity @s[type=minecraft:player] run return:
    @debug << {"text":"Failed to apply overlay to a non player entity!"}
    return fail

# convert the priority to a number
scoreboard players set #priority temp -1
execute if data storage theblackswitch:overlay {priority:"persistent"} run scoreboard players set #priority temp 0
execute if data storage theblackswitch:overlay {priority:"conditional"} run scoreboard players set #priority temp 1
execute if data storage theblackswitch:overlay {priority:"notification"} run scoreboard players set #priority temp 2
execute if data storage theblackswitch:overlay {priority:"override"} run scoreboard players set #priority temp 3

# check if correct priority
execute if score #priority temp matches -1 run return:
    @debug << {"text":"Failed to apply overlay, priority must be one of [persitent|conditional|notification|override]"}
    return fail

execute store result storage theblackswitch:overlay curr_overlay.priority int 1 run scoreboard players get #priority temp

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
## Check if the ID already exists
#-------------------------------------------------------

execute store success score #success temp run function theblackswitch:overlay/apply_storage/verify_id with storage theblackswitch:overlay
execute if score #success temp matches 1.. run return:
    @debug << [{"text":"Failed to apply overlay, the id "},{"nbt":"id","storage":"theblackswitch:overlay","color":"green"},{"text":" already exists!"}]
    return fail

#-------------------------------------------------------
## Apply the overlay
#-------------------------------------------------------

# split the array in a part before the current overlay and a part after the current overlay
data modify storage theblackswitch:overlay post_insert set from storage theblackswitch:overlay data
data remove storage theblackswitch:overlay pre_insert
function theblackswitch:overlay/apply_storage/split

# combine all of the parts
data remove storage theblackswitch:overlay data
data modify storage theblackswitch:overlay data set from storage theblackswitch:overlay pre_insert
data modify storage theblackswitch:overlay data append from storage theblackswitch:overlay curr_overlay
function theblackswitch:overlay/apply_storage/concat_post_insert

@debug << {"text":"Successfully created a new overlay!"}

#-------------------------------------------------------
## Put everything back into the player storage
#-------------------------------------------------------

execute store result storage theblackswitch:overlay player_storage.player_id int 1 run scoreboard players get @s tbs.ID
data modify storage theblackswitch:overlay player_storage.path set value "theblackswitch.overlay"
data modify storage theblackswitch:overlay player_storage.source set value "storage theblackswitch:overlay data"
function theblackswitch:player_storage/set_from with storage theblackswitch:overlay player_storage    

#-------------------------------------------------------
## Reset all passed arguments
#-------------------------------------------------------

data remove storage theblackswitch:overlay texture
data remove storage theblackswitch:overlay priority
data remove storage theblackswitch:overlay id

#-------------------------------------------------------
## Finally update the overlays
#-------------------------------------------------------

function theblackswitch:overlay/show/update