
" 1. Read replacement texts from file"

$replacementTextHash = @{}
$replacementTextContent = get-content "ReplacementText.txt"

$replacementTextLines = $replacementTextContent.split('\n')
foreach($line in $replacementTextLines)
{
    $replacementTextLineItem = $line.split('=')   
    $replacementTextHash.add($replacementTextLineItem[0].trim().toString(),($replacementTextLineItem[1]).trim().toString())
}

# Print replacement texts
$replacementTextHash.keys
$replacementTextHash.values


" 2. Read Folders from file "

$folderTextContent = Get-Content "FoldersText.txt"
$folderTextLines = New-Object System.Collections.Generic.List[string]

foreach($line in $folderTextContent)
{
     $folderTextLines.Add($line)
}

# Print files
#$folderTextLines

" 3. Filter File List from global list"
$serverIndexFiles = New-Object System.Collections.Generic.List[string]
$filteredServerIndexList = New-Object System.Collections.Generic.List[string]

#$serverIndexFiles = Get-ChildItem -Path E:\Stage\AnsibleTest\config\config -Filter serverindex.xml -Recurse -ErrorAction SilentlyContinue -Force

foreach($folderItem in $folderTextLines)
{
     $fileList =  Get-ChildItem -Path $folderItem -Filter serverindex.xml -Recurse -ErrorAction SilentlyContinue -Force

                             foreach($fileItem in $fileList)
                            {
     
                             $singleEntry =  $fileItem.FullName.ToString()
                                     If ($singleEntry -notlike "*servertypes*") {
                                     $filteredServerIndexList.Add($singleEntry)
                         
                                     " 3.a Backup Server Index file"
                                     $currentDTAndTime = Get-Date -Format "MM_dd_yyyy_HH_mm"
                                     $singleEntry = $singleEntry.ToString() + ".bak_" + $currentDTAndTime.ToString()
                                     Copy-Item -Path $fileItem.FullName.ToString() -Destination $singleEntry
                         
                                                     " 3.b Replace texts in the file"
                                                     foreach($replaceTextItem in $replacementTextHash.Keys)
                                                        {
                                                        # Implement relacement command here
                                                        #(Get-Content -Path $fileItem.FullName.ToString()).Replace($replaceTextItem.key.ToString() ,$replacementTextHash[$replaceTextItem].ToString()) | Set-Content -Path $singleEntry
                                                        #"Printing Location of the file" + $fileItem.FullName 
                                                        $serverIndexFileFullPath = $fileItem.FullName
                                                        #"Replacing text "  + $replaceTextItem + " with text " + $replacementTextHash[$replaceTextItem]

                                                         ((Get-Content -path $serverIndexFileFullPath -Raw) -replace $replaceTextItem ,$replacementTextHash[$replaceTextItem]) | Set-Content -Path $serverIndexFileFullPath
                                                        
                                                         }

                                  } 
                            
                        }
}


#" 4. Print Filtered List"
#$filteredServerIndexList

