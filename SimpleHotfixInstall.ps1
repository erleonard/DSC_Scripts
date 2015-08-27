Configuration UpdateWindowsWithPath 
{
    Param(
        [string]$ComputerName='localhost'
    )

    Import-DscResource -ModuleName xWindowsUpdate, xPendingReboot

    Node $ComputerName
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xHotfix HotfixInstall 
        { 
            Ensure = "Present" 
            Path = "C:\Software\x64-Windows8.1-KB2934520-x64.msu" 
            Id = "KB2934520" 
        }
        
        xPendingReboot RebootCheck1
        {
            Name = "RebootCheck1"
            DependsOn = '[xHotfix]HotfixInstall'
        }
    }
} 

Set-Location C:\Scripts
UpdateWindowsWithPath
Set-DscLocalConfigurationManager -Path .\UpdateWindowsWithPath -Verbose 
Start-DscConfiguration -Verbose -wait -Path .\UpdateWindowsWithPath -Force
