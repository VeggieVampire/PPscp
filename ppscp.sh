#  *****Z
#
# Pre Post SCP
#
# Author Nick Farrow
#  farrow.nick@gmail.com
# 
# Initial Release: 1


# $0 is the name of the command
# $1 first parameter
# $2 second parameter
# $3 third parameter etc. etc
# $# total number of parameters
# $@ all the parameters will be listed

userName=$1
server=$2
loc=$3
filename=$4



#checks if user entered info
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


echo $filename

#md5 string maker
md5precheck=$(md5sum $filename|awk '{print $1}')

echo $md5precheck

#scp file
# scp foobar.txt your_username@remotehost.edu:/some/remote/directory

scp $filename $userName@$server:$loc/$filename
#scp $filename osmc@$server:/home/$USER/$filename

#Gets remote md5 of the file
#md5postcheck= $(ssh -q $USER@$server "md5sum $loc/$filename|awk '{print $1}'")
md5postcheck=$(ssh -q $userName@$server "md5sum $loc/$filename"|awk '{print $1}')
echo $md5postcheck

#192.168.1.135
#md5 check remote

#

#checks if md5 local is the same as md5 remote
if [ $md5precheck == $md5postcheck ]
then
    echo "md5 pass"
else
echo $md5postcheck
echo "md5 remote doesn't match local for" $filename
ssh -q $userName@$server "rm -rf $loc/$filename"
echo "file" $filename "deleted!"
exit 1
fi

