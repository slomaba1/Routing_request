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
echo " -h, --help            show this help message and exit"
echo " -r, --robot           robot automation               "
echo " -q, --requirements    more information and setup     "
echo " -s, --single-order    RR single order test           "
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
	Company_name_tobe_routed=`cat 1.tmp | grep "CN to be routed" | awk '{for(i=6;i<=NF;i++){printf "%s ", $i}; printf "\n"}' | awk '{gsub(/^ +| +$/,"")} {print "" $0 ""}'`
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
	if [ $robot -eq 1 ]; then
		echo
		echo robot way
		echo
		continue 1
	else
		echo
		echo single task way
		echo
		exit 1
	fi
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
			 #worknotes=`echo "following information is attached, manual handling is needed \n\r $moreinfo"`
			 csinfo="$(cat <<-EOF
				manual handling is needed \n\r please check following information \n\r $moreinfo
				EOF
				)"
			                        /home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes "${csinfo}"
						/home/elpp/slomaba1/HAL/change_priority3.py $tTaskID
						if [ $robot -eq 1 ]; then
                					continue 1
        					else
                					exit 1
        					fi
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
                ovtwarn=`echo -e "CHECK: Please check Ovt, moved to manual handling"`            
                #/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes $ovtwarn
               		a=0;
						if [ $robot -eq 1 ]; then
                                                        continue 1
                                                else
                                                        exit 1
                                                fi

                else
                        echo "ovt correct : OK"
			ovtwarn=`echo -e "OK: OVT fulfills our requirements"`
			a=1;
                fi

}

#ytj check <==================================================================>
ytj_check()
{
	echo ytj check
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
	echo ytj search count
	countwarn=`echo "Max count of search hits 1100 of 1100 has been reached for this month, please contact PM CS FI Service Desk STD Changes"`
	/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${countwarn}"

	echo "checking time: $CTIME , STATUS INFO: $countwarn "  >> /home/elpp/rparobot/RR/logs/RRlogs
        /home/elpp/slomaba1/HAL/change_priority3.py $tTaskID
	mail -s "1100 max search has been reached" -v -r bartosz.sloma@posti.com krzysztof.olszewski@posti.com,bartosz.sloma@posti.com < /home/elpp/rparobot/CS/ytjcounter.txt
	if [ $robot -eq 1 ]; then
           continue 1
        else
           exit 1
        fi
	
else
	echo "ytj counter OK"
fi


if [ $ytjovt -eq 1 ]
then
        ovtwarning=`echo "OVT warning: something wrong with ovt, OVT is extended or YTJservice not responding. moved to manual handling"`

        echo -e "ovt not exists in ytj, wrong ovt in department or ytj service not responding"
	/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${ovtwarning}"
	
        echo "checking time: $CTIME , STATUS INFO: $ovtwarning "  >> /home/elpp/rparobot/RR/logs/RRlogs
        /home/elpp/slomaba1/HAL/change_priority3.py $tTaskID
        echo exiting task

	if [ $robot -eq 1 ]; then
           continue 1
        else
           exit 1
        fi
		

else
        echo -e "entry in ytj exists, everything ok at this stage"

fi

}
namecompare()
{

if [ "$Company_name_tobe_routed" == "$ytjname" ]; then
	echo company name : $Company_name_tobe_routed
	echo ytj name          : $ytjname

  	echo "match correct name: TRUE"
  	worknotes=`echo "OK: company names are correct, Task: $Company_name_tobe_routed ,YTJ DB: $ytjname"`
	#logs
	echo "checking time: $CTIME , STATUS INFO: $tTask $worknotes "  >> /home/elpp/rparobot/RR/logs/RRlogs
	b=1;
else
	echo "names are not exaclty the same: FALSE"
	b=0;
	worknotes=`echo "CHECK: Company names are not the same, company name from task: $Company_name_tobe_routed , company name from ytj DB: $ytjname"`


	echo "checking time: $CTIME , $tTask STATUS INFO: $worknotes "  >> /home/elpp/rparobot/RR/logs/RRlogs

fi

}

