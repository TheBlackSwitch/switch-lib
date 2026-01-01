execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
scoreboard players set .2 temp 2
scoreboard players operation .curr_approx math = .a math
scoreboard players operation .curr_approx math /= .2 temp
scoreboard players operation .loop temp = .precision math
execute if score .loop temp matches 1.. run function theblackswitch:v2.0/patch-0/math/internal/sqrt/loop
return run scoreboard players get .result math
