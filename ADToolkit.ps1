<#
.DESCRIPTION
		A complete Active Directory toolkit that allows you to check on domain controller health as well as transferring FSMO roles and raising functional levels
            
.PREREQUISITES
            Powershell Client
            Domain & Enterprise Admin privileges
  
.AUTHOR
		Rob Bidinger 12 FEB 23
 
.VERSION
		1.0
 
#>
 #.SCRIPT CONTENT - DO NOT CHANGE BELOW
 Write-Host "- - Setting Variables - -" -ForegroundColor Cyan
 function Show-Menu {
    param (
        [string]$Title = 'AD Toolkit'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Check FSMO role holders"
    Write-Host "2: Transfer FSMO roles"
    Write-Host "3: Check for Global Catalog servers"
    Write-Host "4: Check AD functional level"
    Write-Host "5: Raise AD functional level to Server 2016"
    Write-Host "6: DC Diagnostics Report"
    Write-Host "7: Check Domain Controller replication"
    Write-Host "Q: Press 'Q' to quit."
}
do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
        Write-Host "Checking which domain controller is holding FSMO roles..." -ForegroundColor Green
    Get-ADDomainController -Filter *| ForEach-Object {
        "`nDomain Controller: "    + $_.Name
        "FSMO Roles Owned: "   + $_.OperationMasterRoles}
    } '2' {
        Write-Host "To transfer FSMO roles you need to supply the destination DC hostname (i.e. gpsgpccdcs01)" -ForegroundColor Red
        Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster
    } '3' {
        Write-Host  'Checking for Global Catalog Servers...' -ForegroundColor Green
      Get-ADForest  | FL GlobalCatalogs
    } '4' {
        Write-Host 'Checking for Active Directory Domain and Forest Functional Level...' -ForegroundColor Green
        Get-ADDomain | fl Name, DomainMode
        Get-ADForest | fl Name, ForestMode
    } '5' {
        Write-Host 'Raising AD Domain and Forest to Server 2016 Functional Level...' -ForegroundColor Red
        Set-ADDomainMode -DomainMode 7
        Set-ADForestMode -ForestMode 7
    } '6' {
        Write-Host 'Running DCDIAG...' -ForegroundColor Green
        dcdiag /v
    } '7' {
        Write-Host 'Checking AD Replication...' -ForegroundColor Green
         repadmin /replsummary
    }
    }
    pause 5
 }
 until ($selection -eq 'q')