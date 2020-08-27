# Script
## 脚本实现的功能
1. 通过检测MySQL进程及Jboss服务确定当前电脑是否为主机；
2. 主机则执行主机脚本，副机则执行副机脚本；
3. 通过ping局域网ip的方式来刷新电脑arp缓存；
4. 通过判断3306端口是否开启来确定主机ip地址；
5. 将主机ip地址添加可信站点及兼容性视图；
6. 设置刷新策略为每次访问页面时；
7. 设置可信站点的ActiveX控件为启用；
8. 禁用弹出窗口阻止程序；
9. 生成桌面bat文件，方便快捷访问主机网页。
### 注意事项
1. 调用powershell时360会拦截，需要勾选不再提示且允许；
2. 更改注册表键值时360会拦截，需要勾选不再提示且始终允许该程序操作；
3. 当前局域网ip地址前默认为192.168.x.x；
4. 主辅机脚本为powershell脚本，当前路径为了绕过杀软及后期更好的扩展脚本作用。
```
https://monitor.neverstop.club/Leo/PrimaryIESettings.ps1
https://monitor.neverstop.club/Leo/IESettings.ps1 
```
