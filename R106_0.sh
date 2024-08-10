#!/bin/bash

function install_bmd_hosts() {
    echo "获取本机云控地址"
        if [ -z "$(grep rc_host_ip /m_webui/usr/db/custom_data.txt)" ]; then
            echo "文件一不包含云控地址，检测文件二"
            if [ -z "$(grep rc_host_ip /m_data/factor/db/factor_data.txt)" ]; then
                echo "文件二不包含云控地址，跳过"
                install_bmd_sim
            else
                yunkongn=$(sed -n 's/^rc_host_ip=\(.*\)/\1/p' /m_data/factor/db/factor_data.txt)
                   if grep -q "$yunkongn" /etc/hosts; then
                       echo "文件二中的云控屏蔽过了，跳过"
                       install_bmd_sim
                   else
                       echo "127.0.0.1 $yunkongn" >> /etc/hosts
                       echo "已通过文件二屏蔽云控，执行重启"
                       reboot
                   fi
            fi
        else
            yunkongn=$(sed -n 's/^rc_host_ip=\(.*\)/\1/p' /m_webui/usr/db/custom_data.txt)
            if grep -q "$yunkongn" /etc/hosts; then
                echo "文件一中的云控屏蔽过了，跳过"
                install_bmd_sim
            else
                echo "127.0.0.1 $yunkongn" >> /etc/hosts
                echo "已通过文件一屏蔽云控，执行重启"
                reboot
            fi    
        fi
    install_bmd_sim
}

function install_bmd_sim() {
    echo "关闭自动切卡"
        # 检测切卡配置存放位置1
        if [ -z "$(grep mnet_sim_switch=on /m_webui/usr/db/custom_data.txt)" ]; then
            echo "文件1不包含自动切卡，检测另一个文件"
            # 检测切卡配置存放位置2
            if [ -z "$(grep mnet_sim_switch=on /m_data/factor/db/factor_data.txt)" ]; then
              echo "文件2不包含自动切卡，检测另一个文件"
                 # 检测切卡配置存放位置3
                 if [ -z "$(grep mnet_sim_switch=on /m_webui/usr/db/custom_data_256.txt)" ]; then
                    echo "文件3也不包含自动切卡或文件不存在，跳过"
                    install_bmd_wifi
               else
                    sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_256.txt
                    sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_257.txt
                    sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_258.txt
                    sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_260.txt
                    sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_256.txt
                    sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_257.txt
                    sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_258.txt
                    sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_260.txt
                    echo "文件3成功关闭自动切卡"
                    install_bmd_wifi
                fi
            else
                sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_data/factor/db/factor_data.txt
                sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_data/factor/db/factor_data.txt
                sed -i 's/mnet_sim_polling=on/mnet_sim_polling=off/' /m_data/factor/db/factor_data.txt
                echo "文件2成功关闭自动切卡"
                install_bmd_wifi
            fi
        else    
            sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data.txt
            sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data.txt
            sed -i 's/mnet_sim_polling=on/mnet_sim_polling=off/' /m_webui/usr/db/custom_data.txt
            sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_256.txt
            sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_257.txt
            sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_258.txt
            sed -i 's/mnet_sim_switch=on/mnet_sim_switch=off/' /m_webui/usr/db/custom_data_260.txt
            sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_256.txt
            sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_257.txt
            sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_258.txt
            sed -i 's/mnet_sim_slot=2/mnet_sim_slot=1/' /m_webui/usr/db/custom_data_260.txt
            echo "文件1成功关闭自动切卡"
            install_bmd_wifi
        fi
}


