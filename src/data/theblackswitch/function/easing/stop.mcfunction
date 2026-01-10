#--------------------REQUIREMENTS-------------------------
# 1. Run as target entity to set the animation
#---------------------------------------------------------

execute if entity @s[tag=tbs.easing] run return:
    function theblackswitch:easing/run/reset
    @debug << [{"text":"Successfully stopped easing for entity: "},{"selector":"@s","color":"green","underlined":true}]

@debug << [{"text":"Easing already stopped for entity: "},{"selector":"@s","color":"green","underlined":true}]