@echo off
rem ��ȡ����ԱȨ��
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          #######################################################
echo.          ##                                                   ##
echo.          ##    ��������ϵͳ�����Ե�...                        ##
echo.          ##    ����������ԣ�ʮ���Ӻ���δ��ϵͳ����ϵ��ά   ##
echo.          ##    �԰����꣬ף��������죡����                   ##
echo.          ##                                                   ##
echo.          #######################################################

@echo off
rem ��ѯϵͳ�Ƿ����jboss�����ж��Ƿ�Ϊ����
SC QUERY jboss > NUL
IF ERRORLEVEL 1060 (
goto IESetting
) else (
goto StartServices
)

:StartServices
rem ����һ��ͨ����
net start mysql >nul
net start jboss >nul

rem ��ȡ����ip��ַ�Σ�Ȼ��ˢ�¸���arp��
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.%Three%.%%i >nul

:IESetting
rem ����powershell�ű�����ӿ���վ�㣬��������ͼ
call powershell -ExecutionPolicy unrestricted -File .\IESetting.ps1 >nul

exit