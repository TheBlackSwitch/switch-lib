
# Don't generate an ID if this player already has one (compat with prev version)
execute if entity @s[tag=tbs.has_id] run return fail

# Don't generate an ID when the player already has one (version change compat)
execute unless score @s tbs.ID matches 0.. run return fail

# some stuff for the player storage
data modify storage theblackswitch:player_storage players append value {}

# assign an id to this player
execute unless score #current tbs.ID matches 1.. run scoreboard players set #current tbs.ID 0
scoreboard players operation @s tbs.ID = #current tbs.ID


@debug << [{text:"Assigned player ID "},{score:{objective:"tbs.ID",name:"#current"}},{text:" to player "},{selector:"@s",color:"yellow"}]

scoreboard players add #current tbs.ID 1