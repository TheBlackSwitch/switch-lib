execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
execute unless data storage theblackswitch:overlay post_insert[] run return 1
data modify storage theblackswitch:overlay data append from storage theblackswitch:overlay post_insert[0]
data remove storage theblackswitch:overlay post_insert[0]
function theblackswitch:v2.0/patch-0/overlay/apply_storage/concat_post_insert
