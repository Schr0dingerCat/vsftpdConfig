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
  
