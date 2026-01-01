# This plugin handles automatic version resolution for the library depending on the version specified in the beet.json
# For the features I'll refer to the documentation: https://github.com/theblackswitch/switch-lib/wiki/plugin-version-resolution
# THIS SHOULD RUN BEFORE MECHA

#-------------------------------------------------------
## Imports
#-------------------------------------------------------

from beet import Context, DataPack, Function,  FunctionTag, TagFile, ItemModifier, LootTable
import json as json
import re

#-------------------------------------------------------
## Global Vars / Classes
#-------------------------------------------------------

version = {
    "major": 0,
    "minor": 0,
    "patch": 0
}

lib_namespace = ""

datapack_files = []

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

#-------------------------------------------------------
## Helper Functions
#-------------------------------------------------------

def clean_int(s: str):
    """Convert a string to an int ingoring any other characters"""

    r = ""
    for l in s:
        if l.isdigit():
            r+=l
    return int(r)

#-------------------------------------------------------

def read_version(v: str):
    """Convert a semantic version into a dict of numbers"""

    parts = v.split(".")
    result = {
        "major": clean_int(parts[0]),
        "minor": clean_int(parts[1]),
        "patch": clean_int(parts[2])
    }

    return result

#-------------------------------------------------------
## Main Pipeline
#-------------------------------------------------------

# Runs during the build before mecha to support custom commands / modifiers
def beet_default(ctx: Context):
    """The main pipeline. Run this before mecha to support custom commands / aliases"""
    global version
    global lib_namespace

    version = read_version(ctx.project_version)
    lib_namespace = ctx.project_id

    print(bcolors.OKCYAN + "Applying version resolution..." + bcolors.ENDC)

    find_files(ctx)
    function_version_check(ctx)
    resolve_refrences(ctx)
    resolve_aliases(ctx)
    move_files(ctx)

    print(bcolors.OKGREEN + "Version resolution applied successfully!" + bcolors.ENDC)
    print("")

#-------------------------------------------------------
## features
#-------------------------------------------------------


def find_files(ctx: Context):
    """List all files from the library's namespace with some basic information"""

    try:
        for file_type in ctx.data[lib_namespace].keys():
            for name, file in ctx.data[lib_namespace][file_type].items():

                should_resolve = True
                should_verify = True

                if file_type == Function:

                    # check if this function should be resolved
                    for i in file.lines: # type: ignore
                        if "@noresolve" in i:
                            file.lines.remove(i) # type: ignore
                            should_resolve = False
                            break

                    # check if this function should be version checked
                    for i in file.lines: # type: ignore
                        if "@noverify" in i:
                            file.lines.remove(i) # type: ignore
                            should_verify = False
                            break

                elif file.extension == ".json":

                    if "resolve" in file.data: # type: ignore
                        if not file.data["resolve"]: # type: ignore
                            should_resolve = False
                        del file.data["resolve"] # type: ignore
            
                datapack_files.append({
                    "type": file_type,
                    "name": name,
                    "file": file,
                    "resolve": should_resolve,
                    "verify": should_verify
                })
    except Exception as e:
        print(bcolors.FAIL + "An exception occured whilst searching for resolvable files!")
        print("Exception: " + str(e) + bcolors.ENDC)
        exit()

#-------------------------------------------------------

def function_version_check(ctx: Context):
    """Make sure each function only runs in the newest instance"""

    for file_data in datapack_files:
        if file_data['type'] == Function and file_data['verify']:
                
            try:
                if "version_resolution" in ctx.meta and "function_version_check" in ctx.meta["version_resolution"]:
                    resolve_version = ctx.meta["version_resolution"]["function_version_check"]
                else:
                    raise Exception("Missing field meta.version_resolution.function_version_check in beet.json or beet.yaml")

                i = 0
                vers_check = False
                resolve_occurances = 0

                for l in file_data['file'].lines:
                    if "@verify" in l:
                        resolve_occurances += 1
                        # replace the first @verify with the version check command
                        if not vers_check:
                            file_data['file'].lines[i] = resolve_version
                            vers_check = True
                    i+=1
                
                # throw an error when there are multiple @verify aliases found
                if resolve_occurances > 1:
                    raise Exception(f"No more than one occurance of @verify may be present, found {resolve_occurances}")
                
                if not vers_check:
                    file_data['file'].lines.insert(0, resolve_version)
                
            except Exception as e:
                print(bcolors.FAIL + f"An exception occured whilst applying version check to function:{bcolors.WARNING} {lib_namespace}:{file_data['name']}!" + bcolors.ENDC)
                print(bcolors.FAIL + "Exception: " + str(e) + bcolors.ENDC)
                exit()

#-------------------------------------------------------

