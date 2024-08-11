#!/bin/bash

# 挂载文件系统为可读写状态
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui
rm -rf /root/home/dropbear
exit
