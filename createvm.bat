set VBOXPATH=C:\Program Files\Oracle\VirtualBox
set VMPATH=d:\Virtualbox


"%VBOXPATH%\VboxManage.exe" createvm --name "V%COMPUTERNAME%" --ostype Windows7_64
"%VBOXPATH%\VboxManage.exe" registervm "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vbox"

for /F %%M in ('powershell -ExecutionPolicy Bypass -NoProfile -File .\getmac.ps1') do (
	set MACADDRESS=%%M
)

"%VBOXPATH%\VboxManage.exe" modifyvm  "V%COMPUTERNAME%"  --memory 4096 --vram 32 --acpi on --apic on --paravirtprovider hyperv --cpus 2 --firmware bios --boot1 net --boot2 disk --boot3 dvd --nic1 bridged --nictype1 82540EM --cableconnected1 on --macaddress1 %MACADDRESS% --clipboard bidirectional --draganddrop bidirectional
"%VBOXPATH%\VboxManage.exe" createmedium disk --filename "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi" --format vdi --size 256000 --variant standard
"%VBOXPATH%\VboxManage.exe" storagectl "V%COMPUTERNAME%" --name "SATA" --add sata --controller IntelAHCI --portcount 4 --hostiocache on --bootable on
"%VBOXPATH%\VboxManage.exe" storageattach "V%COMPUTERNAME%" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi"
"%VBOXPATH%\VboxManage.exe" storageattach "V%COMPUTERNAME%" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium emptydrive
rem exit %ERRORLEVEL%