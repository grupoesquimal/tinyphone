# RUN THIS in powershell

# Check to see if we are currently running "as Administrator"
# See: https://github.com/mvijfschaft/dotfiles/blob/master/install.ps1


# https://github.com/lukesampson/scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

 ls "C:\local\boost_1_68_0"
 
iwr -useb get.scoop.sh | iex

scoop update

scoop install git wget cmake openssh unzip make sed cat


git config --global url.https://github.com/.insteadOf git@github.com:

$ErrorActionPreference="Stop"
$BuildMode="Release"

set-psdebug -trace 0

Write-Host "`nUpdating Submodules......"
git submodule -q update --init

cmd /c subst E: C:\projects\tinyphone

cd E:\lib\curl\
ls
.\buildconf.bat
cd E:\lib\curl\winbuild

ls

pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools"
cmd /c "VsDevCmd.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow

where.exe msbuild.exe

nmake /f Makefile.vc mode=dll VC=15 DEBUG=no

cd E:\lib\curl\builds

ls 

cmd /c MKLINK /D E:\lib\curl\builds\libcurl-vc-x86-release-dll-ipv6-sspi-winssl E:\lib\curl\builds\libcurl-vc15-x86-release-dll-ipv6-sspi-winssl
ls E:\lib\curl\builds
cmd /c .\libcurl-vc15-x86-release-dll-ipv6-sspi-winssl\bin\curl.exe https://wttr.in/bangalore

#G729
cd E:\lib\bcg729\build\
cmake ..
msbuild /m bcg729.sln /p:Configuration=$BuildMode /p:Platform=Win32
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

cd E:\lib\cryptopp
msbuild /m cryptlib.vcxproj /p:Configuration=$BuildMode /p:Platform=Win32 /p:PlatformToolset=v140_xp
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

$wc = New-Object net.webclient; $wc.Downloadfile("https://download.steinberg.net/sdk_downloads/asiosdk_2.3.3_2019-06-14.zip", "E:\lib\portaudio\src\hostapi\asio\asiosdk_2.3.3_2019-06-14.zip")
cd E:\lib\portaudio\src\hostapi\asio
unzip asiosdk_2.3.3_2019-06-14.zip
mv asiosdk_2.3.3_2019-06-14 ASIOSDK
cd E:\lib\portaudio\build\msvc
msbuild /m portaudio.sln /p:Configuration=$BuildMode /p:Platform=Win32
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

cd E:\lib\pjproject
msbuild /m pjproject-vs14.sln -target:libpjproject:Rebuild /p:Configuration=$BuildMode-Static /p:Platform=Win32
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

cd E:\lib\statsd-cpp
cmake .
msbuild /m statsd-cpp.vcxproj /p:Configuration=$BuildMode /p:Platform=Win32
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

cd E:\tinyphone

sed -i 's/stampver.inf.*\$/stampver.inf $/g' tinyphone.vcxproj

msbuild /m tinyphone.sln /p:Configuration=$BuildMode /p:Platform=x86
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

Write-Host "`nBuild Completed." -ForegroundColor Yellow