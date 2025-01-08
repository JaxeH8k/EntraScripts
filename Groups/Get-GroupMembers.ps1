$groupIds = @(
    'ddbc43c3-35e2-47f5-8f3b-2449dc6da519,devices corporate'
)

$graphApiEndpoint = 'https://graph.microsoft.com/v1.0/groups'
$selectAttribs = 'displayName,operatingSystem,managementType,approximateLastSignInDateTime'
$rpt = @()
foreach ($id in $groupIds) {
    # only process $id if it contains a 1 and only 1 comma in the string.
    if ($id.IndexOf(',') -ne -1 -and $id.IndexOf(',') -eq $id.LastIndexOf(',')) {
        $graphRequestUrl = $graphApiEndpoint, "{$(($id -split ',')[0])}", 'members', "microsoft.graph.device?`$select=$($selectAttribs)" -join '/'
        $request = Invoke-MgGraphRequest -Uri $graphRequestUrl -Method GET
        if ($request.Values.count -gt 0) {
            foreach ($i in $request.Value) {
                $rpt += [PSCustomObject]@{
                    GroupId                       = ($id.Split(','))[0]
                    GroupName                     = ($id.Split(','))[1]
                    displayName                   = $i.displayName
                    managementType                = $i.managementType
                    operatingSystem               = $i.operatingSystem
                    approximateLastSignInDateTime = $i.approximateLastSignInDateTime
                }
            }
        }
    }
}
