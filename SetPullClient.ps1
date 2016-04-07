#requires -Version 5

[DSCLocalConfigurationManager()]
configuration PullClientConfigID
{
    param  
        ( 
            [string[]]$NodeName = 'localhost', 

            [ValidateNotNullOrEmpty()] 
            [string] $RegistrationKey
        )
    Node $NodeName
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryWeb DSCPullServerConfig
        {
            ServerURL = 'https://DSCPULL.tlab.local:8080/PSDSCPullServer.svc'
            RegistrationKey = $RegistrationKey
            ConfigurationNames = @('ADCS01Base')
        }   

        ReportServerWeb DSCPullServerReport
        {
            ServerURL = 'https://DSCPULL.tlab.local:8080/PSDSCPullServer.svc'
            RegistrationKey = $RegistrationKey
        }
    }
}

$RegistrationKey = Get-Content -Path $env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt

PullClientConfigID -NodeName ADCS01.tlab.local -RegistrationKey $RegistrationKey -OutputPath c:\DSC\TargetNodes

Set-DscLocalConfigurationManager -ComputerName ADCS01.tlab.local -path '.\TargetNodes'  -Force -Verbose