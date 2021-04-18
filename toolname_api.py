#!/usr/bin/env python3
__doc__ = """

Title - One line blurb

Paragraph describing

Usage:
    ./projectmain.py arg1 [optionalarg2]

Parameters
    param1          Thing 1 (required). 6 chars starting with Thing
    param2          Thing 2 (optional)

Output:
    string_output   Thing 3.  6 chars starting with Thing

Examples:
    ./projectmain.py                    Will prompt for all arguments
    ./projectmain.py Thing1             Will prompt for 1 argument
    ./projectmain.py Thing1 Thing2      Will execute and return Thing 3
    ./projectmain.py help               Will output this help doc

"""
__author__ = "epopisces"
__date__ = "2020.12.06"
__version__ = 0.1

import argparse
# import toml # used to parse config file

#from tools.toolname import toolname_api as tool

class ObjectClass():
    """A quick description of the class

    Attributes:
        var1 (bool):          used for this thing
        var2 (str, optional): used for that thing
    """    

    def __init__(self, var1, var2=False):
        self.var1 = var1
        self.var2 = var2

        # maybe call another function here to help setup things

        return

    def this_func(self):
        # do the thing here
        return


if __name__ == "__main__":
    #? Remove this section if not accepting arguments from CLI
    #region  #####     Argparse                                                     #####
    #####################################################################################
    parser = argparse.ArgumentParser(description='short description of the module')
    parser.add_argument('-v','--var2', default=False, type=str, help='describe arg for when man or help is used')
    parser.add_argument('--var1', action='store_true', help='describe arg for when man or help is used')

    args = parser.parse_args()
    #endregion

    # Uncomment for testing setup   
    var1 = True
    oc = ObjectClass(var1, var2=args.var2)