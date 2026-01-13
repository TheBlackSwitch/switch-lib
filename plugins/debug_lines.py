# This plugin handles the debug line generation
# to write a debug line, do: ``@debug >> <text_component>``

#-------------------------------------------------------
## Imports
#-------------------------------------------------------

from beet import Context
import json as json
import re
from beet.contrib.find_replace import find_replace

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

    """try:"""
    if True:

        if not "debug_lines" in ctx.meta:
            raise Exception("No key \"debug_lines\" found in beet.meta!")
        
        if not "prefix" in ctx.meta['debug_lines']:
            raise Exception("No key \"prefix\" found in beet.meta.debug_lines!")
        
        if not "suffix" in ctx.meta['debug_lines']:
            raise Exception("No key \"suffix\" found in beet.meta.debug_lines!")
        
        prefix = ctx.meta['debug_lines']['prefix']
        suffix = ctx.meta['debug_lines']['suffix']

        ctx.require(find_replace(data_pack={"match":"*"}, substitute={"find": r"@debug << ([\[\{].*[\}\]])", "replace": fr"{prefix}\g<1>{suffix}"}))
        ctx.require(find_replace(data_pack={"match":"*"}, substitute={"find": r"([^n]) run execute", "replace": r"\g<1>"}))


    """except Exception as e:
        print(bcolors.FAIL + "An exception occured whilst trying to apply debug lines.")
        print("Exception: " + str(e) + bcolors.ENDC)
        exit()"""

"""
# loop through each line of each function file
        for name, function in ctx.data.functions.items():
            curr_line = 0
            for line in function.lines:

                result = line

                # replace debug aliases
                if re.search(r"@debug *<< *", line):
                    result = re.sub(r"@debug *<< *", prefix, line)
                    result += suffix

                # fix 'run execute' sometimes appearing
                result = re.sub(r"([^n]) run execute", r"\\g<1>", result)

                # apply the changes
                function.lines[curr_line] = result
                curr_line+=1
"""