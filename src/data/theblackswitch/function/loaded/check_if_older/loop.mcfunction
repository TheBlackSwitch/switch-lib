# Loop through all version history and check if there is an older version than the target present

# Abort when the array is empty
execute unless data storage theblackswitch:temp theblackswitch.loaded.array[] run return fail


# Get the current history item
data modify storage theblackswitch:temp theblackswitch.loaded.curr_item set from storage theblackswitch:temp theblackswitch.loaded.array[0]
data remove storage theblackswitch:temp theblackswitch.loaded.array[0]

# Store the version in a scoreboard
execute store result score #major temp run data get storage theblackswitch:temp theblackswitch.loaded.curr_item.major
execute store result score #minor temp run data get storage theblackswitch:temp theblackswitch.loaded.curr_item.minor
execute store result score #patch temp run data get storage theblackswitch:temp theblackswitch.loaded.curr_item.patch
execute store result score #suffix temp run data get storage theblackswitch:temp theblackswitch.loaded.curr_item.suffix

@debug << [{"text":"Checking version history: ","color":"yellow"},{"storage":"theblackswitch:temp","nbt":"theblackswitch.loaded.curr_item","color":"white"}]

# Check if the version is older than the target
execute if function theblackswitch:loaded/check_if_older/is_older run return 1

# Otherwise just try again
return run function theblackswitch:loaded/check_if_older/loop