
# internal event users
execute as @a[tag=tbs.inventory_changed] at @s:
    function theblackswitch:overlay/show/init_update
    function theblackswitch:clear_item/inventory_change

    function #theblackswitch:events/inventory_changed

    advancement revoke @s only theblackswitch:events/inventory_changed
    tag @s remove tbs.inventory_changed