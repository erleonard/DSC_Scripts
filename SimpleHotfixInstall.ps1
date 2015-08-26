Configuration UpdateWindowsWithPath 
{ 
    Import-DscResource -ModuleName xWindowsUpdate       
    Node ‘Server02’ 
    {  
        xHotfix HotfixInstall 
        { 
            Ensure = "Present" 
            Path = "C:\e87e8d5d85abf29e67\x64-Windows8.1-KB2934520-x64.msu" 
            Id = "KB2934520" 
        }  
    }  
} 
  