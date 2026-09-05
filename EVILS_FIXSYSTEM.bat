@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EVILS CITY SYSTEM FIX ALL - GTA5RP.VN [Coded by KayC]

:: ============================================================
:: CHECK ADMINISTRATOR
:: ============================================================

net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo.
    echo ========================================================
    echo          YEU CAU QUYEN ADMINISTRATOR
    echo ========================================================
    echo.
    echo [!] Script can quyen Administrator de chay.
    echo [*] Dang mo lai voi quyen Admin...
    echo.

    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -FilePath '%~f0' -Verb RunAs"

    exit /b
)

set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set "EVILS_DIR="
set "OUT=%TEMP%\evils_dir.txt"

:: Fix TEMP path khi chay Admin
if "%USERNAME%"=="SYSTEM" (
    set "TEMP=%SystemRoot%\Temp"
    set "TMP=%SystemRoot%\Temp"
)

echo.
echo ========================================================
echo        EVILS SYSTEM FIX ALL - BY KAYC DEP ZAI VCL
echo ========================================================
echo.

:: ============================================================
:: 1. CLEAN TEMP / PREFETCH / CITIZENFX
:: ============================================================

echo [1/10] CLEAN TEMP / PREFETCH / CITIZENFX
echo.

echo [*] Cleaning user TEMP...

takeown /f "%temp%" /r /d y >nul 2>&1
icacls "%temp%" /grant %username%:F /T /C >nul 2>&1
del /f /s /q /a "%temp%\*.*" >nul 2>&1

for /d %%p in ("%temp%\*") do (
    rmdir /s /q "%%p" >nul 2>&1
)

echo [OK] User TEMP cleaned.

echo [*] Cleaning Windows TEMP...

takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
icacls "C:\Windows\Temp" /grant Administrators:F /T /C >nul 2>&1
del /f /s /q /a "C:\Windows\Temp\*.*" >nul 2>&1

for /d %%p in ("C:\Windows\Temp\*") do (
    rmdir /s /q "%%p" >nul 2>&1
)

echo [OK] Windows TEMP cleaned.

echo [*] Cleaning Windows Prefetch...

takeown /f "C:\Windows\Prefetch" /r /d y >nul 2>&1
del /s /f /q /a "C:\Windows\Prefetch\*.*" >nul 2>&1

echo [OK] Prefetch cleaned.

echo [*] Cleaning CitizenFX...

rmdir /s /q "%AppData%\CitizenFX" >nul 2>&1

echo [OK] CitizenFX cleaned.
echo.

:: ============================================================
:: 2. RESET IP / DNS
:: ============================================================

echo [2/10] RESET IP / DNS
echo.

echo [*] Releasing IP...
ipconfig /release >nul 2>&1

echo [*] Renewing IP...
ipconfig /renew >nul 2>&1

echo [*] Flushing DNS...
ipconfig /flushdns >nul 2>&1

echo [OK] IP/DNS reset completed.
echo.

:: ============================================================
:: 3. AUTO-DETECT EVILS FOLDER
:: ============================================================

echo [3/10] AUTO-DETECT EVILS FOLDER
echo.

echo [*] Dang tim thu muc EVILS chuan...
echo.