#electronic addres and iban check

eadress_check()
{

echo company EA : $CompanyEA
EA_check_iban=`grep -c '^FI[0-9]*$' <<< $CompanyEA`
echo iban check  : $EA_check_iban

check_tieto=`grep -c 'Tieto' <<< $Rec_operator`
echo -e "tieto check: detected $Rec_operator $CompanyEA"

EA_check_ovt=`grep -c '^0037[0-9]*$' <<< $CompanyEA`
echo ovt check   : $EA_check_ovt


if [ $EA_check_iban -eq 1 ]; then
	echo EA check iban : $EA_check_iban
    	iban_valid=`/home/elpp/rparobot/iban/iban-validate.sh $CompanyEA | grep -c "True"`
    if [ $iban_valid -eq 1 ]; then
        echo ibann confirmed
	ea_check=`echo -e "OK: iban correctness confirmed"`
	c=1;
    else
        echo "incorrect iban"
        iban_worn=`echo -e "NOT OK: Iban not confirmed, moved to manual handling"`
        #worknotes
	ea_check=`echo -e "NOT OK: iban not confirmed"`
	c=0;
    fi

    	#sometimes prefix is not added, 003712345678 -> TE003712345678. correct einvoice address?
elif [ $check_tieto -eq 1 ]; then
	
	echo -e "tieto detected: checking EA for tieto"
	EA_sanity1=`grep -c '^TE0037[0-9]*$' <<< $CompanyEA`
	EA_sanity2=`grep -c '^0037[0-9]*$' <<< $CompanyEA`
        #EA_sanity3=`awk -F '[0-9]' '{print NF-1}' <<< $CompanyEA`
	#EA_sanity4=`awk -F '[0-9]' '{print NF-1}' <<< $CompanyEA`

		if [ $EA_sanity1 -eq 1 ] || [ $EA_sanity2 -eq 1 ]
		then
			
		  echo 
		  EA_check_tieto=`grep -c 'TE' <<< $CompanyEA`
        
		    if [ $EA_check_tieto -eq 1];then
                		echo ok prefix on the place
        	    else
			echo adding prefix
        		CompanyEA="TE${ovt}"
        		echo -e "Company EA for Tieto fixed : $CompanyEA"
			ea_check=`echo -e "OK: wrong prefix in EA address,has been fixed $CompanyEA"`
			c=1;
		    fi

		else
			echo -e "Please check Electronic address for tieto : $CompanyEA"
			ea_check=`echo -e "Please check Electronic address for tieto : $CompanyEA"`
			c=0;
		fi
	
elif [ $EA_check_ovt -eq 1 ]; then
	echo EA check ovt : $EA_check_ovt
        echo Eaddress ovt confirmed
	ea_check=`echo -e "OK: EA ovt confirmed"`
	c=1;
else
    echo -e "NOT OK: eaddress not supported, moved to manual handling"
    ea_check=`echo -e "NOT OK: eaddress ovt not supported"`
	c=0;
fi

}

#Accepted LMC checking

