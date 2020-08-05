@echo off
rem 获取管理员权限
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          #######################################################
echo.          ##                                                   ##
echo.          ##    正在启动系统，请稍等...                        ##
echo.          ##    请勿操作电脑，十分钟后仍未打开系统请联系运维   ##
echo.          ##    稍安勿躁，祝您生活愉快！！！                   ##
echo.          ##                                                   ##
echo.          #######################################################

@echo off
rem 查询系统是否存在jboss服务，判断是否为主机
SC QUERY jboss > NUL
IF ERRORLEVEL 1060 (
goto IESetting
) else (
goto StartServices
)

:StartServices
rem 启动一卡通服务
net start mysql >nul
net start jboss >nul

rem 获取本地ip地址段，然后刷新副机arp表
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.%Three%.%%i >nul

:IESetting
rem 调用powershell脚本，添加可信站点，兼容性视图
call powershell -ExecutionPolicy unrestricted -File .\IESetting.ps1 >nul

exit