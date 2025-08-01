# Connect to Azure AD
Connect-AzureAD

# Set Enterprise App Name
$appName = "AWS XL - SSO"

# Get the Service Principal for the app
$servicePrincipal = Get-AzureADServicePrincipal -Filter "displayName eq '$appName'"

if ($null -eq $servicePrincipal) {
    Write-Error "Enterprise Application '$appName' not found."
    exit
}

# Get all role assignments
$assignments = Get-AzureADServiceAppRoleAssignment -ObjectId $servicePrincipal.ObjectId

# Filter only Group assignments and get Display Names
$groupNames = @()

foreach ($assignment in $assignments) {
    $principal = Get-AzureADObjectByObjectId -ObjectId $assignment.PrincipalId

    if ($principal.ObjectType -eq "Group") {
        $groupNames += $principal.DisplayName
    }
}

# Remove duplicates if any and sort
$groupNames = $groupNames | Sort-Object -Unique

# Output
$groupNames | ForEach-Object { Write-Output $_ }

# Or export to a file:
# $groupNames | Out-File -FilePath ".\AWS_XL_SSO_Assigned_Groups.txt"
