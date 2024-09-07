#!/bin/sh

USERNAME=$(uci get seu_net_login.@login[0].username)
PASSWORD=$(uci get seu_net_login.@login[0].password)
INTERFACE=$(uci get seu_net_login.@login[0].interface)
ISP=$(uci get seu_net_login.@login[0].isp)

# 获取选定接口的IP地址
WLAN_USER_IP=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# URL编码用户名和密码
USERNAME_ENCODED=$(echo -n "$USERNAME" | sed 's/+/%2B/g;s/ /%20/g;s/!/%21/g;s/"/%22/g;s/#/%23/g;s/\$/%24/g;s/\&/%26/g;s/'\''/%27/g;s/(/%28/g;s/)/%29/g;s/\*/%2A/g;s/,/%2C/g;s/:/%3A/g;s/;/%3B/g;s/=/%3D/g;s/?/%3F/g;s/@/%40/g;s/\[/%5B/g;s/\]/%5D/g')
PASSWORD_ENCODED=$(echo -n "$PASSWORD" | sed 's/+/%2B/g;s/ /%20/g;s/!/%21/g;s/"/%22/g;s/#/%23/g;s/\$/%24/g;s/\&/%26/g;s/'\''/%27/g;s/(/%28/g;s/)/%29/g;s/\*/%2A/g;s/,/%2C/g;s/:/%3A/g;s/;/%3B/g;s/=/%3D/g;s/?/%3F/g;s/@/%40/g;s/\[/%5B/g;s/\]/%5D/g')

# 根据ISP选择添加后缀
case $ISP in
    edu)
        USER_ACCOUNT="%2C0%2C${USERNAME_ENCODED}"
        ;;
    cmcc)
        USER_ACCOUNT="%2C0%2C${USERNAME_ENCODED}%40cmcc"
        ;;
    telecom)
        USER_ACCOUNT="%2C0%2C${USERNAME_ENCODED}%40telecom"
        ;;
    unicom)
        USER_ACCOUNT="%2C0%2C${USERNAME_ENCODED}%40unicom"
        ;;
    *)
        USER_ACCOUNT="%2C0%2C${USERNAME_ENCODED}"
        ;;
esac

AUTH_URL="https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=${USER_ACCOUNT}&user_password=${PASSWORD_ENCODED}&wlan_user_ip=${WLAN_USER_IP}&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.2&v=3718"

response=$(curl -s "$AUTH_URL")

# 记录日志
echo "$(date): Request URL: $AUTH_URL" >> /tmp/seu_net_login.log
echo "$(date): Response: $response" >> /tmp/seu_net_login.log
echo "----------------------------------------" >> /tmp/seu_net_login.log

echo "$response"