#!/bin/bash
#created by slomaba1 /// bartosz.sloma@posti.com
echo
echo "##############  iaddress routing requests  ##############"

usage()
{

if [ "$#" == "0" ]; then
        echo USAGE: Run with TASK number as parameter!
            echo example: $0 PMTASK1234567 --robot


echo "more arguments:"
echo
echo " -h, --help             show this help message and exit"
echo " -r, --robot            robot automation "
echo " -q, --requirements    more information about process"
echo " -s, --single-order     talenom account creation TOOL"
echo
                echo
                exit 1
fi
}

check_ps()
{
	tUser=`whoami`
	checkproc=`ps -ef | grep RR-automation | grep -v "less" | wc -l`
	check_userps=`ps -ef | grep RR-automation | grep "/bin/bash" | grep -v $tUser | head -1 | awk '{print $1}'`
	if [ $checkproc -eq 3 ]; then
		echo "OK process executed by $tUser"
	else
		checkproc2=`ps -ef | grep RR-automation | grep -c "vim"`
	if [ $checkproc2 -eq 1 ]; then
		checkproc3=`ps -ef | grep RR-automation | grep "vim" | awk '{print $1}'`
		echo "the script is currently edited , by $checkproc3 please wait"
	else
			echo -e "$check_userps currently running the script, please wait or kill"
		        #echo $checkproc
	fi

	exit 1
fi
}

robot_lock()
{

PIDFILE=/home/elpp/rparobot/RR/hall_lock
tUser=`whoami`

	if [ -f $PIDFILE ]
	then
	 	 PID=$(cat $PIDFILE)
	  	ps -p $PID > /dev/null 2>&1
	  if [ $? -eq 0 ]
	  then
	  	echo
	    	echo "script is already running by $tUser"
	    	echo
	    	exit 1
	  else
	    	## Process not found assume not running
	    	echo $$ > $PIDFILE
	    	if [ $? -ne 0 ]
	   then
	      	echo "Could not create PID file"
	      	exit 1
	    fi
	  fi
	else
	  echo $$ > $PIDFILE
	  if [ $? -ne 0 ]
	  then
	    echo "Could not create hall_lock file"
	    exit 1
	  fi
	fi
}


robot_unlock()
{
	chmod 777 $PIDFILE
	rm $PIDFILE
}

snc()
{
/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTask -r > 1.tmp

#tTask="$1"
echo
echo -e "############ preparing data for $tTask =======>  ##########"
echo
	tOvt1=`cat 1.tmp | grep "TASK subject" | cut -d "/" -f3 | cut -d ' ' -f2`
	tOvt=`cat 1.tmp | grep "To be routed Receiving ID" | awk '{print $7}'`
	tCustomerName=`cat 1.tmp | grep "Company name" | awk '{for(i=6;i<=NF;i++){printf "%s ", $i}; printf "\n"}'`
	Company_name_tobe_routed=`cat 1.tmp | grep "CN to be routed" | awk '{for(i=6;i<=NF;i++){printf "%s ", $i}; printf "\n"}'`
	Type=`cat 1.tmp | grep "Type" | awk '{print $4}'`
	CompanyEA=`cat 1.tmp | grep "company electronic address" | awk '{for(i=5;i<=NF;i++){printf "%s ", $i}; printf "\n"}' `
	Rec_operator=`cat 1.tmp | grep "Receiving operator" | awk '{for(i=4;i<=NF;i++){printf "%s ", $i}; printf "\n"}' `
	Rec_short=`cat 1.tmp | grep "Receiving operator" | awk '{print $4}'`
	tIDate=`cat 1.tmp | grep "Activate routing" | awk '{print $4}'`
	moreinfo=`cat 1.tmp | grep "More information field" | awk '{print $5}' | awk '{gsub(/^ +| +$/,"")} {print "" $0 ""}'`
	tTaskID=`cat 1.tmp | grep "TASK ID" | awk '{print $4}'`
	ParentID=`cat 1.tmp | grep "Parent" | awk '{print $4}' | cut -d "'" -f2`
	tUser=`whoami`

tCustomerNameX='"'$tCustomerName'"'
CTIME=`/usr/bin/date +'%Y-%m-%d'`

#iaddress date
echo $tIDate

if [ -z "${tIDate-unset}" ]
then
	echo "implementation date is today"
        tDate=`/usr/bin/date +'%d.%m.%Y %H:%M'`
        tIDate=$tDate
else
                       tDate=`echo "$tIDate" | awk -v FS=- -v OFS=. '{print $3,$2,$1}'`
                       #echo $tDate
fi


ovt2name=`ovt2name $tOvt 2>&1`
ytjname=`awk '{gsub(/^ +| +$/,"")} {print "" $0 ""}' <<< $ovt2name`



}


