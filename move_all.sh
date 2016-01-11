#This script uses the PPscp script to copy all files.
userName=$1
server=$2
loc=$3

for x in `ls -l |awk '{ print $9}'|grep -v ppscp|grep -v all_folder.sh`
 do
        echo "$x"
		./ppscp.sh $userName $server $loc $x
 done
