execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail

function theblackswitch:v2.0/patch-0/slow_tick/tick
#function theblackswitch:v2.0/patch-0/overlay/internal/tick
#function theblackswitch:v2.0/patch-0/easing/internal/tick

## Kill dropped items with tbs.clear_when_dropped true
#execute at @a as @e[type=item,distance=..20,tag=!no_clear] if items entity @s container.0 *[custom_data~{"tbs.clear_when_dropped":true}] run kill @s
#execute at @a as @e[type=item,distance=..20,tag=!no_clear] run tag @s add no_clear

schedule function theblackswitch:v2.0/patch-0//tick 1t
