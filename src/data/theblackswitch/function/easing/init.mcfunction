#--------------------REQUIREMENTS-----------------------
# 1. Run as target entity to set the animation
# 2. duration            = the time duration of the ease (int)
# 3. x, y, z, yaw, pitch = the relative position and rotation to ease to (int)
# 4. ease                = the ease function to use (one of: ["ease_in","ease_out","ease_in_out","linear"])
# 5. callback (optional) = run a command when the easing is finished
#-------------------------------------------------------

#-------------------------------------------------------
## Process the arguments
#-------------------------------------------------------

# check if we have all arguments
execute unless data storage theblackswitch:easing duration run return:
    @debug << {"text":"Failed to init easing, missing field duration!"}
    return fail

execute unless data storage theblackswitch:easing ease run return:
    @debug << {"text":"Failed to init easing, missing field ease!"}
    return fail

execute unless data storage theblackswitch:easing x run return:
    @debug << {"text":"Failed to init easing, missing field x!"}
    return fail

execute unless data storage theblackswitch:easing y run return:
    @debug << {"text":"Failed to init easing, missing field y!"}
    return fail

execute unless data storage theblackswitch:easing z run return:
    @debug << {"text":"Failed to init easing, missing field z!"}
    return fail

execute unless data storage theblackswitch:easing yaw run return:
    @debug << {"text":"Failed to init easing, missing field yaw!"}
    return fail

execute unless data storage theblackswitch:easing pitch run return:
    @debug << {"text":"Failed to init easing, missing field pitch!"}
    return fail

# enable easing
function theblackswitch:easing/enable

# Store the easing variables
execute store result score @s tbs.easing.duration run data get storage theblackswitch:easing duration 1
execute store result score @s tbs.easing.current_tick run data get storage theblackswitch:easing duration 1
execute store result score @s tbs.easing.x run data get storage theblackswitch:easing x 1000
execute store result score @s tbs.easing.y run data get storage theblackswitch:easing y 1000
execute store result score @s tbs.easing.z run data get storage theblackswitch:easing z 1000
execute store result score @s tbs.easing.yaw run data get storage theblackswitch:easing yaw 1000
execute store result score @s tbs.easing.pitch run data get storage theblackswitch:easing pitch 1000

# Get the easing type
scoreboard players set @s tbs.easing.ease 4 # default to linear
execute if data storage theblackswitch:easing {ease:"ease_in"} run scoreboard players set @s tbs.easing.ease 1
execute if data storage theblackswitch:easing {ease:"ease_out"} run scoreboard players set @s tbs.easing.ease 2
execute if data storage theblackswitch:easing {ease:"ease_in_out"} run scoreboard players set @s tbs.easing.ease 3

#-------------------------------------------------------
## Store the callback if specified
#-------------------------------------------------------

execute if data storage theblackswitch:easing callback:

    # Assign a callback ID
    execute unless score #current tbs.easing.callback_id matches 0.. run scoreboard players set #current tbs.easing.callback_id 0
    execute store result storage theblackswitch:easing callback_item.id int 1 run scoreboard players operation @s tbs.easing.callback_id = #current tbs.easing.callback_id

    # combine everyting in a dict and add it to the que
    data modify storage theblackswitch:easing callback_item.command set from storage theblackswitch:easing callback
    data modify storage theblackswitch:easing callback_queue append from storage theblackswitch:easing callback_item

    # increase the current id
    scoreboard players add #current tbs.easing.callback_id 1

#-------------------------------------------------------
## Start the easing
#-------------------------------------------------------

# mark this entity to run the easing functions
tag @s add tbs.easing
scoreboard players add #tbs.easing_entity_count tbs.server_data 1

execute at @s run function theblackswitch:easing/run/ease

#-------------------------------------------------------
## Reset the arguments
#-------------------------------------------------------

schedule function theblackswitch:easing/run/clear_arguments 1t replace
