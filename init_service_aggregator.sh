#!/bin/bash
cd ~
echo 'export PRIVATE_IP_LOAD_BALANCER_A="${PRIVATE_IP_LOAD_BALANCER_A}"' >> ~/.profile
echo 'export PRIVATE_IP_LOAD_BALANCER_B="${PRIVATE_IP_LOAD_BALANCER_B}"' >> ~/.profile
echo 'export PORT_LOAD_BALANCER="${PORT_LOAD_BALANCER}"' >> ~/.profile  
source ~/.profile
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 -y
git init service_aggregator/
cd service_aggregator/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "requirements.txt" >> .git/info/sparse-checkout
echo "service_aggregator/" >> .git/info/sparse-checkout
git pull origin main 
sed -i '/.*psycopg2-binary.*/d' requirements.txt
python3.11 -m venv env --without-pip
source env/bin/activate
curl https://bootstrap.pypa.io/get-pip.py | python
pip install -r requirements.txt
cd service_aggregator/
python manage.py runserver ${INTERFACE_SERVICE_AGGREGATOR}:${PORT_SERVICE_AGGREGATOR}

