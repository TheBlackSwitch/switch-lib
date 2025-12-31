execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail

execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.show_debug] [{"text":"[Debug]: ","color":"yellow"},{"text":""}]

# support for the older ticking method: don't re-assign an ID
execute if entity @s[tag=tbs.has_id] run return fail

data modify storage theblackswitch:v2.0/patch-0/player_storage players append value {}

execute unless score #current tbs.ID matches 1.. run scoreboard players set #current tbs.ID 0
scoreboard players operation @s tbs.ID = #current tbs.ID
scoreboard players add #current tbs.ID 1
