execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
execute store result storage theblackswitch:temp player_storage.player_id int 1 run scoreboard players get @s tbs.ID
data modify storage theblackswitch:temp player_storage merge value {path: "tbs_current_overlay", result: "theblackswitch:v2.0/patch-0/temp overlay"}
function theblackswitch:v2.0/patch-0/player_storage/get with storage theblackswitch:temp player_storage
data remove storage theblackswitch:temp player_storage
execute unless data storage theblackswitch:temp overlay run return run item modify entity @s armor.head theblackswitch:v2.0/patch-0/overlay/reset_with_sound
execute if data storage theblackswitch:temp {overlay: {texture: "none", enable_sound: 1}} run return run item modify entity @s armor.head theblackswitch:v2.0/patch-0/overlay/reset_with_sound
execute if data storage theblackswitch:temp {overlay: {texture: "none", enable_sound: 0}} run return run item modify entity @s armor.head theblackswitch:v2.0/patch-0/overlay/reset_no_sound
execute if data storage theblackswitch:temp {overlay: {enable_sound: 1}} run return run function theblackswitch:v2.0/patch-0/overlay/internal/replace_with_sound with storage theblackswitch:v2.0/patch-0/temp overlay
execute if data storage theblackswitch:temp {overlay: {enable_sound: 0}} run function theblackswitch:v2.0/patch-0/overlay/internal/replace_no_sound with storage theblackswitch:v2.0/patch-0/temp overlay
