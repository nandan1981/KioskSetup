Start-Process PowerShell -Verb RunAs

$installed = 0

if(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\IntelligentLobbyKioskInstallation' ){
	if(Test-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\IntelligentLobbyKioskInstallation' -Value 'IsRegistryEnabledForKiosk' eq $installed) {
		setUpRegistry
	} else {
		echo Installation is done
	}
}else{
	setUpRegistry
}

function setUpRegistry{
		
		#Set-ItemProperty -Path "HKCU\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" "ExecutionPolicy"="Bypass"

		#check the value of if installation done
		Get-ItemProperty -Path "HKLM:\SOFTWARE\IntelligentLobbyKioskInstallation\IsRegistryEnabledForKiosk"
		
		echo Setting the registry values
		
		#Disable what power button does
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4f971e89-eebd-4455-a8de-9e59040e7347\7648efa3-dd9c-4e3e-b566-50f929386280" -Value 1
		
		#Disable or hide all notifications including restart warnings
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetUpdateNotificationLevel" -Value 1

		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "UpdateNotificationLevel" -Value 2

		#Disable Edge swipe actions on screen to disable minimize or accessing the taskbar
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name "EdgeUI" -Value 0
		
		#Disable crash screen if the os crashes
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\" -Name "DisplayDisabled" -Value 0

		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\" -Name "Explorer" -Value 0

		#Auto Login enabled
		#HAVE TO MODIFY THISS!!!!!!!!
		Set-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Microsoft\WindowsNT\" -Name "CurrentVersion\Winlogon\AutoAdminLogon" -Value 1

		$c = Get-Credential -Message "Please enter you kiosk admin login or current login details" credential Admin
		$c.UserName
		$c.GetNetworkCredential().password

		#Setting the default Username and password
		Set-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Microsoft\WindowsNT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $c.UserName

		Set-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Microsoft\WindowsNT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $c.GetNetworkCredential().password
		
		#disabling auto recovery or repair if restart occurs multiple times
		Start-Process Recovery_disable.bat

		# Set/mark the flag to 1 indicating that the installation is complete 
		Set-ItemProperty -Path "HKLM:\SOFTWARE\IntelligentLobbyKioskInstallation" -Name "IsRegistryEnabledForKiosk" -Value 1

		echo Restarting Computer

		Restart-Computer 
}


function Test-RegistryValue {
	param (
	 [parameter(Mandatory=$true)]
	 [ValidateNotNullOrEmpty()]$Path,

	[parameter(Mandatory=$true)]
	 [ValidateNotNullOrEmpty()]$Value
	)
try {
	Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
	 return $true
	 }
catch {
	return $false
}

}
