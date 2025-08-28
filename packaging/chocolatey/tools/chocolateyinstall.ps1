$ErrorActionPreference = 'Stop'

$packageName = 'qt-simple-template'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/example/qt-simple-template/releases/download/v@PROJECT_VERSION@/qt-simple-template-@PROJECT_VERSION@.msi'
$checksum = 'CHECKSUM_TO_BE_REPLACED'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Qt Simple Template*'
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyPackage @packageArgs
