# PPscp
Pre-Post-Secure-Copy checks a file integrity before transfer and after. If it fails deletes the remote file.


To use copy the ppscp.sh to the local location of the file you want to transfer. Then use this example below to run the script it will ask for a password if you do not have your SSH keys setup.

ppscp.sh RemoteUserName RemoteServerName RemoteLocation LocalFileName

Do not use SPACES!!!! bug found in the code. 
