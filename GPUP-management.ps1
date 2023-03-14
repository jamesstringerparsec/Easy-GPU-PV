#========================================================================
$Global:VM
$Global:VHD
$Global:ServerOS
$Global:StateWasRunning
#========================================================================

#========================================================================
$params = @{
    GPUName = ""
    DriveLetter = ""
    GPUDedicatedResourcePercentage = 100
    VMName = ""
    SourcePath = ""
    Edition    = 6
    VhdFormat  = "VHDX"
    DiskLayout = "UEFI"
    SizeBytes  = 127GB
    MemoryAmount = 4GB
    MemoryMaximum = 32GB
    DynamicMemoryEnabled = $true
    CPUCores = 4
    NetworkSwitch = "Default Switch"
    VMPath = ""
    VHDPath = ""
    Team_ID = ""
    Key = ""
    Username = ""
    Password = ""
    Autologon = $false
    rdp = $true
    Parsec = $true
    CopyRegionalSettings = $true
    ParsecVDD = $false
    NumLock = $true
}
#========================================================================

#========================================================================
[xml]$unattend = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="windowsPE">
    <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SetupUILanguage>
        <UILanguage>en-US</UILanguage>
      </SetupUILanguage>
      <InputLocale>0409:00000409</InputLocale>
      <SystemLocale>en-US</SystemLocale>
      <UILanguage>en-US</UILanguage>
      <UILanguageFallback>en-US</UILanguageFallback>
      <UserLocale>en-US</UserLocale>
    </component>
    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <DiskConfiguration>
        <Disk wcm:action="add">
          <DiskID>0</DiskID>
          <WillWipeDisk>true</WillWipeDisk>
          <CreatePartitions>
            <!-- Windows RE Tools partition -->
            <CreatePartition wcm:action="add">
              <Order>1</Order>
              <Type>Primary</Type>
              <Size>300</Size>
            </CreatePartition>
            <!-- System partition (ESP) -->
            <CreatePartition wcm:action="add">
              <Order>2</Order>
              <Type>EFI</Type>
              <Size>100</Size>
            </CreatePartition>
            <!-- Microsoft reserved partition (MSR) -->
            <CreatePartition wcm:action="add">
              <Order>3</Order>
              <Type>MSR</Type>
              <Size>128</Size>
            </CreatePartition>
            <!-- Windows partition -->
            <CreatePartition wcm:action="add">
              <Order>4</Order>
              <Type>Primary</Type>
              <Extend>true</Extend>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <!-- Windows RE Tools partition -->
            <ModifyPartition wcm:action="add">
              <Order>1</Order>
              <PartitionID>1</PartitionID>
              <Label>WINRE</Label>
              <Format>NTFS</Format>
              <TypeID>DE94BBA4-06D1-4D40-A16A-BFD50179D6AC</TypeID>
            </ModifyPartition>
            <!-- System partition (ESP) -->
            <ModifyPartition wcm:action="add">
              <Order>2</Order>
              <PartitionID>2</PartitionID>
              <Label>System</Label>
              <Format>FAT32</Format>
            </ModifyPartition>
            <!-- MSR partition does not need to be modified -->
            <ModifyPartition wcm:action="add">
              <Order>3</Order>
              <PartitionID>3</PartitionID>
            </ModifyPartition>
            <!-- Windows partition -->
            <ModifyPartition wcm:action="add">
              <Order>4</Order>
              <PartitionID>4</PartitionID>
              <Label>OS</Label>
              <Letter>C</Letter>
              <Format>NTFS</Format>
            </ModifyPartition>
          </ModifyPartitions>
        </Disk>
      </DiskConfiguration>
      <ImageInstall>
        <OSImage>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>4</PartitionID>
          </InstallTo>
          <InstallToAvailablePartition>false</InstallToAvailablePartition>
        </OSImage>
      </ImageInstall>
      <UserData>
        <ProductKey>
          <!-- Do not uncomment the Key element if you are using trial ISOs -->
          <!-- You must uncomment the Key element (and optionally insert your own key) if you are using retail or volume license ISOs -->
          <Key>
          </Key>
          <WillShowUI>Never</WillShowUI>
        </ProductKey>
        <AcceptEula>true</AcceptEula>
        <FullName>GPU-P</FullName>
        <Organization>
        </Organization>
      </UserData>
    </component>
  </settings>
  <settings pass="offlineServicing">
    <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <EnableLUA>true</EnableLUA>
    </component>
  </settings>
  <settings pass="generalize">
    <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SkipRearm>1</SkipRearm>
    </component>
  </settings>
  <settings pass="specialize">
    <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <InputLocale>0409:00000409</InputLocale>
      <SystemLocale>en-US</SystemLocale>
      <UILanguage>en-US</UILanguage>
      <UILanguageFallback>en-US</UILanguageFallback>
      <UserLocale>en-US</UserLocale>
    </component>
    <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SkipAutoActivation>true</SkipAutoActivation>
    </component>
    <component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <CEIPEnabled>0</CEIPEnabled>
    </component>
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ComputerName>GPUP122</ComputerName>
      <ProductKey>W269N-WFGWX-YVC9B-4J6C9-T83GX</ProductKey>
    </component>
  </settings>
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <AutoLogon>
        <Password>
          <Value>CoolestPassword!</Value>
          <PlainText>true</PlainText>
        </Password>
        <Enabled>true</Enabled>
        <Username>GPUVM</Username>
      </AutoLogon>
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Home</NetworkLocation>
        <SkipUserOOBE>true</SkipUserOOBE>
        <SkipMachineOOBE>true</SkipMachineOOBE>
        <ProtectYourPC>1</ProtectYourPC>
      </OOBE>
      <Display>
        <ColorDepth>32</ColorDepth>
        <HorizontalResolution>1920</HorizontalResolution>
        <RefreshRate>60</RefreshRate>
        <VerticalResolution>1080</VerticalResolution>
      </Display>
      <UserAccounts>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            <Password>
              <Value>CoolestPassword!</Value>
              <PlainText>true</PlainText>
            </Password>
            <Description>
            </Description>
            <DisplayName>GPUVM</DisplayName>
            <Group>Administrators</Group>
            <Name>GPUVM</Name>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>
      <RegisteredOrganization>
      </RegisteredOrganization>
      <RegisteredOwner>GPU-P</RegisteredOwner>
      <DisableAutoDaylightTimeSet>false</DisableAutoDaylightTimeSet>
      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Description>Allow Scripts</Description>
          <Order>1</Order>
          <CommandLine>reg add HKLM\Software\Policies\Microsoft\Windows\Powershell</CommandLine>
          <RequiresUserInput>false</RequiresUserInput>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Description>Allow Scripts</Description>
          <Order>2</Order>
          <CommandLine>reg add HKLM\Software\Policies\Microsoft\Windows\Powershell /v ExecutionPolicy /t REG_SZ /d Unrestricted</CommandLine>
          <RequiresUserInput>false</RequiresUserInput>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Description>Allow Scripts</Description>
          <Order>3</Order>
          <CommandLine>reg add HKLM\Software\Policies\Microsoft\Windows\Powershell /v EnableScripts /t REG_DWORD /d 1</CommandLine>
          <RequiresUserInput>false</RequiresUserInput>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>4</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>cmd /C wmic useraccount where name="GPU-P" set PasswordExpires=false</CommandLine>
          <Description>Password Never Expires</Description>
        </SynchronousCommand>
      </FirstLogonCommands>
      <TimeZone>GTB Standard Time</TimeZone>
    </component>
  </settings>
</unattend>
"@
#========================================================================

#========================================================================
$ParsecLnk = (
    76, 0, 0, 0, 1, 20, 2, 0, 0, 0, 0, 0, 192, 0, 0, 0, 0, 0, 0, 70, 219, 64, 8, 0, 32, 0, 0, 0, 0, 36, 210, 154, 63, 198, 213, 1, 42, 9, 123, 54, 220, 199, 213, 1, 0, 36, 210, 
    154, 63, 198, 213, 1, 72, 12, 6, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 1, 20, 0, 31, 80, 224, 79, 208, 32, 234, 58, 105, 16, 162, 216, 8, 0, 
    43, 48, 48, 157, 25, 0, 47, 67, 58, 92, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 140, 0, 49, 0, 0, 0, 0, 0, 45, 80, 20, 189, 17, 0, 80, 82, 79, 71, 82, 65, 
    126, 49, 0, 0, 116, 0, 9, 0, 4, 0, 239, 190, 115, 78, 150, 38, 45, 80, 20, 189, 46, 0, 0, 0, 179, 30, 4, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 0, 0, 0, 0, 0, 4, 233,
    16, 0, 80, 0, 114, 0, 111, 0, 103, 0, 114, 0, 97, 0, 109, 0, 32, 0, 70, 0, 105, 0, 108, 0, 101, 0, 115, 0, 0, 0, 64, 0, 115, 0, 104, 0, 101, 0, 108, 0, 108, 0, 51, 0, 50, 
    0, 46, 0, 100, 0, 108, 0, 108, 0, 44, 0, 45, 0, 50, 0, 49, 0, 55, 0, 56, 0, 49, 0, 0, 0, 24, 0, 84, 0, 49, 0, 0, 0, 0, 0, 46, 80, 87, 144, 16, 0, 80, 97, 114, 115, 101, 99,
    0, 0, 62, 0, 9, 0, 4, 0, 239, 190, 42, 80, 78, 140, 46, 80, 87, 144, 46, 0, 0, 0, 77, 179, 13, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 193, 86, 87, 0, 80, 
    0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 0, 0, 22, 0, 98, 0, 50, 0, 72, 12, 6, 0, 40, 80, 156, 130, 32, 0, 112, 97, 114, 115, 101, 99, 100, 46, 101, 120, 101, 0, 72, 0, 9, 
    0, 4, 0, 239, 190, 40, 80, 156, 130, 42, 80, 79, 140, 46, 0, 0, 0, 172, 161, 1, 0, 0, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 0, 97, 0, 114, 0, 
    115, 0, 101, 0, 99, 0, 100, 0, 46, 0, 101, 0, 120, 0, 101, 0, 0, 0, 26, 0, 0, 0, 84, 0, 0, 0, 28, 0, 0, 0, 1, 0, 0, 0, 28, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 83, 0, 0, 0, 19,
    0, 0, 0, 3, 0, 0, 0, 32, 219, 249, 164, 16, 0, 0, 0, 79, 83, 0, 67, 58, 92, 80, 114, 111, 103, 114, 97, 109, 32, 70, 105, 108, 101, 115, 92, 80, 97, 114, 115, 101, 99, 92, 
    112, 97, 114, 115, 101, 99, 100, 46, 101, 120, 101, 0, 0, 50, 0, 46, 0, 46, 0, 92, 0, 46, 0, 46, 0, 92, 0, 46, 0, 46, 0, 92, 0, 46, 0, 46, 0, 92, 0, 46, 0, 46, 0, 92, 0, 46,
    0, 46, 0, 92, 0, 80, 0, 114, 0, 111, 0, 103, 0, 114, 0, 97, 0, 109, 0, 32, 0, 70, 0, 105, 0, 108, 0, 101, 0, 115, 0, 92, 0, 80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 92,
    0, 112, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 100, 0, 46, 0, 101, 0, 120, 0, 101, 0, 24, 0, 67, 0, 58, 0, 92, 0, 80, 0, 114, 0, 111, 0, 103, 0, 114, 0, 97, 0, 109, 0, 32, 
    0, 70, 0, 105, 0, 108, 0, 101, 0, 115, 0, 92, 0, 80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 92, 0, 35, 0, 67, 0, 58, 0, 92, 0, 80, 0, 114, 0, 111, 0, 103, 0, 114, 0, 97, 0, 
    109, 0, 32, 0, 70, 0, 105, 0, 108, 0, 101, 0, 115, 0, 92, 0, 80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 92, 0, 112, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 100, 0, 46, 0,
    101, 0, 120, 0, 101, 0, 36, 2, 0, 0, 9, 0, 0, 160, 145, 0, 0, 0, 49, 83, 80, 83, 237, 48, 189, 218, 67, 0, 137, 71, 167, 248, 208, 19, 164, 115, 102, 34, 117, 0, 0, 0, 100, 
    0, 0, 0, 0, 31, 0, 0, 0, 49, 0, 0, 0, 101, 0, 108, 0, 101, 0, 99, 0, 116, 0, 114, 0, 111, 0, 110, 0, 32, 0, 40, 0, 67, 0, 58, 0, 92, 0, 85, 0, 115, 0, 101, 0, 114, 0, 115, 
    0, 92, 0, 74, 0, 97, 0, 109, 0, 101, 0, 115, 0, 92, 0, 65, 0, 112, 0, 112, 0, 68, 0, 97, 0, 116, 0, 97, 0, 92, 0, 82, 0, 111, 0, 97, 0, 109, 0, 105, 0, 110, 0, 103, 0, 92, 0, 
    80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 173, 0, 0, 0, 49, 83, 80, 83, 48, 241, 37, 183, 239, 71, 26, 16, 165, 241, 2, 96, 140, 158, 235,
    172, 41, 0, 0, 0, 10, 0, 0, 0, 0, 31, 0, 0, 0, 11, 0, 0, 0, 112, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 46, 0, 101, 0, 120, 0, 101, 0, 0, 0, 0, 0, 21, 0, 0, 0, 15, 0, 0, 0,
    0, 64, 0, 0, 0, 0, 50, 198, 129, 215, 191, 211, 1, 21, 0, 0, 0, 12, 0, 0, 0, 0, 21, 0, 0, 0, 0, 222, 206, 4, 0, 0, 0, 0, 41, 0, 0, 0, 4, 0, 0, 0, 0, 31, 0, 0, 0, 12, 0, 0, 0, 
    65, 0, 112, 0, 112, 0, 108, 0, 105, 0, 99, 0, 97, 0, 116, 0, 105, 0, 111, 0, 110, 0, 0, 0, 21, 0, 0, 0, 14, 0, 0, 0, 0, 64, 0, 0, 0, 0, 50, 198, 129, 215, 191, 211, 1, 0, 0, 
    0, 0, 161, 0, 0, 0, 49, 83, 80, 83, 166, 106, 99, 40, 61, 149, 210, 17, 181, 214, 0, 192, 79, 217, 24, 208, 133, 0, 0, 0, 30, 0, 0, 0, 0, 31, 0, 0, 0, 58, 0, 0, 0, 67, 0, 58, 
    0, 92, 0, 85, 0, 115, 0, 101, 0, 114, 0, 115, 0, 92, 0, 74, 0, 97, 0, 109, 0, 101, 0, 115, 0, 92, 0, 65, 0, 112, 0, 112, 0, 68, 0, 97, 0, 116, 0, 97, 0, 92, 0, 82, 0, 111, 0,
    97, 0, 109, 0, 105, 0, 110, 0, 103, 0, 92, 0, 80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 92, 0, 101, 0, 108, 0, 101, 0, 99, 0, 116, 0, 114, 0, 111, 0, 110, 0, 92, 0, 112, 
    0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 46, 0, 101, 0, 120, 0, 101, 0, 0, 0, 0, 0, 0, 0, 57, 0, 0, 0, 49, 83, 80, 83, 177, 22, 109, 68, 173, 141, 112, 72, 167, 72, 64, 46, 
    164, 61, 120, 140, 29, 0, 0, 0, 104, 0, 0, 0, 0, 72, 0, 0, 0, 81, 177, 96, 115, 82, 246, 99, 73, 181, 157, 8, 48, 36, 153, 12, 1, 0, 0, 0, 0, 0, 0, 0, 0, 20, 3, 0, 0, 7, 0, 
    0, 160, 37, 80, 114, 111, 103, 114, 97, 109, 70, 105, 108, 101, 115, 37, 92, 80, 97, 114, 115, 101, 99, 92, 112, 97, 114, 115, 101, 99, 100, 46, 101, 120, 101, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 0, 80, 0, 114, 0, 111, 0, 
    103, 0, 114, 0, 97, 0, 109, 0, 70, 0, 105, 0, 108, 0, 101, 0, 115, 0, 37, 0, 92, 0, 80, 0, 97, 0, 114, 0, 115, 0, 101, 0, 99, 0, 92, 0, 112, 0, 97, 0, 114, 0, 115, 0, 101, 0, 
    99, 0, 100, 0, 46, 0, 101, 0, 120, 0, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 16, 0, 0, 0, 5, 0, 0, 160, 38, 0, 0, 0, 185, 0, 0, 0, 28, 0, 0, 0, 11, 0, 0, 160, 182, 99, 94, 144, 191, 193, 78, 73, 178, 156, 101, 183, 50, 211, 210, 26, 185, 
    0, 0, 0, 96, 0, 0, 0, 3, 0, 0, 160, 88, 0, 0, 0, 0, 0, 0, 0, 120, 112, 115, 45, 49, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 0, 98, 213, 14, 9, 15, 74, 140, 92, 196, 116, 224, 
    127, 81, 95, 19, 35, 169, 199, 11, 51, 234, 17, 185, 33, 156, 182, 208, 197, 75, 148, 248, 0, 98, 213, 14, 9, 15, 74, 140, 92, 196, 116, 224, 127, 81, 95, 19, 35, 169, 199, 
    11, 51, 234, 17, 185, 33, 156, 182, 208, 197, 75, 148, 0, 0, 0, 0
)
#========================================================================

#========================================================================
function Write-W2VInfo {
    # Function to make the Write-Host output a bit prettier.
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]
        [ValidateNotNullOrEmpty()]$Object,
        [bool]$NoNewline,
        [Object]$Separator,
        [ConsoleColor]$ForegroundColor,
        [ConsoleColor]$BackgroundColor
    )
    $PSBoundParameters.Object = "INFO:  $($Object)" 
    Write-Host @PSBoundParameters
}
#========================================================================

#========================================================================
function Set-W2VItemProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [Object]$Value,
        [switch]$Force,
        [string]$Filter,
        [string[]]$Include,
        [string[]]$Exclude, 
        [pscredential]$Credential, 
        [string]$Type,
        [object]$CommonParameters
    )
    if ((Test-Path $path) -eq $false) {
        New-Item $path -Force
    }   
    try {
        $null = Set-ItemProperty @PSBoundParameters
    } catch {
        $null = New-ItemProperty @PSBoundParameters
    }
}   
#========================================================================

#========================================================================
function Is-Administrator {  
    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal $CurrentUser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
    if ($IsAdmin -eq $false) {
        Write-Warning "Administrator rights are required to run the script."
    }
    return $IsAdmin
}
#========================================================================

#========================================================================
function Get-ISOWindowsEditions {
    param (
        [string]$DriveLetter
    )
    Write-Host "Printing Windows editions on the selected disk image... It may take a while..." -ForegroundColor Yellow
    $WinImages = Get-windowsimage -ImagePath "$($DriveLetter):\sources\install.wim"
    $Report = @()
    Write-Host "Index  Edition"
    Write-Host "=====  =======" 
    foreach ($WinImage in $WinImages) {
        $curImage=Get-WindowsImage -ImagePath "$($DriveLetter):\sources\install.wim" -Index $WinImage.ImageIndex
        $objImage = [PSCustomObject]@{
            Index = $curImage.ImageIndex
            Edition = $curImage.ImageName
            Version = $curImage.Version
        }
        Write-Host "$($curImage.ImageIndex):     $($curImage.ImageName)"
        $Report += $objImage
    }
    return $Report
}
#========================================================================

#========================================================================
function Dismount-ISO {
    param (
        [string]$SourcePath
    )
    $disk = Get-Volume | Where-Object {$_.DriveType -eq "CD-ROM"} | select *
    Foreach ($d in $disk) {
        Dismount-DiskImage -ImagePath $sourcePath  -ErrorAction SilentlyContinue
    }
}
#========================================================================

#========================================================================
function Mount-ISOReliable {
    param (
        [string]$SourcePath
    )
    $mountResult = Mount-DiskImage -ImagePath $SourcePath
    $delay = 0
    do {
        if ($delay -gt 15) {
            function Get-NewDriveLetter {
                $UsedDriveLetters = ((Get-Volume).DriveLetter) -join ""
                do { $DriveLetter = (65..90)| Get-Random | % {[char]$_} }
                Until (!$UsedDriveLetters.Contains("$DriveLetter"))
            }
            $DriveLetter = "$(Get-NewDriveLetter):"
            Get-WmiObject -Class Win32_volume | Where-Object {$_.Label -eq "CCCOMA_X64FRE_EN-US_DV9"} | Set-WmiInstance -Arguments @{DriveLetter="$driveletter"}
        }
        Start-Sleep -s 1 
        $delay++
    } until (($mountResult | Get-Volume).DriveLetter -ne $NULL)
    ($mountResult | Get-Volume).DriveLetter
}
#========================================================================

#========================================================================
function ConcatenateVHDPath {
    param(
        [string]$VHDPath,
        [string]$VMName
    )
    if ($VHDPath[-1] -eq '\') {
        "$($VHDPath)$($VMName).vhdx"
    } else {
        "$($VHDPath)\$($VMName).vhdx"
    }
}
#========================================================================

