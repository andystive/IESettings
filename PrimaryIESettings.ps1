# 设置主机地址
$IP = "127.0.0.1"

<#
# 添加可信站点（域名）
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\ZoneMap\Domains"
new-item inspur.com/ -Force
set-location inspur.com/
new-itemproperty . -Name * -Value 2 -Type DWORD -Force
new-itemproperty . -Name http -Value 2 -Type DWORD -Force
new-itemproperty . -Name https -Value 2 -Type DWORD -Force
#>

# 添加可信站点（IP）
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges"
new-item range1580/ -Force
set-location range1580/
new-itemproperty . -Name http -Value 2 -Type DWORD -Force
new-itemproperty . -Name :Range -Value $IP -Type String -Force

# 设置刷新策略为每次访问页面时
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
new-itemproperty . -Name SyncMode5 -Value 00000003 -Type DWORD -Force

# 设置可信站点的ActiveX控件
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

# 禁用弹出窗口阻止程序
set-location "HKCU:\Software\Microsoft\Internet Explorer\New Windows"
set-itemproperty . -Name PopupMgr -Value no

# 添加兼容视图
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
将数值转换成16进制写入注册表，可以添加多个地址，之间用","隔开，如:
$hex_string=Get-IECVHex @('inspur.com','neverstop.club')
#>
$hex_string=Get-IECVHex @($IP)
reg add 'HKCU\Software\Microsoft\Internet Explorer\BrowserEmulation\ClearableListData' /v UserFilter /t Reg_BINARY /d $hex_string /f

# 判定系统位数，确定调用32位浏览
if (Test-Path "C:\Windows\SysWOW64")
{
	$IE = "C:\\Program Files (x86)\\Internet Explorer\\iexplore.exe"
}else {
	$IE = "C:\\Program Files\\Internet Explorer\\iexplore.exe"
}

# 创建桌面快捷方式，绑定主机IP地址，打开一卡通
<#
# 方法虽好，但不太适合，默认浏览器容易被换
$Shell=New-Object -ComObject WScript.Shell 
$DesktopPath=[System.Environment]::GetFolderPath('Desktop')
$Shortcut=$shell.CreateShortcut("$DesktopPath\点我打开一卡通.lnk")  
$Shortcut.TargetPath="http://$IP/sinoWeb/jsp/login.jsp"
$Shortcut.Save()
#>

# 还是这样比较好，直接调用32位IE打开网页
$DesktopPath=[System.Environment]::GetFolderPath('Desktop')
$Shortcut = "@`"$IE`" `"http://$IP/sinoWeb/jsp/login.jsp`""
$Shortcut|Out-File -FilePath $DesktopPath\点我打开一卡通.bat -Encoding ASCII


# 调用32位IE浏览器打开系统页面
Start-Process -FilePath $IE -ArgumentList http://$IP/sinoWeb/jsp/login.jsp