del /f /q "%OUT%" >nul 2>&1

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
  "$hit=$null;" ^
  "function Test([string]$p){" ^
  " if([string]::IsNullOrWhiteSpace($p)){return $false};" ^
  " return (Test-Path (Join-Path $p 'EVILS.exe') -PathType Leaf) -and (Test-Path (Join-Path $p 'EVILS.VisualElementsManifest.xml') -PathType Leaf)" ^
  "};" ^
  "try{" ^
  " $p=Get-Process EVILS -EA SilentlyContinue | Select-Object -First 1;" ^
  " if($p){" ^
  "  $d=Split-Path $p.Path -Parent;" ^
  "  if(Test $d){$hit=$d}" ^
  " }" ^
  "}catch{};" ^
  "if(-not $hit){" ^
  " try{" ^
  "  $ap=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\EVILS.exe' -EA SilentlyContinue).'(default)';" ^
  "  if(-not $ap){$ap=(Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\EVILS.exe' -EA SilentlyContinue).'(default)'};" ^
  "  if(-not $ap){$ap=(Get-ItemProperty 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\EVILS.exe' -EA SilentlyContinue).'(default)'};" ^
  "  if($ap){" ^
  "   $d=Split-Path $ap -Parent;" ^
  "   if(Test $d){$hit=$d}" ^
  "  }" ^
  " }catch{}" ^
  "};" ^
  "if(-not $hit){" ^
  " $cand=@(" ^
  "  (Join-Path $env:LOCALAPPDATA 'EVILS')," ^
  "  (Join-Path $env:LOCALAPPDATA 'Programs\EVILS')," ^
  "  (Join-Path $env:ProgramFiles 'EVILS')," ^
  "  (Join-Path ${env:ProgramFiles(x86)} 'EVILS')," ^
  "  (Join-Path $env:ProgramData 'EVILS')" ^
  " ) | Where-Object {Test-Path $_};" ^
  " foreach($c in $cand){" ^
  "  if(Test $c){$hit=$c;break}" ^
  " }" ^
  "};" ^
  "if(-not $hit){" ^
  " $root=$env:LOCALAPPDATA;" ^
  " if(Test-Path $root){" ^
  "  try{" ^
  "   $x=Get-ChildItem -LiteralPath $root -Filter 'EVILS.exe' -File -Recurse -Depth 4 -EA SilentlyContinue | Select-Object -First 1;" ^
  "   if($x){" ^
  "    $d=$x.DirectoryName;" ^
  "    if(Test $d){$hit=$d}" ^
  "   }" ^
  "  }catch{}" ^
  " }" ^
  "};" ^
  "if(-not $hit){" ^
  " $dr=(Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}).DeviceID;" ^
  " foreach($d in $dr){" ^
  "  foreach($p in @('EVILS','Games\EVILS','Game\EVILS','Program Files\EVILS','Program Files (x86)\EVILS')){" ^
  "   $pp=Join-Path $d $p;" ^
  "   if(Test $pp){$hit=$pp;break}" ^
  "  }" ^
  "  if($hit){break}" ^
  " };" ^
  " if(-not $hit){" ^
  "  foreach($d in $dr){" ^
  "   try{" ^
  "    $x=Get-ChildItem -LiteralPath ($d+'\') -Filter 'EVILS.exe' -File -Recurse -Depth 5 -EA SilentlyContinue | Select-Object -First 1;" ^
  "    if($x){" ^
  "     $d2=$x.DirectoryName;" ^
  "     if(Test $d2){$hit=$d2;break}" ^
  "    }" ^
  "   }catch{}" ^
  "  }" ^
  " }" ^
  "};" ^
  "if($hit){$hit | Out-File -Encoding ASCII '%OUT%'}" >nul 2>&1

if exist "%OUT%" (
    set /p EVILS_DIR=<"%OUT%"
    del /f /q "%OUT%" >nul 2>&1
)

:: ============================================================
:: MANUAL SELECT IF AUTO-DETECT FAILED
:: ============================================================

if not defined EVILS_DIR (
    echo [!] Khong tu dong tim thay EVILS.
    echo [*] Vui long chon thu muc chua EVILS.exe...
    echo.

    for /f "usebackq delims=" %%D in (`
        "%PS%" -STA -NoProfile -ExecutionPolicy Bypass -Command ^
        "Add-Type -AssemblyName System.Windows.Forms; $f=New-Object Windows.Forms.FolderBrowserDialog; $f.Description='Chon thu muc chua EVILS.exe'; if($f.ShowDialog() -eq 'OK'){[Console]::WriteLine($f.SelectedPath)}"
    `) do (
        set "EVILS_DIR=%%D"
    )
)

:: ============================================================
:: VERIFY EVILS
:: ============================================================

if not defined EVILS_DIR (
    echo.
    echo [ERROR] Khong tim thay thu muc EVILS.
    echo.
    pause
    exit /b 1
)

if not exist "%EVILS_DIR%\EVILS.exe" (
    echo.
    echo [ERROR] Khong co EVILS.exe trong:
    echo "%EVILS_DIR%"
    echo.
    pause
    exit /b 1
)