def resolve_aliases(ctx: Context):
    """
    Replace any $version$, $patch$ $patch-nbr$ with the current version
    Also remove any $@$ used whilst resolving versions
    """


    for file_data in datapack_files:
        
        try:
            if file_data['type'] == Function:
                for i in range(len(file_data['file'].lines)):
                    file_data['file'].lines[i] = file_data['file'].lines[i].replace("$version$", f"v{version['major']}.{version['minor']}")
                    file_data['file'].lines[i] = file_data['file'].lines[i].replace("$patch$", f"patch-{version['patch']}")
                    file_data['file'].lines[i] = file_data['file'].lines[i].replace("$patch-nbr$", str(version['patch']))
                    file_data['file'].lines[i] = file_data['file'].lines[i].replace("$@$", "")

            elif file_data['file'].extension == ".json":
                cont = json.dumps(file_data['file'].get_content())
                cont = cont.replace("$version$", f"v{version['major']}.{version['minor']}")
                cont = cont.replace("$patch-nbr$", str(version['patch']))
                cont = cont.replace("$patch$", f"patch-{version['patch']}")
                cont = cont.replace("$@$", "")
                file_data['file'].set_content(json.loads(cont))

        except Exception as e:
            print(bcolors.FAIL + f"An exception occured whilst replacing version aliases in {file_data['file'].snake_name} file:{bcolors.WARNING} {lib_namespace}:{file_data['name']}!" + bcolors.ENDC)
            print(bcolors.FAIL + "Exception: " + str(e) + bcolors.ENDC)
            exit()

#-------------------------------------------------------

def check_resolve_refrence(path: str, filna: str, check_file_type=False, file_type=None):
    """Check if a refrence should be resolved by looking at the resolved state of the targetted file"""
    for f in datapack_files:
        if f['name'] == path:
            if check_file_type:
                if f['type'] == file_type and not f['resolve']:
                    print(bcolors.WARNING + f"INFO | version_resolution: {f['file'].snake_name} file {lib_namespace}:{f['name']} shouldn't be resolved, ignoring refrence: {lib_namespace}:{path} in file {filna}")
                    return False
                
            elif not f['resolve']:
                print(bcolors.WARNING + f"INFO | version_resolution: {f['file'].snake_name} file {lib_namespace}:{f['name']} shouldn't be resolved, ignoring refrence: {lib_namespace}:{path} in file {filna}")
                return False
    return True

def resolve_single_refrence(path: str, filena: str, is_tag: bool, check_file_type=False, file_type=None):
    """Add the version resolution to the path if the file should be resolved"""
    # resolve the file when needed
    if check_resolve_refrence(path, filena, check_file_type=check_file_type, file_type=file_type):
        if is_tag:
            # the refrence is a tag so we shouldn't include the patch
            # add $@$ to tell the resolved refrences appart from the non resolved ones
            return f"#{lib_namespace}$@$:v{version['major']}.{version['minor']}/{path}"
        else:
            # add @ to tell the resolved refrences appart from the non resolved ones
            return f"{lib_namespace}$@$:v{version['major']}.{version['minor']}/patch-{version['patch']}/{path}"

    return f"{lib_namespace}$@$:{path}"

def resolve_with_regex(regex: str, data: str, filena: str, check_file_type=False, file_type=None):
    """
    Use a regex to search for refrences that may need to be resolved\n
    The regex should have 3 capture groups:\n
    1. everything before the acutal refrence\n
    2. the namespace of the refrence (including the # if it's a tag)\n
    3. the path to the refrence
    """
    result = data
    matches = re.findall(regex, result)
    for m in matches:
        
        source = f"{m[0]}{m[1]}:{m[2]}"

        if m[1][0] == "#":
            resolved = resolve_single_refrence(m[2], filena, is_tag=True, check_file_type=check_file_type, file_type=file_type)
        else:
            resolved = resolve_single_refrence(m[2], filena, is_tag=False, check_file_type=check_file_type, file_type=file_type)
        

        result = result.replace(source, f"{m[0]}{resolved}")
    return result        

