# This plugin handles the debug line generation
# to write a debug line, do: ``@debug >> <text_component>``

#-------------------------------------------------------
## Imports
#-------------------------------------------------------

from beet import Context, DataPack, Function,  FunctionTag, TagFile, ItemModifier, LootTable, JsonFile
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
        if not "aliases" in ctx.meta:
            raise Exception("No key \"aliases\" found in beet.meta!")
        
        for alias in ctx.meta["aliases"]:
            if not "regex" in alias:
                raise Exception(f"No key \"regex\" found in alias {alias}!")
            
            if not "replace" in alias:
                raise Exception(f"No key \"replace\" found in alias {alias}!")
            
            if "count" in alias:
                count = int(alias['count'])
            else:
                count = 0

            for name, file_data in ctx.data.all("*"):
                if isinstance(file_data, Function):

                    index = 0
                    for line in file_data.lines:
                        line = re.sub(alias['regex'], alias['replace'], line, count)
                        file_data.lines[index] = line                     
                        index+=1
                
                elif isinstance(file_data, JsonFile):
                    data = json.dumps(file_data.data)
                    data = re.sub(alias['regex'], alias['replace'], data, count)
                    file_data.data = json.loads(data)
                    
    except Exception as e:
        print(bcolors.FAIL + "An exceoption occured whilst trying to apply aliases")
        print("Exception: " + str(e) + bcolors.ENDC)
        exit()