if not exist "%EVILS_DIR%\EVILS.VisualElementsManifest.xml" (
    echo.
    echo [ERROR] Khong co EVILS.VisualElementsManifest.xml trong:
    echo "%EVILS_DIR%"
    echo.
    pause
    exit /b 1
)

set "EVILS_EXE=%EVILS_DIR%\EVILS.exe"

echo.
echo [OK] EVILS folder:
echo     "%EVILS_DIR%"
echo.
echo [OK] EVILS.exe:
echo     "%EVILS_EXE%"
echo.

:: ============================================================
:: 4. WINDOWS DEFENDER EXCLUSION
:: ============================================================

echo [4/10] WINDOWS DEFENDER EXCLUSION
echo.

echo [*] Them folder EVILS vao Defender Exclusion...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Add-MpPreference -ExclusionPath '%EVILS_DIR%' -ErrorAction Stop; Write-Host '[OK] Folder EVILS da duoc them.' } catch { Write-Host '[ERROR] Khong the them folder exclusion.'; Write-Host $_.Exception.Message; exit 1 }"

if errorlevel 1 (
    echo.
    echo [ERROR] Them folder exclusion that bai.
    echo.
    pause
    exit /b 1
)

echo [*] Them EVILS.exe vao Defender Exclusion...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Add-MpPreference -ExclusionPath '%EVILS_EXE%' -ErrorAction Stop; Write-Host '[OK] EVILS.exe da duoc them.' } catch { Write-Host '[ERROR] Khong the them EVILS.exe exclusion.'; Write-Host $_.Exception.Message; exit 1 }"

if errorlevel 1 (
    echo.
    echo [ERROR] Them EVILS.exe exclusion that bai.
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Defender Exclusion completed.
echo.

:: ============================================================
:: 5. DELETE EVILS CACHE / LOGS / CRASHES
:: ============================================================

echo [5/10] XOA CACHE / LOGS / CRASHES
echo.

echo [*] Dang xoa cache, server-cache, logs, crashes...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = '%EVILS_DIR%';" ^
  "$targets = @('cache','server-cache','server-cache-priv','logs','crashes');" ^
  "Get-ChildItem -LiteralPath $root -Directory -Recurse -Force -EA SilentlyContinue | Where-Object { $targets -contains $_.Name } | ForEach-Object { try { Remove-Item -LiteralPath $_.FullName -Recurse -Force -EA SilentlyContinue } catch {} }" >nul 2>&1

echo [OK] EVILS cache/log/crash cleaned.
echo.

:: ============================================================
:: 6. INSTALL DIRECTX JUNE 2010
:: ============================================================

echo [6/10] CAI DIRECTX JUNE 2010
echo.

set "DX_URL=https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe"
set "DX_FILE=%TEMP%\dxredist.exe"
set "DX_DIR=%TEMP%\dxsetup"

echo [*] Dang tai DirectX June 2010...

:: Retry download up to 3 times
set "RETRY_COUNT=0"

:RETRY_DX

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Invoke-WebRequest -Uri '%DX_URL%' -OutFile '%DX_FILE%' -UseBasicParsing -TimeoutSec 600 } catch { exit 1 }" >nul 2>&1

if not exist "%DX_FILE%" (
    set /a "RETRY_COUNT+=1"

    if !RETRY_COUNT! LSS 3 (
        echo [!] Retry download DirectX (!RETRY_COUNT!/3)...
        timeout /t 3 /nobreak >nul
        goto RETRY_DX
    ) else (
        echo [WARNING] Khong tai duoc DirectX sau 3 lan thu.
        echo [WARNING] Bo qua buoc cai DirectX.
        goto DX_DONE
    )
)

if exist "%DX_FILE%" (
    echo [OK] Download DirectX thanh cong.

    echo [*] Dang giai nen...

    if exist "%DX_DIR%" (
        rd /s /q "%DX_DIR%" >nul 2>&1
    )

    "%DX_FILE%" /Q /T:"%DX_DIR%" >nul 2>&1

    if exist "%DX_DIR%\DXSETUP.exe" (
        echo [*] Dang cai dat DirectX...

        "%DX_DIR%\DXSETUP.exe" /silent >nul 2>&1

        echo [OK] DirectX installation completed.
    ) else (
        echo [WARNING] Khong tim thay DXSETUP.exe.
    )

    del /f /q "%DX_FILE%" >nul 2>&1
    rd /s /q "%DX_DIR%" >nul 2>&1
)

