
#--------------------REQUIREMENTS-------------------------
# 1. Set the score: .a math to the sqrt input value
# 2. Set the score: .precision math to a value from 1 to infinity
# 3. Returns the result
#    and sets the score .result math
#---------------------------------------------------------

#-----------------------EXAMPLE---------------------------
# scoreboard players set .a math 25
# function theblackswitch:math/sqrt ==> returns: 5000
#---------------------------------------------------------


#-------------------------------------------------------
## Process the arguments
#-------------------------------------------------------

execute unless score #a tbs.math matches 0.. run return:
    return fail
    @debug << {"text":"Failed to calculate. The sqrt for negative values is undefined!"}

execute unless score #precision tbs.math matches 1.. run return:
    return fail
    @debug << {"text":"Failed to calculate sqrt. Invalid precision!"}

execute if score #a tbs.math matches 0 run return 0

#-------------------------------------------------------
## Init the calculation
#-------------------------------------------------------
# Newtonian formulla: sqrt(a): x = (x + a / x) / 2 repeat .precision math times

# Start with a value of a/2
scoreboard players set #2 temp 2
scoreboard players operation #curr_approx tbs.math = #a tbs.math
scoreboard players operation #curr_approx tbs.math /= #2 temp

# Set the loop count to the precision
scoreboard players operation #loop temp = #precision tbs.math

# start the loop
execute if score #loop temp matches 1.. run function theblackswitch:math/sqrt/loop

#-------------------------------------------------------
## Reset the args
#-------------------------------------------------------

schedule function theblackswitch:math/sqrt/clear_args 1t replace

#-------------------------------------------------------
## Return the result
#-------------------------------------------------------

return run scoreboard players get #result tbs.math
