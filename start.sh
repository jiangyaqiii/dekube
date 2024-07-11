#!/bin/bash
##配置代理
export http_proxy=http://$username:$pwd@$url:$port
bash <(curl -sLk https://s.dekube.ai/dekube+client/scripts/DEKUBE_1.0.3.sh)
dekube register $login_key
cd dekube-client
nohup sh start_dekube.sh &
