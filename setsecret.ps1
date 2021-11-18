Param(
    [string] $token
)

$ErrorActionPreference = "stop"
Set-StrictMode -Version 2.0

gh version

$repository = $ENV:GITHUB_REPOSITORY
$ENV:GITHUB_TOKEN = $token

Write-Host "authenticate with $token"
gh auth login --with-token

Write-Host "write Secret"
'NYSECRET' | gh secret set TESTSECRET --repo $repository
Write-Host "done"
