function theblackswitch:v2.0/patch-0/overlay/show/init_update
function theblackswitch:v2.0/patch-0/clear_item/inventory_change
function #theblackswitch:v2.0/events/inventory_changed
advancement revoke @s only theblackswitch:v2.0/patch-0/events/inventory_changed
tag @s remove tbs.inventory_changed
