##########################
# created by Nick Farrow #
##########################
RED='\033[0;31m'        #RED
GREEN='\033[0;32m' #GREEN
YELLOW='\033[0;33m' #YELLOW
NC='\033[0m' # No Color

usr=$1
srv=$2
remloc=$3
loc=$4

cd $loc

ls -1a |grep -v srt > found.media
sed 1d found.media > found.media2
sed 1d found.media2 > found.media

rm -rf found.media2
		##sed s/"("/"\("/ < found.media > found.media2
		##cp found.media2 found.media
		##sed s/" "/"\ "/ < found.media > found.media2
		##cp found.media2 found.media
		##sed s/")"/"\)"/ < found.media > found.media2
		##cp found.media2 found.media

#cat found.media

IFS=$'\n' 


#Hash checking
for filename in `cat found.media`
 do

		
		PreHASHcheck=$(sha1sum $filename|awk '{print $1}')
		
		RemoteFile=$(ssh -q $usr@$srv "ls $remloc|grep '$filename'")
		#checks if remote file is on server
		if [ -e "$RemoteFile" ]; then
		PostHASHcheck=$(ssh -q $usr@$srv "sha1sum $remloc/'$filename'"|awk '{print $1}')
			if [ $PreHASHcheck == $PostHASHcheck ];then
			#Pass
				printf "${GREEN} PASSED ${NC} $filename\n"
			else
			#Failed
				printf "${RED} FAILED ${NC} $filename\n"
				#exit 1
			fi
else
		#File not found on remote server
		printf "$filename ${RED} NOT FOUND ${NC} on Remote Server\n"
fi
	
 done

rm -rf found.media

