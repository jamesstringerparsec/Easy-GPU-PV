# Easy-GPU-P
A Project dedicated to making GPU Partitioning on Windows easier!

WARNING: An extreme work in progress...

Requirements...Hyper V feature added to Windowes 10, most likely your Windows 10 updated to 21h1, and a single Desktop NVIDIA GPU (not a laptop GPU).

# How to use the file copier
1. You must create a Win10 VM using the same Windows 10 Version that your host is currently running (Eg. If you're using 21H1, your client needs to VM needs to be 21H1).  Needs to have at least 1GB free space in order for drivers to be added
2. Set up the VM with username and password etc, let it get all the way to the desktop
4. Shutdown the VM
5. Open Disk Management on the Hyper V host
6. Mount the VHD that is associated with the VM
7. Assign the largest partition of the mounted VHD a driver letter, F: for example if it's not already in use.
8. Make sure you can view drive in file explorer, see the Windows\Program Files etc folders.
9. Open Powershell ISE as Administrator on the Hyper V host
10. Open the CopyFilesToVM.ps1 file and change the drive letter if required to match your mounted VHD
11. Run the script
12. Unassign the Drive letter using Disk Management, and dismount the VHD.  You may have to reboot the host in order for it to correctly dismount.
13. Run the GPU Patition adding script in Powershell on the HyperV host
14. ???
15. Profit!
