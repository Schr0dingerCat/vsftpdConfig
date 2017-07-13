# vsftpdConfig
vsftpd安装及虚拟用户设置
vsftpd在centos上的安装、设置及遇到的问题



问题1
  无法连接问题
  1、查看端口是否开放
  
  Centos 7 firewall 命令：
查看已经开放的端口：
firewall-cmd --list-ports
开启端口
firewall-cmd --zone=public --add-port=21/tcp --permanent
命令含义：
–zone #作用域
–add-port=21/tcp #添加端口，格式为：端口/通讯协议
–permanent #永久生效，没有此参数重启后失效
重启防火墙
firewall-cmd --reload #重启firewall
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动

CentOS 7 以下版本 iptables 命令
如要开放80，22，8080 端口，输入以下命令即可
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 22 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
然后保存：
/etc/rc.d/init.d/iptables save

查看打开的端口：
/etc/init.d/iptables status

关闭防火墙 
1） 永久性生效，重启后不会复原
开启： chkconfig iptables on
关闭： chkconfig iptables off

2） 即时生效，重启后复原
开启： service iptables start
关闭： service iptables stop

  2、是否由于selinux开启，可以设置/etc/selinux/config文件里，SELINUX=disable关闭selinux，重启系统

问题2
  553无法上传文件
  1、查看目录的所有者及权限

问题2
  设置好ftp后使用xftp等客户端软件连接时可以连上但是提示如下，无法显示远程文件夹
  1、由于ftp连接模式port模式和pasv模式。设置ftp 链接模式为port (主动模式) ，ftp客户端一般默认使用的pasv (被动模式) 。如果不修改模式，用户链接服务器后，目录一直不能显示。所以要修改为主动模式
  只需将客户端软件ftp连接模式改为主动模式

问题3
    1. 500 OOPS: vsftpd: refusing to run with writable root inside chroot ()  
    从2.3.5之后，vsftpd增强了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报该错误。

 要修复这个错误，可以用命令chmod a-w /home/user去除用户主目录的写权限，注意把目录替换成你自己的。或者你可以在vsftpd的配置文件中增加下列两项中的一项：allow_writeable_chroot=YES
