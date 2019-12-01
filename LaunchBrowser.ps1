#Start-Process -k "chrome.exe" "https://foa-uat.exela.global"

Start-Process PowerShell -Verb RunAs

$Target = "chrome.exe"

#while ($Process.Count -lt 1){
    Start-Process $Target -ArgumentList "-k https://foa-uat.exela.global"
    #Start-Sleep -Seconds 
	
    #$Process = Get-Process | Where-Object { $_.ProcessName -eq $Target }
#}

	