def resolve_refrences(ctx: Context):
    """Add the versioned folder to any refrences that should be resolved"""
    for file_data in datapack_files:
        try:
            # handle function tags
            if file_data['type'] == FunctionTag and 'values' in file_data['file'].data:
                i = 0
                for value in file_data['file'].data['values']:
                    # The tag contains normal string values
                    if isinstance(value, str):

                        if not ":" in value:
                            raise Exception(f"No namespace was found in value: {value}")
                            
                        if not "$@$" in value:
                            # first check for other function tag refrences (they shouldn't have the patch in their path)
                            namespace = value.split(":")[0]
                            path = value.split(":")[1]

                            if namespace == f"#{lib_namespace}":
                                
                                file_data['file'].data['values'][i] = resolve_single_refrence(path, file_data['name'], is_tag=True, check_file_type=True, file_type=FunctionTag)

                            # other normal function refrences should contain the patch in their name
                            elif namespace == lib_namespace:
                                file_data['file'].data['values'][i] = resolve_single_refrence(path, file_data['name'], is_tag=True, check_file_type=True, file_type=Function)
                                
                    # Json style refrences in the tag {"id":"value","required":true|false}
                    elif not "$@$" in value['id']:
                        if not ":" in value['id']:
                            raise Exception(f"No namespace was found in value: {value}")
                        
                        namespace = value['id'].split(":")[0]
                        path = value['id'].split(":")[1]

                        # first check for other function tag refrences (they shouldn't have the patch in their path)
                        if 'id' in value and namespace == f"#{lib_namespace}":
                            file_data['file'].data['values'][i]['id'] = resolve_single_refrence(value['id'].split(":")[1], file_data['name'], is_tag=True, check_file_type=True, file_type=FunctionTag)

                        # other normal function refrences should contain the patch in their name
                        elif 'id' in value and namespace == f"{lib_namespace}":
                            file_data['file'].data['values'][i]['id'] = resolve_single_refrence(value['id'].split(":")[1], file_data['name'], is_tag=False, check_file_type=True, file_type=Function)
                    i+=1                

            
            elif file_data['type'] == Function:
                i = 0
                for l in file_data['file'].lines:
                    result = l

                    # Handle the function command in functions
                    result = resolve_with_regex(fr"(function |clear )({lib_namespace}):([^\s]*)", result, file_data['name'], check_file_type=True, file_type=Function)
                    result = resolve_with_regex(fr"(function |clear )(#{lib_namespace}):([^\s]*)", result, file_data['name'], check_file_type=True, file_type=FunctionTag)

                    # make sure to ignore storages
                    result = re.sub(rf"(\"?storage\"?:? *?\"?)(theblackswitch):([^\s\"]*\"?)", rf"\g<1>\g<2>$@$:\g<3>", result)

                    # ignore set value
                    result = re.sub(rf"(\"?value\"? *?\"?)({lib_namespace}):([^\s\"]*\"?)", rf"\g<1>\g<2>$@$:\g<3>", result)

                    # handle other refrence types
                    result = resolve_with_regex(fr"()({lib_namespace}):([^\s\"]+)", result, file_data['name'])

                    file_data['file'].lines[i] = result
                    i+=1

            # handle json files
            elif file_data['type'].extension == ".json":
                cont = json.dumps(file_data['file'].get_content())

                # the function command
                cont = resolve_with_regex(fr"(function |clear )({lib_namespace}):([^\s]*)", cont, file_data['name'], check_file_type=True, file_type=Function)
                cont = resolve_with_regex(fr"(function |clear )(#{lib_namespace}):([^\s]*)", cont, file_data['name'], check_file_type=True, file_type=FunctionTag)

                # resolve other function refrences
                cont = resolve_with_regex(fr"(\"?function\"?: *?\")({lib_namespace}):([^\"\s]*)", cont, file_data['name'], check_file_type=True, file_type=Function)
                cont = resolve_with_regex(fr"(\"?function\"?: *?\")(#{lib_namespace}):([^\"\s]*)", cont, file_data['name'], check_file_type=True, file_type=FunctionTag)
                
                # resolve all refrences to other files (like advancements)
                #cont = resolve_with_regex(r"()([^\s\"@]+?):([^\s\"]+)", cont, file_data['name'])
                
                file_data['file'].set_content(json.loads(cont))
                
                
        except Exception as e:
            print(bcolors.FAIL + f"An exception occured whilst resolving refrences in {file_data['file'].scope} file:{bcolors.WARNING} {lib_namespace}:{file_data['name']}!" + bcolors.ENDC)
            print(bcolors.FAIL + "Exception: " + str(e) + bcolors.ENDC)
            exit()

#-------------------------------------------------------

def move_files(ctx: Context):
    """Move normal files into a versioned folder"""

    for file_data in datapack_files:
        try:
            if file_data['resolve']:

                if isinstance(file_data['file'], TagFile):
                    new_name = f"v{version['major']}.{version['minor']}/" + file_data['name']
                else:
                    new_name = f"v{version['major']}.{version['minor']}/patch-{version['patch']}/" + file_data['name']

                ctx.data[lib_namespace][file_data['type']][new_name] = file_data['file']
                del ctx.data[lib_namespace][file_data['type']][file_data['name']]
        except Exception as e:
            print(bcolors.FAIL + f"An exception occured whilst resolving path for file:{bcolors.WARNING} {lib_namespace}:{file_data['name']}!" + bcolors.ENDC)
            print(bcolors.FAIL + "Exception: " + str(e) + bcolors.ENDC)
            exit()