LMCprecheck()
{

cat /home/elpp/rparobot/RR/LMC-list-accepted
echo
echo LMC checking
echo
LMC=`cat LMC-list-accepted | grep -c "$Rec_short"`
LMC1=`cat LMC-list-accepted | grep "$Rec_short" | awk '{print $3}'`
echo LMC : $LMC
echo LMC : $LMC1


#if [ "$Rec_operator" == "$Aktia" ] || [ "$Rec_operator" == "$Aland" ] || [ "$Rec_operator" == "$Danske" ] || [ "$Rec_operator" == "$Handel" ] || [ "$Rec_operator" == "$Nordea" ] || [ "$Rec_operator" == "$Osuus" ] || [ "$Rec_operator" == "$POP" ] || [ "$Rec_operator" == "$SPanki"] || [ "$Rec_operator" == "$Saasto" ] || [ "$Rec_operator" == "$Apix" ] || [ "$Rec_operator" == "$Basware" ] || [ "$Rec_operator" == "$CGI" ] || [ "$Rec_operator" == "$Liais" ] || [ "$Rec_operator" == "$Maven" ] || [ "$Rec_operator" == "$Pagero" ] || [ "$Rec_operator" == "$Ropo" ] || [ "$Rec_operator" == "$Tieto" ]

if [ $LMC -eq 1 ]; then

	echo LMCs approved
	echo
	d=1;
	echo Receiving operator : $Rec_operator
	echo LMC name           : $LMC1
	LMC_wn=`echo -e "OK: LMC in task aproved"`
else
	echo -e "LMCs not approved, moved to manual handling"
	d=0;
	LMC_wn=`echo -e "NOT OK: LMC in task not aproved or more information provided"`
		echo
	        echo Receiving operator : $Rec_operator
		echo LMC name           : $LMC1
		echo $Rec_operator >> /home/elpp/rparobot/RR/2.tmp
		echo $Nordea >> /home/elpp/rparobot/RR/2.tmp
		        echo


	#LMCworknotes=`echo -e "LMCs not approved, moved to manual handling"`
fi
}


checkpoint1()
{
echo "a : $a  $ovtwarn"
echo "b : $b  $worknotes"
echo "c : $c  $ea_check"
echo "d : $d  $LMC_wn"



if [ "$a" -eq "1" ] && [ "$b" -eq "1" ] && [ "$c" -eq "1" ] && [ "$d" -eq "1" ]; then
		echo
                echo "first checkpoint before setting iaddress"
	csinfo="$(cat <<-EOF
	CONFIRMED by robot, please check following information \n\r $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn
	EOF
                )"
                echo "$csinfo"
		echo -e " ready for next stage"
		echo
                        echo "$csinfo"

else

	csinfo="$(cat <<-EOF
	Moved to manual handling, please check following information \n\r $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn \n\r iaddress has been skiped
EOF
                )"
                echo "$csinfo"
                echo " Need to be checked by customer service "
                echo "$csinfo"
                echo "checking time: $CTIME , STATUS INFO: CSCHECK: $csinfo" >> /home/elpp/rparobot/RR/logs/RRlogs
                /home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes "${csinfo}"
                /home/elpp/slomaba1/HAL/change_priority3.py $tTaskID

		if [ $robot -eq 1 ]; then
                     continue 1
                else
                     exit 1
                fi

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
	e=1;
	worknotes1=`echo -e "OK : no duplicated organizations"`

	        #logs
		        echo "checking time: $CTIME , STATUS INFO: $worknotes1 "  >> /home/elpp/rparobot/RR/logs/RRlogs

else
	echo "false"
	        echo -e " $sanityOrg organizations found in iaddress, $tTask $tOvt plese remove inccorrect entries" >> /home/elpp/rparobot/RR/logs/RRlogs
		# this will go to manual hendling - info in worknotes with status moderate
		e=0;
		worknotes1=`echo -e "UPSSS: duplicated organization, please check iaddress"`

fi
#checing for edira mess
				        ediraclean=`eivc-site-info $tOvt | grep "EDIRA" | wc -l`
					if [ $ediraclean -gt 1 ]
					then
					        echo -e "Edira mess in iaddress"
						worknotes2=`echo "UPSS: 2 edira records on the same site, please check iaddress"`
						f=0;
						else
						        echo -e "OK: correct eddira, sepparate sites"
							f=1;
							worknotes2=`echo "OK: correct eddira, sepparate sites"`
							fi
}

add_routing()
{
echo -e "eivc-map $tOvt "${Company_name_tobe_routed}" $CompanyEA $LMC1 --orgid $OrgId -t $tTask --add"
        eivc-map $tOvt "${Company_name_tobe_routed}" $CompanyEA $LMC1 --orgid $OrgId -t $tTask --add
        echo
}		
valid_from()
{
        echo "standard routing validation from $tDate"
		
		newchanel=`eivc-site-info $tOvt | grep $CompanyEA | grep " E " | awk '{print $1}'`
		echo
		echo -e " eivc-site-info $tOvt | grep $CompanyEA | grep " E " | awk '{print $1}'"
		eivc-site-addr-modify --id $newchanel --validfrom $tDate -t $tTask
		echo
}


