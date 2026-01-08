
# check if we're done
execute unless data storage theblackswitch:overlay post_insert[] run return 1

# append the first item remove it and try again
data modify storage theblackswitch:overlay data append from storage theblackswitch:overlay post_insert[0]
data remove storage theblackswitch:overlay post_insert[0]

function theblackswitch:overlay/apply_storage/concat_post_insert