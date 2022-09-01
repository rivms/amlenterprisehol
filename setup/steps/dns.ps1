Install-WindowsFeature -Name DNS -IncludeManagementTools 
Add-DnsServerPrimaryZone -Name "cnn.com" -ZoneFile "cnn.com.dns"
Add-DnsServerResourceRecord -ZoneName "cnn.com" -A -Name "cnn.com" -AllowUpdateAny -IPv4Address "1.2.3.5" -TimeToLive 01:00:00 -AgeRecord
Add-DnsServerForwarder -IPAddress 168.63.129.16 -PassThru