#  Battery XML Parser
###############################

Write-host "Parse xml file.."
$out_csv_file = ".\out.csv"


# Remove outputfile if it existed
If (Test-Path $out_csv_file){
    Remove-Item $out_csv_file
}

# Load XML file
#Get-ChildItem .\logs\*.* -include *.xml
$files = Get-ChildItem .\logs\*.* -Filter *.xml
Foreach($file_temp in $files){

    $xmlDoc=[xml](Get-Content $file_temp)
    $fileDateTime=$file_temp.CreationTime

    # Output retrieve data to csv format
    #Header
    foreach ($name in $xmlDoc.payload.'session-tracking-info'.attribute.name){
        Write-Output $name ", " | Out-File ${out_csv_file} -NoNewline -Append -Encoding ascii
    }
    foreach ($name in $xmlDoc.payload.element.attribute.name){
        Write-Output $name ", " | Out-File ${out_csv_file} -NoNewline -Append -Encoding ascii
    }
    Write-Output "File DateTime" | Out-File ${out_csv_file} -Append -Encoding ascii

    #Data
    foreach ($value in $xmlDoc.payload.'session-tracking-info'.attribute.value){
        Write-Output $value ", " | Out-File ${out_csv_file} -NoNewline -Append -Encoding ascii
    }
    foreach ($value in $xmlDoc.payload.element.attribute.value){
        Write-Output $value ", " | Out-File ${out_csv_file} -NoNewline -Append -Encoding ascii
    }
    Write-Output $fileDateTime.ticks | Out-File ${out_csv_file} -Append -Encoding ascii
}
