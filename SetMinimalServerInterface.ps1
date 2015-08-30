Configuration SetMinimalServerInterface 
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

        WindowsFeature MinimalServerInterface
        {
            Ensure = 'Absent'
            Name = 'Server-Gui-Shell'
        }
        
        xPendingReboot RebootCheck1
        {
            Name = "RebootCheck1"
            DependsOn = '[WindowsFeature]MinimalServerInterface'
        }
    }
} 

Set-Location C:\Scripts
SetMinimalServerInterface
Set-DscLocalConfigurationManager -Path .\SetMinimalServerInterface -Verbose 
Start-DscConfiguration -Verbose -wait -Path .\SetMinimalServerInterface -Force