#========================================================================
function SmartExit {
    param (
        [switch]$NoHalt,
        [string]$ExitReason
    )
    Set-PSDebug -Off
    if (($host.name -eq 'Windows PowerShell ISE Host') -or ($host.Name -eq 'Visual Studio Code Host')) {
        Write-Host $ExitReason
        Exit
    } else{
        if ($NoHalt) {
            Write-Host $ExitReason
            Exit
        } else {
            Write-Host $ExitReason
            Read-host -Prompt "Press any key to Exit..."
            Exit
        }
    }
}
#========================================================================

#========================================================================
function New-GPUEnabledVM {
    param(
        [string]$DriveLetter,
        [int64]$SizeBytes,
        [int]$Edition,
        [string]$VhdFormat,
        [string]$VMPath,
        [string]$VhdPath,
        [string]$VMName,
        [string]$DiskLayout,
        [int64]$MemoryAmount,
        [int64]$MemoryMaximum,
        [boolean]$DynamicMemoryEnabled,
        [int]$CPUCores,
        [string]$NetworkSwitch,
        [string]$GPUName,
        [float]$GPUDedicatedResourcePercentage,
        [string]$SourcePath,
        [string]$Team_ID,
        [string]$Key,
        [string]$username,
        [string]$password,
        [string]$autologon,
        [bool]$rdp,
        [bool]$Parsec,
        [bool]$CopyRegionalSettings,
        [bool]$ParsecVDD,
        [bool]$NumLock
    )
    $VHDPath = ConcatenateVHDPath -VHDPath $VHDPath -VMName $VMName
    $DriveLetter = Mount-ISOReliable -SourcePath $SourcePath
    
    #Windows Edition menu
    $Report = Get-ISOWindowsEditions -DriveLetter $DriveLetter
    $LastReportNum = $Report.Count
    $params.Edition = $LastReportNum
    $VMParam = New-VMParameter -name 'CPUCores' -title "Select Index of the Windows Edition [default: $LastReportNum] (press $([char]0x23CE) to skip)" -range @(1, $LastReportNum) -AllowNull $true
    $null = Get-VMParam -VMParam $VMParam
    
    if ($(Get-VM -Name $VMName -ErrorAction SilentlyContinue) -ne $NULL) {
        SmartExit -ExitReason "Virtual Machine already exists with name $VMName, please delete existing VM or change VMName"
    }
    if (Test-Path $vhdPath) {
        SmartExit -ExitReason "Virtual Machine Disk already exists at $vhdPath, please delete existing VHDX or change VMName"
    }
    Write-Host "Virtual Machine is creating... It may take a long time..." -ForegroundColor Yellow
    $unattendPath = Modify-AutoUnattend -username "$username" -password "$password" -autologon $autologon -hostname $VMName -CopyRegionalSettings $CopyRegionalSettings -xml $unattend
    $MaxAvailableVersion = (Get-VMHostSupportedVersion).Version | Where-Object {$_.Major -lt 254}| Select-Object -Last 1 
    try {
        Convert-WindowsImage -SourcePath $SourcePath -ISODriveLetter $DriveLetter -Edition $Edition -VHDFormat $Vhdformat -VHDPath $VhdPath -DiskLayout $DiskLayout -UnattendPath $UnattendPath -Parsec:$Parsec -ParsecVDD:$ParsecVDD -RemoteDesktopEnable:$rdp -NumLock:$NumLock -GPUName $GPUName -Team_ID $Team_ID -Key $Key -SizeBytes $SizeBytes | Out-Null
    } catch {
    }
    if (Test-Path $vhdPath) {
        New-VM -Name $VMName -MemoryStartupBytes $MemoryAmount -Path $VMPath -VHDPath $VhdPath -Generation 2 -SwitchName $NetworkSwitch -Version $MaxAvailableVersion | Out-Null
        Set-VM -Name $VMName -ProcessorCount $CPUCores 
        Set-VM -Name $VMName -CheckpointType Disabled 
        Set-VM -Name $VMName -MemoryMinimum $MemoryAmount
        Set-VM -Name $VMName -MemoryMaximum $MemoryMaximum
        Set-VM -Name $VMName -LowMemoryMappedIoSpace 3GB 
        Set-VM -Name $VMName -HighMemoryMappedIoSpace 32GB
        Set-VM -Name $VMName -GuestControlledCacheTypes $true 
        Set-VM -Name $VMName -AutomaticStopAction ShutDown
        Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $DynamicMemoryEnabled
        $CPUManufacturer = Get-CimInstance -ClassName Win32_Processor | Foreach-Object Manufacturer
        $BuildVer = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        if (($BuildVer.CurrentBuild -lt 22000) -and ($CPUManufacturer -eq "AuthenticAMD")) {
        } else {
            Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
        }
        Set-VMHost -ComputerName $ENV:Computername -EnableEnhancedSessionMode $false
        Set-VMVideo -VMName $VMName -HorizontalResolution 1920 -VerticalResolution 1080
        Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
        Enable-VMTPM -VMName $VMName 
        Add-VMDvdDrive -VMName $VMName -Path $SourcePath 
        $Global:VM  = Get-VM -VMName $VMName
        $Global:VHD = $Global:VM.VMId
        Pass-VMGPUPartitionAdapter
        Write-W2VInfo "Starting and connecting to VM"
        if ($Global:ServerOS -eq $true) {
            Set-ServerOSGroupPolicies
        }
        vmconnect localhost $VMName
    } else {
        SmartExit -ExitReason "Failed to create VHDX, stopping script"
    }
}
#========================================================================

#========================================================================
function Setup-RemoteDesktop {
    param(
        [Parameter(Mandatory = $true)][bool]$Parsec,
        [bool]$ParsecVDD,
        [Parameter(Mandatory = $true)][bool]$rdp,
        [bool]$NumLock,
        [Parameter(Mandatory = $true)][string]$DriveLetter,
        [string]$Team_ID,
        [string]$Key
    )
    
    if (($Parsec -eq $false) -and ($rdp -eq $false) -and ($NumLock -eq $false)) {
        return $null
    }
    
    New-Item -Path $DriveLetter\Windows\system32\GroupPolicy\User\Scripts\Logon -ItemType directory -Force | Out-Null
    New-Item -Path $DriveLetter\Windows\system32\GroupPolicy\User\Scripts\Logoff -ItemType directory -Force | Out-Null
    New-Item -Path $DriveLetter\Windows\system32\GroupPolicy\Machine\Scripts\Startup -ItemType directory -Force | Out-Null
    New-Item -Path $DriveLetter\Windows\system32\GroupPolicy\Machine\Scripts\Shutdown -ItemType directory -Force | Out-Null
    New-Item -Path $DriveLetter\ProgramData\Easy-GPU-P -ItemType directory -Force | Out-Null
    
    $path = "$DriveLetter\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini"
    "[Logon]" >> $path
    "0CmdLine=Install.ps1" >> $path
    "0Parameters=$rdp $Parsec $ParsecVDD $Team_ID $Key" >> $path 

    if ($NumLock -eq $true) {
        $path = "$DriveLetter\Windows\system32\GroupPolicy\Machine\Scripts\psscripts.ini"
        "[Startup]" >> $path
        "0CmdLine=NumLockEnable.ps1" >> $path
        "0Parameters=" >> $path
        
        $path = "$DriveLetter\Windows\system32\GroupPolicy\Machine\Scripts\Startup\NumLockEnable.ps1"
        "`$WshShell = New-Object -ComObject WScript.Shell" >> $path
        "if ([console]::NumberLock -eq `$false) {" >> $path
        "    `$WshShell.SendKeys(""{NUMLOCK}"")" >> $path
        "}" >> $path
    }

    $path = "$DriveLetter\Windows\system32\GroupPolicy\gpt.ini"
    "[General]" >> $path
    "gPCUserExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B66650-4972-11D1-A7CA-0000F87571E3}]" >> $path
    "Version=131074" >> $path
    "gPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]" >> $path
    
    Copy-Item -Path $psscriptroot\VMScripts\Install.ps1 -Destination $DriveLetter\Windows\system32\GroupPolicy\User\Scripts\Logon
    
    if ($Parsec -eq $true) {         
        Copy-Item -Path $psscriptroot\VMScripts\VDDMonitor.ps1 -Destination $DriveLetter\ProgramData\Easy-GPU-P
        Copy-Item -Path $psscriptroot\misc\ParsecPublic.cer -Destination $DriveLetter\ProgramData\Easy-GPU-P
        [io.file]::WriteAllBytes("$DriveLetter\ProgramData\Easy-GPU-P\Parsec.lnk", $ParsecLnk)
    }
}
#========================================================================

