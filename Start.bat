@echo off
rem 获取管理员权限
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          #######################################################
echo.          ##                                                   ##
echo.          ##    正在启动系统，请稍等...                          ##
echo.          ##    请勿操作电脑，十分钟后仍未打开系统请联系运维...    ##
echo.          ##    稍安勿躁，祝您生活愉快...                        ##
echo.          ##                                                   ##
echo.          #######################################################

@echo off

goto MySQL
rem 查询系统是否存在jboss服务，判断是否为主机
SC QUERY jboss > NUL
if ERRORLEVEL 1060 (
    echo 未检测到Jboss服务，正在访问系统地址，请稍等...
    goto IESettings
) else (
    echo 检测到Jboss服务，正在启动系统，请稍等...
    goto StartJboss
)

:MySQL
rem 查询MySQL服务是否启动，判断是否为主机
set M_Status=1 
(tasklist|findstr "mysql"||set M_Status=0) >nul
IF %M_Status% EQU 1 (
    echo 未检测到 MySQL 服务，正在访问系统地址，请稍等...
    goto IESetting
) ELSE (
    echo 检测到 MySQL 服务，正在检测 Jboss 服务，请稍等...
    goto StartJboss
)

:StartJboss
rem 检测Jboss服务是否启动
set J_Status=1 
(tasklist|findstr "jboss"||set J_Status=0) >nul
IF %J_Status% EQU 1 (
    echo Jboss 服务未启动，正在启动服务，请稍等...
    net start jboss
    goto IESettings
) ELSE (
    echo Jboss 服务已启动，正在访问系统，请稍等...
    goto IESettings
)

:IESettings
rem 调用powershell脚本，添加可信站点，兼容性视图
call powershell -ExecutionPolicy unrestricted -File .\IESetting.ps1

rem 获取本地ip地址段，然后刷新副机arp表
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.%Three%.%%i >nul

exit