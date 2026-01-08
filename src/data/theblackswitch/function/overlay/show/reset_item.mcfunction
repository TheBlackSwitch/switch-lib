# reset any items that shouldn't have an overlay


#-------------------------------------------------------
## INVENTORY + HOTBAR
#-------------------------------------------------------


execute if items entity @s container.* *[minecraft:custom_data~{"tbs.overlay":{"applied":1b}}]:

    # summon a chest minecart so we can modify the item's data
    execute summon minecraft:chest_minecart:
        for i in range(36):
            execute if items entity @a[predicate=theblackswitch:player_id/match_search,limit=1] f"container.{i}" *[minecraft:custom_data~{"tbs.overlay":{"applied":1b}}]:
                item replace entity @s container.0 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] f"container.{i}"

                # Remove the equippable component if it wasn't present before applying the overlay
                execute if data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{equippable: "none"}}}}]:
                    data remove entity @s Items[{Slot:0b}].components."minecraft:equippable"

                # Swap the equippable component if there was one present before
                execute unless data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{"equippable":"none"}}}}]:
                    data modify entity @s Items[{Slot:0b}].components."minecraft:equippable" set from entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable

                data remove entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay"

                # move the modified item back to the player
                item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] f"container.{i}" from entity @s container.0

        # remove the minecart
        function theblackswitch:overlay/show/kill_minecart

#-------------------------------------------------------
## OFFHAND
#-------------------------------------------------------

execute if items entity @s weapon.offhand *[minecraft:custom_data~{"tbs.overlay":{"applied":1b}}]:
    execute summon minecraft:chest_minecart:
        item replace entity @s container.0 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] weapon.offhand

        # Remove the equippable component if it wasn't present before applying the overlay
        execute if data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{equippable: "none"}}}}]:
            data remove entity @s Items[{Slot:0b}].components."minecraft:equippable"

        # Swap the equippable component if there was one present before
        execute unless data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{"equippable":"none"}}}}]:
            data modify entity @s Items[{Slot:0b}].components."minecraft:equippable" set from entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable

        data remove entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay"

        # move the modified item back to the player
        item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] weapon.offhand from entity @s container.0
        function theblackswitch:overlay/show/kill_minecart

#-------------------------------------------------------
## PLAYER.CURSOR
#-------------------------------------------------------

execute if items entity @s player.cursor *[minecraft:custom_data~{"tbs.overlay":{"applied":1b}}]:
    execute summon minecraft:chest_minecart:
        item replace entity @s container.0 from entity @a[predicate=theblackswitch:player_id/match_search,limit=1] player.cursor

        # Remove the equippable component if it wasn't present before applying the overlay
        execute if data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{equippable: "none"}}}}]:
            data remove entity @s Items[{Slot:0b}].components."minecraft:equippable"

        # Swap the equippable component if there was one present before
        execute unless data entity @s Items[{Slot:0b,components:{"minecraft:custom_data":{"tbs.overlay":{"equippable":"none"}}}}]:
            data modify entity @s Items[{Slot:0b}].components."minecraft:equippable" set from entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay".equippable

        data remove entity @s Items[{Slot:0b}].components."minecraft:custom_data"."tbs.overlay"

        # move the modified item back to the player
        item replace entity @a[predicate=theblackswitch:player_id/match_search,limit=1] player.cursor from entity @s container.0
        function theblackswitch:overlay/show/kill_minecart