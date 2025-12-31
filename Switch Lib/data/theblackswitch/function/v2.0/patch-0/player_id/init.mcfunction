execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail
execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail

scoreboard objectives add tbs.ID dummy

# convert from .current to #current fake player for older worlds
execute if score .current tbs.ID > #current tbs.ID run scoreboard players operation #current tbs.ID = .current tbs.ID

## Fix a bug for older player storages
execute store result score #entry_count temp if data storage theblackswitch:v2.0/patch-0/player_storage players[]
scoreboard players set #loop temp 100
execute if score #entry_count temp matches 1..99 run function theblackswitch:v2.0/patch-0/player_id/create_empty_player_root
