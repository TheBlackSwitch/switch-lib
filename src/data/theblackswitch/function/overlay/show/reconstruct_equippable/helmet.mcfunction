## Try to reconstruct as much data from the equippable component as possbile


# Use the equippable component incase it's already present
execute if data entity @s Items[{Slot:0b}].components."minecraft:equippable" run return run data modify storage theblackswitch:overlay equippable_reconstruct set from entity @s Items[{Slot:0b}].components."minecraft:equippable"

# Else check for vanilla minecraft items
execute if items entity @s container.0 minecraft:leather_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:diamond","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 #theblackswitch:copper_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:copper","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:chainmail_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:chainmail","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:iron_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:iron","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:golden_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:gold","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:turtle_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:turtle","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:diamond_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:diamond","equip_sound":"minecraft:intentionally_empty"}
execute if items entity @s container.0 minecraft:netherite_helmet run return run data modify storage theblackswitch:overlay equippable_reconstruct set value {"slot":"head","asset_id":"minecraft:netherite","equip_sound":"minecraft:intentionally_empty"}

# If that doesn't work, set the slot to head and try to create the asset id from the name by removing the _helmet at the end
data merge storage theblackswitch:overlay {equippable_reconstruct:{"slot":"head","equip_sound":"minecraft:intentionally_empty"}}

data modify storage theblackswitch:overlay equippable_reconstruct.asset_id set string entity @s Items[{Slot:0b}].id 0 -7