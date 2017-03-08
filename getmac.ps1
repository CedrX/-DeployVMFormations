$SmsSiteCode = "076"
$sccmComputer = "vpsccm.ads.intra.inist.fr"
$vmName = "V"+$env:COMPUTERNAME
$credentials = get-credential
$vmObject = Get-WMIObject -Namespace "Root\SMS\Site_$($SmsSiteCode)" -Class 'SMS_R_SYSTEM' -Filter "Name='$vmName'" -ComputerName $sccmComputer -Credential $credentials
$macaddr = $vmObject.MACAddresses
$macaddr = $macaddr.replace(':','')
write-Host $macaddr