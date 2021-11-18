Param(
    [string] $token,
    [string] $value
)

$ErrorActionPreference = "stop"
Set-StrictMode -Version 2.0

gh version

$repository = $ENV:GITHUB_REPOSITORY
$ENV:GITHUB_TOKEN = $token

Write-Host "authenticate with $token"
Write-Host 1
gh auth login --with-token 1> $null
Write-Host 2
gh auth login --with-token 2> $null
Write-Host 3
gh auth login --with-token 3> $null
Write-Host 4
gh auth login --with-token 4> $null
Write-Host 5
gh auth login --with-token 5> $null
Write-Host 6
gh auth login --with-token 6> $null
Write-Host 7
gh auth login --with-token > $null
gh secret set TESTSECRET -b $value --repo $repository
Write-Host "done"
