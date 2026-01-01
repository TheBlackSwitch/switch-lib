# This plugin handles the debug line generation
# to write a debug line, do: ``@debug >> <text_component>``

#-------------------------------------------------------
## Imports
#-------------------------------------------------------

from beet import Context
import json as json
import re

#-------------------------------------------------------
## Main Pipeline
#-------------------------------------------------------

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# Runs during the build before mecha to support custom commands / modifiers
def beet_default(ctx: Context):

    try:


        if not "debug_lines" in ctx.meta:
            raise Exception("No key \"debug_lines\" found in beet.meta!")
        
        if not "prefix" in ctx.meta['debug_lines']:
            raise Exception("No key \"prefix\" found in beet.meta.debug_lines!")
        
        if not "suffix" in ctx.meta['debug_lines']:
            raise Exception("No key \"suffix\" found in beet.meta.debug_lines!")
        
        prefix = ctx.meta['debug_lines']['prefix']
        suffix = ctx.meta['debug_lines']['suffix']

        for name, function in ctx.data.functions.items():
            curr_line = 0
            for line in function.lines:
                if re.search(r"@debug *<< *", line):
                    result = re.sub(r"@debug *<< *", prefix, line)
                    result += suffix
                    function.lines[curr_line] = result
                curr_line+=1


    except Exception as e:
        print(bcolors.FAIL + "An exceoption occured whilst trying to apply debug lines.")
        print("Exception: " + str(e) + bcolors.ENDC)
        exit()