$ErrorActionPreference = "stop"
Set-StrictMode -Version 2.0

gh version

$token = 'Somestrangetoken'
$repository = $ENV:GITHUB_REPOSITORY

Write-Host "authenticate with $token"
'token' | gh auth login --with-token
Write-Host "write Secret"
'NYSECRET' | gh secret set TESTSECRET --repo $repository
Write-Host "done"