valid_to()
{
echo -e "eivc-site-addr-modify --id $oldchanel --validto $tDate -t $tTask"
eivc-site-addr-modify --id $oldchanel --validto $tDate -t $tTask
echo
}

set_routings()
{

sanityOrg=`eivc-org-info $tOvt | grep "Org id:" | wc -l`
	if [ $sanityOrg -eq 0 ]; then
    		echo creating organization
        	OrgId=`eivc-org-create --name "${Company_name_tobe_routed}" -t $tTask | awk '{print $5}'`
		echo -e " New ORG id : $OrgId"
	else
	    OrgId=`eivc-org-info $tOvt | grep "Org id:" | awk '{print $3}'`
	    echo -e " ORG id : $OrgId"
	fi

#checking for active routings and setting up
site_check=`eivc-site-info $tOvt | grep " E " | wc -l`

if [ $site_check -eq 1 ]; then
            IA_LMC=`eivc-site-info $tOvt | grep "prod" | grep " E " | awk '{print $3}'`
            check_accepted_LMC=`cat LMC-list-accepted | grep -c $IA_LMC`
            
	    if [ $check_accepted_LMC -eq 0 ]; then
                echo "LMC not supported, moved to manual handling"
                check_route_wn=`echo "CHECK: LMC from iaddress not accepted or not in robot scope, moved to manual handling, $check_accepted_LMC"`
		g=0;
            else
		clonecheck=`eivc-site-info $tOvt | grep -v "(" | grep " E " | grep $LMC1 | grep $CompanyEA | wc -l`
		echo -e " eivc-site-info $tOvt | grep -v '(' | grep ' E ' | grep $LMC1 | grep $CompanyEA | wc -l"
	    	if [ $clonecheck -eq 0 ]; then

                	echo ready to set validation
			g=1;
                	oldchanel=`eivc-site-info $tOvt | grep $IA_LMC | awk '{print $1}'`
		
			eivc-site-addr-modify --id $oldchanel --validto $tDate -t $tTask
                	add_routing
                	valid_from
			check_route_wn=`echo -e "OK: New routing has been added"`


		else
			echo open routing for ordered LMC exists
			check_route_wn=`echo -e "OK: Open routing exists, no action required"`
			g=1;
		fi

            fi

elif [ $site_check -eq 0 ]; then

	echo clean site ready to add routing
        add_routing
        valid_from
	g=1;
	check_route_wn=`echo -e "OK: New routing has been added"`

else
	echo some routing awaiting
	check_route_wn=`echo -e "CHECK: two unsupporting active routings, moved to manual handling"`
	g=0;

fi


}

#last checkpoint part

iaddrsum()
{
	iaddrcolR=`eivc-site-info $tOvt | grep " E " | grep -v "(" | grep "$CompanyEA" | wc -l`

	echo "sum iaddr: record $iaddrcolR"


	if [ $iaddrcolR -eq 1 ]
	then

        echo -e "######################### summary ##############################"
        echo -e "           correct routing in iaddress                          "
        echo "PMTASK:                                $tTask"
        echo "OVT Code:                              $tOvt"
        urlIA=`echo Iaddres link : $(eivc-site-info $tOvt | grep "Site id:" | awk '{print $3}' | gxargs -i echo "https://iaddress.itella.net/eivc-ui/hd/site-edit.htm?siteId={}")`
        echo "$urlIA "
	h=1;
	lastwarn_wn=`echo -e "OK: final routing checked, $urlIA"`
	else
	        	echo " WARNING: please check iaddress, routing not found"
	urlIA=`echo Iaddres link : $(eivc-site-info $tOvt | grep "Site id:" | awk '{print $3}' | gxargs -i echo "https://iaddress.itella.net/eivc-ui/hd/site-edit.htm?siteId={}")`
        echo "$urlIA "
				h=0;
			        lastwarn_wn=`echo -e "CHECK: moved to manual handling, $urlIA"`
	fi

}

