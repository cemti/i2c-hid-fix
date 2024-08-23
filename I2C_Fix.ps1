param (
  [Parameter(Mandatory = $true)]
  [string]$VendorId,

  [Parameter(Mandatory = $true)]
  [string]$DeviceId
)

$pattern = "PCI\\VEN_${VendorId}&DEV_${DeviceId}%"
$query = "SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE '${pattern}'"
Set-CimInstance -Namespace root\wmi -Query $query -Property @{Enable = $false}
