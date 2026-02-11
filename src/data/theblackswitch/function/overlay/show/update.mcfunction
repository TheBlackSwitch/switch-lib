## This function runs on inventory change or when any changes happen to the overlay

execute unless score #tbs-$version$.enabled.overlay tbs.server_data matches 1 run return fail # don't do anything when not enabled

# select this player to search for later
scoreboard players operation #search tbs.ID = @s tbs.ID

#-------------------------------------------------------
## Reset any equippable items that got modified
#-------------------------------------------------------

function theblackswitch:overlay/show/reset_item

#-------------------------------------------------------
## Get the data from the player's storage
#-------------------------------------------------------

# Reset the data for this player
data modify storage theblackswitch:overlay data set value []
data remove storage theblackswitch:overlay head
data remove storage theblackswitch:overlay chest
data remove storage theblackswitch:overlay legs
data remove storage theblackswitch:overlay feet
data remove storage theblackswitch:overlay equippable_reconstruct

# get the current data from the player storage
execute store result storage theblackswitch:overlay player_storage.player_id int 1 run scoreboard players get @s tbs.ID
data modify storage theblackswitch:overlay player_storage.path set value "theblackswitch.overlay"
data modify storage theblackswitch:overlay player_storage.result set value "theblackswitch:overlay data"
function theblackswitch:player_storage/get with storage theblackswitch:overlay player_storage
data remove storage theblackswitch:overlay player_storage

# grab the relevant data
data modify storage theblackswitch:overlay head set from storage theblackswitch:overlay data[0]
data modify storage theblackswitch:overlay chest set from storage theblackswitch:overlay data[1]
data modify storage theblackswitch:overlay legs set from storage theblackswitch:overlay data[2]
data modify storage theblackswitch:overlay feet set from storage theblackswitch:overlay data[3]

#-------------------------------------------------------
## Create items for empty slots
#-------------------------------------------------------

execute unless items entity @s armor.head * if data storage theblackswitch:overlay data[0] run item replace entity @s armor.head with minecraft:poisonous_potato[minecraft:item_model="minecraft:air",minecraft:custom_data={"tbs.clear_inventory":true,"tbs.clear_hotbar":true,"tbs.clear_when_dropped":true,"tbs.clear_misc":true},minecraft:equippable={"slot":"head","equip_sound":"minecraft:intentionally_empty"},!minecraft:food,minecraft:tooltip_display={"hide_tooltip":true}]

execute unless items entity @s armor.chest * if data storage theblackswitch:overlay data[1] run item replace entity @s armor.chest with minecraft:poisonous_potato[minecraft:item_model="minecraft:air",minecraft:custom_data={"tbs.clear_inventory":true,"tbs.clear_hotbar":true,"tbs.clear_when_dropped":true,"tbs.clear_misc":true},minecraft:equippable={"slot":"chest","equip_sound":"minecraft:intentionally_empty"},!minecraft:food,minecraft:tooltip_display={"hide_tooltip":true}]

execute unless items entity @s armor.legs * if data storage theblackswitch:overlay data[2] run item replace entity @s armor.legs with minecraft:poisonous_potato[minecraft:item_model="minecraft:air",minecraft:custom_data={"tbs.clear_inventory":true,"tbs.clear_hotbar":true,"tbs.clear_when_dropped":true,"tbs.clear_misc":true},minecraft:equippable={"slot":"legs","equip_sound":"minecraft:intentionally_empty"},!minecraft:food,minecraft:tooltip_display={"hide_tooltip":true}]

execute unless items entity @s armor.feet * if data storage theblackswitch:overlay data[3] run item replace entity @s armor.feet with minecraft:poisonous_potato[minecraft:item_model="minecraft:air",minecraft:custom_data={"tbs.clear_inventory":true,"tbs.clear_hotbar":true,"tbs.clear_when_dropped":true,"tbs.clear_misc":true},minecraft:equippable={"slot":"feet","equip_sound":"minecraft:intentionally_empty"},!minecraft:food,minecraft:tooltip_display={"hide_tooltip":true}]

#-------------------------------------------------------
## Apply the overlays
#-------------------------------------------------------

# summon a chest mincart and move the items in there so we can modify them
execute summon chest_minecart:

    # move the player's items to this chest minecart
    item replace entity @s container.0 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.head
    item replace entity @s container.1 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.chest
    item replace entity @s container.2 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.legs
    item replace entity @s container.3 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.feet

    ##-------HELMET-SLOT-------
    function theblackswitch:overlay/show/update/helmet

    ##-------CHEST-SLOT-------
    function theblackswitch:overlay/show/update/chest

    ##-------LEGS-SLOT-------
    function theblackswitch:overlay/show/update/legs

    ##-------FEET-SLOT-------
    function theblackswitch:overlay/show/update/feet
    

    # remove this minecart and it's items
    function theblackswitch:overlay/show/kill_minecart