checkbox()

{
echo
echo ====================CHECK BOX============================
echo
echo "PMTASK:                                $tTask"
echo "OVT Code:                              $tOvt"
echo "Receiving ID to be routed :            $tOvt1"
echo "Company Name :                         ${tCustomerName}"
echo "Company name to be routed              $Company_name_tobe_routed"
echo "ytj name :                             $ytjname"
echo "Company EA :                           $CompanyEA"
echo "Type :                                 $Type" 
echo "Receiving operator                     $Rec_operator"
echo "Reciving short name :                  $Rec_short"
echo "task ID :                              $tTaskID"
echo "Parent ID :                            $ParentID"
echo "checking time:                         $CTIME"
echo "Date to activate:                      $tIDate"
echo "more information:                      $moreinfo"
echo "iaddress date:                         $tDate"
echo "script user:                           $tUser"
echo =========================================================
echo



#checking mandatory variables
echo -e "checking varaibles ..."
if [ -z "$tOvt" ] || [ -z "${tCustomerName}" ] || [ -z "$tTaskID" ] || [ -z "$ParentID" ] || [ -z "$Company_name_tobe_routed" ] || [ -z "$Type" ] || [ -z "$CompanyEA" ] || [ -z "$Rec_operator" ]

then
    echo " missing variable. exiting"
        #/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $worknotes

	        exit 1
		    else
		        echo
			        echo "variables on the place: OK"
				fi

				echo



if [ -z "${moreinfo-unset}" ]
then
    echo -e "no additional information from customer - ticket can be processed by robot"
        echo $moreinfo
	else
	                 echo -e " moved to manual handling - additional information from customer"
			 worknotes=`echo "following information is attached, manual handling is needed \n\r $moreinfo"`
			                        #/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $worknotes
						                    exit 1
							                           #echo $tDate
   fi


}


closedcomplete()
    {
	        echo "close complete"
		        #/home/elpp/slomaba1/feeniks/feeniks_automation/closedcomplete.py $tTaskID
                /home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --change_status closed_complete
	}

#ovt check
ovt_check()
{         
	    		ovtcor=`grep -c '^0037[0-9]*$' <<<  "$tOvt"`
			echo ovt cor : $ovtcor
                ovtlenght=`awk -F '[0-9]' '{print NF-1}' <<< "$tOvt"`
		echo ovtlenght : $ovtlenght
                echo $ovtlenght

                if [ $ovtlenght -ne 12 ] && [ $ovtcor -eq 0 ]
                then
                        echo -e "ovt is extended or not correct, moved to manual handling"
                ovtwarn=`echo -e "Please check Ovt, moved to manual handling"`            
                #/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $ovtwarn
               
                        exit 1
                else
                        echo "ovt correct : OK"
                fi

}

