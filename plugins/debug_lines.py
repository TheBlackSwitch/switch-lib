# This plugin handles the debug line generation
# to write a debug line, do: ``@debug >> <text_component>``

#-------------------------------------------------------
## Imports
#-------------------------------------------------------

from beet import Context, DataPack, Function,  FunctionTag, TagFile, ItemModifier, LootTable
import json as json
import re

#-------------------------------------------------------
## Main Pipeline
#-------------------------------------------------------

# Runs during the build before mecha to support custom commands / modifiers
def beet_default(ctx: Context):
    for name, function in ctx.data.functions.items():
        curr_line = 0
        for line in function.lines:
            if '@debug >> ' in line:
                function.lines[curr_line] = line.replace("@debug >> ","execute if score #tbs-$version$.debug_enabled tbs.server_data matches 1 run tellraw @a[tag=tbs.debug] [{\"text\":\"[Debug]: \",\"color\":\"yellow\"},") + "]"
            curr_line+=1