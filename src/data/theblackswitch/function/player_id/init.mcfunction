
scoreboard objectives add tbs.ID dummy

# convert from .current to #current fake player form older worlds
execute if score .current tbs.ID > #current tbs.ID run scoreboard players operation #current tbs.ID = .current tbs.ID

## Fix a bug for older player storages
execute store result score #entry_count temp if data storage theblackswitch:player_storage players[]
scoreboard players set #loop temp 100
execute if score #entry_count temp matches 1..99 run function theblackswitch:player_id/create_empty_player_root