#ytj check <==================================================================>
echo ytj check
ytj_check()
{
	#ovt2name=`ovt2name $tOvt 2>&1`
	#ytjname=`awk '{gsub(/^ +| +$/,"")} {print "" $0 ""}' <<< $ovt2name`
	echo ytjname : $ytjname

	ytjovt=`grep -c "Skipping" <<< $ovt2name`
	echo ytjovt : $ytjovt
	#maxcount=`cat 1.tmp | grep "1100 has been reached" | wc -l`
	maxcount=`grep -c "1100 has been reached" <<< $ovt2name`
	echo maxcount : $maxcount

if [ $maxcount -eq 1 ]
then
	countwarn=`echo "Max count of search hits 1100 of 1100 has been reached for this month, please contact PM CS FI Service Desk STD Changes"`
	#/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${countwarn}"

	echo "checking time: $CTIME , STATUS INFO: $countwarn "  >> /home/elpp/rparobot/RR/logs/RRlogs
    #    /home/elpp/slomaba1/HAL/change_priority3.py $tTaskID
	mail -s "1100 max search has been reached" -v -r bartosz.sloma@posti.com krzysztof.olszewski@posti.com,bartosz.sloma@posti.com < /home/elpp/rparobot/CS/ytjcounter.txt
        echo exiting
        exit 1
else
	echo "ytj counter OK"
fi



if [ $ytjovt -eq 1 ]
then
        ovtwarning=`echo "OVT warning: something wrong with ovt, OVT is extended or YTJservice not responding. moved to manual handling"`

        echo -e "ovt not exists in ytj, wrong ovt in department or ytj service not responding"
	#/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${ovtwarning}"

        echo "checking time: $CTIME , STATUS INFO: $ovtwarning "  >> /home/elpp/rparobot/RR/logs/RRlogs
        #/home/elpp/slomaba1/HAL/change_priority3.py $tTaskID
        echo exiting
        exit 1
else
        echo -e "entry in ytj exists, continue"

fi

}
namecompare()
{

if [ "$Company_name_tobe_routed" == "$ytjname" ]
	echo company name : $Company_name_tobe_routed
	echo ytj name          : $ytjname

then
  	echo "match correct name: TRUE"
  	worknotes=`echo "TRUE: company names are correct, Task: $tCustomerName ,YTJ DB: $ytjname"`
	#logs
	echo "checking time: $CTIME , STATUS INFO: $tTask $worknotes "  >> /home/elpp/rparobot/RR/logs/RRlogs
	a=1;
else
	echo "names are not exaclty the same: FALSE"
	a=0;
	worknotes=`echo "detected company names are not the same, company name from task: $tCustomerName , company name from ytj DB: $ytjname"`


						echo "checking time: $CTIME , $tTask STATUS INFO: $worknotes "  >> /home/elpp/rparobot/RR/logs/RRlogs

fi

}

#electronic addres and iban check
eadress_check()
{
echo company EA : $CompanyEA
EA_check_iban=`grep -c '^FI[0-9]*$' <<< $CompanyEA`
echo iban check  : $EA_check_iban
EA_check_tieto=`grep -c '003712345678' <<< $CompanyEA`
echo tieto check : $EA_check_tieto
EA_check_ovt=`grep -c '^0037[0-9]*$' <<< $CompanyEA`
echo ovt check   : $EA_check_ovt


if [ $EA_check_iban -eq 1 ]; then
	echo EA check iban : $EA_check_iban
    	iban_valid=`/home/elpp/rparobot/iban/iban-validate.sh $CompanyEA | grep -c "True"`
    if [ $iban_valid -eq 1 ]; then
        echo ibann confirmed
    else
        echo "incorrect iban"
        iban_worn=`echo -e "Iban is not confirmed, moved to manual handling"`
        #worknotes
	exit 1
    fi

    	#sometimes prefix is not added, 003712345678 -> TE003712345678. correct einvoice address?
elif [ $EA_check_tieto -eq 1 ]; then
	echo EA check tieto : $EA_check_tieto
        echo Tieto detected
        EA_check_tieto1=`grep -c 'TE' <<<  "$CompanyEA"`
    if [ $EA_check_tieto1 -ne 1 ]; then
    	echo EA check tieto1 : $EA_check_tieto1
            echo "adding prefix to ovt"
    else
    	echo ok tieto detected and prefix is ok
    fi

elif [ $EA_check_ovt -eq 1 ]; then
	echo EA check ovt : $EA_check_ovt
        echo Eaddress ovt confirmed
else
    echo -e" eaddress not supported, moved to manual handling"
    #/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $ovtwarn
    exit 1
fi

}
#EA_check_ovt=`grep -c '^0037[0-9]*$' <<<  "$CompanyEA"`