:DX_DONE
echo.

:: ============================================================
:: 7. REMOVE + REINSTALL MICROSOFT VISUAL C++ REDISTRIBUTABLE x64
:: ENHANCED VERSION
:: ============================================================

echo [7/10] CAI LAI MICROSOFT VISUAL C++ REDISTRIBUTABLE x64
echo.

set "VC_URL=https://aka.ms/vc14/vc_redist.x64.exe"
set "VC_FILE=%TEMP%\vc_redist.x64.exe"

:: Kiem tra xem da cai chua
echo [*] Kiem tra Visual C++ Redistributable x64 hien tai...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"$installed = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'Microsoft Visual C++*2015-2022*Redistributable*' -and $_.DisplayName -like '*x64*' }; if($installed){ Write-Host '[OK] Da cai Visual C++ Redistributable x64.'; exit 0 } else { Write-Host '[INFO] Chua cai Visual C++ Redistributable x64.'; exit 1 }"

if %errorlevel% equ 0 (
    echo [OK] Visual C++ Redistributable x64 da ton tai.
    echo [*] Bo qua buoc cai lai.
    goto VC_DONE
)

echo.
echo [*] Dang go Visual C++ Redistributable x64 hien tai (neu co)...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"$apps = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'Microsoft Visual C++*Redistributable*' -and $_.DisplayName -like '*x64*' }; foreach($a in $apps){ try { if($a.QuietUninstallString){ Start-Process 'cmd.exe' -ArgumentList '/c',$a.QuietUninstallString -Wait -WindowStyle Hidden } elseif($a.UninstallString){ $u=$a.UninstallString; if($u -match 'msiexec'){ $u=$u -replace '(?i)msiexec(\.exe)?','msiexec.exe'; Start-Process 'cmd.exe' -ArgumentList '/c',($u + ' /quiet /norestart') -Wait -WindowStyle Hidden } else { Start-Process 'cmd.exe' -ArgumentList '/c',($u + ' /quiet /norestart') -Wait -WindowStyle Hidden } } } catch {} }" >nul 2>&1

echo [OK] Da go Visual C++ Redistributable x64 (neu co).
echo.

:: ------------------------------------------------------------
:: THU DUNG winget NEU CO (NHANH HON)
:: ------------------------------------------------------------

where winget >nul 2>&1

if %errorlevel% equ 0 (
    echo [*] Phat hien winget, dang cai dat bang winget...

    winget install Microsoft.VCRedist.2015+.x64 --silent --accept-package-agreements 2>nul

    if !errorlevel! equ 0 (
        echo [OK] Visual C++ Redistributable x64 da cai thanh cong (winget).
        goto VC_CLEANUP
    ) else (
        echo [WARNING] Cai bang winget that bai, thu cach thu cong...
    )
)

:: ------------------------------------------------------------
:: DOWNLOAD VC++ MOI NHAT (CACH THU CONG)
:: ------------------------------------------------------------

if exist "%VC_FILE%" (
    del /f /q "%VC_FILE%" >nul 2>&1
)

echo [*] Dang tai Visual C++ Redistributable x64 moi nhat...

:: Retry download up to 3 times
set "RETRY_COUNT=0"

:RETRY_VC

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Invoke-WebRequest -Uri '%VC_URL%' -OutFile '%VC_FILE%' -UseBasicParsing -TimeoutSec 600 } catch { exit 1 }" >nul 2>&1

if not exist "%VC_FILE%" (
    set /a "RETRY_COUNT+=1"

    if !RETRY_COUNT! LSS 3 (
        echo [!] Retry download VC++ (!RETRY_COUNT!/3)...
        timeout /t 3 /nobreak >nul
        goto RETRY_VC
    ) else (
        echo [WARNING] Khong tai duoc Visual C++ Redistributable sau 3 lan thu.
        echo [WARNING] Bo qua buoc cai Visual C++.
        goto VC_DONE
    )
)

