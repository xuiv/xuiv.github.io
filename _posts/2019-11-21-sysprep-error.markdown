---
layout: post
title:  "Windows Sysprep报错的处理"
date:   2019-11-21 15:06:00
categories: computer config
---
WINDOWS 7 : SYSPREP 3.14 : A FATAL ERROR HAS OCCURRED DURING SYSPREP. 

01/29/20148 Comments

 

Firstly, run this command on command prompt  slmgr.vbs /dlv 




Then check the re-arm counter value, if it's 0 and you sysprep you will receive errors in the setupact.log and setuperr.log files like these:




Error [0x0f00a8] SYSPRP WinMain: Hit failure while processing sysprep generalize providers; hr = 0xc004d307

Error [0x0f0073] SYSPRP RunExternalDlls:Not running DLLs; either the machine is in an invalid state or we couldn’t update the recorded state, dwRet = 31

Error [0x0f0082] SYSPRP LaunchDll: Failure occurred while executing 'C:\Windows\System32\slc.dll, SLReArmWindows', returned error code -1073425657

Error [0x0f0070] SYSPRP RunExternalDlls: An error occurred while running registry sysprep DLLs, halting sysprep execution. dwRet = -1073425657




Workaround: 




Open regedit and look for: 




HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\SkipRearm




Set to value: 1




HKEY_LOCAL_MACHINE\SYSTEM\Setup\Status\SysprepStatus\CleanupState




Set to value: 2




HKEY_LOCAL_MACHINE\SYSTEM\Setup\Status\SysprepStatus\GeneralizationState




Set to value: 7




And Run these command on elevated command prompt: 




msdtc -uninstall (wait a few seconds)




msdtc -install (wait a few seconds)




Reboot the system.




If this does not work, then last option is Windows Product Activation (WPA) vulnerability that was introduced in Windows 7




When the WPA registry key is deleted, the status of Windows 7 is re-initiated to the Initial Grace Period as if Windows 7 has just been installed. The deletion of the WPA registry key is achieved via the following method. 




·         Create a .bat file with following text and place it in C:, like C:\Reset.bat




reg load HKLM\MY_SYSTEM “%~dp0Windows\System32\config\system”

reg delete HKLM\MY_SYSTEM\WPA /f

reg unload HKLM\MY_SYSTEM




·         Restart the computer.




·         Press F8 right after the BIOS screen to get to the “Advanced Boot Options” and Select Repair Your Computer.




·         Select your keyboard input method, and click next.




·         Enter user name and password login credentials for local Admin user, and continue




·         In the “System Recovery Options”, open Command Prompt.




·         Run the Reset.bat file from C:




·         Restart the computer.




The system will be moved to grace period after the reboot. 


windows in vhd uefi:


1. 挂载你的vhd：
```
DISKPART
SELECT VDISK FILE="C:\ubuntu\win7.vhd"
DETACH VDISK
CREATE VDISK FILE="C:\ubuntu\win7.vhd" PARENT="C:\ubuntu\win7_.vhd"
SELECT VDISK FILE="C:\ubuntu\win7.vhd"
ATTACH VDISK
LIST VOLUME
ASSIGN LETTER=W
EXIT
```
2. 离线修改注册表：
```
REG LOAD HKLM\TEMP W:\WINDOWS\SYSTEM32\CONFIG\SYSTEM
REG ADD HKLM\TEMP\ControlSet001\services\FsDepends\Parameters /v VirtualDiskExpandOnMount /t REG_DWORD /d 4 /f
REG ADD HKLM\TEMP\ControlSet001\Control /v BootDriverFlags /t REG_DWORD /d 4 /f
REG ADD HKLM\TEMP\ControlSet001\Control\PnP /v PollBootPartitionTimeout /t REG_DWORD /d 30000 /f
REG UNLOAD HKLM\TEMP
```
3. deteach vhd 并重启。
