#requires -Version 5 -Modules xPSDesiredStateConfiguration

configuration CreatePullServer
{ 
    param  
    ( 
            [string[]]$NodeName = 'localhost', 

            [ValidateNotNullOrEmpty()] 
            [string] $certificateThumbPrint,

            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string] $RegistrationKey 
     ) 


     Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

     Node $NodeName 
     { 
         WindowsFeature DSCServiceFeature 
         { 
             Ensure = "Present" 
             Name   = "DSC-Service"             
         } 


         xDscWebService PSDSCPullServer 
         { 
             Ensure                  = "Present" 
             EndpointName            = "PSDSCPullServer" 
             Port                    = 8080 
             PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer" 
             CertificateThumbPrint   = $certificateThumbPrint          
             ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules" 
             ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"             
             State                   = "Started" 
             DependsOn               = "[WindowsFeature]DSCServiceFeature"                         
         } 

        File RegistrationKeyFile
        {
            Ensure          ='Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }
    }
}

$certificateThumbPrint = Get-ChildItem -path cert:\LocalMachine\My | Where-Object {$_.Subject -match "$env:COMPUTERNAME"}

CreatePullServer -Nodename DSCPULL.tlab.local -CertificateThumbPrint $certificateThumbPrint.Thumbprint -RegistrationKey (new-guid).Guid

Start-DscConfiguration -ComputerName DSCPULL.tlab.local -path '.\CreatePullServer'  -Force -Wait -Verbose