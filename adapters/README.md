Config
adapters/config.py - defines host, user and passwords for snc interactions. example credentials US = 'RPA_HAL9000' PASS = '====Open the door Hall ==='

Set accounts definition in the department section
usage: routing_request_adapter.py [-h]
                                  [--change_status {open,work_in_progress,closed_complete}]
                                  [--worknotes WORKNOTES] [--read_details]
                                  [--get_tasklist] [--assign_to ASSIGN_TO]
                                  [--assign_req_to ASSIGN_REQ_TO]
                                  [--priority {low,moderate,high}]
                                  [--read_ritmdetails]
                                  id

positional arguments:
  id                    follow options and provide task id, sys id or example
                        message

optional arguments:
  -h, --help            show this help message and exit
  --change_status {open,work_in_progress,closed_complete}, -c {open,work_in_progress,closed_complete}
  --worknotes WORKNOTES, -w WORKNOTES
                        add worknotes to task
  --read_details, -r    provide task number to get details
  --get_tasklist        getting all task from RR queue
  --assign_to ASSIGN_TO, -a ASSIGN_TO
                        provide task sys_id and meseflow_user
  --assign_req_to ASSIGN_REQ_TO, -b ASSIGN_REQ_TO
                        provide req sys_id and meseflow_user
  --priority {low,moderate,high}
                        provide your sys_id and chose option
  --read_ritmdetails, -q
                        provide task number to get details
