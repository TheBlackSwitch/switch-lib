@noverify

# Increase the patch number if it is lower than this library instance's patch number
execute unless score #$version$ tbs.version_control matches ($patch-nbr$ + 1, None) run scoreboard players set #$version$ tbs.version_control $patch-nbr$