function install_bmd_wifi() {
    echo "修改wifi最大连接数量为32"
        if [ -z "$(grep wifi_max_client_range_0=8 /m_webui/usr/db/custom_data.txt)" ]; then
            echo "指令一不存在8，检测16"
            if [ -z "$(grep wifi_max_client_range_0=16 /m_webui/usr/db/custom_data.txt)" ]; then
               echo "指令一不存在16，检测指令二"
               if [ -z "$(grep wifi_max_client_0=8 /m_webui/usr/db/custom_data.txt)" ]; then
                  echo "指令二不存在8，检测16"
                  if [ -z "$(grep wifi_max_client_0=16 /m_webui/usr/db/custom_data.txt)" ]; then
                      echo "指令二不存在16，跳过"
                      install_bmd_gjwebui
                  else
                      sed -i 's/wifi_max_client_0=16/wifi_max_client_0=32/' /m_webui/usr/db/custom_data.txt
                      sed -i 's/wifi_max_client_1=16/wifi_max_client_1=32/' /m_webui/usr/db/custom_data.txt
                      echo "指令二成功将16改成32"
                      reboot
                      install_bmd_gjwebui
                  fi
               else
                   sed -i 's/wifi_max_client_0=8/wifi_max_client_0=32/' /m_webui/usr/db/custom_data.txt
                   sed -i 's/wifi_max_client_1=8/wifi_max_client_1=32/' /m_webui/usr/db/custom_data.txt
                   echo "代指令二成功将8改成32"
                   reboot
                   install_bmd_gjwebui
               fi
            else
                sed -i 's/wifi_max_client_range_0=16/wifi_max_client_range_0=32/' /m_webui/usr/db/custom_data.txt
                sed -i 's/wifi_max_client_range_1=16/wifi_max_client_range_1=32/' /m_webui/usr/db/custom_data.txt
                echo "指令一成功将16改成32"
                reboot
                install_bmd_gjwebui
            fi
        else  
            sed -i 's/wifi_max_client_range_0=8/wifi_max_client_range_0=32/' /m_webui/usr/db/custom_data.txt
            sed -i 's/wifi_max_client_range_1=8/wifi_max_client_range_1=32/' /m_webui/usr/db/custom_data.txt
            echo "指令一成功将8改成32"
            reboot
            install_bmd_gjwebui  
        fi
}

function install_bmd_gjwebui() {
    echo "检测8080后台是否存在"
      if [ -f /home/root/8080/8080.sh ]; then
        echo "8080文件完整"
        install_bmd_webui
      else
        echo "8080不存在开始下载"
        wget -O 8080.tar "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/8080/8080.tar"
           if [ -f 8080.tar ]; then
              echo "8080下载完成，执行文件"
              tar xvf 8080.tar
              cp -r /tmp/8080/ /home/root/
              rm 8080.tar
              rm -rf /tmp/8080
              reboot
            else
              echo "8080下载失败"
              install_bmd_webui
           fi
      fi
}
function install_bmd_webui() {
    echo "检测webui后台版本"
if [ -z "$(cat /m_webui/webui/html/deviceinfo.html | grep 3.3.5)" ]; then
      wget -O webui.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/webui.zip"
      if [ -f webui.zip ]; then
        echo "下载完成，执行文件"
        unzip webui.zip
        cp -r webui /m_webui/
        cp -r index.html /home/root/8080/dist/
        rm webui.zip
        rm index.html
        rm -rf webui 
        install_fbmd_ssh
      else
        echo "下载失败"
        install_fbmd_ssh
      fi
else
   echo "已经是最新版webui后台"
   install_fbmd_ssh
fi
}

function install_fbmd_ssh() {
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
            install_bmd_exit
         fi
    else
      echo "已经存在ssh了"
      install_bmd_exit
fi
}

# 退出脚本
function install_bmd_exit() {
   rm -rf smssn.txt
   rm -rf xxsn.txt
   rm -rf hostssn.txt
   rm -rf sn_yun.txt
   rm -rf ttydsn.txt
   rm -rf R106_0.sh
   rm "$0"
   exit 
}

# ----------------------------------根据条件调用函数-----------------------------------------------------
cd /tmp/
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui
echo "运行白名单"
install_bmd_hosts
exit 0