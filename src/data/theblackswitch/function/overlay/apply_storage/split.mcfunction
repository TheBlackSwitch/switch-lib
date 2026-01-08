# if we don't have any data anymore, we're done
execute unless data storage theblackswitch:overlay post_insert[] run return 1

# get the priority of the current item
execute store result score #item_priority temp run data get storage theblackswitch:overlay post_insert[0].priority

# if the priority of the current item is lower or equal, we're done
execute if score #priority temp >= #item_priority temp run return 1

# move the current item to pre_insert and try again
data modify storage theblackswitch:overlay pre_insert append from storage theblackswitch:overlay post_insert[0]
data remove storage theblackswitch:overlay post_insert[0]

# try again
function theblackswitch:overlay/apply_storage/split 
