# ��ȡ����IP��ַ
Function Get-PrimaryIP
{
	$Nei = ((arp -a|select-string "192.168"|out-string).split(" ")|select-string "192.168"|out-string).Trim()
	$Nei = $Nei.split("`n")
	$Nei|Out-File .\ARP.txt
	$ARP = (Get-Content -Path .\ARP.txt)|Where-Object { $_ -ne '' }
	foreach ($IP in $ARP)
	{
		(new-object Net.Sockets.TcpClient).Connect($IP,3306)
		if ($? -ne 0)
		{
			return $IP
		}
		else
		{
			Continue
		}
	}
}

$IP=Get-PrimaryIP

<#
# ��ӿ���վ�㣨������
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\ZoneMap\Domains"
new-item inspur.com/ -Force
set-location inspur.com/
new-itemproperty . -Name * -Value 2 -Type DWORD -Force
new-itemproperty . -Name http -Value 2 -Type DWORD -Force
new-itemproperty . -Name https -Value 2 -Type DWORD -Force
#>

# ��ӿ���վ�㣨IP��
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges"
new-item range1580/ -Force
set-location range1580/
new-itemproperty . -Name http -Value 2 -Type DWORD -Force
new-itemproperty . -Name :Range -Value $IP -Type String -Force

# ����ˢ�²���Ϊÿ�η���ҳ��ʱ
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
new-itemproperty . -Name SyncMode5 -Value 00000003 -Type DWORD -Force

# ���ÿ���վ���ActiveX�ؼ�
Set-Location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2"
new-itemproperty . -Name 2702 -Value 0 -Type DWORD -Force
new-itemproperty . -Name 1208 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1209 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 2201 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 2000 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 120A -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1001 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1004 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1201 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 120B -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1200 -Value 0 -Type DWORD -Force 
new-itemproperty . -Name 1405 -Value 0 -Type DWORD -Force 

# ���õ���������ֹ����
set-location "HKCU:\Software\Microsoft\Internet Explorer\New Windows"
set-itemproperty . -Name PopupMgr -Value no

# ��Ӽ�����ͼ
Function Get-WebsiteHex(){
	[CmdletBinding()]param(
		[Parameter(Mandatory=$True)]
		[string]$website
	)
	$hex_length=[BitConverter]::ToString([BitConverter]::GetBytes([int16]$website.length)).replace('-','') 
	$hex_data=([System.Text.Encoding]::Unicode.GetBytes($website)|%{"{0:X2}" -f $_}) -join ""
	return "0C000000000000000000000101000000$hex_length$hex_data"
}

Function Get-IECVHex(){
    [CmdletBinding()]param(
        [Parameter(Mandatory=$True)]
        [array]$websites,
		[switch]$ReturnBytes
    )
    $websites|%{$hex_website += Get-WebsiteHex $_}
	$hex_result=("411F00005308ADBA{0}FFFFFFFF01000000{0}$hex_website" -f [BitConverter]::ToString([BitConverter]::GetBytes([int32]$websites.count)).replace('-',''))
	If( $ReturnBytes ){
	    [byte[]]$bytes=@()
		For( $n=0; $n -lt $hex_result.length; $n=$n+2 ){
			$bytes+=([Convert]::ToInt64($hex_result.substring($n,2),16))
		}
		return $bytes # for Set-RegistryValue.ps1 use
	}else{
	   return $hex_result # for reg add use
	}
}
<#
����ֵת����16����д��ע���������Ӷ����ַ��֮����","��������:
$hex_string=Get-IECVHex @('inspur.com','neverstop.club')
#>
$hex_string=Get-IECVHex @($IP)
reg add 'HKCU\Software\Microsoft\Internet Explorer\BrowserEmulation\ClearableListData' /v UserFilter /t Reg_BINARY /d $hex_string /f

# �ж�ϵͳλ����ȷ������32λ���
if (Test-Path "C:\Windows\SysWOW64")
{
	$IE = "C:\\Program Files (x86)\\Internet Explorer\\iexplore.exe"
}else {
	$IE = "C:\\Program Files\\Internet Explorer\\iexplore.exe"
}

# ���������ݷ�ʽ��������IP��ַ����һ��ͨ
<#
# ������ã�����̫�ʺϣ�Ĭ����������ױ���
$Shell=New-Object -ComObject WScript.Shell 
$DesktopPath=[System.Environment]::GetFolderPath('Desktop')
$Shortcut=$shell.CreateShortcut("$DesktopPath\���Ҵ�һ��ͨ.lnk")  
$Shortcut.TargetPath="http://$IP/sinoWeb/jsp/login.jsp"
$Shortcut.Save()
#>

# ���������ȽϺã�ֱ�ӵ���32λIE����ҳ
$DesktopPath=[System.Environment]::GetFolderPath('Desktop')
$Shortcut = "@`"$IE`" `"http://$IP/sinoWeb/jsp/login.jsp`""
$Shortcut|Out-File -FilePath $DesktopPath\���Ҵ�һ��ͨ.bat -Encoding ASCII


# ����32λIE�������ϵͳҳ��
Start-Process -FilePath $IE -ArgumentList http://$IP/sinoWeb/jsp/login.jsp