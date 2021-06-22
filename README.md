# Easy-GPU-P
A Project dedicated to making GPU Partitioning on Windows easier!

WARNING: An extreme work in progress...

Requirements...Hyper V feature added to Windows 10, most likely your Windows 10 updated to 21h1, and a single Desktop NVIDIA GPU (not a laptop GPU).

# How to use the file copier
1. Create a VM WITHOUT adding a disk.  You must create a Win10 VM using the same Windows 10 Version that your host is currently running (Eg. If you're using 21H1, your client needs to VM needs to be 21H1).  
2. Once you have created the VM without a disk, create a new disk in Hyper V, make sure it's FIXED Size! Make it at least 40GB to be safe.
3. Edit the VM settings, disable checkpoints! 
4. Add the Disk you created to the VM, along with a DVD drive pointing to the Win10 ISO file.
5. You may need to reconfigure the boot order to put the dvd drive on top.
6. Set up the VM with username and password etc, let it get all the way to the desktop
7. Shutdown the VM
8. Open Disk Management on the Hyper V host
9. Mount the VHD that is associated with the VM
10. Assign the largest partition of the mounted VHD a driver letter, F: for example if it's not already in use.
11. Make sure you can view drive in file explorer, see the Windows\Program Files etc folders.
12. Open Powershell ISE as Administrator on the Hyper V host
13. Open the CopyFilesToVM.ps1 file and change the drive letter if required to match your mounted VHD
14. Run the script
15. Unassign the Drive letter using Disk Management, and dismount the VHD.  You may have to reboot the host in order for it to correctly dismount.
16. Run the GPU Patition adding script in Powershell on the HyperV host
17. ???
18. Profit!