#EA_check=`grep -c '^FI[0-9]*$' <<<  "$CompanyEA"`
#                EAlenght=`awk -F '[0-9]' '{print NF-1}' <<< "$CompanyEA"`
#                echo $EA_lenght
#
#                if [ $EA_lenght -ne 18 ] && [ $EA_check -eq 0 ]
#                then
#                        echo -e "ovt is extended or not correct, moved to manual handling"
#                ovtwarn=`echo -e "Please check Ovt, moved to manual handling"`            
#                  /home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $ovtwarn
#                                       exit 1
#                else
#                        echo "ovt correct : OK"
#                fi

#eaddress check


#iaddress check <================================================================>


#Accepted LMC checking




LMCprecheck()
{
echo LMC checking

echo -e "Aktia Pankki (HELSFIHH)"
echo -e "Ålandsbanken (AABAFI22)"
echo -e "Danske Bank (DABAFIHH)"
echo -e "Handelsbanken (HANDFIHH)"
echo -e "Nordea Bank (NDEAFIHH)"
echo -e "Osuuspankki (OKOYFIHH)"
echo -e "POP Pankki (POPFFI22)"
echo -e "S-Pankki (SBANFIHH)"
echo -e "Säästöpankkien Keskuspankki Suomi Oy (ITELFIHH)"
echo -e "Apix Messaging Oy (003723327487)"
echo -e "Basware (003705925424 / BAWCFI22 / BWEI)"
echo -e "CGI (003703575029)"
echo -e "Liaison (003708599126)"
echo -e "Maventa (003721291126)"
echo -e "Pagero (PAGERO / 003723609900 )"
echo -e "Ropo Capital Oy (Enfo Zender Oy) (003714377140)"
echo -e "Tieto (003701011385)"

Aktia=`echo -e "Aktia Pankki (HELSFIHH)"`
Aland=`echo -e "Ålandsbanken (AABAFI22)"`
Danske=`echo -e "Danske Bank (DABAFIHH)"`
Handel=`echo -e "Handelsbanken (HANDFIHH)"`
Nordea=`echo -e "Nordea Bank (NDEAFIHH)"`
Osuus=`echo -e "Osuuspankki (OKOYFIHH)"`
POP=`echo -e "POP Pankki (POPFFI22)"`
SPanki=`echo -e "S-Pankki (SBANFIHH)"`
Saasto=`echo -e "Säästöpankkien Keskuspankki Suomi Oy (ITELFIHH)"`
Apix=`echo -e "Apix Messaging Oy (003723327487)"`
Basware=`echo -e "Basware (003705925424 / BAWCFI22 / BWEI)"`
CGI=`echo -e "CGI (003703575029)"`
Liais=`echo -e "Liaison (003708599126)"`
Maven=`echo -e "Maventa (003721291126)"`
Pagero=`echo -e "Pagero (PAGERO / 003723609900 )"`
Ropo=`echo -e "Ropo Capital Oy (Enfo Zender Oy) (003714377140)"`
Tieto=`echo -e "Tieto (003701011385)"`

LMC=`cat LMC-list-accepted | grep -c "$Rec_short"`
LMC1=`cat LMC-list-accepted | grep "$Rec_short"`
echo LMC : $LMC


#if [ "$Rec_operator" == "$Aktia" ] || [ "$Rec_operator" == "$Aland" ] || [ "$Rec_operator" == "$Danske" ] || [ "$Rec_operator" == "$Handel" ] || [ "$Rec_operator" == "$Nordea" ] || [ "$Rec_operator" == "$Osuus" ] || [ "$Rec_operator" == "$POP" ] || [ "$Rec_operator" == "$SPanki"] || [ "$Rec_operator" == "$Saasto" ] || [ "$Rec_operator" == "$Apix" ] || [ "$Rec_operator" == "$Basware" ] || [ "$Rec_operator" == "$CGI" ] || [ "$Rec_operator" == "$Liais" ] || [ "$Rec_operator" == "$Maven" ] || [ "$Rec_operator" == "$Pagero" ] || [ "$Rec_operator" == "$Ropo" ] || [ "$Rec_operator" == "$Tieto" ]

if [ $LMC -eq 1 ]; then

	echo LMCs approved
	echo
	echo Receiving operator : $Rec_operator
	echo LMC name           : $LMC1
else
	echo -e "LMCs not approved, moved to manual handling"
		echo
	        echo Receiving operator : $Rec_operator
		echo LMC name           : $LMC1
		echo $Rec_operator >> /home/elpp/rparobot/RR/2.tmp
		echo $Nordea >> /home/elpp/rparobot/RR/2.tmp
		        echo


	LMCworknotes=`echo -e "LMCs not approved, moved to manual handling"`
fi
}


