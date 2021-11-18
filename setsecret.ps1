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
gh auth login --with-token 6> $null
gh secret set TESTSECRET -b $value --repo $repository
Write-Host "done"
