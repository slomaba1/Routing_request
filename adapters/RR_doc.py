#!/usr/bin/env python3

import argparse

parser = argparse.ArgumentParser(
    description='Simple documentation for STD in a nuttshell',
    epilog='Any suggestions? send email to bartosz.sloma@posti.com')
parser.add_argument('message', help='Any text of your choosing')

# scope
parser.add_argument('-s', '--scope',
    dest='scope',
    action='store_true',
    default='False',
    help='scope')

# filters
parser.add_argument('-f', '--filters',
    dest='filters',
    action='store_true',
    default='False',
    help='filters')



args = parser.parse_args()

print(args)
print(args.message)

if args.scope == True:
    print('''
Requirements:
- Autonomous. Should be able to run and handle tickets on it.s own. 
- Fast response to new tickets. Should be able to detect and handle new cases within few minutes max. 
- Should be able to check whether the company info in YTJ, like already done in reseller-validation tasks. 
- Able to insert or update iAddress-routing based on the values given in ticket. 
- Able to move tickets to manual handling with work notes based on certain rules.

Situations when ticket must be moved to manual handling: 
Existing active OC-routing found
Request-description is not empty 
OVT does not start with 0037
OVT shorter than 12 digits
OVT longer than 12 digits
OVT is one of LMC-ids (there.s a list of these)
E-address is one of LMC-ids (same list as above)
E-address is shorter than 12 digits
E-address is longer than 18 digits
E-address does not start with either 0037, TE0037, or FI
LMC/operator selected is not on the list of approved LMCs (there.s another list)
Company name doesn't match with VAT-code in YTJ
E-address starts with FI, is 18 digits long, but doesn't pass the iban-validation (not sure how to do this, current solution is not viable)


''')

if args.filters == True:
    print('''
---      FILTERS      ---
Lotta taking cases from
https://meseflow.service-now.com/nav_to.do?uri=%2Ftask_list.do%3Fsysparm_query%3Dactive%3Dtrue%5Eassignment_group%3De6407b040f3a0700f3ecf68ce1050edc%5Eassigned_toISEMPTY%5EstateNOT%20IN3,4,7,10,8,6%5Eref_sc_req_item.cat_item%3D5104756b55f63000b6624d5691b14b7a%5EORref_sc_req_item.cat_item%3D2ec3f1213792e7002a098d2754990e56%5Esys_mod_count<4%26sysparm_first_row%3D1%26sysparm_view%3D

Short descriptions start either .Request for new B2B e-invoice routing to iAddress.. or .Uusi iAddress B2B verkkolaskureitityspyynto.. if customer.s language-selection in portal is Finnish, but the item is the same either way.




examples:
PMTASK: https://meseflow.service-now.com/sc_task.do?sys_id=1df2e8371b2da410a805b166464bcb42&sysparm_record_target=sc_task&sysparm_record_row=1&sysparm_record_rows=1&sysparm_record_list=request_item%3D58f264371b2da410a805b166464bcbff%5EORDERBYnumber

PMRITM: https://meseflow.service-now.com/sc_req_item.do?sys_id=58f264371b2da410a805b166464bcbff&sysparm_view=&sysparm_domain=null&sysparm_domain_scope=null&sysparm_record_row=1&sysparm_record_rows=4&sysparm_record_list=active%3dtrue%5eassignment_group%3de6407b040f3a0700f3ecf68ce1050edc%5eassigned_toISEMPTY%5estateNOT+IN3%2c4%2c7%2c10%2c8%2c6%5eref_sc_req_item.cat_item%3d5104756b55f63000b6624d5691b14b7a%5eORref_sc_req_item.cat_item%3d2ec3f1213792e7002a098d2754990e56%5esys_mod_count<4%5eORDERBYnumber&sysparm_nostack=yes


''')