#iaddress part

checkin_iaddress()

{

#checking for more than one organization and edira sites

sanityOrg=`eivc-org-info $tOvt | grep "Org id:" | wc -l`

if [ $sanityOrg -le 1 ]
then
        echo -e "no duplicated organizations, OK"
	b=1;
	worknotes1=`echo "OK : no duplicated organizations"`

	        #logs
		        echo "checking time: $CTIME , STATUS INFO: $worknotes1 "  >> /home/elpp/rparobot/RR/logs/RRlogs

else
	echo "false"
	        echo -e " $sanityOrg organizations found in iaddress, $tTask $tOvt plese remove inccorrect entries" >> /home/elpp/rparobot/RR/logs/RRlogs
		# this will go to manual hendling - info in worknotes with status moderate
		b=0;
		worknotes1=`echo "UPSSS: duplicated organization, please check iaddress"`

fi
#checing for edira mess
				        ediraclean=`eivc-site-info $tOvt | grep "EDIRA" | wc -l`
					if [ $ediraclean -gt 1 ]
					then
					        echo -e "Edira mess in iaddress"
						worknotes2=`echo "UPSS: 2 edira records on the same site, please check iaddress"`
						c=0;
						else
						        echo -e "OK: correct eddira, sepparate sites"
							c=1;
							worknotes2=`echo "OK: correct eddira, sepparate sites"`
							fi
}




set_routings()
{


if [sanityOrg -eq 0]; then
    echo creating organization
    OrgId=`eivc-org-create --name "${Company_name_tobe_routed}" -t $tTask | awk '{print $5}'`
else
    OrgId=`eivc-org-info 003709761455 | grep "Org id:" | awk '{print $3}'`
fi

add_routing()
{
echo -e "eivc-map $tOvt "${Company_name_tobe_routed}" $CompanyEA $LMC1 --orgid $OrgId -t $tTask --add"
        eivc-map $tOvt "${Company_name_tobe_routed}" $CompanyEA $LMC1 --orgid $OrgId -t $tTask --add
        echo
}		
valid_from()
{
        echo "standard routing validation from $tDate"
		
		newchanel=`eivc-site-info $tOvt | grep $CompanyEA | awk '{print $1}'`
		
		eivc-site-addr-modify --id $newchanel --validfrom $tDate --feeniks-export Y -t $tTask
}

#checking for active routings and setting up
site_check=`eivc-site-info $tOvt | grep -c " E "`
if [site_check -eq 0]; then
    echo clean site ready to add LMC
    fi
        if [site_check -eq 1]; then
            IA_LMC=`eivc-site-info $tOvt | grep "prod" | grep " E " | awk '{print $3}'`
            check_accepted_LMC=`cat LMC-list-accepted | grep -c $IA_LMC`
            if [ $check_accepted_LMC -eq 0 ]; then
                echo "LMC not supported, moved to manual handling"
                LMC_IA_WARN=`echo "LMC not accepted, moved to manual handling /n/r $check_accepted_LMC"`
                #worknotes
                exit 1
            else
                echo ready to set validation
                oldchanel=`eivc-site-info $tOvt | grep $IA_LMC | awk '{print $1}'`
		
		        eivc-site-addr-modify --id $oldchanel --validto $tDate -t $tTask
                add_routing
                valid_from
            fi
        else
        echo -e "some validation routing awaiting, moved to manual handling"

        fi


}





