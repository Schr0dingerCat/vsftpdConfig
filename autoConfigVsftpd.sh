#! /bin/bash
####centos下通过yum安装vsftpd、pam、db4(db_load命令)
yum install vsftpd
yum install pam
yum install db4
####vsftpd安装成功后，会在/var目录下创建ftp目录。会自动创建名为ftp的用户和组，虚拟用户的映射用户默认使用ftp，
####如果使用源码安装，则需要执行下列命令：

#tar xzvf vsftpd-xxx.tar.gz
#cd vsftpd-xxx
#make
#make install

#安装完成后，还需要复制相关配置文件到相关系统路径下

#cp vsftpd.conf /etc/vsftpd/
####vsftpd.pam、vsftpd.log名字要与vsftpd.conf里相关设置参数名相同
#cp RedHat/vsftpd.pam /etc/pam.d/vsftpd.pam
#cp RedHat/vsftpd.log	/var/log/
#chown ftp:ftp /var/log/vsftpd.log
#chmod a+w /var/log/vsftpd.log

######备份vsftpd.conf并设置相关配置参数
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
######
#anonymous_enable=NO									//设定不允许匿名访问
#local_enable=YES											//设定本地用户可以访问。注意：主要是为虚拟宿主用户，如果该项目设定为NO那么所有虚拟用户将无法访问.PAM方式此处必须为YES，如果不是将出现如下错误：500 OOPS: vsftpd: both local and anonymous access disabled! 
#write_enable=YES											//设定可以进行写操作
#chmod_enable=NO											//禁止用户通过FTP修改文件或文件夹的权限。（默认值为YES）
#local_umask=022											//设定上传后文件的权限掩码
#anon_upload_enable=NO								//禁止匿名用户上传
#anon_mkdir_write_enable=NO						//禁止匿名用户建立目录
#dirmessage_enable=YES								//设定开启目录标语功能
#connect_from_port_20=YES							//设定端口20进行数据连接
#chown_uploads=NO											//设定禁止上传文件更改宿主
#xferlog_enable=YES										//设定开启日志记录功能
#xferlog_file=/var/log/vsftpd.log			//设定Vsftpd的服务日志保存路径。注意，该文件默认不存在。必须要手动touch出来，并且由于这里更改了Vsftpd的服务宿主用户为手动建立的Vsftpd。必须注意给与该用户对日志的写入权限，否则服务将启动失败。
#xferlog_std_format=YES								//设定日志使用标准的记录格式
#idle_session_timeout=600							//设定空闲连接超时时间，这里使用默认。将具体数值留给每个具体用户具体指定，当然如果不指定的话，还是使用这里的默认值600，单位秒。
#data_connection_timeout=120					//设定单次最大连续传输时间，这里使用默认。将具体数值留给每个具体用户具体指定，当然如果不指定的话，还是使用这里的默认值120，单位秒。
#tcp_wrappers=YES											//设定支持TCP Wrappers
#nopriv_user=vsftpd										//设定支撑Vsftpd服务的宿主用户为手动建立的Vsftpd用户。注意，一旦做出更改宿主用户后，必须注意一起与该服务相关的读写文件的读写赋权问题。比如日志文件就必须给与该用户写入权限等。
#nopriv_user=ftp											//使用默认程序自动创建的ftp用户
#async_abor_enable=YES								//设定支持异步传输功能
#ascii_upload_enable=YES
#ascii_download_enable=YES						//设定支持ASCII模式的上传和下载功能
#ftpd_banner=This Vsftp server supports virtual users ^_^						//设定Vsftpd的登陆标语。
#chroot_local_user=YES								//将本地用户锁定在主目录中，不允许切换到上一级目录中
#chroot_list_enable=NO
#ls_recurse_enable=NO									//禁止用户登陆FTP后使用"ls -R"的命令。该命令会对服务器性能造成巨大开销。如果该项被允许，那么挡多用户同时使用该命令时将会对该服务器造成威胁。
#listen=YES														//设定该Vsftpd服务工作在StandAlone模式下。顺便展开说明一下，所谓StandAlone模式就是该服务拥有自己的守护进程支持，在ps -A命令下我们将可用看到vsftpd的守护进程名。如果不想工作在StandAlone模式下，则可以选择SuperDaemon模式，在该模式下 vsftpd将没有自己的守护进程，而是由超级守护进程Xinetd全权代理，与此同时，Vsftp服务的许多功能将得不到实现。
#pam_service_name=vsftpd.pam					//设定PAM服务下Vsftpd的验证配置文件名,这里与前面源码安装复制的文件名相同，使用yum安装的话，貌似文件名为vsftpd
#####默认Vsftpd.conf中不包含这些设定项目，需要自己手动添加配置。
#guest_enable=YES											//设定启用虚拟用户功能。
#guest_username=ftp										//指定虚拟用户的映射的本地用户。ftp为默认的用户
#virtual_use_local_privs=YES					//设定虚拟用户的权限符合他们的映射本地用户。
#user_config_dir=/etc/vsftpd/vconf		//设定虚拟用户个人Vsftp的配置文件存放路径。也就是说，这个被指定的目录里，将存放每个Vsftp虚拟用户个性的配置文件，一个需要注意的地方就是这些配置文件名必须和虚拟用户名相同
#allow_writeable_chroot=YES						//从2.3.5之后，vsftpd增强了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报该错误。要修复这个错误，可以用命令chmod a-w /home/user去除用户主目录的写权限，注意把目录替换成你自己的。或者你可以在vsftpd的配置文件中增加下列两项中的一项