echo [OK] Tai Visual C++ thanh cong.
echo.

:: ------------------------------------------------------------
:: CAI DAT
:: ------------------------------------------------------------

echo [*] Dang cai Visual C++ Redistributable x64 moi nhat...

"%VC_FILE%" /install /quiet /norestart

set "VC_RESULT=!errorlevel!"

if "!VC_RESULT!"=="0" (
    echo [OK] Visual C++ Redistributable x64 da cai dat thanh cong.
) else if "!VC_RESULT!"=="3010" (
    echo [OK] Visual C++ da cai thanh cong. Can restart de hoan tat.
) else (
    echo [WARNING] Visual C++ installer returned code: !VC_RESULT!
)

:VC_CLEANUP

del /f /q "%VC_FILE%" >nul 2>&1

:VC_DONE
echo.

:: ============================================================
:: 8. INSTALL EASYANTICHEAT_EOS
:: ============================================================

echo ============================================================
echo [8/10] CAI DAT EASYANTICHEAT_EOS
echo ============================================================
echo.

set "EAC_DIR=%EVILS_DIR%\EVILS.app\EasyAntiCheat"
set "EAC_SETUP=%EAC_DIR%\EasyAntiCheat_EOS_Setup.exe"

:: ============================================================
:: KIEM TRA THU MUC EASYANTICHEAT TRONG GAME EVILS
:: ============================================================

if not exist "%EAC_DIR%\" (
    echo [EAC] LOI: Khong tim thay thu muc:
    echo "%EAC_DIR%"
    echo.
    goto EAC_DOWNLOAD
)

if not exist "%EAC_SETUP%" (
    echo [EAC] LOI: Khong tim thay:
    echo "%EAC_SETUP%"
    echo.
    goto EAC_DOWNLOAD
)

echo [EAC] Thu muc:
echo "%EAC_DIR%"
echo.
echo [EAC] EasyAntiCheat_EOS_Setup.exe da ton tai.
echo.

:: ============================================================
:: CHAY LENH EAC SO 1
:: TUONG DUONG MO TERMINAL TAI THU MUC EAC
:: ============================================================

echo [EAC] Dang chay lenh install 1...
echo.

pushd "%EAC_DIR%" >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$p=Start-Process -FilePath '%EAC_SETUP%' -ArgumentList 'install','f9443da5c6514e3191925875511b0726' -WorkingDirectory '%EAC_DIR%' -WindowStyle Hidden -Wait -PassThru; exit $p.ExitCode" >nul 2>&1

set "EAC_RESULT1=!errorlevel!"

popd >nul 2>&1

echo [EAC] Lenh install 1 da hoan tat. Ma: !EAC_RESULT1!
echo.

:: ============================================================
:: CHAY LENH EAC SO 2
:: ============================================================

echo [EAC] Dang chay lenh install 2...
echo.

pushd "%EAC_DIR%" >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$p=Start-Process -FilePath '%EAC_SETUP%' -ArgumentList 'install','b50929489498d9eb6d47a11c1d43cdf9' -WorkingDirectory '%EAC_DIR%' -WindowStyle Hidden -Wait -PassThru; exit $p.ExitCode" >nul 2>&1

set "EAC_RESULT2=!errorlevel!"

popd >nul 2>&1

echo [EAC] Lenh install 2 da hoan tat. Ma: !EAC_RESULT2!
echo.

:: ============================================================
:: TAI EASYANTICHEAT_EOS.ZIP
:: ============================================================

:EAC_DOWNLOAD

set "EAC_URL=https://github.com/evilscity/EasyAntiCheat_EOS/raw/refs/heads/main/EasyAntiCheat_EOS.zip"
set "EAC_ZIP=%TEMP%\EasyAntiCheat_EOS.zip"
set "EAC_EXTRACT=%TEMP%\EasyAntiCheat_EOS_EXTRACT"
set "EAC_TARGET=C:\Program Files (x86)\EasyAntiCheat_EOS"

echo [EAC] Dang tai EasyAntiCheat_EOS.zip...
echo.

:: Xoa file ZIP cu neu con
del /f /q "%EAC_ZIP%" >nul 2>&1

