#!/bin/bash
cd ~
source env/bin/activate
if [ x"$VIRTUAL_ENV" != x"" ]; then
	~/RR/iban/iban-validate.working.py $@
	deactivate 2> /dev/null
else
	echo "Error no virtual environment set"
	exit 99
fi
exit 0
