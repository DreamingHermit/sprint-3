#!/bin/bash
# TODO Service Aggregator
echo 'export PRIVATE_IP_SERVICE_AGGREGATOR_A="${PRIVATE_IP_SERVICE_AGGREGATOR_A}"' >> ~/.profile
echo 'export PRIVATE_IP_SERVICE_AGGREGATOR_B="${PRIVATE_IP_SERVICE_AGGREGATOR_B}"' >> ~/.profile
echo 'export PORT_SERVICE_AGGREGATOR="${PORT_SERVICE_AGGREGATOR}"' >> ~/.profile
#
echo 'export PRIVATE_IP_PRODUCT_MANAGER_A="${PRIVATE_IP_PRODUCT_MANAGER_A}"' >> ~/.profile
echo 'export PRIVATE_IP_PRODUCT_MANAGER_B="${PRIVATE_IP_PRODUCT_MANAGER_B}"' >> ~/.profile
echo 'export PORT_PRODUCT_MANAGER="${PORT_PRODUCT_MANAGER}"' >> ~/.profile
echo 'export PRIVATE_IP_LOG_MANAGER_A="${PRIVATE_IP_LOG_MANAGER_A}"' >> ~/.profile
echo 'export PRIVATE_IP_LOG_MANAGER_B="${PRIVATE_IP_LOG_MANAGER_B}"' >> ~/.profile
echo 'export PORT_LOG_MANAGER="${PORT_LOG_MANAGER}"' >> ~/.profile
source ~/.profile
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker --version
git init kong_api_gateway/
cd kong_api_gateway/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "kong.yaml.template" >> .git/info/sparse-checkout
git pull origin main
envsubst < kong.yaml.template > kong.yml
sudo docker network create kong-net
sudo docker run -d --name kong --network=kong-net -v "$(pwd):/kong/declarative/" -e "KONG_DATABASE=off" -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_LISTEN=${INTERFACE_KONG_API_GATEWAY}:${PORT_ADMIN_API_KONG_API_GATEWAY}" -e "KONG_ADMIN_GUI_URL=http://localhost:${PORT_ADMIN_GUI_KONG_API_GATEWAY}" -p ${PORT_DEFAULT_KONG_API_GATEWAY}:${PORT_DEFAULT_KONG_API_GATEWAY} -p ${PORT_ADMIN_API_KONG_API_GATEWAY}:${PORT_ADMIN_API_KONG_API_GATEWAY} -p ${PORT_ADMIN_GUI_KONG_API_GATEWAY}:${PORT_ADMIN_GUI_KONG_API_GATEWAY} kong/kong-gateway:2.7.2.0-alpine
docker ps