:: Xoa thu muc giai nen tam cu
if exist "%EAC_EXTRACT%" (
    rd /s /q "%EAC_EXTRACT%" >nul 2>&1
)

mkdir "%EAC_EXTRACT%" >nul 2>&1

:: Retry download up to 3 times
set "RETRY_COUNT=0"

:RETRY_EAC

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Invoke-WebRequest -Uri '%EAC_URL%' -OutFile '%EAC_ZIP%' -UseBasicParsing -TimeoutSec 600; exit 0 } catch { exit 1 }" >nul 2>&1

if not exist "%EAC_ZIP%" (
    set /a "RETRY_COUNT+=1"

    if !RETRY_COUNT! LSS 3 (
        echo [EAC] Retry download EAC (!RETRY_COUNT!/3)...
        timeout /t 3 /nobreak >nul
        goto RETRY_EAC
    ) else (
        echo.
        echo [EAC] LOI: Khong tai duoc EasyAntiCheat_EOS.zip sau 3 lan thu.
        echo.
        goto EAC_CLEANUP
    )
)

echo [EAC] Tai ZIP thanh cong.
echo.

:: ============================================================
:: GIAI NEN ZIP BANG POWERSHELL
:: KHONG CAN 7-ZIP
:: ============================================================

echo [EAC] Dang giai nen EasyAntiCheat_EOS.zip...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"try { Expand-Archive -LiteralPath '%EAC_ZIP%' -DestinationPath '%EAC_EXTRACT%' -Force; exit 0 } catch { exit 1 }" >nul 2>&1

if errorlevel 1 (
    echo.
    echo [EAC] LOI: Giai nen EasyAntiCheat_EOS.zip that bai.
    echo.
    goto EAC_CLEANUP
)

:: ============================================================
:: TIM THU MUC EasyAntiCheat_EOS SAU KHI GIAI NEN
:: ============================================================

set "EAC_SOURCE="

if exist "%EAC_EXTRACT%\EasyAntiCheat_EOS\" (
    set "EAC_SOURCE=%EAC_EXTRACT%\EasyAntiCheat_EOS"
)

:: Truong hop ZIP co them mot lop thu muc
if not defined EAC_SOURCE (
    for /d %%D in ("%EAC_EXTRACT%\*") do (
        if /I "%%~nxD"=="EasyAntiCheat_EOS" (
            set "EAC_SOURCE=%%~fD"
        )
    )
)

if not defined EAC_SOURCE (
    echo.
    echo [EAC] LOI: Khong tim thay thu muc EasyAntiCheat_EOS sau khi giai nen.
    echo.
    goto EAC_CLEANUP
)

echo [EAC] Da giai nen:
echo "%EAC_SOURCE%"
echo.

:: ============================================================
:: XOA EasyAntiCheat_EOS CU
:: ============================================================

echo [EAC] Dang xoa ban EasyAntiCheat_EOS cu...
echo.

if exist "%EAC_TARGET%\" (
    takeown /f "%EAC_TARGET%" /r /d y >nul 2>&1
    icacls "%EAC_TARGET%" /grant Administrators:F /T /C >nul 2>&1
    rd /s /q "%EAC_TARGET%" >nul 2>&1
)

:: ============================================================
:: DUA EasyAntiCheat_EOS MOI VAO PROGRAM FILES (X86)
:: ============================================================

echo [EAC] Dang dua EasyAntiCheat_EOS moi vao:
echo "%EAC_TARGET%"
echo.

:: Dam bao target khong con ton tai
if exist "%EAC_TARGET%\" (
    rd /s /q "%EAC_TARGET%" >nul 2>&1
)

mkdir "%EAC_TARGET%" >nul 2>&1

:: Copy toan bo thu muc EAC
robocopy "%EAC_SOURCE%" "%EAC_TARGET%" /E /COPY:DAT /DCOPY:DAT /R:2 /W:1 /NFL /NDL /NJH /NJS /NP >nul 2>&1

set "EAC_COPY_RESULT=!errorlevel!"

