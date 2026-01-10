
# Grab the callback ID
execute store result storage theblackswitch:easing callback_id int 1 run scoreboard players get @s tbs.easing.callback_id

# Grab the callback command using the ID
with storage theblackswitch:easing:
    $data modify storage theblackswitch:easing callback_result set from storage theblackswitch:easing callback_queue[{"id":$(callback_id)}].command
    $data remove storage theblackswitch:easing callback_queue[{"id":$(callback_id)}]

# Run the callback
with storage theblackswitch:easing:
    $@debug << {"text":"Easing finished, running callback: $(callback_result)"}
    $$(callback_result)

# reset the callback
scoreboard players reset @s tbs.easing.callback_id