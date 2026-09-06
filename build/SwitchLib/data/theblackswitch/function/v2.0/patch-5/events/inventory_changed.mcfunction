execute unless function theblackswitch:v2.0/patch-5/version_control/is_latest run return fail
tag @s add tbs.inventory_changed
schedule function theblackswitch:v2.0/patch-5/events/reset_inventory_changed 1 replace
