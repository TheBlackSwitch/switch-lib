

# Store the version that should be checked against
$scoreboard players set #check-major temp $(major)
$scoreboard players set #check-minor temp $(minor)
$scoreboard players set #check-patch temp $(patch)
$scoreboard players set #check-suffix temp $(suffix)

# Create a loopable safe copy from the history array
$data modify storage theblackswitch:temp theblackswitch.loaded.array set from storage theblackswitch:loaded $(pack_id).history

return run function theblackswitch:loaded/check_if_older/loop