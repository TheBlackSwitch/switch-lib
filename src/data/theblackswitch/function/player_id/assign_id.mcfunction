
# Don't generate an ID if this player already has one
execute if entity @s[tag=tbs.has_id] run return fail

# some stuff for the player storage
data modify storage theblackswitch:player_storage players append value {}

# assign an id to this player
execute unless score #current tbs.ID matches 1.. run scoreboard players set #current tbs.ID 0
scoreboard players operation @s tbs.ID = #current tbs.ID

# Mark this player as done
tag @s add tbs.has_id

@debug << [{text:"Assigned player ID "},{score:{objective:"tbs.ID",name:"#current"}},{text:" to player "},{selector:"@s",color:"yellow"}]

scoreboard players add #current tbs.ID 1