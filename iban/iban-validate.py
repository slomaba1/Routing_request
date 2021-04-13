#!/usr/bin/env python3
import sys
import re
import string
from functools import partial

from pycountry import countries

from schwifty import common
from schwifty import iban
from schwifty import exceptions
from schwifty import registry
from schwifty.bic import BIC

command_line = ' '.join(sys.argv[1:])

#print (command_line)

#iban = IBAN('GB94BARC10201530093459').is_valid
#print (iban)

try:
    IBAN(command_line).is_valid
except:
    print ('False')
    quit(0)
else:
    print ('True')
    quit(1)

