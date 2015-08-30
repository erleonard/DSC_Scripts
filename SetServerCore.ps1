Configuration SetServerCore
{
    Param(
        [string]$ComputerName='localhost'
    )

    Import-DscResource -ModuleName xPendingReboot

    Node $ComputerName
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature RemoveServerGUIShell
        {
            Ensure = 'Absent'
            Name = 'Server-Gui-Shell'
        }

        WindowsFeature RemoveGuiMgmtInfra
        {
            Ensure = 'Absent'
            Name = 'Server-Gui-Mgmt-Infra'
        }
        
        xPendingReboot RebootCheck1
        {
            Name = "RebootCheck1"
            DependsOn = '[WindowsFeature]RemoveServerGUIShell','[WindowsFeature]RemoveGuiMgmtInfra'
        }
    }
} 

Set-Location C:\Scripts
SetServerCore
Set-DscLocalConfigurationManager -Path .\SetServerCore -Verbose 
Start-DscConfiguration -Verbose -wait -Path .\SetServerCore -Force
