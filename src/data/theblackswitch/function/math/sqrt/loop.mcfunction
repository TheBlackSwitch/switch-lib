
# Newtonian formulla: sqrt(a): x = (x + a / x) / 2 repeat .precision tbs.math times
# X in this case is the current approximation


# a / x
scoreboard players operation #result tbs.math = #a tbs.math
scoreboard players operation #result tbs.math /= #curr_approx tbs.math

# (a/x + x) / 2
scoreboard players operation #result tbs.math += #curr_approx tbs.math
scoreboard players operation #result tbs.math /= #2 temp
scoreboard players operation #curr_approx tbs.math = #result tbs.math

# Re-run the loop if needed
scoreboard players remove #loop temp 1
execute if score #loop temp matches 1.. run function theblackswitch:math/sqrt/loop



