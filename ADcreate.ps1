# Create AD 

# Request Name

Write-Host '[*] Change the name and reboot Rename-Computer -NewName $name '
Write-Host ' '
Write-Host 'Save the name of the adapter with Get-NetAdapter'

$ip = Read-Host -Prompt "[*] IP: "
Write-Host ' '
$gw = Read-Host -Prompt "[*] Gateway: "
Write-Host ' '
$adapter = Read-Host -Prompt "[*] Adapter (If the name of the adapter is e.g. Ethernet 2 you have to put it in quotation marks like this 'Ethernet 2'): "
$dns = Read-Host -Prompt "[*] DNS: "
Write-Host ' '
$Domainname = Read-Host -Promt "[*] Domain Name e.g. beeklabs.com: "
Write-Host ' '
$Netbios = Read-Host -Prompt "[*] Netbios e.g. BEEK: "
Write-Host ' '

Write-Host '[*] Setup IP...'
New-NetIPAddress -InterfaceAlias $adapter -IPAddress $ip -AddressFamily IPv4 -PrefixLength 24 –DefaultGateway $gw

Write-Host '[*] Setup DNS...'
Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses $dns

# Install Active Directory Domain Services role

Write-Host '[*] Installing role...'
Install-WindowsFeature AD-Domain-Services –IncludeManagementTools -Verbose	

Write-Host '[*] Checking...'
Get-WindowsFeature -Name *AD*

Write-Host '[*] Installing...'
Install-ADDSForest -DomainName $Domainname -ForestMode Win2012 -DomainMode Win2012 -DomainNetbiosName $Netbios -InstallDns:$true

Write-Host '[*] Finish, if you want to verify Get-ADDomainController -Discover. Restarting...'
Start-Sleep -Seconds 10

Restart-Computer	