#========================================================================
function Convert-WindowsImage {
    <#
    .NOTES
            Copyright (c) Microsoft Corporation. All rights reserved.
            Use of this sample source code is subject to the terms of the Microsoft
            license agreement under which you licensed this sample source code. If
            you did not accept the terms of the license agreement, you are not
            authorized to use this sample source code. For the terms of the license,
            please see the license agreement between you and Microsoft or, if applicable,
            see the LICENSE.RTF on your install media or the root of your tools installation.
            THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.

    .SYNOPSIS
            Creates a bootable VHD(X) based on Windows 7 or Windows 8 installation media.

    .DESCRIPTION
            Creates a bootable VHD(X) based on Windows 7 or Windows 8 installation media.

    .PARAMETER SourcePath
            The complete path to the WIM or ISO file that will be converted to a Virtual Hard Disk.
            The ISO file must be valid Windows installation media to be recognized successfully.

    .PARAMETER CacheSource
            If the source WIM/ISO was copied locally, we delete it by default.
            Pass $true to cache the source image from the temp directory.

    .PARAMETER VHDPath
            The name and path of the Virtual Hard Disk to create.
            Omitting this parameter will create the Virtual Hard Disk is the current directory, (or,
            if specified by the -WorkingDirectory parameter, the working directory) and will automatically
            name the file in the following format:

            <build>.<revision>.<architecture>.<branch>.<timestamp>_<skufamily>_<sku>_<language>.<extension>
            i.e.:
            9200.0.amd64fre.winmain_win8rtm.120725-1247_client_professional_en-us.vhd(x)

    .PARAMETER WorkingDirectory
            Specifies the directory where the VHD(X) file should be generated.
            If specified along with -VHDPath, the -WorkingDirectory value is ignored.
            The default value is the current directory ($pwd).

    .PARAMETER TempDirectory
            Specifies the directory where the logs and ISO files should be placed.
            The default value is the temp directory ($env:Temp).

    .PARAMETER SizeBytes
            The size of the Virtual Hard Disk to create.
            For fixed disks, the VHD(X) file will be allocated all of this space immediately.
            For dynamic disks, this will be the maximum size that the VHD(X) can grow to.
            The default value is 40GB.

    .PARAMETER VHDFormat
            Specifies whether to create a VHD or VHDX formatted Virtual Hard Disk.
            The default is AUTO, which will create a VHD if using the BIOS disk layout or
            VHDX if using UEFI or WindowsToGo layouts.

    .PARAMETER DiskLayout
            Specifies whether to build the image for BIOS (MBR), UEFI (GPT), or WindowsToGo (MBR).
            Generation 1 VMs require BIOS (MBR) images.    Generation 2 VMs require UEFI (GPT) images.
            Windows To Go images will boot in UEFI or BIOS but are not technically supported (upgrade
            doesn't work)

    .PARAMETER UnattendPath
            The complete path to an unattend.xml file that can be injected into the VHD(X).

    .PARAMETER Edition
            The name or image index of the image to apply from the WIM.

    .PARAMETER Passthru
            Specifies that the full path to the VHD(X) that is created should be
            returned on the pipeline.

    .PARAMETER BCDBoot
            By default, the version of BCDBOOT.EXE that is present in \Windows\System32
            is used by Convert-WindowsImage.    If you need to specify an alternate version,
            use this parameter to do so.

    .PARAMETER MergeFolder
            Specifies additional MergeFolder path to be added to the root of the VHD(X)

    .PARAMETER BCDinVHD
            Specifies the purpose of the VHD(x). Use NativeBoot to skip cration of BCD store
            inside the VHD(x). Use VirtualMachine (or do not specify this option) to ensure
            the BCD store is created inside the VHD(x).

    .PARAMETER Driver
            Full path to driver(s) (.inf files) to inject to the OS inside the VHD(x).

    .PARAMETER ExpandOnNativeBoot
            Specifies whether to expand the VHD(x) to its maximum suze upon native boot.
            The default is True. Set to False to disable expansion.

    .PARAMETER RemoteDesktopEnable
            Enable Remote Desktop to connect to the OS inside the VHD(x) upon provisioning.

    .PARAMETER Parsec
            Install Remote Desktop app Parsec.
  
    .PARAMETER ParsecVDD
            Install Remote Desktop app Parsec Virtual Display Driver

    .PARAMETER Numlock
            Enable / Disable NumLock at logon
            
    .PARAMETER Feature
            Enables specified Windows Feature(s). Note that you need to specify the Internal names
            understood by DISM and DISM CMDLets (e.g. NetFx3) instead of the "Friendly" names
            from Server Manager CMDLets (e.g. NET-Framework-Core).

    .PARAMETER Package
            Injects specified Windows Package(s). Accepts path to either a directory or individual
            CAB or MSU file.

    .PARAMETER ShowUI
            Specifies that the Graphical User Interface should be displayed.

    .PARAMETER EnableDebugger
            Configures kernel debugging for the VHD(X) being created.
            EnableDebugger takes a single argument which specifies the debugging transport to use.
            Valid transports are: None, Serial, 1394, USB, Network, Local.
            Depending on the type of transport selected, additional configuration parameters will become
            available.

            Serial:  -ComPort     - The COM port number to use while communicating with the debugger.
                                             The default value is 1 (indicating COM1).
                     -BaudRate    - The baud rate (in bps) to use while communicating with the debugger.
                                             The default value is 115200, valid values are:
                                             9600, 19200, 38400, 56700, 115200
                                             
            1394:    -Channel     - The 1394 channel used to communicate with the debugger.
                                             The default value is 10.

            USB:     -Target        - The target name used for USB debugging (the default value is "debugging").

            Network: -IPAddress - The IP address of the debugging host computer.
                     -Port            - The port on which to connect to the debugging host.
                                             The default value is 50000, with a minimum value of 49152.
                     -Key             - The key used to encrypt the connection.    Only [0-9] and [a-z] are allowed.
                     -nodhcp        - Prevents the use of DHCP to obtain the target IP address.
                     -newkey        - Specifies that a new encryption key should be generated for the connection.

    .PARAMETER DismPath
            Full Path to an alternative version of the Dism.exe tool. The default is the current OS version.

    .PARAMETER ApplyEA
            Specifies that any EAs captured in the WIM should be applied to the VHD.
            The default is False.

    .EXAMPLE
            .\Convert-WindowsImage.ps1 -SourcePath D:\foo\install.wim -Edition Professional -WorkingDirectory D:\foo
            This command will create a 40GB dynamically expanding VHD in the D:\foo folder.
            The VHD will be based on the Professional edition from D:\foo\install.wim,
            and will be named automatically.

    .EXAMPLE
            .\Convert-WindowsImage.ps1 -SourcePath D:\foo\Win7SP1.iso -Edition Ultimate -VHDPath D:\foo\Win7_Ultimate_SP1.vhd
            This command will parse the ISO file D:\foo\Win7SP1.iso and try to locate
            \sources\install.wim.    If that file is found, it will be used to create a
            dynamically-expanding 40GB VHD containing the Ultimate SKU, and will be
            named D:\foo\Win7_Ultimate_SP1.vhd

    .EXAMPLE
            .\Convert-WindowsImage.ps1 -SourcePath D:\foo\install.wim -Edition Professional -EnableDebugger Serial -ComPort 2 -BaudRate 38400
            This command will create a VHD from D:\foo\install.wim of the Professional SKU.
            Serial debugging will be enabled in the VHD via COM2 at a baud rate of 38400bps.

    .OUTPUTS
            System.IO.FileInfo
    #>
    [CmdletBinding(DefaultParameterSetName = "SRC",
        HelpURI = "https://github.com/Microsoft/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage")]

    param(
        [Parameter(ParameterSetName = "SRC", Mandatory = $true,ValueFromPipeline = $true)]
        [Alias("WIM")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $(Resolve-Path $_) })]
        $SourcePath,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("DriveLetter")]
        [string]
        [ValidateNotNullOrEmpty()]
        [string]$ISODriveLetter,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("GPU")]
        [string]
        [ValidateNotNullOrEmpty()]
        [string]$GPUName,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("TeamID")]
        [string]
        #[ValidateNotNullOrEmpty()]
        [string]$Team_ID,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("Teamkey")]
        [string]
        #[ValidateNotNullOrEmpty()]
        [string]$Key,

        [Parameter(ParameterSetName = "SRC")]
        [switch]
        $CacheSource = $false,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("SKU")]
        [string[]]
        [ValidateNotNullOrEmpty()]
        $Edition,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("WorkDir")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        $WorkingDirectory = $pwd,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("TempDir")]
        [string]
        [ValidateNotNullOrEmpty()]
        $TempDirectory = $env:Temp,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("VHD")]
        [string]
        [ValidateNotNullOrEmpty()]
        $VHDPath,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("Size")]
        [uint64]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(512MB,64TB)]
        $SizeBytes = 25GB,

        [Parameter(ParameterSetName = "SRC")]
        [Alias("Format")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("VHD","VHDX","AUTO")]
        $VHDFormat = "AUTO",

        [Parameter(ParameterSetName = "SRC")]
        [Alias("MergeFolder")]
        [string]
        [ValidateNotNullOrEmpty()]
        $MergeFolderPath = "",

        [Parameter(ParameterSetName = "SRC",Mandatory = $true)]
        [Alias("Layout")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BIOS","UEFI","WindowsToGo")]
        $DiskLayout,

        [Parameter(ParameterSetName = "SRC")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("NativeBoot","VirtualMachine")]
        $BCDinVHD = "VirtualMachine",

        [Parameter(ParameterSetName = "SRC")]
        [Parameter(ParameterSetName = "UI")]
        [string]
        $BCDBoot = "bcdboot.exe",

        [Parameter(ParameterSetName = "SRC")]
        [Parameter(ParameterSetName = "UI")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("None","Serial","1394","USB","Local","Network")]
        $EnableDebugger = "None",

        [Parameter(ParameterSetName = "SRC")]
        [string[]]
        [ValidateNotNullOrEmpty()]
        $Feature,

        [Parameter(ParameterSetName = "SRC")]
        [string[]]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $(Resolve-Path $_) })]
        $Driver,

        [Parameter(ParameterSetName = "SRC")]
        [string[]]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $(Resolve-Path $_) })]
        $Package,

        [Parameter(ParameterSetName = "SRC")]
        [switch]
        $ExpandOnNativeBoot = $true,

        [Parameter(ParameterSetName = "SRC")]
        [bool]
        $RemoteDesktopEnable,

        [Parameter(ParameterSetName = "SRC")]
        [bool]
        $Parsec,

        [Parameter(ParameterSetName = "SRC")]
        [bool]
        $ParsecVDD,
    
        [Parameter(ParameterSetName = "SRC")]
        [bool]
        $NumLock,
        
        [Parameter(ParameterSetName = "SRC")]
        [Alias("Unattend")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $(Resolve-Path $_) })]
        $UnattendPath,

        [Parameter(ParameterSetName = "SRC")]
        [Parameter(ParameterSetName = "UI")]
        [switch]
        $Passthru,

        [Parameter(ParameterSetName = "SRC")]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $(Resolve-Path $_) })]
        $DismPath,

        [Parameter(ParameterSetName = "SRC")]
        [switch]
        $ApplyEA = $false,

        [Parameter(ParameterSetName = "UI")]
        [switch]
        $ShowUI
    )
    #region Code

    # Begin Dynamic Parameters
    # Create the parameters for the various types of debugging.
    dynamicparam {
        #Set-StrictMode -version 3
        # Set up the dynamic parameters.
        # Dynamic parameters are only available if certain conditions are met, so they'll only show up
        # as valid parameters when those conditions apply.    Here, the conditions are based on the value of
        # the EnableDebugger parameter.    Depending on which of a set of values is the specified argument
        # for EnableDebugger, different parameters will light up, as outlined below.

        $parameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        if (!(Test-Path Variable:Private:EnableDebugger)) {
            return $parameterDictionary
        }

        switch ($EnableDebugger){
            "Serial" {
                #region ComPort

                $ComPortAttr = New-Object System.Management.Automation.ParameterAttribute
                $ComPortAttr.ParameterSetName = "__AllParameterSets"
                $ComPortAttr.Mandatory = $false
                $ComPortValidator = New-Object System.Management.Automation.ValidateRangeAttribute (
                    1,
                    10 # Is that a good maximum?
                )
                $ComPortNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $ComPortAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $ComPortAttrCollection.Add($ComPortAttr)
                $ComPortAttrCollection.Add($ComPortValidator)
                $ComPortAttrCollection.Add($ComPortNotNull)
                $ComPort = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "ComPort",
                    [uint16],
                    $ComPortAttrCollection
                )
                # By default, use COM1
                $ComPort.Value = 1
                $parameterDictionary.Add("ComPort",$ComPort)
                #endregion ComPort

                #region BaudRate
                $BaudRateAttr = New-Object System.Management.Automation.ParameterAttribute
                $BaudRateAttr.ParameterSetName = "__AllParameterSets"
                $BaudRateAttr.Mandatory = $false
                $BaudRateValidator = New-Object System.Management.Automation.ValidateSetAttribute (
                    9600,19200,38400,57600,115200
                )
                $BaudRateNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $BaudRateAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $BaudRateAttrCollection.Add($BaudRateAttr)
                $BaudRateAttrCollection.Add($BaudRateValidator)
                $BaudRateAttrCollection.Add($BaudRateNotNull)
                $BaudRate = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "BaudRate",
                    [uint32],
                    $BaudRateAttrCollection
                )
                # By default, use 115,200.
                $BaudRate.Value = 115200
                $parameterDictionary.Add("BaudRate",$BaudRate)
                #endregion BaudRate

                break
            }

            "1394" {
                $ChannelAttr = New-Object System.Management.Automation.ParameterAttribute
                $ChannelAttr.ParameterSetName = "__AllParameterSets"
                $ChannelAttr.Mandatory = $false
                $ChannelValidator = New-Object System.Management.Automation.ValidateRangeAttribute (
                    0,
                    62
                )
                $ChannelNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $ChannelAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $ChannelAttrCollection.Add($ChannelAttr)
                $ChannelAttrCollection.Add($ChannelValidator)
                $ChannelAttrCollection.Add($ChannelNotNull)
                $Channel = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "Channel",
                    [uint16],
                    $ChannelAttrCollection
                )
                # By default, use channel 10
                $Channel.Value = 10
                $parameterDictionary.Add("Channel",$Channel)
                break
            }

            "USB" {
                $TargetAttr = New-Object System.Management.Automation.ParameterAttribute
                $TargetAttr.ParameterSetName = "__AllParameterSets"
                $TargetAttr.Mandatory = $false
                $TargetNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $TargetAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $TargetAttrCollection.Add($TargetAttr)
                $TargetAttrCollection.Add($TargetNotNull)
                $Target = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "Target",
                    [string],
                    $TargetAttrCollection
                )
                # By default, use target = "debugging"
                $Target.Value = "Debugging"
                $parameterDictionary.Add("Target",$Target)
                break
            }

            "Network" {
                #region IP
                $IpAttr = New-Object System.Management.Automation.ParameterAttribute
                $IpAttr.ParameterSetName = "__AllParameterSets"
                $IpAttr.Mandatory = $true
                $IpValidator = New-Object System.Management.Automation.ValidatePatternAttribute (
                    "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
                )
                $IpNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $IpAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $IpAttrCollection.Add($IpAttr)
                $IpAttrCollection.Add($IpValidator)
                $IpAttrCollection.Add($IpNotNull)
                $IP = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "IPAddress",
                    [string],
                    $IpAttrCollection
                )
                # There's no good way to set a default value for this.
                $parameterDictionary.Add("IPAddress",$IP)
                #endregion IP

                #region Port
                $PortAttr = New-Object System.Management.Automation.ParameterAttribute
                $PortAttr.ParameterSetName = "__AllParameterSets"
                $PortAttr.Mandatory = $false
                $PortValidator = New-Object System.Management.Automation.ValidateRangeAttribute (
                    49152,
                    50039
                )
                $PortNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $PortAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $PortAttrCollection.Add($PortAttr)
                $PortAttrCollection.Add($PortValidator)
                $PortAttrCollection.Add($PortNotNull)
                $Port = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "Port",
                    [uint16],
                    $PortAttrCollection
                )
                # By default, use port 50000
                $Port.Value = 50000
                $parameterDictionary.Add("Port",$Port)
                #endregion Port

                #region Key
                $KeyAttr = New-Object System.Management.Automation.ParameterAttribute
                $KeyAttr.ParameterSetName = "__AllParameterSets"
                $KeyAttr.Mandatory = $true
                $KeyValidator = New-Object System.Management.Automation.ValidatePatternAttribute (
                    "\b([A-Z0-9]+).([A-Z0-9]+).([A-Z0-9]+).([A-Z0-9]+)\b"
                )
                $KeyNotNull = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $KeyAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $KeyAttrCollection.Add($KeyAttr)
                $KeyAttrCollection.Add($KeyValidator)
                $KeyAttrCollection.Add($KeyNotNull)
                $Key = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "Key",
                    [string],
                    $KeyAttrCollection
                )
                # Don't set a default key.
                $parameterDictionary.Add("Key",$Key)
                #endregion Key

                #region NoDHCP
                $NoDHCPAttr = New-Object System.Management.Automation.ParameterAttribute
                $NoDHCPAttr.ParameterSetName = "__AllParameterSets"
                $NoDHCPAttr.Mandatory = $false
                $NoDHCPAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $NoDHCPAttrCollection.Add($NoDHCPAttr)
                $NoDHCP = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "NoDHCP",
                    [switch],
                    $NoDHCPAttrCollection
                )
                $parameterDictionary.Add("NoDHCP",$NoDHCP)
                #endregion NoDHCP

                #region NewKey
                $NewKeyAttr = New-Object System.Management.Automation.ParameterAttribute
                $NewKeyAttr.ParameterSetName = "__AllParameterSets"
                $NewKeyAttr.Mandatory = $false
                $NewKeyAttrCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $NewKeyAttrCollection.Add($NewKeyAttr)
                $NewKey = New-Object System.Management.Automation.RuntimeDefinedParameter (
                    "NewKey",
                    [switch],
                    $NewKeyAttrCollection
                )
                # Don't set a default key.
                $parameterDictionary.Add("NewKey",$NewKey)
                #endregion NewKey
                break
            }
            # There's nothing to do for local debugging.
            # Synthetic debugging is not yet implemented.
            default {
                break
            }
        }

        return $parameterDictionary
    }

    begin {
        $PARTITION_STYLE_MBR = 0x00000000 # The default value
        $PARTITION_STYLE_GPT = 0x00000001 # Just in case...
        # Version information that can be populated by timebuild.
        $ScriptVersion = data {
            ConvertFrom-StringData -StringData @"
                Major     = 10
                Minor     = 0
                Build     = 14278
                Qfe       = 1000
                Branch    = rs1_es_media
                Timestamp = 160201-1707
                Flavor    = amd64fre
"@
        }
        $myVersion = "$($ScriptVersion.Major).$($ScriptVersion.Minor).$($ScriptVersion.Build).$($ScriptVersion.QFE).$($ScriptVersion.Flavor).$($ScriptVersion.Branch).$($ScriptVersion.Timestamp)"
        $scriptName = "Convert-WindowsImage" # Name of the script, obviously.
        $sessionKey = [guid]::NewGuid().ToString() # Session key, used for keeping records unique between multiple runs.
        $logFolder = "$($TempDirectory)\$($scriptName)\$($sessionKey)" # Log folder path.
        $vhdMaxSize = 2040GB # Maximum size for VHD is ~2040GB.
        $vhdxMaxSize = 64TB # Maximum size for VHDX is ~64TB.
        $lowestSupportedVersion = New-Object Version "6.1" # The lowest supported *image* version; making sure we don't run against Vista/2k8.
        $lowestSupportedBuild = 9200 # The lowest supported *host* build.    Set to Win8 CP.
        $transcripting = $false
        # Since we use the VHDFormat in output, make it uppercase.
        # We'll make it lowercase again when we use it as a file extension.
        $VHDFormat = $VHDFormat.ToUpper()
        # Banner text displayed during each run.
        $header = @"
Windows(R) Image to Virtual Hard Disk Converter for Windows(R) 10
Copyright (C) Microsoft Corporation.    All rights reserved.
Version $myVersion

"@
        # Text used as the banner in the UI.
        $uiHeader = @"
You can use the fields below to configure the VHD or VHDX that you want to create!
"@
        #region Helper Functions
        <#
            Functions to mount and dismount registry hives.
            These hives will automatically be accessible via the HKLM:\ registry PSDrive.
    
            It should be noted that I have more confidence in using the RegLoadKey and
            RegUnloadKey Win32 APIs than I do using REG.EXE - it just seems like we should
            do things ourselves if we can, instead of using yet another binary.
    
            Consider this a TODO for future versions.
        #>
        function Mount-RegistryHive {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true,ValueFromPipeline = $true,Position = 0)]
                [System.IO.FileInfo]
                [ValidateNotNullOrEmpty()]
                [ValidateScript({ $_.Exists })]
                $Hive
            )
            $mountKey = [System.Guid]::NewGuid().ToString()
            $regPath = "REG.EXE"
            if (Test-Path HKLM:\$mountKey) {
                throw "The registry path already exists.    I should just regenerate it, but I'm lazy."
            }
            $regArgs = (
                "LOAD",
                "HKLM\$mountKey",
                $Hive.FullName
            )
            try {
                Run-Executable -Executable $regPath -Arguments $regArgs
            } catch {
                throw
            }
            # Set a global variable containing the name of the mounted registry key
            # so we can unmount it if there's an error.
            $global:mountedHive = $mountKey
            return $mountKey
        }

        function Dismount-RegistryHive {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true,ValueFromPipeline = $true,Position = 0)]
                [string]
                [ValidateNotNullOrEmpty()]
                $HiveMountPoint
            )

            $regPath = "REG.EXE"

            $regArgs = (
                "UNLOAD",
                "HKLM\$($HiveMountPoint)"
            )

            Run-Executable -Executable $regPath -Arguments $regArgs

            $global:mountedHive = $null
        }

        function Test-Admin {
        <#
            .SYNOPSIS
                    Short function to determine whether the logged-on user is an administrator.

            .EXAMPLE
                    Do you honestly need one?    There are no parameters!

            .OUTPUTS
                    $true if user is admin.
                    $false if user is not an admin.
        #>
            [CmdletBinding()]
            param()
            $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
            $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
            Write-W2VTrace "isUserAdmin? $isAdmin"
            return $isAdmin
        }
        
        function Get-WindowsBuildNumber {
            $os = Get-WmiObject -Class Win32_OperatingSystem
            return [int]($os.BuildNumber)
        }

        function Test-WindowsVersion {
            $isWin8 = ((Get-WindowsBuildNumber) -ge [int]$lowestSupportedBuild)
            Write-W2VTrace "is Windows 8 or Higher? $isWin8"
            return $isWin8
        }

        function Write-W2VTrace {
            # Function to make the Write-Verbose output... well... exactly the same as it was before.
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
                [string]
                [ValidateNotNullOrEmpty()]
                $text
            )
            Write-Verbose $text
        }

        function Write-W2VError {
            # Function to make the Write-Host (NOT Write-Error) output prettier in the case of an error.
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
                [string]
                [ValidateNotNullOrEmpty()]
                $text
            )
            Write-Host "ERROR    : $($text)"
        }

        function Write-W2VWarn {
            # Function to make the Write-Host (NOT Write-Warning) output prettier.
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
                [string]
                [ValidateNotNullOrEmpty()]
                $text
            )
            Write-Host "WARN     : $($text)" -ForegroundColor (Get-Host).PrivateData.WarningForegroundColor
        }

        function Run-Executable {   
        <#
            .SYNOPSIS
                    Runs an external executable file, and validates the error level.

            .PARAMETER Executable
                    The path to the executable to run and monitor.

            .PARAMETER Arguments
                    An array of arguments to pass to the executable when it's executed.

            .PARAMETER SuccessfulErrorCode
                    The error code that means the executable ran successfully.
                    The default value is 0.
        #>
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]
                [ValidateNotNullOrEmpty()]
                $Executable,
                [Parameter(Mandatory = $true)]
                [string[]]
                [ValidateNotNullOrEmpty()]
                $Arguments,
                [Parameter()]
                [int]
                [ValidateNotNullOrEmpty()]
                $SuccessfulErrorCode = 0
            )
            Write-W2VTrace "Running $Executable $Arguments"
            $ret = Start-Process `
                 -FilePath $Executable `
                 -ArgumentList $Arguments `
                 -NoNewWindow `
                 -Wait `
                 -RedirectStandardOutput "$($TempDirectory)\$($scriptName)\$($sessionKey)\$($Executable)-StandardOutput.txt" `
                 -RedirectStandardError "$($TempDirectory)\$($scriptName)\$($sessionKey)\$($Executable)-StandardError.txt" `
                 -Passthru

            Write-W2VTrace "Return code was $($ret.ExitCode)."
            if ($ret.ExitCode -ne $SuccessfulErrorCode) {
                throw "$Executable failed with code $($ret.ExitCode)!"
            }
        }

        function Test-IsNetworkLocation {
        <#
            .SYNOPSIS
                    Determines whether or not a given path is a network location or a local drive.
            
            .DESCRIPTION
                    Function to determine whether or not a specified path is a local path, a UNC path,
                    or a mapped network drive.
            
            .PARAMETER Path
        #>
            [CmdletBinding()]
            param(
                [Parameter(ValueFromPipeline = $true)]
                [string]
                [ValidateNotNullOrEmpty()]
                $Path
            )

            $result = $false
            if ([bool]([uri]$Path).IsUNC) {
                $result = $true
            } else {
                $driveInfo = [IO.DriveInfo]((Resolve-Path $Path).Path)
                if ($driveInfo.DriveType -eq "Network") {
                    $result = $true
                }
            }

            return $result
        }
        #endregion Helper Functions
    }

    process {
        Write-Host $header
        $disk = $null
        $openWim = $null
        $openIso = $null
        $openImage = $null
        $vhdFinalName = $null
        $vhdFinalPath = $null
        $mountedHive = $null
        $isoPath = $null
        $tempSource = $null

        if (Get-Command Get-WindowsOptionalFeature -ErrorAction SilentlyContinue) {
            try {
                $hyperVEnabled = $((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Enabled")
            } catch {
                # WinPE DISM does not support online queries. This will throw on non-WinPE machines
                $winpeVersion = (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinPE').Version

                Write-W2VInfo "Running WinPE version $winpeVersion"

                $hyperVEnabled = $false
            }
        } else {
            $hyperVEnabled = $false
        }

        $vhd = @()

        try {
            # Create log folder
            if (Test-Path $logFolder) {
                $null = Remove-Item $logFolder -Force -Recurse
            }
            $null = mkdir $logFolder -Force
            # Try to start transcripting.    If it's already running, we'll get an exception and swallow it.
            try {
                $null = Start-Transcript -Path (Join-Path $logFolder "Convert-WindowsImageTranscript.txt") -Force -ErrorAction SilentlyContinue
                $transcripting = $true
            } catch {
                Write-W2VWarn "Transcription is already running.    No Convert-WindowsImage-specific transcript will be created."
                $transcripting = $false
            }
            #
            # Add types
            #
            Add-WindowsImageTypes
            # Check to make sure we're running as Admin.
            if (!(Test-Admin)) {
                throw "Images can only be applied by an administrator.    Please launch PowerShell elevated and run this script again."
            }
            # Check to make sure we're running on Win8.
            if (!(Test-WindowsVersion))  {
                throw "$scriptName requires Windows 8 Consumer Preview or higher.    Please use WIM2VHD.WSF (http://code.msdn.microsoft.com/wim2vhd) if you need to create VHDs from Windows 7."
            }
            # Resolve the path for the unattend file.
            if (![string]::IsNullOrEmpty($UnattendPath)) {
                $UnattendPath = (Resolve-Path $UnattendPath).Path
            }
            if ($ShowUI) {
                Write-W2VInfo "Launching UI..."
                Add-Type -AssemblyName System.Drawing,System.Windows.Forms
                #region Form Objects
                $frmMain = New-Object System.Windows.Forms.Form
                $groupBox4 = New-Object System.Windows.Forms.GroupBox
                $btnGo = New-Object System.Windows.Forms.Button
                $groupBox3 = New-Object System.Windows.Forms.GroupBox
                $txtVhdName = New-Object System.Windows.Forms.TextBox
                $label6 = New-Object System.Windows.Forms.Label
                $btnWrkBrowse = New-Object System.Windows.Forms.Button
                $cmbVhdSizeUnit = New-Object System.Windows.Forms.ComboBox
                $numVhdSize = New-Object System.Windows.Forms.NumericUpDown
                $cmbVhdFormat = New-Object System.Windows.Forms.ComboBox
                $label5 = New-Object System.Windows.Forms.Label
                $txtWorkingDirectory = New-Object System.Windows.Forms.TextBox
                $label4 = New-Object System.Windows.Forms.Label
                $label3 = New-Object System.Windows.Forms.Label
                $label2 = New-Object System.Windows.Forms.Label
                $label7 = New-Object System.Windows.Forms.Label
                $txtUnattendFile = New-Object System.Windows.Forms.TextBox
                $btnUnattendBrowse = New-Object System.Windows.Forms.Button
                $groupBox2 = New-Object System.Windows.Forms.GroupBox
                $cmbSkuList = New-Object System.Windows.Forms.ComboBox
                $label1 = New-Object System.Windows.Forms.Label
                $groupBox1 = New-Object System.Windows.Forms.GroupBox
                $txtSourcePath = New-Object System.Windows.Forms.TextBox
                $btnBrowseWim = New-Object System.Windows.Forms.Button
                $openFileDialog1 = New-Object System.Windows.Forms.OpenFileDialog
                $openFolderDialog1 = New-Object System.Windows.Forms.FolderBrowserDialog
                $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
                #endregion Form Objects

                #region Event scriptblocks.
                $btnGo_OnClick = {
                    $frmMain.Close()
                }
                $btnWrkBrowse_OnClick = {
                    $openFolderDialog1.RootFolder = "Desktop"
                    $openFolderDialog1.Description = "Select the folder you'd like your VHD(X) to be created in."
                    $openFolderDialog1.SelectedPath = $WorkingDirectory
                    $ret = $openFolderDialog1.ShowDialog()
                    if ($ret -ilike "ok") {
                        $WorkingDirectory = $txtWorkingDirectory = $openFolderDialog1.SelectedPath
                        Write-W2VInfo "Selected Working Directory is $WorkingDirectory..."
                    }
                }
                $btnUnattendBrowse_OnClick = {
                    $openFileDialog1.InitialDirectory = $pwd
                    $openFileDialog1.Filter = "XML files (*.xml)|*.XML|All files (*.*)|*.*"
                    $openFileDialog1.FilterIndex = 1
                    $openFileDialog1.CheckFileExists = $true
                    $openFileDialog1.CheckPathExists = $true
                    $openFileDialog1.FileName = $null
                    $openFileDialog1.ShowHelp = $false
                    $openFileDialog1.Title = "Select an unattend file..."
                    $ret = $openFileDialog1.ShowDialog()
                    if ($ret -ilike "ok") {
                        $UnattendPath = $txtUnattendFile.Text = $openFileDialog1.FileName
                    }
                }
                $btnBrowseWim_OnClick = {
                    $openFileDialog1.InitialDirectory = $pwd
                    $openFileDialog1.Filter = "All compatible files (*.ISO, *.WIM)|*.ISO;*.WIM|All files (*.*)|*.*"
                    $openFileDialog1.FilterIndex = 1
                    $openFileDialog1.CheckFileExists = $true
                    $openFileDialog1.CheckPathExists = $true
                    $openFileDialog1.FileName = $null
                    $openFileDialog1.ShowHelp = $false
                    $openFileDialog1.Title = "Select a source file..."
                    $ret = $openFileDialog1.ShowDialog()
                    if ($ret -ilike "ok") {
                        if (([IO.FileInfo]$openFileDialog1.FileName).Extension -ilike ".iso") {
                            if (Test-IsNetworkLocation $openFileDialog1.FileName) {
                                Write-W2VInfo "Copying ISO $(Split-Path $openFileDialog1.FileName -Leaf) to temp folder..."
                                Write-W2VWarn "The UI may become non-responsive while this copy takes place..."
                                Copy-Item -Path $openFileDialog1.FileName -Destination $TempDirectory -Force
                                $openFileDialog1.FileName = "$($TempDirectory)\$(Split-Path $openFileDialog1.FileName -Leaf)"
                            }
                            $txtSourcePath.Text = $isoPath = (Resolve-Path $openFileDialog1.FileName).Path
                            Write-W2VInfo "Opening ISO $(Split-Path $isoPath -Leaf)..."
                            $script:SourcePath = "$($driveLetter):\sources\install.wim"
                            # Check to see if there's a WIM file we can muck about with.
                            Write-W2VInfo "Looking for $($SourcePath)..."
                            if (!(Test-Path $SourcePath)) {
                                throw "The specified ISO does not appear to be valid Windows installation media."
                            }
                        } else {
                            $txtSourcePath.Text = $script:SourcePath = $openFileDialog1.FileName
                        }
                        # Check to see if the WIM is local, or on a network location.    If the latter, copy it locally.
                        if (Test-IsNetworkLocation $SourcePath){
                            Write-W2VInfo "Copying WIM $(Split-Path $SourcePath -Leaf) to temp folder..."
                            Write-W2VWarn "The UI may become non-responsive while this copy takes place..."
                            Copy-Item -Path $SourcePath -Destination $TempDirectory -Force
                            $txtSourcePath.Text = $script:SourcePath = "$($TempDirectory)\$(Split-Path $SourcePath -Leaf)"
                        }
                        $script:SourcePath = (Resolve-Path $SourcePath).Path
                        Write-W2VInfo "Scanning WIM metadata..."
                        $tempOpenWim = $null
                        try {
                            $tempOpenWim = New-Object WIM2VHD.WimFile $SourcePath
                            # Let's see if we're running against an unstaged build.    If we are, we need to blow up.
                            if ($tempOpenWim.ImageNames.Contains("Windows Longhorn Client") -or
                                $tempOpenWim.ImageNames.Contains("Windows Longhorn Server") -or
                                $tempOpenWim.ImageNames.Contains("Windows Longhorn Server Core")){
                                [Windows.Forms.MessageBox]::Show(
                                    "Convert-WindowsImage cannot run against unstaged builds. Please try again with a staged build.",
                                    "WIM is incompatible!",
                                    "OK",
                                    "Error"
                                )
                                return
                            } else {
                                $tempOpenWim.Images | ForEach-Object { $cmbSkuList.Items.Add($_.ImageFlags) }
                                $cmbSkuList.SelectedIndex = 0
                            }

                        } catch {
                            throw "Unable to load WIM metadata!"
                        } finally {
                            $tempOpenWim.Close()
                            Write-W2VTrace "Closing WIM metadata..."
                        }
                    }
                }
                $OnLoadForm_StateCorrection = {
                    # Correct the initial state of the form to prevent the .Net maximized form issue
                    $frmMain.WindowState = $InitialFormWindowState
                }
                #endregion Event scriptblocks

                # Figure out VHD size and size unit.
                $unit = $null
                switch ([math]::Round($SizeBytes.ToString().Length / 3)) {
                    3 { $unit = "MB"; break }
                    4 { $unit = "GB"; break }
                    5 { $unit = "TB"; break }
                    default { $unit = ""; break }
                }
                $quantity = Invoke-Expression -Command "$($SizeBytes) / 1$($unit)"

                #region Form Code
                #region frmMain
                $frmMain.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 579
                $System_Drawing_Size.Width = 512
                $frmMain.ClientSize = $System_Drawing_Size
                $frmMain.Font = New-Object System.Drawing.Font ("Segoe UI",10,0,3,1)
                $frmMain.FormBorderStyle = 1
                $frmMain.MaximizeBox = $false
                $frmMain.MinimizeBox = $false
                $frmMain.Name = "frmMain"
                $frmMain.StartPosition = 1
                $frmMain.Text = "Convert-WindowsImage UI"
                #endregion frmMain

                #region groupBox4
                $groupBox4.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 10
                $System_Drawing_Point.Y = 498
                $groupBox4.Location = $System_Drawing_Point
                $groupBox4.Name = "groupBox4"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 69
                $System_Drawing_Size.Width = 489
                $groupBox4.Size = $System_Drawing_Size
                $groupBox4.TabIndex = 8
                $groupBox4.TabStop = $false
                $groupBox4.Text = "4. Make the VHD!"
                $frmMain.Controls.Add($groupBox4)
                #endregion groupBox4

                #region btnGo
                $btnGo.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 39
                $System_Drawing_Point.Y = 24
                $btnGo.Location = $System_Drawing_Point
                $btnGo.Name = "btnGo"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 33
                $System_Drawing_Size.Width = 415
                $btnGo.Size = $System_Drawing_Size
                $btnGo.TabIndex = 0
                $btnGo.Text = "&Make my VHD"
                $btnGo.UseVisualStyleBackColor = $true
                $btnGo.DialogResult = "OK"
                $btnGo.add_Click($btnGo_OnClick)
                $groupBox4.Controls.Add($btnGo)
                $frmMain.AcceptButton = $btnGo
                #endregion btnGo

                #region groupBox3
                $groupBox3.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 10
                $System_Drawing_Point.Y = 243
                $groupBox3.Location = $System_Drawing_Point
                $groupBox3.Name = "groupBox3"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 245
                $System_Drawing_Size.Width = 489
                $groupBox3.Size = $System_Drawing_Size
                $groupBox3.TabIndex = 7
                $groupBox3.TabStop = $false
                $groupBox3.Text = "3. Choose configuration options"
                $frmMain.Controls.Add($groupBox3)
                #endregion groupBox3

                #region txtVhdName
                $txtVhdName.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 150
                $txtVhdName.Location = $System_Drawing_Point
                $txtVhdName.Name = "txtVhdName"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 418
                $txtVhdName.Size = $System_Drawing_Size
                $txtVhdName.TabIndex = 10
                $groupBox3.Controls.Add($txtVhdName)
                #endregion txtVhdName

                #region txtUnattendFile
                $txtUnattendFile.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 198
                $txtUnattendFile.Location = $System_Drawing_Point
                $txtUnattendFile.Name = "txtUnattendFile"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 418
                $txtUnattendFile.Size = $System_Drawing_Size
                $txtUnattendFile.TabIndex = 11
                $groupBox3.Controls.Add($txtUnattendFile)
                #endregion txtUnattendFile

                #region label7
                $label7.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 23
                $System_Drawing_Point.Y = 180
                $label7.Location = $System_Drawing_Point
                $label7.Name = "label7"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 23
                $System_Drawing_Size.Width = 175
                $label7.Size = $System_Drawing_Size
                $label7.Text = "Unattend File (Optional)"
                $groupBox3.Controls.Add($label7)
                #endregion label7

                #region label6
                $label6.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 23
                $System_Drawing_Point.Y = 132
                $label6.Location = $System_Drawing_Point
                $label6.Name = "label6"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 23
                $System_Drawing_Size.Width = 175
                $label6.Size = $System_Drawing_Size
                $label6.Text = "VHD Name (Optional)"
                $groupBox3.Controls.Add($label6)
                #endregion label6

                #region btnUnattendBrowse
                $btnUnattendBrowse.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 449
                $System_Drawing_Point.Y = 199
                $btnUnattendBrowse.Location = $System_Drawing_Point
                $btnUnattendBrowse.Name = "btnUnattendBrowse"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 27
                $btnUnattendBrowse.Size = $System_Drawing_Size
                $btnUnattendBrowse.TabIndex = 9
                $btnUnattendBrowse.Text = "..."
                $btnUnattendBrowse.UseVisualStyleBackColor = $true
                $btnUnattendBrowse.add_Click($btnUnattendBrowse_OnClick)
                $groupBox3.Controls.Add($btnUnattendBrowse)
                #endregion btnUnattendBrowse

                #region btnWrkBrowse
                $btnWrkBrowse.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 449
                $System_Drawing_Point.Y = 98
                $btnWrkBrowse.Location = $System_Drawing_Point
                $btnWrkBrowse.Name = "btnWrkBrowse"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 27
                $btnWrkBrowse.Size = $System_Drawing_Size
                $btnWrkBrowse.TabIndex = 9
                $btnWrkBrowse.Text = "..."
                $btnWrkBrowse.UseVisualStyleBackColor = $true
                $btnWrkBrowse.add_Click($btnWrkBrowse_OnClick)
                $groupBox3.Controls.Add($btnWrkBrowse)
                #endregion btnWrkBrowse

                #region cmbVhdSizeUnit
                $cmbVhdSizeUnit.DataBindings.DefaultDataSourceUpdateMode = 0
                $cmbVhdSizeUnit.FormattingEnabled = $true
                $cmbVhdSizeUnit.Items.Add("MB") | Out-Null
                $cmbVhdSizeUnit.Items.Add("GB") | Out-Null
                $cmbVhdSizeUnit.Items.Add("TB") | Out-Null
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 409
                $System_Drawing_Point.Y = 42
                $cmbVhdSizeUnit.Location = $System_Drawing_Point
                $cmbVhdSizeUnit.Name = "cmbVhdSizeUnit"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 67
                $cmbVhdSizeUnit.Size = $System_Drawing_Size
                $cmbVhdSizeUnit.TabIndex = 5
                $cmbVhdSizeUnit.Text = $unit
                $groupBox3.Controls.Add($cmbVhdSizeUnit)
                #endregion cmbVhdSizeUnit

                #region numVhdSize
                $numVhdSize.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 340
                $System_Drawing_Point.Y = 42
                $numVhdSize.Location = $System_Drawing_Point
                $numVhdSize.Name = "numVhdSize"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 63
                $numVhdSize.Size = $System_Drawing_Size
                $numVhdSize.TabIndex = 4
                $numVhdSize.Value = $quantity
                $groupBox3.Controls.Add($numVhdSize)
                #endregion numVhdSize

                #region cmbVhdFormat
                $cmbVhdFormat.DataBindings.DefaultDataSourceUpdateMode = 0
                $cmbVhdFormat.FormattingEnabled = $true
                $cmbVhdFormat.Items.Add("VHD") | Out-Null
                $cmbVhdFormat.Items.Add("VHDX") | Out-Null
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 42
                $cmbVhdFormat.Location = $System_Drawing_Point
                $cmbVhdFormat.Name = "cmbVhdFormat"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 136
                $cmbVhdFormat.Size = $System_Drawing_Size
                $cmbVhdFormat.TabIndex = 0
                $cmbVhdFormat.Text = $VHDFormat
                $groupBox3.Controls.Add($cmbVhdFormat)
                #endregion cmbVhdFormat

                #region label5
                $label5.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 23
                $System_Drawing_Point.Y = 76
                $label5.Location = $System_Drawing_Point
                $label5.Name = "label5"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 23
                $System_Drawing_Size.Width = 264
                $label5.Size = $System_Drawing_Size
                $label5.TabIndex = 8
                $label5.Text = "Working Directory"
                $groupBox3.Controls.Add($label5)
                #endregion label5

                #region txtWorkingDirectory
                $txtWorkingDirectory.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 99
                $txtWorkingDirectory.Location = $System_Drawing_Point
                $txtWorkingDirectory.Name = "txtWorkingDirectory"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 418
                $txtWorkingDirectory.Size = $System_Drawing_Size
                $txtWorkingDirectory.TabIndex = 7
                $txtWorkingDirectory.Text = $WorkingDirectory
                $groupBox3.Controls.Add($txtWorkingDirectory)
                #endregion txtWorkingDirectory

                #region label4
                $label4.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 340
                $System_Drawing_Point.Y = 21
                $label4.Location = $System_Drawing_Point
                $label4.Name = "label4"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 27
                $System_Drawing_Size.Width = 86
                $label4.Size = $System_Drawing_Size
                $label4.TabIndex = 6
                $label4.Text = "VHD Size"
                $groupBox3.Controls.Add($label4)
                #endregion label4

                #region label3
                $label3.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 176
                $System_Drawing_Point.Y = 21
                $label3.Location = $System_Drawing_Point
                $label3.Name = "label3"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 27
                $System_Drawing_Size.Width = 92
                $label3.Size = $System_Drawing_Size
                $label3.TabIndex = 3
                $label3.Text = "VHD Type"
                $groupBox3.Controls.Add($label3)
                #endregion label3

                #region label2
                $label2.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 21
                $label2.Location = $System_Drawing_Point
                $label2.Name = "label2"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 30
                $System_Drawing_Size.Width = 118
                $label2.Size = $System_Drawing_Size
                $label2.TabIndex = 1
                $label2.Text = "VHD Format"
                $groupBox3.Controls.Add($label2)
                #endregion label2

                #region groupBox2
                $groupBox2.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 10
                $System_Drawing_Point.Y = 169
                $groupBox2.Location = $System_Drawing_Point
                $groupBox2.Name = "groupBox2"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 68
                $System_Drawing_Size.Width = 490
                $groupBox2.Size = $System_Drawing_Size
                $groupBox2.TabIndex = 6
                $groupBox2.TabStop = $false
                $groupBox2.Text = "2. Choose a SKU from the list"
                $frmMain.Controls.Add($groupBox2)
                #endregion groupBox2

                #region cmbSkuList
                $cmbSkuList.DataBindings.DefaultDataSourceUpdateMode = 0
                $cmbSkuList.FormattingEnabled = $true
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 24
                $cmbSkuList.Location = $System_Drawing_Point
                $cmbSkuList.Name = "cmbSkuList"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 452
                $cmbSkuList.Size = $System_Drawing_Size
                $cmbSkuList.TabIndex = 2
                $groupBox2.Controls.Add($cmbSkuList)
                #endregion cmbSkuList

                #region label1
                $label1.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 23
                $System_Drawing_Point.Y = 21
                $label1.Location = $System_Drawing_Point
                $label1.Name = "label1"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 71
                $System_Drawing_Size.Width = 464
                $label1.Size = $System_Drawing_Size
                $label1.TabIndex = 5
                $label1.Text = $uiHeader
                $frmMain.Controls.Add($label1)
                #endregion label1

                #region groupBox1
                $groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 10
                $System_Drawing_Point.Y = 95
                $groupBox1.Location = $System_Drawing_Point
                $groupBox1.Name = "groupBox1"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 68
                $System_Drawing_Size.Width = 490
                $groupBox1.Size = $System_Drawing_Size
                $groupBox1.TabIndex = 4
                $groupBox1.TabStop = $false
                $groupBox1.Text = "1. Choose a source"
                $frmMain.Controls.Add($groupBox1)
                #endregion groupBox1

                #region txtSourcePath
                $txtSourcePath.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 25
                $System_Drawing_Point.Y = 24
                $txtSourcePath.Location = $System_Drawing_Point
                $txtSourcePath.Name = "txtSourcePath"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 418
                $txtSourcePath.Size = $System_Drawing_Size
                $txtSourcePath.TabIndex = 0
                $groupBox1.Controls.Add($txtSourcePath)
                #endregion txtSourcePath

                #region btnBrowseWim
                $btnBrowseWim.DataBindings.DefaultDataSourceUpdateMode = 0
                $System_Drawing_Point = New-Object System.Drawing.Point
                $System_Drawing_Point.X = 449
                $System_Drawing_Point.Y = 24
                $btnBrowseWim.Location = $System_Drawing_Point
                $btnBrowseWim.Name = "btnBrowseWim"
                $System_Drawing_Size = New-Object System.Drawing.Size
                $System_Drawing_Size.Height = 25
                $System_Drawing_Size.Width = 28
                $btnBrowseWim.Size = $System_Drawing_Size
                $btnBrowseWim.TabIndex = 1
                $btnBrowseWim.Text = "..."
                $btnBrowseWim.UseVisualStyleBackColor = $true
                $btnBrowseWim.add_Click($btnBrowseWim_OnClick)
                $groupBox1.Controls.Add($btnBrowseWim)
                #endregion btnBrowseWim

                $openFileDialog1.FileName = "openFileDialog1"
                $openFileDialog1.ShowHelp = $true
                #endregion Form Code

                # Save the initial state of the form
                $InitialFormWindowState = $frmMain.WindowState

                # Init the OnLoad event to correct the initial state of the form
                $frmMain.add_Load($OnLoadForm_StateCorrection)

                # Return the constructed form.
                $ret = $frmMain.ShowDialog()

                if (!($ret -ilike "OK")) {
                    throw "Form session has been cancelled."
                }
                if ([string]::IsNullOrEmpty($SourcePath)) {
                    throw "No source path specified."
                }

                # VHD Format
                $VHDFormat = $cmbVhdFormat.SelectedItem

                # VHD Size
                $SizeBytes = Invoke-Expression "$($numVhdSize.Value)$($cmbVhdSizeUnit.SelectedItem)"

                # Working Directory
                $WorkingDirectory = $txtWorkingDirectory.Text

                # VHDPath
                if (![string]::IsNullOrEmpty($txtVhdName.Text)) {
                    $VHDPath = "$($WorkingDirectory)\$($txtVhdName.Text)"
                }

                # Edition
                if (![string]::IsNullOrEmpty($cmbSkuList.SelectedItem)) {
                    $Edition = $cmbSkuList.SelectedItem
                }

                # Because we used ShowDialog, we need to manually dispose of the form.
                # This probably won't make much of a difference, but let's free up all of the resources we can
                # before we start the conversion process.
                $frmMain.Dispose()
            }

            if ($VHDFormat -ilike "AUTO") {
                if ($DiskLayout -eq "BIOS") {
                    $VHDFormat = "VHD"
                } else {
                    $VHDFormat = "VHDX"
                }
            }

            #
            # Choose smallest supported block size for dynamic VHD(X)
            #
            $BlockSizeBytes = 1MB

            # There's a difference between the maximum sizes for VHDs and VHDXs.    Make sure we follow it.
            if ("VHD" -ilike $VHDFormat) {
                if ($SizeBytes -gt $vhdMaxSize) {
                    Write-W2VWarn "For the VHD file format, the maximum file size is ~2040GB.    We're automatically setting the size to 2040GB for you."
                    $SizeBytes = 2040GB
                }

                $BlockSizeBytes = 512KB
            }

            # Check if -VHDPath and -WorkingDirectory were both specified.
            if ((![string]::IsNullOrEmpty($VHDPath)) -and (![string]::IsNullOrEmpty($WorkingDirectory))) {
                if ($WorkingDirectory -ne $pwd) {
                    # If the WorkingDirectory is anything besides $pwd, tell people that the WorkingDirectory is being ignored.
                    Write-W2VWarn "Specifying -VHDPath and -WorkingDirectory at the same time is contradictory."
                    Write-W2VWarn "Ignoring the WorkingDirectory specification."
                    $WorkingDirectory = Split-Path $VHDPath -Parent
                }
            }
            if ($VHDPath) {
                # Check to see if there's a conflict between the specified file extension and the VHDFormat being used.
                $ext = ([IO.FileInfo]$VHDPath).Extension

                if (!($ext -ilike ".$($VHDFormat)")) {
                    throw "There is a mismatch between the VHDPath file extension ($($ext.ToUpper())), and the VHDFormat (.$($VHDFormat)).    Please ensure that these match and try again."
                }
            }

            # Create a temporary name for the VHD(x).    We'll name it properly at the end of the script.
            if ([string]::IsNullOrEmpty($VHDPath)) {
                $VHDPath = Join-Path $WorkingDirectory "$($sessionKey).$($VHDFormat.ToLower())"
            } else {
                # Since we can't do Resolve-Path against a file that doesn't exist, we need to get creative in determining
                # the full path that the user specified (or meant to specify if they gave us a relative path).
                # Check to see if the path has a root specified.    If it doesn't, use the working directory.
                if (![IO.Path]::IsPathRooted($VHDPath)) {
                    $VHDPath = Join-Path $WorkingDirectory $VHDPath
                }

                $vhdFinalName = Split-Path $VHDPath -Leaf
                $VHDPath = Join-Path (Split-Path $VHDPath -Parent) "$($sessionKey).$($VHDFormat.ToLower())"
            }
            Write-W2VTrace "Temporary $VHDFormat path is : $VHDPath"

            # If we're using an ISO, mount it and get the path to the WIM file.
            if (([IO.FileInfo]$SourcePath).Extension -ilike ".ISO") {
                # If the ISO isn't local, copy it down so we don't have to worry about resource contention
                # or about network latency.
                if (Test-IsNetworkLocation $SourcePath) {
                    Write-W2VError "ISO Path cannot be network location"
                    #Write-W2VInfo "Copying ISO $(Split-Path $SourcePath -Leaf) to temp folder..."
                    #robocopy $(Split-Path $SourcePath -Parent) $TempDirectory $(Split-Path $SourcePath -Leaf) | Out-Null
                    #$SourcePath = "$($TempDirectory)\$(Split-Path $SourcePath -Leaf)"
                    #$tempSource = $SourcePath
                }
                $isoPath = (Resolve-Path $SourcePath).Path

                Write-W2VInfo "Opening ISO $(Split-Path $isoPath -Leaf)..."
                <#
                                $openIso         = Mount-DiskImage -ImagePath $isoPath -StorageType ISO -PassThru
                                # Refresh the DiskImage object so we can get the real information about it.    I assume this is a bug.
                                $openIso         = Get-DiskImage -ImagePath $isoPath
                                $driveLetter = ($openIso | Get-Volume).DriveLetter
                                #>
                $SourcePath = "$($DriveLetter):\sources\install.wim"

                # Check to see if there's a WIM file we can muck about with.
                Write-W2VInfo "Looking for $($SourcePath)..."
                if (!(Test-Path $SourcePath)) {
                    throw "The specified ISO does not appear to be valid Windows installation media."
                }
            }

            # Check to see if the WIM is local, or on a network location.    If the latter, copy it locally.
            if (Test-IsNetworkLocation $SourcePath) {
                Write-W2VInfo "Copying WIM $(Split-Path $SourcePath -Leaf) to temp folder..."
                robocopy $(Split-Path $SourcePath -Parent) $TempDirectory $(Split-Path $SourcePath -Leaf) | Out-Null
                $SourcePath = "$($TempDirectory)\$(Split-Path $SourcePath -Leaf)"

                $tempSource = $SourcePath
            }
            $SourcePath = (Resolve-Path $SourcePath).Path
            Write-W2VInfo "Looking for the requested Windows image in the WIM file"
            $WindowsImage = Get-WindowsImage -ImagePath "$($driveLetter):\sources\install.wim"
            if (-not $WindowsImage -or ($WindowsImage -is [System.Array])) {
                $EditionIndex = 0;
                if ([int32]::TryParse($Edition,[ref]$EditionIndex)) {
                    $WindowsImage = Get-WindowsImage -ImagePath $SourcePath -Index $EditionIndex
                } else {
                    $WindowsImage = Get-WindowsImage -ImagePath $SourcePath | Where-Object { $_.ImageName -ilike "*$($Edition)" }
                }
                if (-not $WindowsImage) {
                    throw "Requested windows Image was not found on the WIM file!"
                }
                if ($WindowsImage -is [System.Array]) {
                    Write-W2VInfo "WIM file has the following $($WindowsImage.Count) images that match filter *$($Edition)"
                    Get-WindowsImage -ImagePath $SourcePath

                    Write-W2VError "You must specify an Edition or SKU index, since the WIM has more than one image."
                    throw "There are more than one images that match ImageName filter *$($Edition)"
                }
            }
            $ImageIndex = $WindowsImage[0].ImageIndex

            # We're good.    Open the WIM container.
            # NOTE: this is only required because we want to get the XML-based meta-data at the end.    Is there a better way?
            # If we can get this information from DISM cmdlets, we can remove the openWim constructs
            $openWim = New-Object WIM2VHD.WimFile $SourcePath
            $openImage = $openWim[[int32]$ImageIndex]
            if ($null -eq $openImage) {
                Write-W2VError "The specified edition does not appear to exist in the specified WIM."
                Write-W2VError "Valid edition names are:"
                $openWim.Images | ForEach-Object { Write-W2VError "    $($_.ImageFlags)" }
                throw
            }
            Write-W2VInfo "Image $($openImage.ImageIndex) selected ($($openImage.ImageFlags))..."

            # Check to make sure that the image we're applying is Windows 7 or greater.
            if ($openImage.ImageVersion -lt $lowestSupportedVersion) {
                if ($openImage.ImageVersion -eq "0.0.0.0") {
                    Write-W2VWarn "The specified WIM does not encode the Windows version."
                } else {
                    throw "Convert-WindowsImage only supports Windows 7 and Windows 8 WIM files.    The specified image (version $($openImage.ImageVersion)) does not appear to contain one of those operating systems."
                }
            }
            if ($hyperVEnabled) {
                Write-W2VInfo "Creating sparse disk..."
                $newVhd = New-VHD -Path $VHDPath -SizeBytes $SizeBytes -BlockSizeBytes $BlockSizeBytes -Dynamic

                Write-W2VInfo "Mounting $VHDFormat..."
                $disk = $newVhd | Mount-VHD -Passthru | Get-Disk
            } else {
            <#
                Create the VHD using the VirtDisk Win32 API.
                So, why not use the New-VHD cmdlet here?
                
                New-VHD depends on the Hyper-V Cmdlets, which aren't installed by default.
                Installing those cmdlets isn't a big deal, but they depend on the Hyper-V WMI
                APIs, which in turn depend on Hyper-V.    In order to prevent Convert-WindowsImage
                from being dependent on Hyper-V (and thus, x64 systems only), we're using the
                VirtDisk APIs directly.
             #>

                Write-W2VInfo "Creating sparse disk..."
                [WIM2VHD.VirtualHardDisk]::CreateSparseDisk(
                    $VHDFormat,
                    $VHDPath,
                    $SizeBytes,
                    $true
                )
                # Attach the VHD.\
                Write-W2VInfo "Attaching $VHDFormat..."
                $disk = Mount-DiskImage -ImagePath $VHDPath -Passthru | Get-DiskImage | Get-Disk
            }

            switch ($DiskLayout) {
                "BIOS" {
                    Write-W2VInfo "Initializing disk..."
                    Initialize-Disk -Number $disk.Number -PartitionStyle MBR
                    #
                    # Create the Windows/system partition
                    #
                    Write-W2VInfo "Creating single partition..."
                    $systemPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -MbrType IFS -IsActive
                    $windowsPartition = $systemPartition
                    Write-W2VInfo "Formatting windows volume..."
                    $systemVolume = Format-Volume -Partition $systemPartition -FileSystem NTFS -Force -Confirm:$false
                    $windowsVolume = $systemVolume
                }

                "UEFI" {
                    Write-W2VInfo "Initializing disk..."
                    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
                    if ((Get-WindowsBuildNumber) -ge 10240) {
                        #
                        # Create the system partition.    Create a data partition so we can format it, then change to ESP
                        #
                        Write-W2VInfo "Creating EFI system partition..."
                        $systemPartition = New-Partition -DiskNumber $disk.Number -Size 200MB -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}'
                        Write-W2VInfo "Formatting system volume..."
                        $systemVolume = Format-Volume -Partition $systemPartition -FileSystem FAT32 -Force -Confirm:$false
                        Write-W2VInfo "Setting system partition as ESP..."
                        $systemPartition | Set-Partition -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'
                        $systemPartition | Add-PartitionAccessPath -AssignDriveLetter
                    } else {
                        #
                        # Create the system partition
                        #
                        Write-W2VInfo "Creating EFI system partition (ESP)..."
                        $systemPartition = New-Partition -DiskNumber $disk.Number -Size 200MB -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}' -AssignDriveLetter
                        Write-W2VInfo "Formatting ESP..."
                        $formatArgs = @(
                            "$($systemPartition.DriveLetter):",# Partition drive letter
                            "/FS:FAT32",# File system
                            "/Q",# Quick format
                            "/Y" # Suppress prompt
                        )
                        Run-Executable -Executable format -Arguments $formatArgs
                    }

                    #
                    # Create the reserved partition
                    #
                    Write-W2VInfo "Creating MSR partition..."
                    $reservedPartition = New-Partition -DiskNumber $disk.Number -Size 128MB -GptType '{e3c9e316-0b5c-4db8-817d-f92df00215ae}'

                    #
                    # Create the Windows partition
                    #
                    Write-W2VInfo "Creating windows partition..."
                    $windowsPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}'

                    Write-W2VInfo "Formatting windows volume..."
                    $windowsVolume = Format-Volume -Partition $windowsPartition -FileSystem NTFS -Force -Confirm:$false
                }

                "WindowsToGo" {
                    Write-W2VInfo "Initializing disk..."
                    Initialize-Disk -Number $disk.Number -PartitionStyle MBR
                    #
                    # Create the system partition
                    #
                    Write-W2VInfo "Creating system partition..."
                    $systemPartition = New-Partition -DiskNumber $disk.Number -Size 350MB -MbrType FAT32 -IsActive

                    Write-W2VInfo "Formatting system volume..."
                    $systemVolume = Format-Volume -Partition $systemPartition -FileSystem FAT32 -Force -Confirm:$false
                    #
                    # Create the Windows partition
                    #
                    Write-W2VInfo "Creating windows partition..."
                    $windowsPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -MbrType IFS
                    Write-W2VInfo "Formatting windows volume..."
                    $windowsVolume = Format-Volume -Partition $windowsPartition -FileSystem NTFS -Force -Confirm:$false
                }
            }

            #
            # Assign drive letter to Windows partition.    This is required for bcdboot
            #
            $attempts = 1
            $assigned = $false
            do {
                $windowsPartition | Add-PartitionAccessPath -AssignDriveLetter
                $windowsPartition = $windowsPartition | Get-Partition
                if ($windowsPartition.DriveLetter -ne 0) {
                    $assigned = $true
                } else {
                    #sleep for up to 10 seconds and retry
                    Get-Random -Minimum 1 -Maximum 10 | Start-Sleep
                    $attempts++
                }
            } while ($attempts -le 100 -and -not ($assigned))
            if (-not ($assigned)) {
                throw "Unable to get Partition after retry"
            }
            $windowsDrive = $(Get-Partition -Volume $windowsVolume).AccessPaths[0].substring(0,2)
            Write-W2VInfo "Windows path ($windowsDrive) has been assigned."
            Write-W2VInfo "Windows path ($windowsDrive) took $attempts attempts to be assigned."

            #
            # Refresh access paths (we have now formatted the volume)
            #
            $systemPartition = $systemPartition | Get-Partition
            $systemDrive = $systemPartition.AccessPaths[0].trimend("\").Replace("\?","??")
            Write-W2VInfo "System volume location: $systemDrive"

            ####################################################################################################
            # APPLY IMAGE FROM WIM TO THE NEW VHD
            ####################################################################################################

            Write-W2VInfo "Applying image to $VHDFormat. This could take a while..."
            if ((Get-Command Expand-WindowsImage -ErrorAction SilentlyContinue) -and ((-not $ApplyEA) -and ([string]::IsNullOrEmpty($DismPath)))) {
                Expand-WindowsImage -ApplyPath $windowsDrive -ImagePath $SourcePath -Index $ImageIndex -LogPath "$($logFolder)\DismLogs.log" | Out-Null
            } else {
                if (![string]::IsNullOrEmpty($DismPath)) {
                    $dismPath = $DismPath
                } else {
                    $dismPath = $(Join-Path (Get-Item env:\windir).Value "system32\dism.exe")
                }

                $applyImage = "/Apply-Image"
                if ($ApplyEA) {
                    $applyImage = $applyImage + " /EA"
                }

                $dismArgs = @("$applyImage /ImageFile:`"$SourcePath`" /Index:$ImageIndex /ApplyDir:$windowsDrive /LogPath:`"$($logFolder)\DismLogs.log`"")
                Write-W2VInfo "Applying image: $dismPath $dismArgs"
                $process = Start-Process -Passthru -Wait -NoNewWindow -FilePath $dismPath `
                     -ArgumentList $dismArgs `

                if ($process.ExitCode -ne 0) {
                    throw "Image Apply failed! See DismImageApply logs for details"
                }
            }
            Write-W2VInfo "Image was applied successfully. "

            #
            # Here we copy in the unattend file (if specified by the command line)
            #
            if (![string]::IsNullOrEmpty($UnattendPath)) {
                Write-W2VInfo "Applying unattend file ($(Split-Path $UnattendPath -Leaf))..."
                Copy-Item -Path $UnattendPath -Destination (Join-Path $windowsDrive "unattend.xml") -Force
            }
            if (![string]::IsNullOrEmpty($MergeFolderPath)) {
                Write-W2VInfo "Applying merge folder ($MergeFolderPath)..."
                Copy-Item -Recurse -Path (Join-Path $MergeFolderPath "*") -Destination $windowsDrive -Force #added to handle merge folders
            }
            if (($openImage.ImageArchitecture -ne "ARM") -and # No virtualization platform for ARM images
                ($openImage.ImageArchitecture -ne "ARM64") -and # No virtualization platform for ARM64 images
                ($BCDinVHD -ne "NativeBoot")) # User asked for a non-bootable image
            {
                if (Test-Path "$($systemDrive)\boot\bcd") {
                    Write-W2VInfo "Image already has BIOS BCD store..."
                } elseif (Test-Path "$($systemDrive)\efi\microsoft\boot\bcd") {
                    Write-W2VInfo "Image already has EFI BCD store..."
                } else  {
                    Write-W2VInfo "Making image bootable..."
                    $bcdBootArgs = @(
                        "$($windowsDrive)\Windows",# Path to the \Windows on the VHD
                        "/s $systemDrive",# Specifies the volume letter of the drive to create the \BOOT folder on.
                        "/v" # Enabled verbose logging.
                    )
                    switch ($DiskLayout) {
                        "BIOS" {
                            $bcdBootArgs += "/f BIOS" # Specifies the firmware type of the target system partition
                        }
                        "UEFI" {
                            $bcdBootArgs += "/f UEFI" # Specifies the firmware type of the target system partition
                        }
                        "WindowsToGo" {
                            # Create entries for both UEFI and BIOS if possible
                            if (Test-Path "$($windowsDrive)\Windows\boot\EFI\bootmgfw.efi") {
                                $bcdBootArgs += "/f ALL"
                            }
                        }
                    }
                    Run-Executable -Executable $BCDBoot -Arguments $bcdBootArgs

                    # The following is added to mitigate the VMM diff disk handling
                    # We're going to change from MBRBootOption to LocateBootOption.
                    if ($DiskLayout -eq "BIOS") {
                        Write-W2VInfo "Fixing the Device ID in the BCD store on $($VHDFormat)..."
                        Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                            "/store $($systemDrive)\boot\bcd",
                            "/set `{bootmgr`} device locate"
                        )
                        Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                            "/store $($systemDrive)\boot\bcd",
                            "/set `{default`} device locate"
                        )
                        Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                            "/store $($systemDrive)\boot\bcd",
                            "/set `{default`} osdevice locate"
                        )
                    }
                }
                Write-W2VInfo "Drive is bootable. Cleaning up..."

                # Are we turning the debugger on?
                if ($EnableDebugger -inotlike "None") {
                    $bcdEditArgs = $null;
                    # Configure the specified debugging transport and other settings.
                    switch ($EnableDebugger) {
                        "Serial" {
                            $bcdEditArgs = @(
                                "/dbgsettings SERIAL",
                                "DEBUGPORT:$($ComPort.Value)",
                                "BAUDRATE:$($BaudRate.Value)"
                            )
                        }
                        "1394" {
                            $bcdEditArgs = @(
                                "/dbgsettings 1394",
                                "CHANNEL:$($Channel.Value)"
                            )
                        }
                        "USB" {
                            $bcdEditArgs = @(
                                "/dbgsettings USB",
                                "TARGETNAME:$($Target.Value)"
                            )
                        }
                        "Local" {
                            $bcdEditArgs = @(
                                "/dbgsettings LOCAL"
                            )
                        }
                        "Network" {
                            $bcdEditArgs = @(
                                "/dbgsettings NET",
                                "HOSTIP:$($IP.Value)",
                                "PORT:$($Port.Value)",
                                "KEY:$($Key.Value)"
                            )
                        }
                    }
                    $bcdStores = @(
                        "$($systemDrive)\boot\bcd",
                        "$($systemDrive)\efi\microsoft\boot\bcd"
                    )
                    foreach ($bcdStore in $bcdStores) {
                        if (Test-Path $bcdStore) {
                            Write-W2VInfo "Turning kernel debugging on in the $($VHDFormat) for $($bcdStore)..."
                            Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                "/store $($bcdStore)",
                                "/set `{default`} debug on"
                            )
                            $bcdEditArguments = @("/store $($bcdStore)") + $bcdEditArgs
                            Run-Executable -Executable "BCDEDIT.EXE" -Arguments $bcdEditArguments
                        }
                    }
                }
            } else {
                # Don't bother to check on debugging.    We can't boot WoA VHDs in VMs, and
                # if we're native booting, the changes need to be made to the BCD store on the
                # physical computer's boot volume.
                Write-W2VInfo "Image applied. It is not bootable."
            }

            if ($RemoteDesktopEnable -or (-not $ExpandOnNativeBoot)) {
                $hiveSystem   = Mount-RegistryHive -Hive (Join-Path $windowsDrive "Windows\System32\Config\System")
                $hiveSoftware = Mount-RegistryHive -Hive (Join-Path $windowsDrive "Windows\System32\Config\Software")
                $hiveDefault  = Mount-RegistryHive -Hive (Join-Path $windowsDrive "Windows\System32\Config\Default")
                if ($RemoteDesktopEnable) {
                    Write-W2VInfo "Enabling Remote Desktop"
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSystem)\ControlSet001\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSystem)\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp"  -Name "UserAuthentication" -Value 0
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableVirtualizedGraphics" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "ColorDepth" -Value 4
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "bEnumerateHWBeforeSW" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableRemoteFXAdvancedRemoteApp" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "AVC444ModePreferred" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "AVCHardwareEncodePreferred" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxCompressionLevel" -Value 2
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableVirtualizedGraphics" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "GraphicsProfile" -Value 2
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableWddmDriver" -Value 1
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSoftware)\Policies\Microsoft\Windows NT\Terminal Services\Client" -Name "EnableHardwareMode" -Value 1

                }
                if (-not $ExpandOnNativeBoot) {
                    Write-W2VInfo "Disabling automatic $VHDFormat expansion for Native Boot"
                    Set-W2VItemProperty -Path "HKLM:\$($hiveSystem)\ControlSet001\Services\FsDepends\Parameters" -Name "VirtualDiskExpandOnMount" -Value 4
                }
                if ($NumLock -eq $true) {
                    Set-W2VItemProperty -Path "HKLM:\$($hiveDefault)\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 2
                }
                Dismount-RegistryHive -HiveMountPoint $hiveSystem
                Dismount-RegistryHive -HiveMountPoint $hiveSoftware
                Dismount-RegistryHive -HiveMountPoint $hiveDefault
            }

            if ($Driver) {
                Write-W2VInfo "Adding Windows Drivers to the Image"
                $Driver | ForEach-Object -Process {
                    Write-W2VInfo "Driver path: $PSItem"
                    Add-WindowsDriver -Path $windowsDrive -Recurse -Driver $PSItem -Verbose | Out-Null
                }
            }

            if ($Feature) {
                Write-W2VInfo "Installing Windows Feature(s) $Feature to the Image"
                $FeatureSourcePath = Join-Path -Path "$($driveLetter):" -ChildPath "sources\sxs"
                Write-W2VInfo "From $FeatureSourcePath"
                Enable-WindowsOptionalFeature -FeatureName $Feature -Source $FeatureSourcePath -Path $windowsDrive -All | Out-Null
            }

            if ($Package) {
                Write-W2VInfo "Adding Windows Packages to the Image"
                $Package | ForEach-Object -Process {
                    Write-W2VInfo "Package path: $PSItem"
                    Add-WindowsPackage -Path $windowsDrive -PackagePath $PSItem | Out-Null
                }
            }

            #
            # Remove system partition access path, if necessary
            #
            if (($GPUName)) {
                Add-VMGpuPartitionAdapterFiles -GPUName $GPUName -DriveLetter $windowsDrive
            }

            if ($Parsec -eq $true) {
                Write-W2VInfo "Setting up Parsec to install at boot"
            }
            
            if (($Parsec -eq $true) -or ($RemoteDesktopEnable -eq $true) -or ($NumLock -eq $true)) {
                Setup-RemoteDesktop -Parsec:$Parsec -ParsecVDD:$ParsecVDD -rdp:$RemoteDesktopEnable -NumLock:$NumLock -DriveLetter $WindowsDrive -Team_ID $team_id -Key $key
            }
            
            if ($DiskLayout -eq "UEFI") {
                $systemPartition | Remove-PartitionAccessPath -AccessPath $systemPartition.AccessPaths[0]
            }

            if ([string]::IsNullOrEmpty($vhdFinalName)) {
                # We need to generate a file name.
                Write-W2VInfo "Generating name for $($VHDFormat)..."
                $hive = Mount-RegistryHive -Hive (Join-Path $windowsDrive "Windows\System32\Config\Software")
                $buildLabEx = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").BuildLabEx
                $installType = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").InstallationType
                $editionId = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").EditionID
                $skuFamily = $null

                Dismount-RegistryHive -HiveMountPoint $hive

                # Is this ServerCore?
                # Since we're only doing this string comparison against the InstallType key, we won't get
                # false positives with the Core SKU.
                if ($installType.ToUpper().Contains("CORE")) {
                    $editionId += "Core"
                }

                # What type of SKU are we?
                if ($installType.ToUpper().Contains("SERVER")) {
                    $skuFamily = "Server"
                } elseif ($installType.ToUpper().Contains("CLIENT")) {
                    $skuFamily = "Client"
                } else {
                    $skuFamily = "Unknown"
                }

                #
                # ISSUE - do we want VL here?
                #
                $vhdFinalName = "$($buildLabEx)_$($skuFamily)_$($editionId)_$($openImage.ImageDefaultLanguage).$($VHDFormat.ToLower())"
                Write-W2VTrace "$VHDFormat final name is : $vhdFinalName"
            }

            if ($hyperVEnabled) {
                Write-W2VInfo "Dismounting $VHDFormat..."
                Dismount-VHD -Path $VHDPath
            } else {
                Write-W2VInfo "Closing $VHDFormat..."
                Dismount-DiskImage -ImagePath $VHDPath
            }

            $vhdFinalPath = Join-Path (Split-Path $VHDPath -Parent) $vhdFinalName
            Write-W2VTrace "$VHDFormat final path is : $vhdFinalPath"

            if (Test-Path $vhdFinalPath) {
                Write-W2VInfo "Deleting pre-existing $VHDFormat : $(Split-Path $vhdFinalPath -Leaf)..."
                Remove-Item -Path $vhdFinalPath -Force
            }

            Write-W2VTrace -text "Renaming $VHDFormat at $VHDPath to $vhdFinalName"
            Rename-Item -Path (Resolve-Path $VHDPath).Path -NewName $vhdFinalName -Force
            $vhd += Get-DiskImage -ImagePath $vhdFinalPath

            $vhdFinalName = $null
        } catch {
            Write-W2VError $_
            Write-W2VInfo "Log folder is $logFolder"
        } finally {
            # If we still have a WIM image open, close it.
            if ($openWim -ne $null) {
                Write-W2VInfo "Closing Windows image..."
                $openWim.Close()
            }
            # If we still have a registry hive mounted, dismount it.
            if ($mountedHive -ne $null) {
                Write-W2VInfo "Closing registry hive..."
                Dismount-RegistryHive -HiveMountPoint $mountedHive
            }
            # If VHD is mounted, unmount it
            if (Test-Path $VHDPath) {
                if ($hyperVEnabled) {
                    if ((Get-VHD -Path $VHDPath).Attached) {
                            Dismount-VHD -Path $VHDPath
                    }
                } else {
                    Dismount-DiskImage -ImagePath $VHDPath
                }
            }
            # If we still have an ISO open, close it.
            if ($openIso -ne $null) {
                Write-W2VInfo "Closing ISO..."
                Dismount-DiskImage $ISOPath
            }
            if (-not $CacheSource) {
                if ($tempSource -and (Test-Path $tempSource)) {
                    Remove-Item -Path $tempSource -Force
                }
            }
            # Close out the transcript and tell the user we're done.
            Dismount-ISO -SourcePath $ISOPath
            if ($transcripting) {
                $null = Stop-Transcript
            }
        }
    } end {
        if ($Passthru) {
            return $vhd
        }
    }
    #endregion Code

}
#========================================================================

