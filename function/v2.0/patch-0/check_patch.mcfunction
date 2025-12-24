# check if this patch is the latest patch and return the result

execute store result score #curr_patch tbs.version_control run function theblackswitch:v2.0.0/get_curr_patch
return run execute if score #curr_patch tbs.version_control = #v2.0 tbs.version_control