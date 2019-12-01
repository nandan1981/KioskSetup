Start-Process PowerShell -Verb RunAs

Get-WmiObject -Namespace root\cimv2 -Class CIM_BIOSElement

Get-WmiObject -Namespace root\cimv2 -Class Win32_SMBIOSMemory