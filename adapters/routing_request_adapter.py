#!/usr/bin/env python3

import requests
import argparse
import config

user = config.US
pwd = config.PASS

host = 'https://meseflow.service-now.com'

headers = {"Content-Type":"application/json","Accept":"application/json"}

def task_details(number):
    url=host+'/api/now/table/sc_task'

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
    print('$$$$_________________________Service now adapter 1.0.1_________________________$$$$')
    print('$$$$        Dedicated for all tasks and Iaddress routing request service       $$$$')
    print('$$$$                  more information: bartosz.sloma@posti.com                $$$$')
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


# getting variable form

    sys_id=data.get('sys_id','')
    #print("task sys id            : {}".format(dep_id_value))
    print(sys_id)

    url1=host+"/sc_task.do?JSONv2&sysparm_action=getRecords&sysparm_query=sys_id="+sys_id+"&displayvariables=true"
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
    print("Company name variables field         : {}".format(data['records'][0].get('variables')[1].get('value')))
    print("CN to be routed                      : {}".format(data['records'][0].get('variables')[3].get('value')))
    print("Type                                 : {}".format(data['records'][0].get('variables')[4].get('value')))
    print("To be routed Receiving ID            : {}".format(data['records'][0].get('variables')[5].get('value')))
    print("company electronic address           : {}".format(data['records'][0].get('variables')[6].get('value')))
    print("Receiving operator                   : {}".format(data['records'][0].get('variables')[7].get('value')))
    print("Activate routing                     : {}".format(data['records'][0].get('variables')[8].get('value')))
    print("More information field               : {}".format(data['records'][0].get('variables')[9].get('value')))
    #print(data['records'][0].get('variables'))
    #test(dep_id_value)
    #return dep_id_value



#getting information from request


def ritm_details(number):
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
    print("CN to be routed                      : {}".format(data['records'][0].get('variables')[5].get('value')))
    print("Type                                 : {}".format(data['records'][0].get('variables')[6].get('value')))
    print("To be routed Receiving ID            : {}".format(data['records'][0].get('variables')[7].get('value')))
    print("company electronic address           : {}".format(data['records'][0].get('variables')[8].get('value')))
    print("Receiving operator                   : {}".format(data['records'][0].get('variables')[9].get('value')))
    print("Date to activate or change routing   : {}".format(data['records'][0].get('variables')[10].get('value')))
    print("More information field               : {}".format(data['records'][0].get('variables')[11].get('value')))
    #print(data['records'][0].get('variables'))
    #test(dep_id_value)
    #return dep_id_value







#getting tasklist

def get_tasklist_RR():
    #print ('getting information from sn')


    url = 'https://meseflow.service-now.com/api/now/table/task?sysparm_query=assignment_group%3De6407b040f3a0700f3ecf68ce1050edc%5Eparent.ref_sc_req_item.cat_item%3D2ec3f1213792e7002a098d2754990e56%5Esys_class_name%3Dsc_task%5Epriority%3D4%5Eu_state_dv%3DOpen%5Eparent.sys_mod_count<4&sysparm_first_row=1&sysparm_view=catalog'

    headers = {"Content-Type":"application/json","Accept":"application/json"}

# Do the HTTP request
    response = requests.get(url, auth=(user, pwd), headers=headers )

# Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()

# Decode the JSON response into a dictionary and use the data
    data = response.json()

    data1=(data['result'])
    file=open("tasklist.tmp","w")
    for item in data1:

        file.write(item['sys_id'] + ' ' + item['number'] + ' ' + item['short_description'] + '\n')

    file.close()

def assign(inc_sys_id,usr_sys_id):

    url = host+'/api/now/table/sc_task/'+inc_sys_id

    response = requests.put(url, auth=(user, pwd), headers=headers ,data='{"assigned_to":"'+str(usr_sys_id)+'"}')

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()

def assign_req(inc_sys_id,usr_sys_id):
#sc_req_item task
    url = host+'/api/now/table/sc_req_item/'+inc_sys_id

    response = requests.put(url, auth=(user, pwd), headers=headers ,data='{"assigned_to":"'+str(usr_sys_id)+'"}')

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()



def worknotes(sys_id,text):

    url = host+'/api/now/table/sc_task/'+sys_id

    response = requests.put(url, auth=(user, pwd), headers=headers ,data='{"work_notes":"'+text+'"}')

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())

        exit()


def change_state(sys_id, s):
    #state=1
    if s=='open':
        state = 1
    elif s=='work_in_progress':
        state = 2
    elif s =='closed_complete':
        state = 3

    url = host+'/api/now/table/sc_task/'+sys_id
    response = requests.put(url, auth=(user, pwd), headers=headers ,data='{"state":"'+str(state)+'"}')

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())

        exit()

def set_priority(sys_id, s):
    if s=='low':
        state = 4
    elif s=='moderate':
        state = 3
    elif s== 'high':
        state = 2

    url = "https://meseflow.service-now.com/api/now/table/sc_task/" + sys_id
    response = requests.patch(url, auth=(user, pwd), headers=headers ,data="{\"priority\":\"+str(state)+\"}")

    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()

    data = response.json()
    print(data)

if __name__=="__main__":




    parser = argparse.ArgumentParser()
    parser.add_argument('id',help='follow options and provide task id, sys id or example message')
    parser.add_argument('--change_status','-c', choices=['open','work_in_progress','closed_complete'])
    parser.add_argument('--worknotes','-w',help='add worknotes to task')
    parser.add_argument('--read_details','-r',action='store_true',help='provide task number to get details')
    parser.add_argument('--get_tasklist',action='store_true',help='getting all task from RR queue')
    parser.add_argument('--assign_to','-a',help='provide task sys_id and meseflow_user')
    parser.add_argument('--assign_req_to','-b',help='provide req sys_id and meseflow_user')
    parser.add_argument('--priority',choices=['low','moderate','high'],help='provide your sys_id and chose option')
    parser.add_argument('--read_ritmdetails','-q',action='store_true',help='provide task number to get details')
    args = parser.parse_args()

    if args.id:
        if args.change_status:
            change_state(args.id,args.change_status)
        if args.worknotes:
            worknotes(args.id,args.worknotes)
        if args.read_details:
            task_details(args.id)
        if args.read_ritmdetails:
            ritm_details(args.id)
        if args.get_tasklist:
            get_tasklist_RR()
        if args.assign_to:
            assign(args.id,args.assign_to)
        if args.assign_req_to:
            assign_req(args.id,args.assign_to)
        if args.priority:
            set_priority(args.id,args.priority)



