
#-------------------------------------------------------
## Reset the slot if no overlay should be set
#-------------------------------------------------------

execute unless data storage theblackswitch:overlay data[0] run return:
    execute unless items entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.head *[minecraft:custom_data~{"tbs.overlay":{"applied":1b}}] run return fail   

    execute if data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.clear_inventory":true}}}] run return:
        item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.head with air
        function theblackswitch:overlay/show/kill_minecart

    # Remove the equippable component if it wasn't present before applying the overlay
    execute if data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{equippable: "none"}}}}]:
        data remove entity @s Items[{Slot:0b}].components."minecraft:equippable"

    # Swap the equippable component if there was one present before
    execute unless data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{"equippable":"none"}}}}]:
        data modify entity @s Items[{Slot:0b}].components."minecraft:equippable" set from entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable

    data remove entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay"

    # move the modified item back to the player
    item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.head from entity @s container.0

    # remove the minecart
    function theblackswitch:overlay/show/kill_minecart

#-------------------------------------------------------
## Update the slot with the overlay
#-------------------------------------------------------

# first detect if the overlay has changed
data modify storage theblackswitch:overlay version.id set from storage theblackswitch:overlay data[0].id
data modify storage theblackswitch:overlay version.number set from storage theblackswitch:overlay data[0].version

data remove storage theblackswitch:overlay check
data modify storage theblackswitch:overlay check set from entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".version

execute store success score #should_modify temp run data modify storage theblackswitch:overlay check set from storage theblackswitch:overlay version

if score #should_modify temp matches 1:
    # Try to re-construct the equippable component from the unmodified item
    function theblackswitch:overlay/show/reconstruct_equippable/helmet

    # copy the normal equippable component to the item if it doesn't aready exist
    execute unless data entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable:
        execute unless data entity @s Items[{Slot:0b}].components."minecraft:equippable" run data modify entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable set value "none"    
        execute if data entity @s Items[{Slot:0b}].components."minecraft:equippable" run data modify entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable set from entity @s Items[{Slot:0b}].components."minecraft:equippable"
        
    # finally modify the item
    data modify entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".applied set value true # mark this item as modified by the overlay
    data modify entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".version.id set from storage theblackswitch:overlay data[0].id
    data modify entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".version.number set from storage theblackswitch:overlay data[0].version

    data modify storage theblackswitch:overlay equippable_reconstruct.camera_overlay set from storage theblackswitch:overlay data[0].texture
    data modify entity @s Items[{Slot:0b}].components."minecraft:equippable" set from storage theblackswitch:overlay equippable_reconstruct
    
    # apply this version data
    item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] armor.head from entity @s container.0