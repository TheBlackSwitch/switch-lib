execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
scoreboard players operation .result math = .a math
scoreboard players operation .result math /= .curr_approx math
scoreboard players operation .result math += .curr_approx math
scoreboard players operation .result math /= .2 temp
scoreboard players operation .curr_approx math = .result math
scoreboard players remove .loop temp 1
execute if score .loop temp matches 1.. run function theblackswitch:v2.0/patch-0/math/internal/sqrt/loop
