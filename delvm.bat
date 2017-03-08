set VBOXPATH=C:\Program Files\Oracle\VirtualBox
set VMPATH=d:\Virtualbox
echo V%COMPUTERNAME%
echo %VBOXPATH%
"%VBOXPATH%\VboxManage.exe" list vms

"%VBOXPATH%\VboxManage.exe" list vms > vms.txt
FOR /F delims^=^"^ tokens^=1* %%m in (vms.txt) do (
	IF /I %%m==V%COMPUTERNAME% ( 
		rem suppression de la machine virtuelle
                "%VBOXPATH%\VboxManage.exe" unregistervm "V%COMPUTERNAME%" --delete
		rem Suppression du disque dur virtuel associé à la machine
		rem "%VBOXPATH%\VboxManage.exe" closemedium "%VMPATH%\V%COMPUTERNAME%\V%COMPUTERNAME%.vdi" --delete				
	)

)