#!/usr/bin/env python3


import requests
import argparse


import config


user = config.US
pwd = config.PASS


host = 'https://meseflow.service-now.com'

headers = {"Content-Type":"application/json","Accept":"application/json"}


def task_details(number):
    url=host+'/api/now/table/sc_req_item'
    
    headers = {"Content-Type":"application/json","Accept":"application/json"}
    payload = {'number': number}
    response = requests.get(url, auth=(user, pwd), headers=headers, params=payload)
    #print(response.url)
		 
    if response.status_code != 200: 
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())

        exit()

    data=response.json().get('result','')[0]
    #print(data)
    print()
    print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    print('$$$$_____________service now adapter 1.0 implemented by slomaba1___________$$$$')
    print('$$$$             Dedicated for Iaddress routing request service            $$$$')
    print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    print()
    print('____________________________TASK DETAILS_______________________________________')
    print()
    print("TASK number            : {}".format(data.get('number','')))
    print("Parent                 : {}".format(data.get('parent', '')))
    print("TASK subject           : {}".format(data.get('short_description','')))
    print("TASK status            : {}".format(data.get('state','')))
    print("TASK ID                : {}".format(data.get('sys_id','')))
    print("assignment group       : {}".format(data.get('assignment_group', '')))
    print("TASK status            : {}".format(data.get('state', '')))
   # dep_id=data.get('u_department','')
   # dep_id_value=dep_id['value']
    
    #print(dep_id_value)
    #print("Department id          : {}".format(dep_id_value))


# getting variable

    sys_id=data.get('sys_id','')
    #print("task sys id            : {}".format(dep_id_value))
    print(sys_id)
    
    url1=host+"/sc_req_item.do?JSONv2&sysparm_action=getRecords&sysparm_query=sys_id="+sys_id+"&displayvariables=true"
    #print(url1)

    headers = {"Content-Type":"application/json","Accept":"application/json"}

    response = requests.get(url1, auth=(user, pwd), headers=headers)
    #print(response)


    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()


    data=response.json()


    #print(data)
    print()
    print(' ________________________Information taken from variables form___________________________')
    print()
    #print('______________________________________')

    #print(data['records'][0].get('variables')[7])
    #print(data['records'][0].get('variables')[8].get('value'))
    print("Product                              : {}".format(data['records'][0].get('variables')[0].get('value')))
    print("Company name                         : {}".format(data['records'][0].get('variables')[3].get('value')))
    print("Company name to be routed            : {}".format(data['records'][0].get('variables')[5].get('value')))
    print("Type                                 : {}".format(data['records'][0].get('variables')[6].get('value')))
    print("To be routed Receiving ID            : {}".format(data['records'][0].get('variables')[7].get('value')))
    print("company electronic address           : {}".format(data['records'][0].get('variables')[8].get('value')))
    print("Receiving operator                   : {}".format(data['records'][0].get('variables')[9].get('value')))
    print("Date to activate or change routing   : {}".format(data['records'][0].get('variables')[10].get('value')))
    print("More information                     : {}".format(data['records'][0].get('variables')[11].get('value')))
    #print(data['records'][0].get('variables'))
    #test(dep_id_value)
    #return dep_id_value

#getting data from department


def test(dep_id_value):
    url = 'https://meseflow.service-now.com/api/now/table/cmn_department/'+dep_id_value
    headers = {"Content-Type":"application/json","Accept":"application/json"}

    response = requests.get(url, auth=(user, pwd), headers=headers)

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())

        exit()

    data=response.json().get('result','')

    print('__________________________Information taken from department site__________________________')
    print('    ')

    print("OVT                     : {}".format(data.get('u_ovt_number','')))
    print("COMPANY NAME            : {}".format(data.get('name','')))
    print("VAT                     : {}".format(data.get('u_vat_number', '')))
    print("Agreement number        : {}".format(data.get('u_epm_agreement_number','')))
    print("EPM customer number     : {}".format(data.get('u_epm_customer_number', '')))
    print("Ipost class             : {}".format(data.get('u_ipost_class', '')))
    print("implementation date     : {}".format(data.get('u_desired_impl_date', '')))
    print("Sending account         : {}".format(data.get('u_sales_invoices_account', '')))
    print("Password Sending account: {}".format(data.get('u_test_sales_inv_acc_pwd', '')))
    print("test sending            : {}".format(data.get('u_test_sales_inv_acc', '')))
    print("Password test sending   : {}".format(data.get('u_sales_inv_acc_pwd', '')))
    print("Receiving               : {}".format(data.get('u_purchase_invoices_account', '')))
    print("password receiving      : {}".format(data.get('u_test_purchase_inv_acc_pwd', '')))
    print("Test receiving          : {}".format(data.get('u_test_purchase_inv_acc', '')))
    print("password test receiving : {}".format(data.get('u_test_purchase_inv_acc_pwd', '')))
    print("Master account          : {}".format(data.get('u_purchase_inv_master_account', '')))
    print("Virtual connection      : {}".format(data.get('u_virtual_connection', '')))
    print("Desired termination date: {}".format(data.get('u_desired_term_date', '')))
    print("Tieke                   : {}".format(data.get('u_published_to_tieke', '')))




if __name__=="__main__":


    parser = argparse.ArgumentParser()
    parser.add_argument('id',help='PMTASK --provide following flag')
    parser.add_argument('--read_details','-r',action='store_true',help='show task details')

    args = parser.parse_args()
    
    if args.id:
        if args.read_details:
            task_details(args.id)

