configuration SimpleSQLInstall {

    Import-DscResource -ModuleName xSQLServer,xDisk
    Node $AllNodes.NodeName
    {
        xWaitForDisk InstallDisk
        {
            DiskNumber = 1
            RetryIntervalSec = 60
            RetryCount = 3
        }
        
        xDisk Installdisk
        {
            DiskNumber = 1
            DriveLetter = 'I'
            DependsOn = '[xWaitForDisk]InstallDisk'
        }

        
        xSQLServerSetup SQL
        {
            InstanceName =  'AutomationJouney'
            SourcePath = "C:\Software"
            SourceFolder = "SQL2014"
            Features= "SQLENGINE,SSMS"
            #SecurityMode="SQL"
            DependsOn = '[xDisk]Installdisk'
            UpdateEnabled = 'True'
            UpdateSource = 'C:\Software\SQL2014\Updates'

            SetupCredential = $InstallerServiceAccount
        }
    }
}

$SecurePassword = ConvertTo-SecureString -String "Foxtrot.12" -AsPlainText -Force
$InstallerServiceAccount = New-Object System.Management.Automation.PSCredential ("TLAB\SQLSVC", $SecurePassword)
$LocalSystemAccount = New-Object System.Management.Automation.PSCredential ("SYSTEM", $SecurePassword)

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
         }
        @{
            NodeName="Server02"
         }
    )
}

SQLInstall -ConfigurationData $ConfigurationData
Set-DscLocalConfigurationManager -Path .\SQLInstall -Verbose
Start-DscConfiguration -Path .\SQLInstall -Verbose -Wait -Force