#sample
Write-host "Parse xml file.."
$xmlDoc=[xml](Get-Content .\logs\sample.xml)
#$xmlDoc.payload.'session-tracking-info'.attribute
#$xmlDoc.payload.element.attribute

Get-ChildItem .\logs\*.* -include *.xml

foreach ($name in $xmlDoc.payload.element.attribute.name){
    Write-host -NoNewline $name ", "
    }
Write-Host ""
foreach ($value in $xmlDoc.payload.element.atute.value){
    Write-host -NoNewline $value "' "
    }
Write-Host ""
