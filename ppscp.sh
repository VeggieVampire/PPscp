#  *****Z
#
# Pre Post SCP
#
# Author Nick Farrow
#  farrow.nick@gmail.com
# 
# Initial Release: 1


userName=$1
server=$2
loc=$3
filename=$4



#checks if user entered any info
if [ -z "$filename" ]
then
  echo "Missing filename"
  exit 1
else
  echo $filename "is NOT null. Good!"
fi 

#check if file is really there
if [ -e "$filename" ]; then
  echo "File exists"
else
echo "File not found on localhost"
exit 1
fi

#creates amd5 hash for local file aka PRE
md5precheck=$(md5sum $filename|awk '{print $1}')

#copies file over
scp $filename $userName@$server:$loc/$filename

#Gets remote md5 hash of the copied file aka POST
md5postcheck=$(ssh -q $userName@$server "md5sum $loc/$filename"|awk '{print $1}')

#checks if md5 local is the same as md5 remote
if [ $md5precheck == $md5postcheck ]
then
#Pass
    echo "MD5 integrity check successful"
else
#Failed
echo "MD5 integrity check FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "md5 remote doesn't match local for" $filename
ssh -q $userName@$server "rm -rf $loc/$filename"
echo "file" $filename "deleted!"
exit 1
fi

