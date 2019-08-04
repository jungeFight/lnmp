Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  if($isPre){
    $VERSION=$preVersion
  }

  $url="https://mirrors.huaweicloud.com/helm/v${VERSION}/helm-v${VERSION}-windows-amd64.zip"

  $filename="helm-v${VERSION}-windows-amd64.zip"
  $unzipDesc="helm"

  if($(_command helm)){
    $CURRENT_VERSION=(ConvertFrom-Json -InputObject (helm version).trim('version.BuildInfo')).Version.trim("v")

    if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    }
  }

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  _cleanup helm
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force helm\windows-amd64\helm.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup helm

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  (ConvertFrom-Json -InputObject (helm version).trim('version.BuildInfo')).Version.trim("v")
}

Function uninstall(){
  _cleanup C:\bin\helm.exe
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\releases.ps1

  $lastRelease=getLatestRelease $githubRepo

  echo "
Package: $name
Version: $stableVersion
PreVersion: $preVersion
LastVersion: $lastRelease
HomePage: $homepage
Releases: $releases
Bugs: $bug
Description: $description
"
}

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
