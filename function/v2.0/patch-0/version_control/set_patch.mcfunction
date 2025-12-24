# Grab the patch number of this specific library instance and evaluate if this is the latest

execute store result score #curr_patch tbs.version_control run function theblackswitch:v2.0.0/get_curr_patch
function theblackswitch:v2.0.0/version_control/evaluate_version