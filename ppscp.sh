#
# Pre Post SCP
#
# Author Nick Farrow
# 
# Initial Release: 2.0



userName=$1
server=$2
loc=$3
filename=$4



#checks if user entered anything at all
if [ -z "$filename" ]
then
  echo "Missing file name!!!!!!!!"
  echo "example:" 
  echo "./ppscp.sh RemoteUserName RemoteServerName RemoteLocation LocalFileName"
  exit 1
else
  echo $filename "passed"
fi 

#check if file is really there
if [ -e "$filename" ]; then
	echo "File exists!"
else
	echo "File not found on localhost"
	exit 1
fi

#creates a md5 hash for local file aka PRE
echo "PreHash check"
md5precheck=$(md5sum $filename|awk '{print $1}')

echo $md5precheck
#tarring the file to save integrity also compressing
echo "tarring file...."
filetar=$filename.tgz
tar -zcvf  $filetar $filename --atime-preserve

#split file  for easier transfer 
echo "Splitting file for easier transfer by 3.2M"
split -b 3276800 -d $filetar $filetar.

#get count - 2 files
a=$((($(ls -l |grep $filetar|wc -l)) - 2))
#start count
b=0

#starting the main loop
while [ $a -ge $b ]
do
   if [ $b -ge 10 ]
	then
			#no need for zeros now
			newfilename=$(ls|grep $filetar.$b)

			#creates a md5 hash for local file aka PRE
			#SubPreHash check"
			subMD5precheck=$(md5sum $newfilename|awk '{print $1}')
			echo $subMD5precheck
			#copy over a file
			scp $newfilename $userName@$server:$loc/$newfilename
			#Gets remote md5 hash of the copied file aka POST
			subMD5postcheck=$(ssh -q $userName@$server "md5sum $loc/$newfilename"|awk '{print $1}')
			echo $subMD5postcheck
			#Check sub file MD5 integrity
			if [ $subMD5precheck == $subMD5postcheck ]
			then
				#Pass
					echo "MD5 integrity check successful for sub file"
					echo "removing local sub file"
					rm -rf $newfilename
			else
				#Failed
					echo "MD5 integrity check FAILED! But don't worry.."
					echo "MD5 remote doesn't match local for" $newfilename
					ssh -q $userName@$server "rm -rf $loc/$newfilename"
					echo "file" $newfilename "deleted"
					echo "Trying to scp the sub file again"
					scp $newfilename $userName@$server:$loc/$newfilename
			fi
						
	else
			#you need to add your zeros 
			newfilename=$(ls|grep $filetar.0$b)

			#creates a md5 hash for local file aka PRE
			#SubPreHash check"
			subMD5precheck=$(md5sum $newfilename|awk '{print $1}')				
			echo $subMD5precheck
			scp $newfilename $userName@$server:$loc/$newfilename
			#Gets remote md5 hash of the copied file aka POST
			subMD5postcheck=$(ssh -q $userName@$server "md5sum $loc/$newfilename"|awk '{print $1}')
			echo $subMD5postcheck
			#Check sub file MD5 integrity
			if [ $subMD5precheck == $subMD5postcheck ]
			then
				#Pass
					echo "MD5 integrity check successful for sub file"
					#echo "removing local sub file"
					rm -rf $newfilename
			else
				#Failed
					echo "MD5 integrity check FAILED! But don't worry.."
					echo "MD5 remote doesn't match local for" $newfilename
					ssh -q $userName@$server "rm -rf $loc/$newfilename"
					echo "file" $newfilename "deleted"
					echo "Trying to scp the sub file again"
					scp $newfilename $userName@$server:$loc/$newfilename
			fi
			
			
			
			
	fi
   b=`expr $b + 1`
done


echo "....................each sub file is on remote host......"

#Joining the files
echo "Joining the files, this might take a while"
ssh -q $userName@$server "sh -c 'cat $loc/$filetar.* > $loc/$filetar'"

#Untarring the file to save integrity also compressing
ssh -q $userName@$server "tar -zxvf $loc/$filetar -C $loc"
echo "Untarring" $filename
#ssh -q $userName@$server "md5sum $loc/$filename"|awk '{print $1}'

#removing sub files local and remote
rm -rf $filename.*
ssh -q $userName@$server "rm -rf $loc/$filetar*"

#Gets remote md5 hash of the copied file aka POST
MD5postcheck=$(ssh -q $userName@$server "md5sum $loc/$filename"|awk '{print $1}')

echo "PRE:	"$md5precheck
echo "POST:	"$MD5postcheck
#checks if md5 local is the same as md5 remote
if [ $md5precheck == $MD5postcheck ]
then
#Pass
	echo '..................................................................'
    echo "................MD5 integrity check successful!................"
	echo '..................................................................'
	#enable line below to fully transfer from localhost
    #rm -rf $filename
else
#Failed
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "MD5 integrity check FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "md5 remote doesn't match local for" $filename
	ssh -q $userName@$server "rm -rf $loc/$filename"
	echo "file" $filename "deleted!"
	exit 1
fi


