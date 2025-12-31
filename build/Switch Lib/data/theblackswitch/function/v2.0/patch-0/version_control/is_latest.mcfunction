execute unless function theblackswitch:v2.0/patch-0/version_control/is_latest run return fail
# check if this patch is the latest patch and return the result
return run execute if score #2.0 tbs.version_control matches 0
