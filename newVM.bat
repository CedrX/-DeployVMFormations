set VMPATH=d:\Virtualbox

"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" list vms > vms.txt
FOR /F delims^=^"^ tokens^=1* %%m in (vms.txt) do (
	IF /I %%m==V%COMPUTERNAME% ( 
		rem suppression de la machine virtuelle
                "%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" unregistervm "V%COMPUTERNAME%" --delete
		rem Suppression du disque dur virtuel associé à la machine
		rem "%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" closemedium "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi" --delete				
	)

)

"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" createvm --name "V%COMPUTERNAME%" --ostype Windows7_64
"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" registervm "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vbox"

for /F %%M in ('powershell -ExecutionPolicy Bypass -NoProfile -File .\getmac.ps1') do (
	set MACADDRESS=%%M
)

"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" modifyvm  "V%COMPUTERNAME%"  --memory 4096 --vram 32 --acpi on --apic on --paravirtprovider hyperv --cpus 2 --firmware bios --boot1 net --boot2 disk --boot3 dvd --nic1 bridged --nictype1 82540EM --cableconnected1 on --macaddress1 %MACADDRESS% --clipboard bidirectional --draganddrop bidirectional
"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" createmedium disk --filename "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi" --format vdi --size 256000 --variant standard
"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" storagectl "V%COMPUTERNAME%" --name "SATA" --add sata --controller IntelAHCI --portcount 4 --hostiocache on --bootable on
"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" storageattach "V%COMPUTERNAME%" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi"
"%VBOX_MSI_INSTALL_PATH%\VboxManage.exe" storageattach "V%COMPUTERNAME%" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium emptydrive
exit %ERRORLEVEL%