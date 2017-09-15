# PPscp
The script stands for "Pre-Post-Secure-Copy" It checks a file integrity before transfer with a MD5 HASH sum, then RARs and breaks up the file into a more manageable chunks for the SCP. If it fails to transfer or individual chunk or has the wrong hash it deletes the remote file and tries again. When it finishes the script unrars and combines the file and makes sure it has the same HASH has before the transfer.
<br>
This is perfect for transferring large files (Gigabytes) on less than stable networks tha can handle less than 1 Megabyte transfers.



# Install 
sudo apt-get install -y git <br>
git clone https://github.com/VeggieVampire/PPscp <br>

cd PPscp <br>
chmod 777 * <br>

mv ./ppscp.sh LocalLOCATION

# Key Setup <br>
ssh-keygen -t rsa<br>
cd ~<br>
ssh $USER@RemoteServerName mkdir -p .ssh<br>
cat .ssh/id_rsa.pub | ssh $USERE@RemoteServerName 'cat >> .ssh/authorized_keys'<br>

# Run
After moving ppscp.sh to the folder where your file is located. run command below.<br>
ppscp.sh RemoteUserName RemoteServerName RemoteLocation LocalFileName<br>


Do not use SPACES!!!! bug found in the code. 
