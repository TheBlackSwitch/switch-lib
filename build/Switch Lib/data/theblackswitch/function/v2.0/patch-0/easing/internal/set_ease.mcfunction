execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
execute if data storage theblackswitch:temp {easing: {ease: "ease_in"}} run return run scoreboard players set @s tbs.easing.ease 1
execute if data storage theblackswitch:temp {easing: {ease: "ease_out"}} run return run scoreboard players set @s tbs.easing.ease 2
execute if data storage theblackswitch:temp {easing: {ease: "ease_in_out"}} run return run scoreboard players set @s tbs.easing.ease 3
scoreboard players set @s tbs.easing.ease 4
