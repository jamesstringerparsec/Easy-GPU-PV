# Easy-GPU-P
A Project dedicated to making GPU Partitioning on Windows Hyper-V easier! Also known as GPU Paravirtualization (GPU-PV).  

GPU-P allows you to partition your systems dedicated or integrated GPU and assign it to several Hyper-V VMs.  It's the same technology that is used in WSL2, and Windows Sandbox.  

Easy-GPU-P aims to make this easier by automating the steps required to get a GPU-P VM up and running.  
Easy-GPU-P does the following...  
1) Creates a VM of your choosing
2) Automatically Installs Windows 11 to the VM
3) Partitions your GPU of choice and copies the required driver files to the VM  
4) Installs Parsec to the VM  


WARNING: A work in progress...

### Prerequisites:
* Windows 11 Pro or Enterprise
* Desktop Computer with dedicated NVIDIA/AMD GPU or Integrated Intel GPU - Laptops with NVIDIA GPUs are not supported at this time, but Intel integrated GPUs work on laptops.  GPU must support hardware video encoding (NVIDIA NVENC, Intel Quicksync or AMD AMF).
* Latest GPU driver from Intel.com or NVIDIA.com, don't rely on Device manager or Windows update.
* Windows 11 ISO [downloaded from here](https://www.microsoft.com/en-us/software-download/windows11)
* Virtualisation enabled in the motherboard and Hyper-V fully enabled on the Windows 11 OS (requires reboot)
* Allow Powershell scripts to run on your system - typically by running "Set-ExecutionPolicy unrestricted" in Powershell

### Instructions
1. Make sure your system meets the prerequisits.
2. [Download the Repo and extract.](https://github.com/jamesstringerparsec/Easy-GPU-P/archive/refs/heads/main.zip)
3. Search your system for Powershell ISE and run as Administrator.
4. In the extracted folder you downloaded, open PreChecks.ps1 in Powershell ISE (It must be Powershell ISE or Powershell 5.X)
5. Open and Run PreChecks.ps1 in Powershell ISE using the green play button and copy the GPU Listed (or the warnings that you need to fix).
6. Open CopyFilesToVM.ps1 and edit the params section at the top of the file, you need to be careful about how much ram, storage and hard drive you give it as you system needs to have that available.  You also need to write the GPU name exactly how it appears in PreChecks.ps1.  Additionally, you need to provide the path to the Windows 11 ISO file you downloaded.
7. Run CopyFilesToVM.ps1 with your changes to the params section - this may take 5-10 minutes.
8. View the VM in Hyper-V, once it gets to the Windows Desktop you will need to approve the certificate install request for Parsec and Virtual Audio Cable
9. Sign into Parsec on the VM.
10. You should be good to go!


Thanks to [Hyper-ConvertImage](https://github.com/tabs-not-spaces/Hyper-ConvertImage) for creating an updated version of [Convert-WindowsImage](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage) that is compatible with Windows 10 and 11.

### Notes:  
VM password is CoolPassword!:) but you can change it inside the autounattend.xml file for now, it's in two areas, so make sure to replace it in both.  
