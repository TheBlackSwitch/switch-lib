execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
execute store result storage theblackswitch:temp player_storage.player_id int 1 run scoreboard players get @s tbs.ID
tag @s add tbs.used_overlay
$data modify storage theblackswitch:temp player_storage.value set value {texture:"$(overlay)",enable_sound:$(do_sound)}
data modify storage theblackswitch:temp player_storage merge value {path: "tbs_current_overlay", source: "storage theblackswitch:v2.0/patch-0/temp player_storage.value"}
function theblackswitch:v2.0/patch-0/player_storage/set_from with storage theblackswitch:temp player_storage
data remove storage theblackswitch:temp player_storage
function theblackswitch:v2.0/patch-0/overlay/internal/run
