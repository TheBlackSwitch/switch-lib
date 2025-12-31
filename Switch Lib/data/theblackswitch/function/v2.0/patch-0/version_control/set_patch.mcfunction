execute unless function theblackswitch:v2.0/patch-0/v2.0/patch-0/version_control/is_latest run return fail
# Increase the patch number if it is lower than this library instance's patch number
execute unless score #2.0 tbs.version_control matches 1.. run scoreboard players set #2.0 tbs.version_control 0