#pasv_enable=YES 											//建立资料联机采用被动方式，可以不设置，客户端程序需要改为主动
#pasv_min_port=30000 									//建立资料联机所可以使用port 范围的上界，0表示任意。默认值为0。可以不设置 
#pasv_max_port=30999 									//建立资料联机所可以使用port 范围的下界，0表示任意。默认值为0。可以不设置


vi /etc/vsftpd/vsftpd.conf
#对应配置文件设置，创建虚拟用户配置文件存放路径
mkdir /etc/vsftpd/vconf/
#建立了一个虚拟用户名单文件，这个文件就是来记录vsftpd虚拟用户的用户名和口令的数据文件，我这里给它命名为logins.txt。为了避免文件的混乱，我把这个名单文件就放置在/etc/vsftpd/下
#编辑这个虚拟用户名单文件，在其中加入用户的用户名和口令信息。格式很简单：“一行用户名，一行口令”
touch /etc/vsftpd/vconf/logins.txt
vi /etc/vsftpd/vconf/logins.txt				//设置测试虚拟用户test1、test2
#生成虚拟用户数据文件
db_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/vsftpd_login.db
#察看生成的虚拟用户数据文件
ll /etc/vsftpd/vsftpd_login.db
#需要特别注意的是，以后再要添加虚拟用户的时候，只需要按照“一行用户名，一行口令”的格式将新用户名和口令添加进虚拟用户名单文件。但是光这样做还不够，不会生效的哦！还要再执行一遍“ db_load -T -t hash -f 虚拟用户名单文件 虚拟用户数据库文件.db ”的命令使其生效才可以
#设定PAM验证文件，并指定虚拟用户数据库文件进行读取
#察看原来的Vsftp的PAM验证配置文件：文件名与前面对应
cat /etc/pam.d/vsftpd.pam
#备份
cat /etc/pam.d/vsftpd.pam /etc/pam.d/vsftpd.pam.bak
#增加2行，如果系统为64为，则2行中的lib为lib64
echo "auth required /lib64/security/pam_userdb.so db=/etc/vsftpd_login" >> /etc/pam.d/vsftpd.pam
echo "account required /lib64/security/pam_userdb.so db=/etc/vsftpd_login"	>> /etc/pam.d/vsftpd.pam

#设置/var/ftp为虚拟用户的主路径，各个虚拟用户目录在该路径下，该路径下，默认pub为匿名用户目录
mkdir /var/ftp/test1/ /var/ftp/test2/
#更改虚拟用户的主目录的属主为虚拟宿主用户
chown -R ftp:ftp /var/ftp/
#检查权限
ll /var/ftp/
#建立虚拟用户配置文件模版
cp /etc/vsftpd/vsftpd.conf.bak /etc/vsftpd/vconf/vconf.tmp
#定制虚拟用户模版配置文件。这里将原vsftpd.conf配置文件经过简化后保存作为虚拟用户配置文件的模版。这里将并不需要指定太多的配置内容，主要的框架和限制交由 Vsftpd的主配置文件vsftpd.conf来定义，即虚拟用户配置文件当中没有提到的配置项目将参考主配置文件中的设定。而在这里作为虚拟用户的配置文件模版只需要留一些和用户流量控制，访问方式控制的配置项目就可以了。这里的关键项是local_root这个配置，用来指定这个虚拟用户的FTP主路径
vi /etc/vsftpd/vconf/vconf.tmp
#从虚拟用户模版配置文件复制
cp /etc/vsftpd/vconf/vconf.tmp /etc/vsftpd/vconf/test1
#针对具体用户进行定制
#加入local_root这个配置，用来指定这个虚拟用户的FTP主路径
echo "/var/ftp/test1" >> /etc/vsftpd/vconf/test1
#启动服务
systemctl start vsftpd
#设置开机启动
systemctl enable vsftpd
#开启端口
firewall-cmd --zone=public --add-port=21/tcp --permanent
#重启防火墙
firewall-cmd --reload



####centos下vsftpd安装完成后，通过该脚本自动完成对虚拟用户的相关配置及相关目录的所有者和权限
echo "配置开始..."
