Write-Host "BönæøåÆØÅ"
Write-Host "BönæøåÆØÅ".Length


$testSecret = '${{ secrets.TESTSECRET }}'
Write-Host $testSecret
Write-Host $testSecret.Length

Write-Host ($testSecret -eq "BönæøåÆØÅ")

$bytes = [System.Text.Encoding]::ASCII.GetBytes($testSecret)
$testSecret2 = [System.Text.Encoding]::UTF8.GetString($bytes)
$testSecret.ToCharArray() | % { Write-Host -NoNewline "$_ " }
Write-Host

$testSecret.ToCharArray() | % { Write-Host -NoNewline "$([int]$_) " }
Write-Host
$testSecret2.ToCharArray() | % { Write-Host -NoNewline "$_ " }
Write-Host
