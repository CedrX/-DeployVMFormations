for /F %%M in ('powershell -ExecutionPolicy Bypass -NoProfile -File .\getmac.ps1') do (
	set MACADDRESS=%%M
)
echo %MACADDRESS%