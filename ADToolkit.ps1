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
    Write-Host "4: Disable Global Catalog function from Domain Controller"
    Write-Host "5: Check AD functional level"
    Write-Host "6: Raise AD functional level to Server 2016"
    Write-Host "7: DC Diagnostics Report"
    Write-Host "8: Check Domain Controller replication"
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
        "Domain Controller: "    + $_.Name
        "FSMO Roles Owned: "   + $_.OperationMasterRoles}
    } '2' {
        Write-Host "To transfer FSMO roles you need to supply the destination DC hostname (i.e. homelabdc, homelabdc2)" -ForegroundColor Red
        Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster
    } '3' {
        Write-Host  "Checking for Global Catalog Servers..." -ForegroundColor Green
        Get-ADForest  | Format-List GlobalCatalogs
    } '4' {
        Write-Host "Disable the Global Catalog function from Domain Controller" -ForegroundColor Green
        $DomainController = Read-Host "Enter the name of the domain controller to disable Global Catalog"
        repadmin.exe /options $DomainController –IS_GC
    } '5' {
        Write-Host "Checking for Active Directory Domain and Forest Functional Level..." -ForegroundColor Green
        Get-ADDomain | Format-List Name, DomainMode
        Get-ADForest | Format-List Name, ForestMode
    } '6' {
        Write-Host "Raising AD Domain and Forest to Server 2016 Functional Level..." -ForegroundColor Red
        Set-ADDomainMode -DomainMode 7
        Set-ADForestMode -ForestMode 7
    } '7' {
        Write-Host "Running DCDIAG..." -ForegroundColor Green
        dcdiag /v
    } '8' {
        Write-Host "Checking AD Replication..." -ForegroundColor Green
         repadmin /replsummary
    }
    }
    pause 5
 }
 until ($selection -eq 'q')