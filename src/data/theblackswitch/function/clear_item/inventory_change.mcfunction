
execute unless score #tbs-$version$.enabled.clear_item tbs.server_data matches 1 run return fail

# Clear items in any slot
clear @s *[custom_data~{"tbs.always_clear":true}]

# Clear inventory slots only
execute if items entity @s inventory.* *[custom_data~{"tbs.clear_inventory":true}]:
    for i in range(27):
        execute if items entity @s f"inventory.{i}" *[custom_data~{"tbs.clear_inventory":true}] run item replace entity @s f"inventory.{i}" with minecraft:air

# Clear items in hotbar
execute if items entity @s hotbar.* *[custom_data~{"tbs.clear_hotbar":true}]:
    for i in range(9):
        execute if items entity @s f"hotbar.{i}" *[custom_data~{"tbs.clear_hotbar":true}] run item replace entity @s f"hotbar.{i}" with minecraft:air
execute if items entity @s weapon.offhand *[custom_data~{"tbs.clear_hotbar":true}] run item replace entity @s weapon.offhand with minecraft:air

# Clear armor items
execute if items entity @s armor.head *[custom_data~{"tbs.clear_armor":true}] run item replace entity @s armor.head with minecraft:air
execute if items entity @s armor.chest *[custom_data~{"tbs.clear_armor":true}] run item replace entity @s armor.chest with minecraft:air
execute if items entity @s armor.legs *[custom_data~{"tbs.clear_armor":true}] run item replace entity @s armor.legs with minecraft:air
execute if items entity @s armor.feet *[custom_data~{"tbs.clear_armor":true}] run item replace entity @s armor.feet with minecraft:air

# Clear misc slots
execute if items entity @s player.cursor *[custom_data~{"tbs.clear_misc":true}] run item replace entity @s player.cursor with minecraft:air
    
for i in range(4):
    execute if items entity @s f'player.crafting.{i}' *[custom_data~{"tbs.clear_misc":true}] run item replace entity @s f'player.crafting.{i}' with minecraft:air

execute if items entity @s saddle *[custom_data~{"tbs.clear_misc":true}] run item replace entity @s saddle with minecraft:air
execute if items entity @s armor.body *[custom_data~{"tbs.clear_misc":true}] run item replace entity @s armor.body with minecraft:air