:: Robocopy:
:: 0-7 = thanh cong / khong co loi nghiem trong
:: >=8 = loi copy
if !EAC_COPY_RESULT! GEQ 8 (
    echo [EAC] LOI: Copy EasyAntiCheat_EOS that bai. Ma: !EAC_COPY_RESULT!
    goto EAC_CLEANUP
)

:: ============================================================
:: KIEM TRA EAC SAU KHI COPY
:: ============================================================

if not exist "%EAC_TARGET%\" (
    echo.
    echo [EAC] LOI: Khong the cai dat EasyAntiCheat_EOS.
    echo.
    goto EAC_CLEANUP
)

if not exist "%EAC_TARGET%\EasyAntiCheat_EOS_Setup.exe" (
    echo.
    echo [EAC] LOI: Khong tim thay EasyAntiCheat_EOS_Setup.exe sau khi copy.
    echo.
    goto EAC_CLEANUP
)

echo.
echo ============================================================
echo [EAC] EASYANTICHEAT_EOS DA CAI DAT THANH CONG
echo ============================================================
echo.

:: ============================================================
:: DON DEP ZIP + THU MUC TAM
:: ============================================================

:EAC_CLEANUP

echo [EAC] Dang don dep file tam...

:: Xoa ZIP vua tai
if exist "%EAC_ZIP%" (
    del /f /q "%EAC_ZIP%" >nul 2>&1
)

:: Xoa thu muc giai nen tam
if exist "%EAC_EXTRACT%" (
    rd /s /q "%EAC_EXTRACT%" >nul 2>&1
)

echo [EAC] Da xoa file ZIP va thu muc tam.
echo.

:: ============================================================
:: 9. FIX & SYNC WINDOWS TIME
:: ============================================================

echo [9/10] FIX & DONG BO THOI GIAN
echo.

echo [*] Cau hinh Windows Time...

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate' -Name 'Start' -Value 4" >nul 2>&1

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command ^
"Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\w32time\Parameters' -Name 'Type' -Value 'NoSync'" >nul 2>&1

net stop w32time >nul 2>&1
net start w32time >nul 2>&1

echo [*] Sync time.windows.com...

w32tm /config /manualpeerlist:"time.windows.com,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
w32tm /resync /nowait >nul 2>&1

w32tm /query /status | findstr /C:"Stratum" >nul 2>&1

if %errorlevel% neq 0 (

    echo [!] time.windows.com failed.
    echo [*] Trying time.nist.gov...

    w32tm /config /manualpeerlist:"time.nist.gov,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
    w32tm /resync /nowait >nul 2>&1

    w32tm /query /status | findstr /C:"Stratum" >nul 2>&1

    if %errorlevel% neq 0 (

        echo [!] time.nist.gov failed.
        echo [*] Trying pool.ntp.org...

        w32tm /config /manualpeerlist:"pool.ntp.org,0x1" /syncfromflags:manual /reliable:YES /update >nul 2>&1
        w32tm /resync /nowait >nul 2>&1

    )
)

echo [OK] Time synchronization completed.
echo.

:: ============================================================
:: 10. START EVILS
:: ============================================================

echo [10/10] START EVILS
echo.

if exist "%EVILS_EXE%" (

    echo ========================================================
    echo                    HOAN TAT
    echo ========================================================
    echo.
    echo [OK] Clean TEMP
    echo [OK] Clean Windows TEMP
    echo [OK] Clean Prefetch
    echo [OK] Clean CitizenFX
    echo [OK] Reset IP
    echo [OK] Flush DNS
    echo [OK] Detect EVILS
    echo [OK] Defender Folder Exclusion
    echo [OK] Defender EVILS.exe Exclusion
    echo [OK] Clean EVILS Cache
    echo [OK] Clean EVILS Logs
    echo [OK] Clean EVILS Crashes
    echo [OK] DirectX June 2010
    echo [OK] Visual C++ Redistributable x64
    echo [OK] EAC Installation
    echo [OK] Windows Time Sync
    echo.
    echo [*] Dang mo EVILS...
    echo.
    echo ========================================================
    echo.

    start "" "%EVILS_EXE%"

    exit /b 0

) else (

    echo [ERROR] Khong tim thay EVILS.exe:
    echo "%EVILS_EXE%"
    echo.
    pause
    exit /b 1
)