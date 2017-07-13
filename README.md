# vsftpdConfig
vsftpd安装及虚拟用户设置
vsftpd在centos上的安装、设置及遇到的问题



问题1
  553无法上传文件
  1、查看目录的所有者及权限
  2、是否由于selinux开启，可以设置/etc/selinux/config文件里，SELINUX=disable关闭selinux，重启系统

问题2
  设置好ftp后使用xftp等客户端软件连接时可以连上但是提示如下，无法显示远程文件夹
  1、由于ftp连接模式port模式和pasv模式。设置ftp 链接模式为port (主动模式) ，ftp客户端一般默认使用的pasv (被动模式) 。如果不修改模式，用户链接服务器后，目录一直不能显示。所以要修改为主动模式
  只需将客户端软件ftp连接模式改为主动模式

问题3
    1. 500 OOPS: vsftpd: refusing to run with writable root inside chroot ()  
    从2.3.5之后，vsftpd增强了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报该错误。

 要修复这个错误，可以用命令chmod a-w /home/user去除用户主目录的写权限，注意把目录替换成你自己的。或者你可以在vsftpd的配置文件中增加下列两项中的一项：allow_writeable_chroot=YES
