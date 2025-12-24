# we want to know the latest patch of the library that is installed so increase the #v2.0.patch if our patch number
# is higher than the current one

execute unless score #curr_patch tbs.version_control <= #v2.0.patch tbs.version_control run scoreboard players operation #v2.0.patch tbs.version_control = #curr_patch