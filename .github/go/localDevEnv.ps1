$ErrorActionPreference = "Stop"
$gitHubGoHelperPath = "$([System.IO.Path]::GetTempFileName()).ps1"
$webClient = New-Object System.Net.WebClient
$webClient.CachePolicy = New-Object System.Net.Cache.RequestCachePolicy -argumentList ([System.Net.Cache.RequestCacheLevel]::NoCacheNoStore)
$webClient.DownloadFile('https://raw.githubusercontent.com/freddydk/ghgo/main/GitHub-Go-Helper.ps1', $gitHubGoHelperPath)
. $gitHubGoHelperPath -local
$BcContainerHelperPath = DownloadAndImportBcContainerHelper

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Check-BcContainerHelperPermissions -silent -fix
}

# auth
$auth = "UserPassword"
$credential = New-Object pscredential -ArgumentList 'admin', (ConvertTo-SecureString -String 'P@ssword1' -AsPlainText -Force)

try {
    $environment = 'Local'
    $baseFolder = (Get-Item -path (Join-Path $PSScriptRoot "..\..")).FullName
    $workflowName = 'LocalDevEnv'
    $containerName = "bcServer"

    $settings = ReadSettings -baseFolder $baseFolder -workflowName $workflowName -userName $env:UserName

    $insiderSasToken = ""
    $LicenseFileUrl = ""
    if ($settings.keyVaultName) {
        Write-Host "Reading Key Vault $($settings.keyVaultName)"
        if (-not (get-installedmodule -Name az)) {
            Write-Host "Installing Az PowerShell module"
            Install-Module Az -Force
        }
        Write-Host "Importing Az PowerShell module"
        Import-Module Az
        $LicenseFileUrl = (Get-AzKeyVaultSecret -VaultName $settings.keyVaultName -Name $settings.LicenseFileUrlSecretName).SecretValue | Get-PlainText
        $insiderSasToken = (Get-AzKeyVaultSecret -VaultName $settings.keyVaultName -Name $settings.InsiderSasTokenSecretName).SecretValue | Get-PlainText
    }

    $repo = AnalyzeRepo -settings $settings -insiderSasToken $insiderSasToken -licenseFileUrl $LicenseFileUrl

    $params = @{}

    if (-not $repo.appFolders) {
        exit
    }

    $artifact = $repo.artifact
    $installApps = $repo.installApps
    $installTestApps = $repo.installTestApps

    if (-not $repo.appFolders) {
        exit
    }

    $buildArtifactFolder = Join-Path $baseFolder "output"
    if (Test-Path $buildArtifactFolder) {
        Get-ChildItem -Path $buildArtifactFolder -Include * -File | ForEach-Object { $_.Delete()}
    }
    else {
        New-Item $buildArtifactFolder -ItemType Directory | Out-Null
    }

    $allTestResults = "testresults*.xml"
    $testResultsFile = Join-Path $baseFolder "TestResults.xml"
    $testResultsFiles = Join-Path $baseFolder $allTestResults
    if (Test-Path $testResultsFiles) {
        Remove-Item $testResultsFiles -Force
    }

    Set-Location $baseFolder
    $runAlPipelineOverrides | ForEach-Object {
        $scriptName = $_
        $scriptPath = Join-Path $gitHubGoFolder "$ScriptName.ps1"
        if (Test-Path -Path $scriptPath -Type Leaf) {
            Write-Host "Add override for $scriptName"
            $params += @{
                "$scriptName" = (Get-Command $scriptPath | Select-Object -ExpandProperty ScriptBlock)
            }
        }
    }
    
    Run-AlPipeline @params `
        -auth $auth `
        -credential $credential `
        -pipelinename $workflowName `
        -containerName $containerName `
        -imageName "" `
        -artifact $artifact.replace('{INSIDERSASTOKEN}',$insiderSasToken) `
        -memoryLimit $repo.memoryLimit `
        -baseFolder $baseFolder `
        -licenseFile $LicenseFileUrl `
        -installApps $installApps `
        -installTestApps $installTestApps `
        -appFolders $repo.appFolders `
        -testFolders $repo.testFolders `
        -testResultsFile $testResultsFile `
        -testResultsFormat 'JUnit' `
        -installTestRunner:$repo.installTestRunner `
        -installTestFramework:$repo.installTestFramework `
        -installTestLibraries:$repo.installTestLibraries `
        -installPerformanceToolkit:$repo.installPerformanceToolkit `
        -enableCodeCop:$repo.enableCodeCop `
        -enableAppSourceCop:$repo.enableAppSourceCop `
        -enablePerTenantExtensionCop:$repo.enablePerTenantExtensionCop `
        -enableUICop:$repo.enableUICop `
        -azureDevOps:($environment -eq 'AzureDevOps') `
        -gitLab:($environment -eq 'GitLab') `
        -gitHubActions:($environment -eq 'GitHubActions') `
        -failOn 'error' `
        -AppSourceCopMandatoryAffixes $repo.appSourceCopMandatoryAffixes `
        -AppSourceCopSupportedCountries @() `
        -doNotRunTests `
        -useDevEndpoint `
        -updateLaunchJson "Local Sandbox" `
        -keepContainer `
}
finally {
    # Cleanup
    try {
        Remove-Module BcContainerHelper
        Remove-Item $bcContainerHelperPath -Recurse
    }
    catch {}
}