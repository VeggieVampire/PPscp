# PPscp
The script stands for "Pre-Post-Secure-Copy" It checks a file integrity before transfer with a MD5 HASH sum, then RARs and breaks up the file into a more manageable chunks for the SCP. If it fails to transfer or individual chunk or has the wrong hash it deletes the remote file and tries again. When it finishes the script unrars and combines the file and makes sure it has the same HASH has before the transfer.
<br>
This is perfect for transferring large files (Gigabytes) on less than stable networks tha can handle less than 1 Megabyte transfers.



To use copy the ppscp.sh to the local location of the file you want to transfer. Then use this example below to run the script it will ask for a password if you do not have your SSH keys setup.

ppscp.sh RemoteUserName RemoteServerName RemoteLocation LocalFileName

Do not use SPACES!!!! bug found in the code. 
