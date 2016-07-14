Add-Type -AssemblyName System.IO.Compression.FileSystem
function UnZip
{
    param([string]$zipfile, [string]$outpath)
    
    foreach($entry in $zipfile){
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
        
    }
}


function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "docx (*.docx)| *.docx| xlsx (*.xlsx)| *.xlsx"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}


function Crack-It
{
    write-host = "Select the file"
    $filepath = Get-FileName "C:\"
        
    $ResultTest = test-path $filepath

    #gets the extension of the file
    $extension = [System.IO.Path]::GetExtension($filepath)
    
    #tests path
    if(($ResultTest -eq $False))
    {
        write-host "Invalid Filepath"
    }

    else
    {
        
        if($extension -eq ".docx")
        {
             write-host "Condition .docx successfull"
             $newpath = Copy-Item -Path $filepath –Destination ([io.path]::ChangeExtension($filepath, '.zip')) -Verbose -PassThru -ErrorAction SilentlyContinue
             
              Unzip "$newpath" "C:\Users\Public\Documents" 
             
             #PWD Removal Word Doc
             
             $File = 'C:\Users\Public\Documents\word\settings.xml' #sets XML file = $File
             [xml]$xml = Get-Content $File  #Gets Content of the $File and sets to $xml
             $xml | Select-Xml -XPath '//w:documentProtection' -Namespace @{w = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"} | Foreach{$_.Node.ParentNode.RemoveChild($_.Node)}  #searchs for the document protection using the namespace
             $xml.Save($File)

        }

        elseif($extension -eq ".xlsx")
        {
             

             $newpath = Copy-Item -Path $filepath –Destination ([io.path]::ChangeExtension($filepath, '.zip')) -Verbose -PassThru -ErrorAction SilentlyContinue
             Unzip "$newpath" "C:\Users\Public\Documents\NewFolder"

             $File = 'C:\Users\Public\Documents\xl\workbook.xml' #sets XML file = $File
             $newpathtxt = Copy-Item -Path $file –Destination ([io.path]::ChangeExtension($file, '.txt')) -Verbose -PassThru -ErrorAction SilentlyContinue
             
             get-content $newpathtxt | select-string -pattern '(<)(workbookProtection)(.*?)(>)' -notmatch | Out-File $newpathtxt

             $nextFile = Get-ChildItem C:\Users\Public\Documents\TestUnlock\xl\worksheets\*.xml

             foreach($fileElement in $nextFile)
             {
                $newpathSheettxt = Copy-Item -Path $fileElement –Destination ([io.path]::ChangeExtension($fileElement, '.txt')) -Verbose -PassThru -ErrorAction SilentlyContinue
                get-content $newpathSheettxt | select-string -pattern '(<)(sheetProtection)(.*?)(>)' -notmatch | Out-File $newpathSheettxt

             }

             $nextTxt = Get-ChildItem C:\Users\Public\Documents\TestUnlock\xl\worksheets\*.txt

             foreach($txtfile in $nextTxt)
             {
                $newXmlPath = Copy-Item -Path $txtfile -Destination ([io.path]::ChangeExtension($txtfile, '.xml')) -Verbose -PassThru -ErrorAction SilentlyContinue

             }


                #regex for workbook protection = (<)(workbookProtection)(.*?)(>)
                #regex for sheet protection = (<)(sheetProtection)(.*?)(>)

        }

        else
        {

            write-host "File type not supported.  If possible, please save the document in either a .docx or .xlsx format.  If it is not possible, oh well."

        }

        

    }
    
}