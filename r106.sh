#!/bin/bash

# 挂载文件系统为可读写状态
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui
#函数
cd /tmp/
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui
#开启ssh
    if [ -z "$(cat /etc/init.d/hostname.sh | grep sshd.sh)" ]; then
      echo -e "root\nroot" | passwd root
      wget -O ssh.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/ssh/ssh.zip"
         if [ -f ssh.zip ]; then
            echo "下载完成，执行文件"
            rm /etc/init.d/R106.sh
            rm /etc/init.d/r106.sh
            rm -rf /home/root/forward
            rm /home/root/ssh.sh
            rm /home/root/sn.txt
            rm /home/root/R106.sh
            rm /home/root/r106.sh
            sed -i '/R106/d' /etc/init.d/hostname.sh
            sed -i '/R106/d' /etc/rcS.d/S39hostname.sh
            unzip ssh.zip
            tar xvf ssh.tar
            rm ssh.zip
            rm ssh.tar
            cp -r dropbear /home/root/
            chmod 777 ssh.sh
            bash /tmp/ssh.sh start &
            install_bmd_exit
         else
            echo "下载失败"
            exit
         fi