iaddrsum()
{
	iaddrcolR=`eivc-site-info $tOvt | grep " E " | grep "$CompanyEA" | wc -l`

	echo "sum iaddr: record $iaddrcolR"


	if [ $iaddrcolR -eq 1 ]
	then
        	echo correct routing in iaddress

	else
	        	echo " WARNING: please check iaddress, routing not found"
			        lastwarn=`echo"moved to manual handling, please check iaddress"`
	fi

}


lastnotes()
{
	echo
	echo -e "######################### summary ##############################"
	echo
	echo "PMTASK:                                $tTask"
	echo "OVT Code:                              $tOvt"
	echo "customer name from department:         ${tCustomerName}"
	urlIA=`echo Message sending : $(eivc-site-info $tOvt | grep "Site id:" | awk '{print $3}' | gxargs -i echo "https://iaddress.itella.net/eivc-ui/hd/site-edit.htm?siteId={}")`
	echo "$urlIA "
	echo

}

requirements()
{
echo setup documentation will be here
}

robotitems()
{
	echo task number : $tTask
	#check_ps
	snc1
	checkboxtal
	leukucheck
	checking_console
	ovtok
	agrok
	sending_bruteforce
	lastnotes

}


robot()
{

	# collecting routing requests task tickets
	/home/elpp/rparobot/RR/adapters/routing_request_adapter.py something --get_tasklist > tasklist.tmp


	echo
        RR_tasklist=`cat tasklist.tmp | wc -l`
        #echo " number of assigned RR tasks : $RR_tasklist "


	echo
	echo -e " |. ===========================================================================.|   "
	echo -e " || . . . . . . . .  WELCOME IN ROUTING REQUEST AUTOMATION PROCES . . .  . . . .||  "
	echo -e " || . . . . . .  . . . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " || . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " || . . . . . ----  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " || . . . .  /    \ . . / . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " || . . . . |      |   /\/  . . .ORDERS ASSIGNED TO HALL ROBOT . . .. . . . . . ||  "
	echo -e " || . . . .  \____/   / / . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " || . . . .  (___) __/ /  . . . . . . . $RR_tasklist  . . . . . . . . . . . . . ||"
	echo -e " || . . . . / _ \ \ __/   . . . . . . . . . . . . . . . . . . . . . . . . . . . ||  "
	echo -e " |.======== \___ \_)============================================================.|  "
	echo -e "            |_____|                                                                 "
	echo -e "            | | | |                                                                 "
	echo -e "            |_| |_|                                                                 "
	echo -e "           (__) (__)                                                                "
	echo -e "                                                                                    "
	tUser=`whoami`

	logdate=`/usr/bin/date +'%d.%m.%Y %H:%M' | awk '{print $1 " " $2}'`
	echo
	echo "all logs from $logdate you can find in /home/elpp/rparobot/RR/logs/RRlogs"
	echo
	echo "# $RR_tasklist logs from $logdate made by robot #" >> /home/elpp/rparobot/RR/logs/RRlogs

	cat tasklist.tmp | awk '{print $2}' | while read tTask; do robotitems; done

	echo "======== The amount of talenom orders processed by the robot : $talenom_tasklist  ========"
	echo "# batch end from $logdate : $talenom_tasklist orders processed by robot  #" >> /home/elpp/rparobot/RR/logs/RRlogs

}

   if [ "$#" -le "1" ]; then
      usage
   fi
tTask="$1"


while [ ! $# -eq 0 ]
do
        case "$2" in
                --help | -h)
                        echo
                        usage
                        exit
                        ;;

                --robot | -r)
                	check_ps        
			robot
                        exit
                        ;;
                --single-order | -s)
                        snc
                       	checkbox
                       	ovt_check
                       	ytj_check
                       	namecompare
                       	eadress_check
		       	LMCprecheck

                       	exit
                        ;;
                --requirements | -q)
                        requirements
                        exit
                        ;;
		
        esac
        shift
done

