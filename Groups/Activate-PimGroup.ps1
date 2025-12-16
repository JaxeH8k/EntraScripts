param(
    [string]$requestorObjectId = 'c7114156-6a6d-4081-b87f-3fcd179de459',
    [string]$entraEnrollGroupId = 'e342ec54-b2ed-4942-93ba-e5911f338508'
)

$splat = @{
    uri         = 'https://graph.microsoft.com/beta/identityGovernance/privilegedAccess/group/assignmentScheduleRequests'
    body        = @{
        accessId      = 'member'
        principalId   = $requestorObjectId
        groupId       = $entraEnrollGroupId
        action        = 'adminAssign'
        scheduleInfo  = @{
            startDateTime = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
            expiration    = @{
                type     = 'afterDuration'
                duration = 'PT1H'
            }
        }
        justification = 'Assign active member access.'
    } | ConvertTo-Json
    method      = 'POST'
    contentType = 'application/json'
}
Invoke-MgGraphRequest @splat
