#!/bin/bash

# 挂载文件系统为可读写状态
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui
mount -o remount,rw /root/home

cd /tmp/

unzip ssh.zip
rm ssh.zip
cp -r dropbear /home/root/
chmod 777 /dropbear/script/start-sshd.sh
bash /dropbear/script/start-sshd.sh start &