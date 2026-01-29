item replace entity @s container.0 from entity @a[predicate=theblackswitch:v2.0/patch-1/player_id/match_search, limit=1] armor.head
item replace entity @s container.1 from entity @a[predicate=theblackswitch:v2.0/patch-1/player_id/match_search, limit=1] armor.chest
item replace entity @s container.2 from entity @a[predicate=theblackswitch:v2.0/patch-1/player_id/match_search, limit=1] armor.legs
item replace entity @s container.3 from entity @a[predicate=theblackswitch:v2.0/patch-1/player_id/match_search, limit=1] armor.feet
execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] ["", {text: "[Debug]: ", color: "yellow", bold: true}, {text: "HELMET!"}]
function theblackswitch:v2.0/patch-1/overlay/show/update/helmet
execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] ["", {text: "[Debug]: ", color: "yellow", bold: true}, {text: "CHEST!"}]
function theblackswitch:v2.0/patch-1/overlay/show/update/chest
execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] ["", {text: "[Debug]: ", color: "yellow", bold: true}, {text: "LEGS!"}]
function theblackswitch:v2.0/patch-1/overlay/show/update/legs
execute if score #tbs-v2.0.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] ["", {text: "[Debug]: ", color: "yellow", bold: true}, {text: "FEET!"}]
function theblackswitch:v2.0/patch-1/overlay/show/update/feet
function theblackswitch:v2.0/patch-1/overlay/show/kill_minecart
