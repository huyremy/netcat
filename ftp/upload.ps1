# FTP Server Variables
$FTPHost = 'ftp://matilda.vn/'
$FTPUser = 'huyremy@matilda.vn'
$FTPPass = 'passwordthayvaoday'
 

$UploadFolder = "C:\abc\ đường dẫn đến thư mục chứa nhưng file cần tranfer"
  
$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass)  
 
$SrcEntries = Get-ChildItem $UploadFolder -Recurse
$Srcfolders = $SrcEntries | Where-Object{$_.PSIsContainer}
$SrcFiles = $SrcEntries | Where-Object{!$_.PSIsContainer}
 

foreach($folder in $Srcfolders)
{    
    $SrcFolderPath = $UploadFolder  -replace "\\","\\" -replace "\:","\:"   
    $DesFolder = $folder.Fullname -replace $SrcFolderPath,$FTPHost
    $DesFolder = $DesFolder -replace "\\", "/"
    
 
    try
        {
            $makeDirectory = [System.Net.WebRequest]::Create($DesFolder);
            $makeDirectory.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass);
            $makeDirectory.Method = [System.Net.WebRequestMethods+FTP]::MakeDirectory;
            $makeDirectory.GetResponse();
            
        }
    catch [Net.WebException]
        {
            try {
                
                $checkDirectory = [System.Net.WebRequest]::Create($DesFolder);
                $checkDirectory.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass);
                $checkDirectory.Method = [System.Net.WebRequestMethods+FTP]::PrintWorkingDirectory;
                $response = $checkDirectory.GetResponse();
                
            }
            catch [Net.WebException] {
                
            }
        }
}
foreach($entry in $SrcFiles)
{
    $SrcFullname = $entry.fullname
    $SrcName = $entry.Name
    $SrcFilePath = $UploadFolder -replace "\\","\\" -replace "\:","\:"
    $DesFile = $SrcFullname -replace $SrcFilePath,$FTPHost
    $DesFile = $DesFile -replace "\\", "/"
    
 
    $uri = New-Object System.Uri($DesFile) 
    $webclient.UploadFile($uri, $SrcFullname)
}
