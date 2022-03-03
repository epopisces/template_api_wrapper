# testing code is a good idea!
#import os #? for os.getenv('ENVNAME')

import toolname_api as shortname

#region #####=-   Configure Tests                                            -=###########
def test_case_1(shortname):
    shortname.function('test param')
    return

#endregion

shortname = shortname.ObjectClass()

shortname

#region #####=-   Execute Tests                                                -=#########
test_case_1(shortname)

#endregion