#========================================================================
function Add-WindowsImageTypes {
    $code = @"
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Runtime.InteropServices;
    using System.Security;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using Microsoft.Win32.SafeHandles;
    namespace WIM2VHD {
    public class NativeMethods {
        #region Delegates and Callbacks
        #region WIMGAPI
        public delegate uint WimMessageCallback(
            uint   MessageId,
            IntPtr wParam,
            IntPtr lParam,
            IntPtr UserData
        );
        public static void RegisterMessageCallback(WimFileHandle hWim, WimMessageCallback callback) {
            uint _callback = NativeMethods.WimRegisterMessageCallback(hWim, callback, IntPtr.Zero);
            int rc = Marshal.GetLastWin32Error();
            if (0 != rc) {
                throw
                    new InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to register message callback."
                ));
            }
        }
        public static void UnregisterMessageCallback(WimFileHandle hWim, WimMessageCallback registeredCallback) {
            bool status = NativeMethods.WimUnregisterMessageCallback(hWim, registeredCallback);
            int rc = Marshal.GetLastWin32Error();
            if (!status) {
                throw
                    new InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to unregister message callback."
                ));
            }
        }
        #endregion WIMGAPI
        #endregion Delegates and Callbacks
        #region Constants
        #region VDiskInterop
        public   const uint  OPEN_VIRTUAL_DISK_RW_DEFAULT_DEPTH   = 0x00000001;
        public   const uint  DEFAULT_BLOCK_SIZE                   = 0x00080000;
        public   const uint  DISK_SECTOR_SIZE                     = 0x00000200;
        internal const uint  ERROR_VIRTDISK_NOT_VIRTUAL_DISK      = 0xC03A0015;
        internal const uint  ERROR_NOT_FOUND                      = 0x00000490;
        internal const uint  ERROR_IO_PENDING                     = 0x000003E5;
        internal const uint  ERROR_INSUFFICIENT_BUFFER            = 0x0000007A;
        internal const uint  ERROR_ERROR_DEV_NOT_EXIST            = 0x00000037;
        internal const uint  ERROR_BAD_COMMAND                    = 0x00000016;
        internal const uint  ERROR_SUCCESS                        = 0x00000000;
        public   const uint  GENERIC_READ                         = 0x80000000;
        public   const uint  GENERIC_WRITE                        = 0x40000000;
        public   const short FILE_ATTRIBUTE_NORMAL                = 0x00000080;
        public   const uint  CREATE_NEW                           = 0x00000001;
        public   const uint  CREATE_ALWAYS                        = 0x00000002;
        public   const uint  OPEN_EXISTING                        = 0x00000003;
        public   const short INVALID_HANDLE_VALUE                 = -1;
        internal static Guid VirtualStorageTypeVendorUnknown      = new Guid("00000000-0000-0000-0000-000000000000");
        internal static Guid VirtualStorageTypeVendorMicrosoft    = new Guid("EC984AEC-A0F9-47e9-901F-71415A66345B");
        #endregion VDiskInterop
        #region WIMGAPI
        public   const uint  WIM_FLAG_VERIFY                      = 0x00000002;
        public   const uint  WIM_FLAG_INDEX                       = 0x00000004;  
        public   const uint  WM_APP                               = 0x00008000;
        #endregion WIMGAPI
        #endregion Constants
        #region Enums and Flags
        #region VDiskInterop
        public enum CreateVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }
        public enum OpenVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }
        public enum AttachVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }
        public enum CompactVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001
        }
        public enum VirtualStorageDeviceType : int {
            Unknown                    = 0x00000000,
            ISO                        = 0x00000001,
            VHD                        = 0x00000002,
            VHDX                       = 0x00000003
        }
        [Flags]
        public enum OpenVirtualDiskFlags {
            None                       = 0x00000000,
            NoParents                  = 0x00000001,
            BlankFile                  = 0x00000002,
            BootDrive                  = 0x00000004,
        }
        [Flags]
        public enum VirtualDiskAccessMask {
            None                       = 0x00000000,
            AttachReadOnly             = 0x00010000,
            AttachReadWrite            = 0x00020000,
            Detach                     = 0x00040000,
            GetInfo                    = 0x00080000,
            Create                     = 0x00100000,
            MetaOperations             = 0x00200000,
            Read                       = 0x000D0000,
            All                        = 0x003F0000,
            Writable                   = 0x00320000
        }
        [Flags]
        public enum CreateVirtualDiskFlags {
            None                       = 0x00000000,
            FullPhysicalAllocation     = 0x00000001
        }
        [Flags]
        public enum AttachVirtualDiskFlags {
            None                       = 0x00000000,
            ReadOnly                   = 0x00000001,
            NoDriveLetter              = 0x00000002,
            PermanentLifetime          = 0x00000004,
            NoLocalHost                = 0x00000008
        }
        [Flags]
        public enum DetachVirtualDiskFlag {
            None                       = 0x00000000
        }
        [Flags]
        public enum CompactVirtualDiskFlags {
            None                       = 0x00000000,
            NoZeroScan                 = 0x00000001,
            NoBlockMoves               = 0x00000002
        }
        #endregion VDiskInterop
        #region WIMGAPI
        [FlagsAttribute]
        internal enum WimCreateFileDesiredAccess : uint {
            WimQuery                   = 0x00000000,
            WimGenericRead             = 0x80000000
        }
        public enum WimMessage : uint {
            WIM_MSG                    = WM_APP + 0x1476,
            WIM_MSG_TEXT,
            WIM_MSG_PROGRESS,
            WIM_MSG_PROCESS,
            WIM_MSG_SCANNING,
            WIM_MSG_SETRANGE,
            WIM_MSG_SETPOS,
            WIM_MSG_STEPIT,
            WIM_MSG_COMPRESS,
            WIM_MSG_ERROR,
            WIM_MSG_ALIGNMENT,
            WIM_MSG_RETRY,
            WIM_MSG_SPLIT,
            WIM_MSG_SUCCESS            = 0x00000000,
            WIM_MSG_ABORT_IMAGE        = 0xFFFFFFFF
        }
        internal enum WimCreationDisposition : uint {
            WimOpenExisting            = 0x00000003,
        }
        internal enum WimActionFlags : uint {
            WimIgnored                 = 0x00000000
        }
        internal enum  WimCompressionType : uint {
            WimIgnored                 = 0x00000000
        }
        internal enum WimCreationResult : uint {
            WimCreatedNew              = 0x00000000,
            WimOpenedExisting          = 0x00000001
        }
        #endregion WIMGAPI
        #endregion Enums and Flags
        #region Structs
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct CreateVirtualDiskParameters {
            public CreateVirtualDiskVersion Version;
            public Guid UniqueId;
            public ulong MaximumSize;
            public uint BlockSizeInBytes;
            public uint SectorSizeInBytes;
            public string ParentPath;
            public string SourcePath;
            public OpenVirtualDiskFlags OpenFlags;
            public bool GetInfoOnly;
            public VirtualStorageType ParentVirtualStorageType;
            public VirtualStorageType SourceVirtualStorageType;
            public Guid ResiliencyGuid;
        }
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct VirtualStorageType {
            public VirtualStorageDeviceType DeviceId;
            public Guid VendorId;
        }
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct SecurityDescriptor {
            public byte revision;
            public byte size;
            public short control;
            public IntPtr owner;
            public IntPtr group;
            public IntPtr sacl;
            public IntPtr dacl;
        }
        #endregion Structs
        #region VirtDisk.DLL P/Invoke
        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint CreateVirtualDisk(
            [In, Out] ref VirtualStorageType VirtualStorageType,
            [In]          string Path,
            [In]          VirtualDiskAccessMask VirtualDiskAccessMask,
            [In, Out] ref SecurityDescriptor SecurityDescriptor,
            [In]          CreateVirtualDiskFlags Flags,
            [In]          uint ProviderSpecificFlags,
            [In, Out] ref CreateVirtualDiskParameters Parameters,
            [In]          IntPtr Overlapped,
            [Out]     out SafeFileHandle Handle);
        #endregion VirtDisk.DLL P/Invoke
        #region Win32 P/Invoke
        [DllImport("advapi32", SetLastError = true)]
        public static extern bool InitializeSecurityDescriptor(
            [Out]     out SecurityDescriptor pSecurityDescriptor,
            [In]          uint dwRevision);
        #endregion Win32 P/Invoke
        #region WIMGAPI P/Invoke
        #region SafeHandle wrappers for WimFileHandle and WimImageHandle
        public sealed class WimFileHandle : SafeHandle {
            public WimFileHandle(string wimPath) : base(IntPtr.Zero, true) {
                if (String.IsNullOrEmpty(wimPath)) {
                    throw new ArgumentNullException("wimPath");
                }
                if (!File.Exists(Path.GetFullPath(wimPath))) {
                    throw new FileNotFoundException((new FileNotFoundException()).Message, wimPath);
                }
                NativeMethods.WimCreationResult creationResult;
                this.handle = NativeMethods.WimCreateFile(
                    wimPath,
                    NativeMethods.WimCreateFileDesiredAccess.WimGenericRead,
                    NativeMethods.WimCreationDisposition.WimOpenExisting,
                    NativeMethods.WimActionFlags.WimIgnored,
                    NativeMethods.WimCompressionType.WimIgnored,
                    out creationResult
                );
                if (creationResult != NativeMethods.WimCreationResult.WimOpenedExisting) {
                    throw new Win32Exception();
                }
                if (this.handle == IntPtr.Zero) {
                    throw new Win32Exception();
                }
                NativeMethods.WimSetTemporaryPath(this, Environment.ExpandEnvironmentVariables("%TEMP%"));
            }
            protected override bool ReleaseHandle() {
                return NativeMethods.WimCloseHandle(this.handle);
            }
            public override bool IsInvalid {
                get { return this.handle == IntPtr.Zero; }
            }
        }
        public sealed class WimImageHandle : SafeHandle {
            public WimImageHandle(WimFile Container, uint ImageIndex) : base(IntPtr.Zero, true) {
                if (null == Container) {
                    throw new ArgumentNullException("Container");
                }
                if ((Container.Handle.IsClosed) || (Container.Handle.IsInvalid)) {
                    throw new ArgumentNullException("The handle to the WIM file has already been closed, or is invalid.", "Container");
                }
                if (ImageIndex > Container.ImageCount) {
                    throw new ArgumentOutOfRangeException("ImageIndex", "The index does not exist in the specified WIM file.");
                }
                this.handle = NativeMethods.WimLoadImage(
                    Container.Handle.DangerousGetHandle(),
                    ImageIndex);
            }
            protected override bool ReleaseHandle() {
                return NativeMethods.WimCloseHandle(this.handle);
            }
            public override bool IsInvalid {
                get { return this.handle == IntPtr.Zero; }
            }
        }
        #endregion SafeHandle wrappers for WimFileHandle and WimImageHandle
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMCreateFile")]
        internal static extern IntPtr WimCreateFile(
            [In, MarshalAs(UnmanagedType.LPWStr)] string WimPath,
            [In]    WimCreateFileDesiredAccess DesiredAccess,
            [In]    WimCreationDisposition CreationDisposition,
            [In]    WimActionFlags FlagsAndAttributes,
            [In]    WimCompressionType CompressionType,
            [Out, Optional] out WimCreationResult CreationResult
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMCloseHandle")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool WimCloseHandle(
            [In]    IntPtr Handle
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMLoadImage")]
        internal static extern IntPtr WimLoadImage(
            [In]    IntPtr Handle,
            [In]    uint ImageIndex
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMGetImageCount")]
        internal static extern uint WimGetImageCount(
            [In]    WimFileHandle Handle
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMGetImageInformation")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool WimGetImageInformation(
            [In]        SafeHandle Handle,
            [Out]   out StringBuilder ImageInfo,
            [Out]   out uint SizeOfImageInfo
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMSetTemporaryPath")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool WimSetTemporaryPath(
            [In]    WimFileHandle Handle,
            [In]    string TempPath
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMRegisterMessageCallback", CallingConvention = CallingConvention.StdCall)]
        internal static extern uint WimRegisterMessageCallback(
            [In, Optional] WimFileHandle      hWim,
            [In]           WimMessageCallback MessageProc,
            [In, Optional] IntPtr             ImageInfo
        );
        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMUnregisterMessageCallback", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool WimUnregisterMessageCallback(
            [In, Optional] WimFileHandle      hWim,
            [In]           WimMessageCallback MessageProc
        );
        #endregion WIMGAPI P/Invoke
    }
    #region WIM Interop
    public class WimFile {
        internal XDocument m_xmlInfo;
        internal List<WimImage> m_imageList;
        private static NativeMethods.WimMessageCallback wimMessageCallback;
        #region Events
        public delegate void DefaultImageEventHandler(object sender, DefaultImageEventArgs e);
        public delegate void ProcessFileEventHandler(object sender, ProcessFileEventArgs e);
        public event ProcessFileEventHandler ProcessFileEvent;
        public event DefaultImageEventHandler ProgressEvent;
        public event DefaultImageEventHandler ErrorEvent;
        public event DefaultImageEventHandler StepItEvent;
        public event DefaultImageEventHandler SetRangeEvent;
        public event DefaultImageEventHandler SetPosEvent;
        #endregion Events
        private enum ImageEventMessage : uint {
            Progress = NativeMethods.WimMessage.WIM_MSG_PROGRESS,
            Process = NativeMethods.WimMessage.WIM_MSG_PROCESS,
            Compress = NativeMethods.WimMessage.WIM_MSG_COMPRESS,
            Error = NativeMethods.WimMessage.WIM_MSG_ERROR,
            Alignment = NativeMethods.WimMessage.WIM_MSG_ALIGNMENT,
            Split = NativeMethods.WimMessage.WIM_MSG_SPLIT,
            Scanning = NativeMethods.WimMessage.WIM_MSG_SCANNING,
            SetRange = NativeMethods.WimMessage.WIM_MSG_SETRANGE,
            SetPos = NativeMethods.WimMessage.WIM_MSG_SETPOS,
            StepIt = NativeMethods.WimMessage.WIM_MSG_STEPIT,
            Success = NativeMethods.WimMessage.WIM_MSG_SUCCESS,
            Abort = NativeMethods.WimMessage.WIM_MSG_ABORT_IMAGE
        }
        private uint ImageEventMessagePump(uint MessageId, IntPtr wParam, IntPtr lParam, IntPtr UserData) { 
            uint status = (uint) NativeMethods.WimMessage.WIM_MSG_SUCCESS;
            DefaultImageEventArgs eventArgs = new DefaultImageEventArgs(wParam, lParam, UserData);
            switch ((ImageEventMessage)MessageId) {
                case ImageEventMessage.Progress:
                    ProgressEvent(this, eventArgs);
                    break;
                case ImageEventMessage.Process:
                    if (null != ProcessFileEvent) {
                        string fileToImage = Marshal.PtrToStringUni(wParam);
                        ProcessFileEventArgs fileToProcess = new ProcessFileEventArgs(fileToImage, lParam);
                        ProcessFileEvent(this, fileToProcess);
                        if (fileToProcess.Abort == true) {
                            status = (uint)ImageEventMessage.Abort;
                        }
                    }
                    break;
                case ImageEventMessage.Error:
                    if (null != ErrorEvent) {
                        ErrorEvent(this, eventArgs);
                    }
                    break;
                case ImageEventMessage.SetRange:
                    if (null != SetRangeEvent) {
                        SetRangeEvent(this, eventArgs);
                    }
                    break;
                case ImageEventMessage.SetPos:
                    if (null != SetPosEvent) {
                        SetPosEvent(this, eventArgs);
                    }
                    break;
                case ImageEventMessage.StepIt:
                    if (null != StepItEvent) {
                        StepItEvent(this, eventArgs);
                    }
                    break;
                default:
                    break;
            }
            return status;
        }
        public WimFile(string wimPath) {
            if (string.IsNullOrEmpty(wimPath)) {
                throw new ArgumentNullException("wimPath");
            }
            if (!File.Exists(Path.GetFullPath(wimPath))) {
                throw new FileNotFoundException((new FileNotFoundException()).Message, wimPath);
            }
            Handle = new NativeMethods.WimFileHandle(wimPath);
        }
        public void Close() {
            foreach (WimImage image in Images) {
                image.Close();
            }
            if (null != wimMessageCallback) {
                NativeMethods.UnregisterMessageCallback(this.Handle, wimMessageCallback);
                wimMessageCallback = null;
            }
            if ((!Handle.IsClosed) && (!Handle.IsInvalid)) {
                Handle.Close();
            }
        }
        public List<WimImage> Images {
            get {
                if (null == m_imageList) {
                    int imageCount = (int)ImageCount;
                    m_imageList = new List<WimImage>(imageCount);
                    for (int i = 0; i < imageCount; i++) {
                        // Load up each image so it's ready for us.
                        m_imageList.Add(
                            new WimImage(this, (uint)i + 1));
                    }
                }
                return m_imageList;
            }
        }
        public List<string> ImageNames {
            get {
                List<string> nameList = new List<string>();
                foreach (WimImage image in Images) {
                    nameList.Add(image.ImageName);
                }
                return nameList;
            }
        }
        public WimImage this[int ImageIndex] {
            get { return Images[ImageIndex - 1]; }
        }
        public WimImage this[string ImageName] {
            get {
                return
                    Images.Where(i => (
                        i.ImageName.ToUpper()  == ImageName.ToUpper() ||
                        i.ImageFlags.ToUpper() == ImageName.ToUpper() ))
                    .DefaultIfEmpty(null)
                        .FirstOrDefault<WimImage>();
            }
        }
        internal uint ImageCount {
            get { return NativeMethods.WimGetImageCount(Handle); }
        }
        internal XDocument XmlInfo {
            get {
                if (null == m_xmlInfo) {
                    StringBuilder builder;
                    uint bytes;
                    if (!NativeMethods.WimGetImageInformation(Handle, out builder, out bytes)) {
                        throw new Win32Exception();
                    }
                    int charCount = (int)bytes / sizeof(char);
                    if (null != builder) {
                        // Get rid of the unicode file marker at the beginning of the XML.
                        builder.Remove(0, 1);
                        builder.EnsureCapacity(charCount - 1);
                        builder.Length = charCount - 1;
                        m_xmlInfo = XDocument.Parse(builder.ToString().Trim());
                    } else {
                        m_xmlInfo = null;
                    }
                }
                return m_xmlInfo;
            }
        }
        public NativeMethods.WimFileHandle Handle {
            get;
            private set;
        }
    }
    public class WimImage {
        internal XDocument m_xmlInfo;
        public WimImage(WimFile Container, uint ImageIndex) {
            if (null == Container) {
                throw new ArgumentNullException("Container");
            }
            if ((Container.Handle.IsClosed) || (Container.Handle.IsInvalid)) {
                throw new ArgumentNullException("The handle to the WIM file has already been closed, or is invalid.", "Container");
            }
            if (ImageIndex > Container.ImageCount) {
                throw new ArgumentOutOfRangeException("ImageIndex", "The index does not exist in the specified WIM file.");
            }  
            Handle = new NativeMethods.WimImageHandle(Container, ImageIndex);
        }
        public enum Architectures : uint {
            x86   = 0x0,
            ARM   = 0x5,
            IA64  = 0x6,
            AMD64 = 0x9,
            ARM64 = 0xC
        }
        public void Close() {
            if ((!Handle.IsClosed) && (!Handle.IsInvalid)) {
                Handle.Close();
            }
        }
        public NativeMethods.WimImageHandle Handle {
            get;
            private set;
        }
        internal XDocument XmlInfo {
            get {
                if (null == m_xmlInfo) {
                    StringBuilder builder;
                    uint bytes;
                    if (!NativeMethods.WimGetImageInformation(Handle, out builder, out bytes)) {
                        throw new Win32Exception();
                    }
                    int charCount = (int)bytes / sizeof(char);
                    if (null != builder) {
                        builder.Remove(0, 1);
                        builder.EnsureCapacity(charCount - 1);
                        builder.Length = charCount - 1;
                        m_xmlInfo = XDocument.Parse(builder.ToString().Trim());
                    } else {
                        m_xmlInfo = null;
                    }
                }
                return m_xmlInfo;
            }
        }
        public string ImageIndex {
            get { return XmlInfo.Element("IMAGE").Attribute("INDEX").Value; }
        }
        public string ImageName {
            get { return XmlInfo.XPathSelectElement("/IMAGE/NAME").Value; }
        }
        public string ImageEditionId {
            get { return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/EDITIONID").Value; }
        }
        public string ImageFlags {
            get {
                string flagValue = String.Empty;
                try {
                    flagValue = XmlInfo.XPathSelectElement("/IMAGE/FLAGS").Value;
                } catch {
                    if (String.IsNullOrEmpty(flagValue)) {
                        flagValue = this.ImageEditionId;
                        if (0 == String.Compare("serverhyper", flagValue, true)) {
                            flagValue = "ServerHyperCore";
                        }
                    }
                }
                return flagValue;
            }
        }
        public string ImageProductType {
            get { return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/PRODUCTTYPE").Value; }
        }
        public string ImageInstallationType {
            get { return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/INSTALLATIONTYPE").Value; }
        }
        public string ImageDescription {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DESCRIPTION").Value; }
        }
        public ulong ImageSize {
            get { return ulong.Parse(XmlInfo.XPathSelectElement("/IMAGE/TOTALBYTES").Value); }
        }
        public Architectures ImageArchitecture {
            get {
                int arch = -1;
                try {
                    arch = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/ARCH").Value);
                } catch { }
                return (Architectures)arch;
            }
        }
        public string ImageDefaultLanguage {
            get {
                string lang = null;
                try {
                    lang = XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/LANGUAGES/DEFAULT").Value;
                } catch { }
                return lang;
            }
        }
        public Version ImageVersion {
            get {
                int major = 0;
                int minor = 0;
                int build = 0;
                int revision = 0;
                try {
                    major = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/MAJOR").Value);
                    minor = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/MINOR").Value);
                    build = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/BUILD").Value);
                    revision = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/SPBUILD").Value);
                } catch { }
                return (new Version(major, minor, build, revision));
            }
        }
        public string ImageDisplayName {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DISPLAYNAME").Value; }
        }
        public string ImageDisplayDescription {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DISPLAYDESCRIPTION").Value; }
        }
    }
    public class DefaultImageEventArgs : EventArgs {
        public DefaultImageEventArgs( IntPtr wideParameter, IntPtr leftParameter, IntPtr userData) {
            WideParameter = wideParameter;
            LeftParameter = leftParameter;
            UserData      = userData;
        }
        public IntPtr WideParameter {
            get;
            private set;
        }
        public IntPtr LeftParameter {
            get;
            private set;
        }
        public IntPtr UserData {
            get;
            private set;
        }
    }
    public class ProcessFileEventArgs : EventArgs {
        public ProcessFileEventArgs(string file, IntPtr skipFileFlag) {
            m_FilePath = file;
            m_SkipFileFlag = skipFileFlag;
        }
        public void SkipFile() {
            byte[] byteBuffer = {0};
            int byteBufferSize = byteBuffer.Length;
            Marshal.Copy(byteBuffer, 0, m_SkipFileFlag, byteBufferSize);
        } 
        public string FilePath {
            get {
                string stringToReturn = "";
                if (m_FilePath != null) {
                    stringToReturn = m_FilePath;
                }
                return stringToReturn;
            }
        }
        public bool Abort {
            set { m_Abort = value; }
            get { return m_Abort;  }
        }
        private string m_FilePath;
        private bool m_Abort;
        private IntPtr m_SkipFileFlag;
    }
    #endregion WIM Interop
    #region VHD Interop
    public class VirtualHardDisk {
        #region Static Methods
        #region Sparse Disks
        public static void CreateSparseDisk(NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType, string path, ulong size, bool overwrite) {
            CreateSparseDisk(
                path, 
                size, 
                overwrite, 
                null, 
                IntPtr.Zero, 
                (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD) ? NativeMethods.DEFAULT_BLOCK_SIZE : 0,
                virtualStorageDeviceType,
                NativeMethods.DISK_SECTOR_SIZE
            );
        }
        public static void CreateSparseDisk(
            string path,
            ulong size,
            bool overwrite,
            string source,
            IntPtr overlapped,
            uint blockSizeInBytes,
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType,
            uint sectorSizeInBytes) {
            if (virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHD && virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHDX){
                throw (
                    new ArgumentOutOfRangeException(
                        "virtualStorageDeviceType",
                        virtualStorageDeviceType,
                        "VirtualStorageDeviceType must be VHD or VHDX."
                ));
            }
            if ((size % NativeMethods.DISK_SECTOR_SIZE) != 0) {
                throw (
                    new ArgumentOutOfRangeException(
                        "size",
                        size,
                        "The size of the virtual disk must be a multiple of 512."
                ));
            }
            if ((!String.IsNullOrEmpty(source)) && (!System.IO.File.Exists(source))) {
                throw (
                    new System.IO.FileNotFoundException(
                        "Unable to find the source file.",
                        source
                ));
            }
            if ((overwrite) && (System.IO.File.Exists(path))) {
                System.IO.File.Delete(path);
            }
            NativeMethods.CreateVirtualDiskParameters createParams = new NativeMethods.CreateVirtualDiskParameters();
            createParams.Version = (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                ? NativeMethods.CreateVirtualDiskVersion.Version1
                : NativeMethods.CreateVirtualDiskVersion.Version2;
            createParams.UniqueId                 = Guid.NewGuid();
            createParams.MaximumSize              = size;
            createParams.BlockSizeInBytes         = blockSizeInBytes;
            createParams.SectorSizeInBytes        = sectorSizeInBytes;
            createParams.ParentPath               = null;
            createParams.SourcePath               = source;
            createParams.OpenFlags                = NativeMethods.OpenVirtualDiskFlags.None;
            createParams.GetInfoOnly              = false;
            createParams.ParentVirtualStorageType = new NativeMethods.VirtualStorageType();
            createParams.SourceVirtualStorageType = new NativeMethods.VirtualStorageType();
            NativeMethods.SecurityDescriptor securityDescriptor;
            if (!NativeMethods.InitializeSecurityDescriptor(out securityDescriptor, 1)) {
                throw (
                    new SecurityException(
                        "Unable to initialize the security descriptor for the virtual disk."
                ));
            }
            NativeMethods.VirtualStorageType virtualStorageType = new NativeMethods.VirtualStorageType();
            virtualStorageType.DeviceId = virtualStorageDeviceType;
            virtualStorageType.VendorId = NativeMethods.VirtualStorageTypeVendorMicrosoft;
            SafeFileHandle vhdHandle;
            uint returnCode = NativeMethods.CreateVirtualDisk(
                ref virtualStorageType,
                    path,
                    (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                        ? NativeMethods.VirtualDiskAccessMask.All
                        : NativeMethods.VirtualDiskAccessMask.None,
                ref securityDescriptor,
                    NativeMethods.CreateVirtualDiskFlags.None,
                    0,
                ref createParams,
                    overlapped,
                out vhdHandle);
            vhdHandle.Close();
            if (NativeMethods.ERROR_SUCCESS != returnCode && NativeMethods.ERROR_IO_PENDING != returnCode) {
                throw (
                    new Win32Exception(
                        (int)returnCode
                ));
            }
        }
        #endregion Sparse Disks
        #endregion Static Methods
    }
    #endregion VHD Interop
    }
"@
    #ifdef for Powershell V7 or greater which looks for assemblies in same path as powershell dll path
    if ($PSVersionTable.psversion.Major -ge 7) {        
        Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue 
    } else {
        Add-Type -TypeDefinition $code -ReferencedAssemblies "System.Xml","System.Linq","System.Xml.Linq" -ErrorAction SilentlyContinue
    }
}
#========================================================================

#========================================================================
function Modify-AutoUnattend {
    param (
        [string]$username,
        [string]$password,
        [string]$autologon,
        [string]$hostname,
        [xml]$xml
    )

    ($xml.unattend.settings.component | where-object {$_.autologon}).autologon.password.value = $password
    ($xml.unattend.settings.component | where-object {$_.autologon}).autologon.username = $username
    ($xml.unattend.settings.component | where-object {$_.autologon}).autologon.enabled = $autologon
    ($xml.unattend.settings.component | where-object {$_.UserAccounts}).UserAccounts.LocalAccounts.localaccount.Group = "Administrators"
    ($xml.unattend.settings.component | where-object {$_.UserAccounts}).UserAccounts.LocalAccounts.localaccount.Name = $username
    ($xml.unattend.settings.component | where-object {$_.UserAccounts}).UserAccounts.LocalAccounts.localaccount.DisplayName = $username
    ($xml.unattend.settings.component | where-object {$_.UserAccounts}).UserAccounts.LocalAccounts.localaccount.Password.Value = $password
    ($xml.unattend.settings.component | where-object {$_.Computername}).Computername = $hostname
    ($xml.unattend.settings.component | where-object {$_.FirstLogonCommands}).FirstLogonCommands.LastChild.CommandLine = "cmd /C wmic useraccount where name=""$($username)"" set PasswordExpires=false"
    
    if ($CopyRegionalSettings -eq $true) {
        # Get HostOS Regional Settings   
        $GeoId            = [int32]((Get-WinHomeLocation | Select-Object -Property *).GeoId)
        $TimeZone         = [string]((Get-TimeZone).Id)
        $SytemLocale      = [string](Get-WinSystemLocale)
        $UserLocale       = [string]((Get-Culture | Select-Object -Property *).Name)
        $LanguageTags     = "$([string]([string[]]((Get-WinUserLanguageList).LanguageTag) | %{"$_;"}) -replace "".$"")"
        $InputMethodTips  = "$([string]([string[]]((Get-WinUserLanguageList).InputMethodTips) | %{"$_;"}) -replace "".$"")"
        $DefaultMethodTip = [string]((Get-WinDefaultInputMethodOverride | Select-Object -Property *).InputMethodTip)
        # Set autounattend.xml Regional Settings associated paramemetrs 
        $xml.GetElementsByTagName('TimeZone')     | %{$_.'#text' = $TimeZone}
        $xml.GetElementsByTagName('UILanguage')   | %{$_.'#text' = $UserLocale}
        $xml.GetElementsByTagName('UserLocale')   | %{$_.'#text' = $UserLocale}
        $xml.GetElementsByTagName('InputLocale')  | %{$_.'#text' = $InputMethodTips}
        $xml.GetElementsByTagName('SystemLocale') | %{$_.'#text' = $SytemLocale}
        $xml.GetElementsByTagName('UILanguageFallback') | %{$_.'#text' = $SytemLocale}
    }
    $UnattendPath = New-TemporaryFile
    $xml.Save("$UnattendPath")
    return $UnattendPath
}
#========================================================================

#========================================================================
function Get-WindowsCompatibleOS {
    $build = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    if ($build.CurrentBuild -ge 19041 -and ($($build.editionid -like 'Professional*') -or $($build.editionid -like 'Enterprise*') -or $($build.editionid -like 'Education*') -or $($build.editionid -like 'Education*') -or $($build.ProductName -like 'Windows Server 2022*'))) {
        $Global:ServerOS = $($build.ProductName -like 'Windows Server 2022*')
        return $true
    } else {
        Write-Warning "Only Windows 10 20H1 or Windows 11 or Server 2022 is supported"
    }
}
#========================================================================

#========================================================================
function Get-HyperVEnabled {
    if ((Get-WindowsOptionalFeature -Online | Where-Object FeatureName -Like 'Microsoft-Hyper-V-All') -or (Get-WindowsOptionalFeature -Online | Where-Object FeatureName -Like 'Microsoft-Hyper-V-Online')) {
        return $true
    } else {
        Write-Warning "You need to enable Virtualisation in your motherboard and then add the Hyper-V Windows Feature and reboot"
        return $false
    }
}
#========================================================================

#========================================================================
function Get-WSLEnabled {
    if ((wsl -l -v)[2].length -gt 1 ) {
        Write-Warning "WSL is Enabled. This may interferre with GPU-P and produce an error 43 in the VM"
        return $true
    } else {
        return $false
    }
}
#========================================================================

#========================================================================
function Get-VMAvailable {
    $VMs = Get-VM
    if ($VMs.length -eq 0) {
        Write-Host "There is no an available VM to proceed. Create a VM and run script again" -ForegroundColor Yellow
        return $false
    } else {
        return $true
    }
}
#========================================================================

#========================================================================
function Get-VMGpuPartitionAdapterFriendlyName {
    $Devices = (Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2").name
    $GPUs = New-Object System.Collections.Generic.List[System.Object]
    Write-Host "Printing a list of compatible GPUs... It may take a while..." -ForegroundColor Yellow
    $i = 0
    $GPUs.Add("AUTO")
    Write-Host "0: AUTO"
    foreach ($GPU in $Devices) {
        $GPUname = (Get-WmiObject Win32_PNPSignedDriver | where {($_.HardwareID -eq "PCI\$($GPU.Split('#')[1])")}).DeviceName 
        Write-Host "$([string](++$i)): $($GPUname)"
        $GPUs.Add($GPUname);
    }
    $m = "Select GPU ID [default: 0] (press $([char]0x23CE) to default)"
    while ($true) {
        try {
            $s = Read-Host -Prompt $m
            if (([decimal]($s) -ge 0) -and ([decimal]($s) -le $i) -and ($s.length -ne 0)) {
                break
            }
        } catch {
            $s = -1     
        }
        if ($s.length -eq 0) {
            $s = 0
            break
        }
    }
    $params.GPUName = $GPUs[[decimal]($s)]
}
#========================================================================

#========================================================================
function Get-VMObjects {
    $VMs = New-Object System.Collections.Generic.List[System.Object]
    $i = 0
    Write-Host "Printing a list of VMs..." -ForegroundColor Yellow
    Foreach ($VM in Get-VM) {
        Write-Host "$([string](++$i)): $($VM.Name)"
        $VMs.Add($VM.Name) 
    }
    $m = "Select VM ID from 1 to $($i)"
    while ($true) {
        try {
            $s = Read-Host -Prompt $m
            if (([decimal]($s) -ge 1) -and ([decimal]($s) -le $i) -and ($s.length -ne 0)) {
                break
            }
        } catch {
            $s = -1     
        }
    }
    
    $Global:VM  = Get-VM -VMName $VMs[[decimal]($s)-1]
    $Global:VHD = Get-VHD -VMId $VM.VMId
    $Global:StateWasRunning = $Global:VM.state -eq "Running"
    
    if ($Global:VM.state -ne "Off") {
        Write-Host "`r`nAttemping to shutdown VM..."
        Stop-VM -Name $Global:VM.Name -Force
    } 
    While ($VM.State -ne "Off") {
        Start-Sleep -s 3
        Write-Host "`r`nWaiting for VM to shutdown - make sure there are no unsaved documents..."
    }
}
#========================================================================

#========================================================================
function Add-VMGpuPartitionAdapterFiles {
    param(
        [string]$hostname = $ENV:COMPUTERNAME,
        [string]$DriveLetter,
        [string]$GPUName
    )
    
    If (!($DriveLetter -like "*:*")) {
        $DriveLetter = $Driveletter + ":"
    }

    If ($GPUName -eq "AUTO") {
        $PartitionableGPUList = Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2"
        $DevicePathName = $PartitionableGPUList.Name | Select-Object -First 1
        $GPU = Get-PnpDevice | Where-Object {($_.DeviceID -like "*$($DevicePathName.Substring(8,16))*") -and ($_.Status -eq "OK")} | Select-Object -First 1
        $GPUName = $GPU.Friendlyname
        $GPUServiceName = $GPU.Service 
    } else {
        $GPU = Get-PnpDevice | Where-Object {($_.Name -eq "$GPUName") -and ($_.Status -eq "OK")} | Select-Object -First 1
        $GPUServiceName = $GPU.Service
    }
    # Get Third Party drivers used, that are not provided by Microsoft and presumably included in the OS

    Write-W2VInfo "Finding and copying driver files for $GPUName to VM. This could take a while..."

    $Drivers = Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "$GPUName"}

    New-Item -ItemType Directory -Path "$DriveLetter\windows\system32\HostDriverStore" -Force | Out-Null

    #copy directory associated with sys file 
    $servicePath = (Get-WmiObject Win32_SystemDriver | Where-Object {$_.Name -eq "$GPUServiceName"}).Pathname
    $ServiceDriverDir = $servicepath.split('\')[0..5] -join('\')
    $ServicedriverDest = ("$($driveletter)\$($servicepath.split('\')[1..5] -join('\'))").Replace("DriverStore","HostDriverStore")
    if (!(Test-Path $ServicedriverDest)) {
        Copy-item -path "$ServiceDriverDir" -Destination "$ServicedriverDest" -Recurse
    }

    # Initialize the list of detected driver packages as an array
    $DriverFolders = @()
    foreach ($d in $drivers) {
        $DriverFiles = @()
        $ModifiedDeviceID = $d.DeviceID -replace "\\", "\\"
        $Antecedent = "\\$($hostname)\ROOT\cimv2:Win32_PNPSignedDriver.DeviceID=""$ModifiedDeviceID"""
        $DriverFiles += Get-WmiObject Win32_PNPSignedDriverCIMDataFile -ErrorAction SilentlyContinue | where {$_.Antecedent -eq $Antecedent}
        $DriverName = $d.DeviceName
        $DriverID = $d.DeviceID
        if ($DriverName -like "NVIDIA*") {
            New-Item -ItemType Directory -Path "$driveletter\Windows\System32\drivers\Nvidia Corporation\" -Force | Out-Null
        }
        foreach ($i in $DriverFiles) {
            $path = $i.Dependent.Split("=")[1] -replace '\\\\', '\'
            $path2 = $path.Substring(1,$path.Length-2)
            $InfItem = Get-Item -Path $path2
            $Version = $InfItem.VersionInfo.FileVersion
            If ($path2 -like "c:\windows\system32\driverstore\*") {
                $DriverDir = $path2.split('\')[0..5] -join('\')
                $driverDest = ("$($driveletter)\$($path2.split('\')[1..5] -join('\'))").Replace("driverstore","HostDriverStore")
                if (!(Test-Path $driverDest)) {
                Copy-item -path "$DriverDir" -Destination "$driverDest" -Recurse
                }
            } else {
                $ParseDestination = $path2.Replace("c:", "$driveletter")
                $Destination = $ParseDestination.Substring(0, $ParseDestination.LastIndexOf('\'))
                if (!$(Test-Path -Path $Destination)) {
                    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                }
                Copy-Item $path2 -Destination $Destination -Force 
            }
        }
    }

}
#========================================================================

#========================================================================
function Copy-GPUDrivers {
    param()
    Write-Host "`r`nMounting Drive..."
    $params.DriveLetter = (Mount-VHD -Path $Global:VHD.Path -PassThru | Get-Disk | Get-Partition | Get-Volume | Where-Object {$_.DriveLetter} | ForEach-Object DriveLetter)
    
    Add-VMGpuPartitionAdapterFiles -DriveLetter $params.DriveLetter -GPUName $params.GPUName
    
    Write-Host "Dismounting Drive..."
    Dismount-VHD -Path $Global:VHD.Path
}
#========================================================================

#========================================================================
function Delete-VMGPUPartitionAdapter {
    param()
    $VMName  = $Global:VM.Name
    $GPUP = Get-VMGPUPartitionAdapter -VMName $VMName
    If ($GPUP.length -ne 0) {
        Remove-VMGpuPartitionAdapter -VMName $VMName
    }
}
#========================================================================

#========================================================================
function Pass-VMGPUPartitionAdapter {
    param (
        [switch]$OnlyResources = $false
    )
    $VMName  = $Global:VM.Name
    $GPUName = $params.GPUName
    $DedicatedPercentage = $params.GPUDedicatedResourcePercentage

    $PartitionableGPUList = Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2" 
    if ($OnlyResources -ne $true) {
        if ($GPUName -eq "AUTO") {
            $DevicePathName = $PartitionableGPUList.Name[0]
            Add-VMGpuPartitionAdapter -VMName $VMName
        } else {
            $DeviceID = ((Get-WmiObject Win32_PNPSignedDriver | where {($_.Devicename -eq "$GPUNAME")}).hardwareid).split('\')[1]
            $DevicePathName = ($PartitionableGPUList | Where-Object name -like "*$deviceid*").Name
            Add-VMGpuPartitionAdapter -VMName $VMName -InstancePath $DevicePathName
        }
    }
    [float]$div = [math]::round($(100 / $DedicatedPercentage), 2)
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionVRAM        ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -MaxPartitionVRAM        ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -OptimalPartitionVRAM    ([math]::round($(1000000000 / $div)))
    Set-VMGPUPartitionAdapter -VMName $VMName -MinPartitionEncode      ([math]::round($(18446744073709551615 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -MaxPartitionEncode      ([math]::round($(18446744073709551615 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -OptimalPartitionEncode  ([math]::round($(18446744073709551615 / $div)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionDecode      ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -MaxPartitionDecode      ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -OptimalPartitionDecode  ([math]::round($(1000000000 / $div)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionCompute     ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -MaxPartitionCompute     ([math]::round($(1000000000 / $div))) 
    Set-VMGpuPartitionAdapter -VMName $VMName -OptimalPartitionCompute ([math]::round($(1000000000 / $div)))
    Set-VM -GuestControlledCacheTypes:$true -VMName $VMName
}
#========================================================================

#========================================================================
function Get-Action {
    param()
    Write-Host "`r`nAvailable actions:" -ForegroundColor Yellow
    Write-Host "1: Create new VM with GPU acceleration"
    Write-Host "2: Pass through GPU acceleration to HyperV VM (GPU drivers are copied automatically)"
    Write-Host "3: Copy GPU Drivers from Host to VM"
    Write-Host "4: Upgrade VMs GPU Drivers"
    Write-Host "5: Remove GPU acceleration from HyperV VM"
    Write-Host "6: Change dedicated resources percentage of passed through GPU"
    Write-Host "7: Exit"
    $m = "`r`nSelect an action from 1 to 7"
    while ($true) {
        try {
            $s = Read-Host -Prompt $m
            if (([decimal]($s) -ge 1) -and ([decimal]($s) -le 7) -and ($s.length -ne 0)) {
                break
            }
        } catch {
            $s = -1     
        }
    }
    switch ($s) {
        1 {}
        3 { if (!(Get-VMAvailable)) { exit } break }
        4 { if (!(Get-VMAvailable)) { exit } break }
        5 { if (!(Get-VMAvailable)) { exit } break }
        7 { exit } 
        default {
            if (!(Get-VMAvailable)) { exit }
            $m = "Enter dedicated resources percentage of passing through GPU (from 1 to 100)"
            $p = Read-Host -Prompt $m
            while ($true) {
                try {
                    if ((1 -gt [decimal]($p)) -or ([decimal]($p) -gt 100)) {
                        $p = Read-Host -Prompt $m
                    } else {
                        break
                    }
                } catch {
                    $p = -1     
                }
            }
            $params.GPUDedicatedResourcePercentage = [decimal]($p)
        } 
    }
    return $s
}
#========================================================================

#========================================================================
function Get-RemoteDesktopApp {
    param()
    Write-Host "Available Remote Desktop apps:" -ForegroundColor Yellow
    Write-Host "1: Parsec (proprietary app mostly for gaming)"
    Write-Host "2: RDP (less performance 3D Acceleration than Parsec provides)"
    Write-Host "3: Parsec & RDP"
    Write-Host "4: None of them"
    if (($params.Parsec -eq $true) -and ($params.rdp -eq $false)) {
        $d = 1
    } elseif (($params.Parsec -eq $false) -and ($params.rdp -eq $true)) {
        $d = 2
    } elseif (($params.Parsec -eq $true) -and ($params.rdp -eq $true)) {
        $d = 3
    } else {
        $d = 4
    }
    $m = "Select an app you're going to use in VM [default: $d] (Press $([char]0x23CE) to default}"
    while ($true) {
        try {
            $s = Read-Host -Prompt $m
            if (([decimal]($s) -ge 1) -and ([decimal]($s) -le 4) -and ($s.length -ne 0)) {
                break
            }
        } catch {
            $s = -1     
        }
        if ($s.length -eq 0) {
            $s = $d
            break
        }
    }
    switch ($s) {
        1 { $params.rdp = $false; $params.Parsec = $true  }
        2 { $params.rdp = $true;  $params.Parsec = $false }
        3 { $params.rdp = $true;  $params.Parsec = $true  }
        4 { $params.rdp = $false; $params.Parsec = $false }
    }
}
#========================================================================

#========================================================================
function Set-ServerOSGroupPolicies {
    param()
    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HyperV"
    if ((Test-Path $path) -eq $false) {
        New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "HyperV"
    }
    $null = New-ItemProperty -Path $path -Name "RequireSecureDeviceAssignment" -Value 0 -PropertyType "DWORD"
    $null = New-ItemProperty -Path $path -Name "RequireSupportedDeviceAssignment" -Value 0 -PropertyType "DWORD"
}
#========================================================================

#========================================================================
function Open-ISOImageDialog {
    param()
    Write-Host "A GUI dialog is available to help you select the Gest OS Windows disk image ISO." 
    Add-Type -AssemblyName System.Windows.Forms
    
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    $FileBrowser.Filter = "Windows Disk Image (ISO)|*.iso"
    $FileBrowser.RestoreDirectory = $true
    $FileBrowser.MultiSelect = $false;
    $FileBrowser.Title = "Select Windows Disk Image ISO for VM Guest OS"
    
    if ($FileBrowser.ShowDialog() -eq "OK") {
        $params.SourcePath = $FileBrowser.FileName
        Write-Host "Windows Disk Image (ISO) path: ""$($FileBrowser.FileName)"""
    } else {
        Write-Warning "Error: You have to select Guest OS Windows Disk Image ISO."
        exit
    }
}
#========================================================================

#========================================================================
function Open-VHDFolderDialog {
    param()
    Add-Type -AssemblyName System.Windows.Forms
    
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = "Select VM virtual hard disk location"
    $FolderBrowser.RootFolder = "MyComputer"
    $FolderBrowser.SelectedPath = Get-VMHost | Select-Object VirtualHardDiskPath -ExpandProperty VirtualHardDiskPath
      
    if ($FolderBrowser.ShowDialog() -eq "OK") {
        $params.VHDPath = "$($FolderBrowser.SelectedPath)\$($params.VMName)\Virtual Hard Disks"
    } else {
        Write-Warning "You didn't select VM virtual hard disk location. Default is used"
        $params.VHDPath = Get-VMHost | Select-Object VirtualHardDiskPath -ExpandProperty VirtualHardDiskPath
    } 
    Write-W2VInfo "VM virtual hard disk location: ""$($params.VHDPath)""" -ForegroundColor Yellow   
}
#========================================================================

#========================================================================
function Open-VMFolderDialog {
    param()
    Add-Type -AssemblyName System.Windows.Forms
    
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = "Select Virtual Machine files location"
    $FolderBrowser.RootFolder = "MyComputer"
    $FolderBrowser.SelectedPath = Get-VMHost | Select-Object VirtualMachinePath -ExpandProperty VirtualMachinePath
    
    if ($FolderBrowser.ShowDialog() -eq "OK") {
        $params.VMPath = $FolderBrowser.SelectedPath
    } else {
        Write-Warning "You didn't select Virtual Machine files location. Default is used."
        $params.VMPath = Get-VMHost | Select-Object VirtualMachinePath -ExpandProperty VirtualMachinePath
    }   
    Write-W2VInfo "Virtual Machine files location: ""$($params.VMPath)\$($params.VMName)""" -ForegroundColor Yellow
}
#========================================================================

#========================================================================
function Get-GuestOSCredentials{
    param()
    while ($true) {
        [string]$UserName = Read-Host -Prompt "Enter username"
        if ($UserName.length -eq 0) {
            Write-Warning "username can't be empty"
        } else {
            break;
        }
    }
    while ($true) {
        $SecurePassword = Read-Host -Prompt "Enter password" -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        $ReenteredSecurePassword = Read-Host -Prompt "Reenter password" -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ReenteredSecurePassword)
        $ReenteredPlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        if ($PlainPassword -eq $ReenteredPlainPassword) {
            break
        } else {
            Write-Warning "password confirmation doesn't match"
        }
    } 
    $params.UserName = $UserName
    $params.Password = $PlainPassword
}
#========================================================================

#========================================================================
function Get-VMName {
    param()
    while ($true) {
        [string]$VMName = Read-Host -Prompt "Enter Virtual Machine name"
        if ($VMName.length -eq 0) {
            Write-Warning "Virtual Machine name can't be empty"
        } else {
            break;
        }
    }
    $params.VMName = $VMName
}
#========================================================================

#========================================================================
function Get-HyperVSwitchAdapter {
    param()
    Write-Host "Available Virtual Network Switches..." -ForegroundColor Yellow
    $Switches = Get-VMSwitch | Select-Object -Property SwitchType, Name
    switch ($Switches.Length -eq 0) {
        0 { $Name = 'Default Switch'
            Write-Warning "There isn't any Virtual Network Switch" 
            break }
        1 { $Name = $Switches[0].Name
            Write-W2VInfo "There is only one Virtual Network Switch: $Name" 
            break }
        default { 
            $i = 0
            foreach ($switch in $Switches) {
                Write-Host "$([string](++$i)): [$($switch | Select-Object -Property Name -ExpandProperty SwitchType)] $($switch | Select-Object -Property Name -ExpandProperty Name)"
            }
            $VMParam = New-VMParameter -name 'VSIndex' -title "Select Virtual Network Switch (press $([char]0x23CE) to default)" -range @(1, $Switches.Count + 1) -rangeIsHidden -AllowNull
            $s = Get-VMParam -VMParam $VMParam
            if ($s.length -eq 0) {
                $Name = 'Default Switch'
            } else {
                $Name = $Switches[$s-1].Name
            }
        }
    }
    $params.NetworkSwitch = $Name
    return $Name
}
#========================================================================

#========================================================================
function Set-CorrectHyperVSwitchAdapterDialog {
    param(
        [parameter(Mandatory = $true)][string]$Name
    )
    $Switch = Get-VMSwitch | Where-Object Name -eq $Name
    if (($Name -ne 'Default Switch') ) {
        $VMParam = New-VMParameter -name 'VMChangeQuery' -title "Set Virtual Network switch to external bridged network mode [Y/N] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
        $result = Get-VMParam -VMParam $VMParam
        if ($result -eq $true) {
            Set-CorrectHyperVExternalSwitchAdapter -Name $Name -SuspendOutput
        }
    }
}
#========================================================================

#========================================================================
function Set-CorrectHyperVExternalSwitchAdapter {
    param (
        [parameter(Mandatory = $true)][string]$Name,
        [switch]$SuspendOutput = $false
    )
    if ($Name -ne 'Default Switch') {
        #retrieve external switch(es) and get Network adapter with Up state
        $externalswitch = Get-VMSwitch | Where-Object Name -eq $Name
        $connectedadapter = Get-NetAdapter | Where-Object Status -eq Up | Sort-Object ifIndex | Where-Object {$_.Name -NotMatch 'vEthernet' -and $_.Name -notmatch 'Network Bridge'} | Select-Object -First 1
        #Set VMSwitch(es) properties so that the connected adapter is configured
        try {
            Set-VMSwitch $externalswitch.Name -NetAdapterName $connectedadapter.Name -AllowManagementOS:$true -ErrorAction Stop
            if ($suspendOutput -ne $true) {
                Write-Host ("Reconfiguring External Hyper-V Switch {0} to use Network Adapter {1}" -f $Name, $connectedadapter.Name) -ForegroundColor Green
            }
        } catch {
            Write-Warning ("Failed reconfiguring External Hyper-V Switch {0} to use Network Adapter {1}" -f $Name, $connectedadapter.Name)
        }
    }
}
#========================================================================

#========================================================================
function New-VMParameter  {
    param (
        [string]$name,
        [string]$title,
        [int64[]]$range,
        [switch]$rangeIsHidden = $false,
        [System.Object]$AllowedValues,
        [switch]$AllowNull = $false
    )
    return ([PSCustomObject]@{
        name = $name
        title  = $title
        range = $range
        rangeIsHidden = $rangeIsHidden
        AllowedValues = $AllowedValues
        AllowNull = $AllowNull
    })
}
#========================================================================

#========================================================================
function Get-VMParam {
    param (
        [System.Object]$VMParam
    )
    
    if ($VMParam.range.count -ne 0) {
        $RangeMode = $true
        if ($VMParam.range[1] -gt 1Gb) {
            $min = $VMParam.range[0] / 1Gb
            $max = $VMParam.range[1] / 1Gb
            $mul = 1Gb
            if ($VMParam.rangeIsHidden -ne $true) {
                $VMParam.title += ' [range:' + $min + 'GB...' + $max + 'GB]'
            }
        } else {
            $min = $VMParam.range[0]
            $max = $VMParam.range[1]
            $mul = 1
            if ($VMParam.rangeIsHidden -ne $true) {
                $VMParam.title += ' [range:' + $min + '...' + $max + ']' 
            }
        }   
    } else {
        if ($VMParam.AllowedValues.count -eq 0) {
            if ($params.ContainsKey($VMParam.name)) {
                return $params[$VMParam.name]
            } else {
                return $null
            }
        }
        $Valid = $false
    }
    
    while ($true) {
        $p = Read-Host -Prompt $VMParam.title
        if ($RangeMode) {
            try {
                if ([int64]($p) -gt 1Gb) {
                    $p /= 1Gb
                } 
                if (([int64]($p) -ge $min) -and ([int64]($p) -le $max) -and ($p.length -ne 0)) {
                    [int64]($p) *= $mul
                    break
                }
            } catch {
                $p = $min - 1     
            }
        } else {
            foreach ($item in $VMParam.AllowedValues.GetEnumerator()) {
                if ($p -like [string]($item.key)) {
                    $valid = $true
                    $p = $item.value
                }
            }
            if ($valid) {
                break
            }   
        }
        if ($VMParam.AllowNull -and $p.Length -eq 0) {
            return $p
        }
    }
    
    if ($params.ContainsKey($VMParam.name)) {
        $params[$VMParam.name] = $p
    } 
    return $p
}
#========================================================================

#========================================================================
function BoolToYesNo {
	param([bool]$value)
	if ($value -eq $true) {
		return 'Y'
	} else {
		return 'N'
	}
}
#========================================================================

#========================================================================
function Get-VMParams {
    param()

    Get-VMName
    
    Write-Host "Virtual Machine files location: ""$(Get-VMHost | Select-Object VirtualMachinePath -ExpandProperty VirtualMachinePath)\""" -ForegroundColor Yellow
    $VMParam = New-VMParameter -name 'ChangeVMPath' -title "Change default Virtual Machine files location? [Y/N] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    if ((Get-VMParam -VMParam $VMParam) -eq $true) {
        $null = Open-VMFolderDialog
    } else {
        $params.VMPath = Get-VMHost | Select-Object VirtualMachinePath -ExpandProperty VirtualMachinePath
    }

    Write-Host "VM virtual hard disk location: ""$(Get-VMHost | Select-Object VirtualHardDiskPath -ExpandProperty VirtualHardDiskPath)\""" -ForegroundColor Yellow
    $VMParam = New-VMParameter -name 'ChangeVHDPath' -title "Change default VM virtual hard disk location? [Y/N] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    if ((Get-VMParam -VMParam $VMParam) -eq $true) {
        $null = Open-VHDFolderDialog
    } else {
        $params.VHDPath = Get-VMHost | Select-Object VirtualHardDiskPath -ExpandProperty VirtualHardDiskPath
    } 
    
    $VMParam = New-VMParameter -name 'SizeBytes' -title "Specify VM virtual hard disk size [default: $($params.SizeBytes / 1Gb)GB] (press $([char]0x23CE) to default)" -range @(24Gb, 1024Gb) -AllowNull
    $null = Get-VMParam -VMParam $VMParam
    
    $VMParam = New-VMParameter -name 'MemoryAmount' -title "Specify amount of RAM dedicated for VM [default: $($params.MemoryAmount / 1Gb)GB] (press $([char]0x23CE) to default)" -range @(2Gb, (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum) -AllowNull
    $null = Get-VMParam -VMParam $VMParam
    
    $VMParam = New-VMParameter -name 'DynamicMemoryEnabled' -title "Enable Dynamic Memory? [Y/N] [default: $(BoolToYesNo $params.DynamicMemoryEnabled)] (press $([char]0x23CE) to enable)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    $null = Get-VMParam -VMParam $VMParam
    if ($params.DynamicMemoryEnabled -eq $true) {
        $VMParam = New-VMParameter -name 'MemoryMaximum' -title "Specify maximum amount of dynamic RAM dedicated for VM [default: $(($params.MemoryMaximum / 1Gb))GB] (press $([char]0x23CE) to default)" -range @($params.MemoryAmount, 128Gb) -AllowNull
        $null = Get-VMParam -VMParam $VMParam
    }

    $VMParam = New-VMParameter -name 'CPUCores' -title "Specify Number of virtual proccesosrs [default: $($params.CPUCores)] (press $([char]0x23CE) to default)" -range @(1, (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) -AllowNull
    $null = Get-VMParam -VMParam $VMParam
 
    $switch = Get-HyperVSwitchAdapter
    $null = Set-CorrectHyperVSwitchAdapterDialog -Name $switch
    
    $null = Get-VMGpuPartitionAdapterFriendlyName
    $VMParam = New-VMParameter -name 'GPUDedicatedResourcePercentage' -title "Specify the percentage of dedicated VM GPU resource to pass [default: $($params.GPUDedicatedResourcePercentage)] (press $([char]0x23CE) to default)" -range @(5, 100) -AllowNull
    $null = Get-VMParam -VMParam $VMParam   
    
    Write-Host "Guest OS Parameters:"  -ForegroundColor Yellow
    $null = Open-ISOImageDialog 
    $null = Get-GuestOSCredentials
    
    $VMParam = New-VMParameter -name 'Autologon' -title "Enable Autologon to Guest OS? [Y/N] [default: $(BoolToYesNo $params.Autologon)] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    $null = Get-VMParam -VMParam $VMParam
 
    $VMParam = New-VMParameter -name 'CopyRegionalSettings' -title "Copy Host OS regional settings (locale, keyboard layout etc.) to Guest OS? [Y/N] [default: Y] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    $null = Get-VMParam -VMParam $VMParam

    $VMParam = New-VMParameter -name 'NumLock' -title "Enable NumLock at Logon? [Y/N] [default: $(BoolToYesNo $params.NumLock)] (press $([char]0x23CE) to enable)" -AllowedValues @{Y = $true; N = $false} -AllowNull
    $null = Get-VMParam -VMParam $VMParam 

    Get-RemoteDesktopApp
    if ($params.Parsec -eq $true) { 
        $VMParam = New-VMParameter -name 'ParsecVDD' -title "Install Parsec Virtual Display Driver? [Y/N] [default: $(BoolToYesNo $params.ParsecVDD)] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
        $null = Get-VMParam -VMParam $VMParam
        $VMParam = New-VMParameter -name 'ParsecForTeamsSubscriber' -title "Are you are a Parsec for Teams Subscriber? [Y/N] [default: N] (press $([char]0x23CE) to skip)" -AllowedValues @{Y = $true; N = $false} -AllowNull
        if ((Get-VMParam -VMParam $VMParam) -eq 0) {
            $VMParam = New-VMParameter -name 'Team_ID' -title "Enter the Parsec for Teams ID (press $([char]0x23CE) to skip)" -AllowNull
            $null = Get-VMParam -VMParam $VMParam
            
            $VMParam = New-VMParameter -name 'Key' -title "Enter the Parsec for Teams Secret Key (press $([char]0x23CE) to skip)" -AllowNull
            $null = Get-VMParam -VMParam $VMParam       
        }
    }
}
#========================================================================

#========================================================================
function Start-VMandConnect {
	param([string]$Name)
    Start-VM -Name $Name
    Start-Sleep -s 5
    If ((Get-Process VMconnect -ErrorAction SilentlyContinue).Length -eq 0) {
        VMconnect $env:COMPUTERNAME $Name
    }
}
#========================================================================

#========================================================================
#Script executing section
Clear-Host
Write-Host "System is checking ..." -ForegroundColor Yellow

If ((Is-Administrator) -and (Get-WindowsCompatibleOS) -and (Get-HyperVEnabled)) {
    Write-Host "Checking completed: " -NoNewline -ForegroundColor Yellow 
    Write-Host "System is Compatible" -ForegroundColor DarkGreen 
    
    $Action = Get-Action
    Write-Host "`r`nRequired parameters:" -ForegroundColor Yellow
    
    switch ($Action) {
        1 { Get-VMParams
            New-GPUEnabledVM @params }
        2 { Get-VMObjects
            Get-VMGpuPartitionAdapterFriendlyName
            Delete-VMGPUPartitionAdapter
            Pass-VMGPUPartitionAdapter 
            Copy-GPUDrivers }
        3 { Get-VMObjects
            Get-VMGpuPartitionAdapterFriendlyName
            Copy-GPUDrivers }
        4 { Get-VMObjects
            Get-VMGpuPartitionAdapterFriendlyName
            Copy-GPUDrivers }
        5 { Get-VMObjects
            Delete-VMGPUPartitionAdapter }
        6 { Get-VMObjects
            Pass-VMGPUPartitionAdapter -OnlyResources }
    }
    
    if ($Global:ServerOS -eq $true) {
        Set-ServerOSGroupPolicies
    }
    
    If ($Global:StateWasRunning){
        Write-Host "Previous State was running so starting VM..."
        Start-VMandConnect -Name $Global:VM.Name
    }
    
    if ($Action -eq 1) {
        Start-VMandConnect -Name $params.VMName
        $m = "If all went well the Virtual Machine will have started, 
            `rIn a few minutes it will load the Windows desktop." 
        if (($params.Parsec -eq $true) -and ($params.rdp -eq $false)) {
            $m += "When it does, sign into Parsec (a fast remote desktop app)
                `rand connect to the machine using Parsec from another computer. 
                `rHave fun!
                `rSign up to Parsec at https://Parsec.app"
        } elseif (($params.Parsec -eq $false) -and ($params.rdp -eq $true)) {
            $m += "When it does, install Microsot Remote Desktop moder client
                `rand connect to the machine using username and password you set. 
                `rHave fun!
                `rhttps://www.microsoft.com/store/productId/9WZDNCRFJ3PS"
        } elseif (($params.Parsec -eq $true) -and ($params.rdp -eq $true)) {
            $m += "When it does, sign into Parsec (a fast remote desktop app)
                `rand connect to the machine using Parsec from another computer. 
                `ror install Microsot Remote Desktop moder client
                `rand connect to the machine using username and password you set.
                `rHave fun!
                `rSign up to Parsec at https://Parsec.app
                `rhttps://www.microsoft.com/store/productId/9WZDNCRFJ3PS"
        }
    } else {
        $m = "Done..."
    }
    SmartExit -ExitReason $m
}
#========================================================================
