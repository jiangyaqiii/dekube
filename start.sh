#!/bin/bash

bash <(curl -sLk https://s.dekube.ai/dekube+client/scripts/DEKUBE_1.0.3.sh)
dekube register $login_key
cd dekube-client
./start_dekube.sh
