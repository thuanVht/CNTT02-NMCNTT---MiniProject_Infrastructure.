@echo off
REM ==========================================================
REM auto_report.bat - Robot loc log GreenTech (Module 2)
REM Chay tu bat ky thu muc nao, script tu chuyen ve thu muc goc du an.
REM AUDIT: script nay khong chua lenh xoa (del, rd, rmdir, format).
REM ==========================================================
cd /d "%~dp0.."

set "LOG=data\log-he-thong.log"
set "REPORT=backup\bao-cao-su-co.txt"

if not exist "%LOG%" (
    echo [LOI] Khong tim thay %LOG%
    goto :end
)
if not exist "backup" mkdir "backup"

REM Tieu de bao cao (echo), ghi noi tiep bang >>
>> "%REPORT%" echo ================================================
>> "%REPORT%" echo BAO CAO SU CO GREENTECH - %date% %time:~0,8%
>> "%REPORT%" echo ================================================

REM Pipe: type doc tung dong, findstr loc dong CRITICAL va ERROR (gom ca ERROR 404, TIMEOUT)
type "%LOG%" | findstr /c:"[CRITICAL]" /c:"[ERROR]" >> "%REPORT%"

REM Dong trong ngan cach giua cac lan chay
>> "%REPORT%" echo.

echo Hoan tat. Ket qua da ghi noi tiep vao %REPORT%

:end
if /i not "%~1"=="/nopause" pause
