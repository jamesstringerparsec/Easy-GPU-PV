# Interactive-Easy-GPU-PV 
A work-in-progress fork of [jamesstringerparse Easy-GPU-PV repository](https://github.com/jamesstringerparsec/Easy-GPU-PV). The goal of the project is to simplify the entire process as much as possible. The main script is interactive, so users don't have to define any parameters in advance. Instead, parameters can be chosen while the script is running, making the process much easier.

![Administrator_-PowerShell-2023-03-21-16-38-00](https://user-images.githubusercontent.com/77991615/226651194-032db39b-291a-4cd4-a231-da5a215c9eee.gif)

***The following text is primarily taken from the original Easy-GPU-PV project. I've made some modifications and improvements to ensure that it accurately reflects the current state of the project and provides relevant information.***

GPU-PV allows you to partition your systems dedicated or integrated GPU and assign it to several Hyper-V VMs.  It's the same technology that is used in WSL2, and Windows Sandbox.  

Interactive-Easy-GPU-PV aims to make this easier by automating the steps required to get a GPU-PV VM up and running.  
This project provides the following...  
1) Creates a VM of your choosing
2) Automatically Installs Windows to the VM
3) Partitions your GPU of choice and copies the required driver files to the VM  
4) Installs [Parsec](https://parsec.app) to the VM, Parsec is an ultra low latency remote desktop app, use this to connect to the VM.  You can use Parsec for free non commercially. To use Parsec commercially, sign up to a [Parsec For Teams](https://parsec.app/teams) account  
5) Configures Microsoft Remote Desktop to provide 3D accelerated remote session. Note that 3D acceleration during a Microsoft RDP remote session isn't that perfomance as Parsec Remote Desktop session is.

### Prerequisites:
* A desktop computer running Windows 10 20H1+ Pro, Enterprise, or Education, or Windows 11 Pro, Enterprise, or Education, or Windows Server 2022. Windows 11 or Windows Server 2022 is preferred for better compatibility. The host and VM must have matching Windows versions, as mismatches can cause compatibility issues, blue-screens, or other problems. For example, Win10 21H1 + Win10 21H1 or Win11 21H2 + Win11 21H2.
* PC with dedicated NVIDIA/AMD GPU or integrated Intel GPU. Laptops with NVIDIA GPUs are currently not supported, but Intel integrated GPUs work on laptops. The GPU must support hardware video encoding (NVIDIA NVENC, Intel Quicksync, or AMD AMF).
* The latest GPU driver from [Intel.com](https://www.intel.com/content/www/us/en/search.html#sort=relevancy&f:@tabfilter=[Downloads]&f:@stm_10385_en=[Graphics]) or [AMD.com](https://www.amd.com/en/support) or [NVIDIA.com](https://www.nvidia.com/download/index.aspx)  (for desktop NVIDIA GPUs, only the GameReady driver is supported). Do not rely on Device Manager or Windows Update to install the driver. It's important to ensure that you have the latest driver installed to avoid compatibility issues and ensure optimal performance.
* Latest Windows 10 ISO [downloaded from here](https://www.microsoft.com/en-gb/software-download/windows10ISO) / Windows 11 ISO [downloaded from here.](https://www.microsoft.com/en-us/software-download/windows11) - Do not use Media Creation Tool, if no direct ISO link is available, follow [this guide.](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus)
* Virtualisation enabled in the motherboard and [Hyper-V fully enabled](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) on the Windows 10/ 11 OS (requires reboot).  
* Allow Powershell scripts to run on your system - typically by running "Set-ExecutionPolicy unrestricted" in Powershell running as Administrator.  

### Instructions
To get started with Interactive-Easy-GPU-PV, follow these steps:
1) Make sure your system meets all the prerequisites mentioned in the documentation.
2) Download the [Interactive-Easy-GPU-PV repository](https://github.com/jamesstringerparsec/Easy-GPU-PV/archive/refs/heads/main.zip) and extract it to a folder on your computer. You can download it from the project's GitHub page.
3) Search for Powershell ISE on your computer and run it as Administrator.
4) Navigate to the extracted folder you downloaded and run the interactive script named "GPUP-management.ps1". Select "Create new VM with GPU acceleration" when prompted and set any required parameters. The script will start creating the VM, which may take 5-10 minutes depending on your system.
5) Once the VM is created, open and sign into Parsec on the VM. You can use Parsec to connect to the VM at up to 4K60FPS.
6) You're all set, enjoy!

### Upgrading VM GPU Drivers after you update the host GPU Drivers
To ensure proper functioning of the VM, it's important to update the GPU drivers inside the VM after updating the drivers on the host machine. To do this, follow these steps:
1) After updating the GPU drivers on the host machine, reboot it.
2) Open Powershell as an administrator, navigate to the extracted folder of the Interactive-Easy-GPU-PV repo and run the interactive script GPUP-management.ps1.
3) Select action 3: Copy GPU Drivers from Host to VM. This will copy the updated GPU drivers from the host machine to the VM.


### Thanks to:  
- [jamesstringerparsec](https://github.com/jamesstringerparsec/Easy-GPU-PV) for creating EASY-GPU-PV project that was taken as a base as well as main part of this readme
- [Hyper-ConvertImage](https://github.com/tabs-not-spaces/Hyper-ConvertImage) for creating an updated version of [Convert-WindowsImage](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage) that is compatible with Windows 10 and 11.
- [gawainXX](https://github.com/gawainXX) for help [jamesstringerparsec](https://github.com/jamesstringerparsec/Easy-GPU-PV) testing and pointing out bugs and feature improvements.  


### Notes:    
- If you install Parsec Virtual Display Driver (Parsec VDD), after you have signed into Parsec on the VM, always use Parsec to connect to the VM. Keep the Microsft Hyper-V Video adapter disabled. Using RDP and Hyper-V Enhanced Session mode will result in broken behaviour and black screens in Parsec. Using Parsec will allow you to use up to 4k60 FPS. 
- If you get "ERROR  : Cannot bind argument to parameter 'Path' because it is null." this probably means you used Media Creation Tool to download the ISO.  You unfortunately cannot use that, if you don't see a direct ISO download link at the Microsoft page, follow [this guide.](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus)  
- Your GPU on the host will have a Microsoft driver in device manager, rather than an nvidia/intel/amd driver. As long as it doesn't have a yellow triangle over top of the device in device manager, it's working correctly.  
- A powered on display / HDMI dummy dongle must be plugged into the GPU to allow Parsec to capture the screen.  You only need one of these per host machine regardless of number of VM's.
- If your computer is super fast it may get to the login screen before the audio driver (VB Cable) and Parsec display driver are installed, but fear not! They should soon install.  
- The screen may go black for times up to 10 seconds in situations when UAC prompts appear, applications go in and out of fullscreen and when you switch between video codecs in Parsec - not really sure why this happens, it's unique to GPU-P machines and seems to recover faster at 1280x720.
- Vulkan renderer is unavailable and GL games may or may not work.  [This](https://www.microsoft.com/en-us/p/opencl-and-opengl-compatibility-pack/9nqpsl29bfff?SilentAuth=1&wa=wsignin1.0#activetab=pivot:overviewtab) may help with some OpenGL apps.  
- If you do not have administrator permissions on the machine it means you set the username and vmname to the same thing, these needs to be different.  
- AMD Polaris GPUS like the RX 580 do not support hardware video encoding via GPU Paravirtualization at this time.  
- To download Windows ISOs with Rufus, it must have "Check for updates" enabled.
Dd acceleration with Parsec VDD