closechecks()
{
echo "a : $a  $ovtwarn"
echo "b : $b  $worknotes"
echo "c : $c  $ea_check"
echo "d : $d  $LMC_wn"
echo "e : $e  $worknotes1"
echo "f : $f  $worknotes2"
echo "g : $g  $check_route_wn"



		if [ "$a" -eq "1" ] && [ "$b" -eq "1" ] && [ "$c" -eq "1" ] && [ "$d" -eq "1" ]&& [ "$e" -eq "1" ]&& [ "$f" -eq "1" ]&& [ "$g" -eq "1" ] && [ "$h" -eq "1" ]
			then
			echo "ready to close"
csinfo="$(cat <<-EOF
CONFIRMED by robot, please check following information \n\r $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn \n\r $worknotes1 \n\r $worknotes2 \n\r $check_route_wn \n\r $lastwarn_wn
EOF
                )"
                echo "$csinfo"

			#csinfo=`echo -e "CONFIRMED by robot, please check following information \n\r | $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn \n\r $worknotes1 \n\r $worknotes2 \n\r $check_route_wn"`
			echo "$csinfo"
				/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes "${csinfo}"
				#/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${csinfo}"	
				/home/elpp/slomaba1/HAL/change_priority2.py $tTaskID
				#assigntoHAL

				echo "checking time: $CTIME , STATUS INFO: CORRECT: $tTask $tOvt ${tCustomerName} $urlIA "  >> /home/elpp/rparobot/RR/logs/RRlogs
				#closedcomplete
		else

csinfo="$(cat <<-EOF
moved to manual handling, please check following information \n\r $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn \n\r $worknotes1 \n\r $worknotes2 \n\r $check_route_wn \n\r $lastwarn_wn
EOF
                )"
                echo "$csinfo"
						echo " Need to be checked by customer service "
						#csinfo=`echo -e "moved to manual handling, please check following information \n\r $ovtwarn \n\r $worknotes \n\r $ea_check \n\r $LMC_wn \n\r $worknotes1 \n\r $worknotes2 \n\r $check_route_wn"`
						echo "$csinfo"
						echo "$CTIME , STATUS INFO: CSCHECK: $tTask $tOvt ${tCustomerName} $urlIA " >> /home/elpp/rparobot/RR/logs/RRlogs
						#/home/elpp/slomaba1/HAL/worknotes_prod.py $tTaskID "${csinfo}"
						/home/elpp/rparobot/RR/adapters/routing_request_adapter.py $tTaskID --worknotes "${csinfo}"
						/home/elpp/slomaba1/HAL/change_priority3.py $tTaskID

		fi

}


requirements()
{
echo setup documentation will be here


}

robotitems()
{
robot=1;
	snc
        checkbox
        ovt_check
        ytj_check
        namecompare
        eadress_check
        LMCprecheck
	checkpoint1
        checkin_iaddress
        set_routings
        iaddrsum
        closechecks


}


robot()
{

	# collecting routing requests task tickets
	/home/elpp/rparobot/RR/adapters/routing_request_adapter.py something --get_tasklist > /home/elpp/rparobot/RR/tasklist.tmp


	echo
        RR_tasklist=`cat /home/elpp/rparobot/RR/tasklist.tmp | wc -l`
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

	cat /home/elpp/rparobot/RR/tasklist.tmp | awk '{print $2}' | while read tTask; do robotitems; done

	echo "======== The amount of routing requests orders processed by the robot : $RR_tasklist  ========"
	echo "# batch end from $logdate : $RR_tasklist orders processed by robot  #" >> /home/elpp/rparobot/RR/logs/RRlogs

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
			robot=0;
                        snc
                       	checkbox
                       	ovt_check
                       	ytj_check
                       	namecompare
                       	eadress_check
		       	LMCprecheck
			checkpoint1
			checkin_iaddress
			set_routings
			iaddrsum
			closechecks
			

                       	exit
                        ;;
                --requirements | -q)
                        requirements
                        exit
                        ;;
		
        esac
        shift
done

