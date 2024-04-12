#!/bin/bash
export PRIVATE_IP_LOAD_BALANCER_A="${PRIVATE_IP_LOAD_BALANCER_A}"
export PRIVATE_IP_LOAD_BALANCER_B="${PRIVATE_IP_LOAD_BALANCER_B}"
export PORT_LOAD_BALANCER=="${PORT_LOAD_BALANCER}"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11.8
git init service_aggregator/
cd service_aggregator/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "requirements.txt" >> .git/info/sparse-checkout
echo "service_aggregator/" >> .git/info/sparse-checkout
git pull origin main 
sed -i '/.*certifi.*/d' requirements.txt
sed -i '/.*influxdb-client.*/d' requirements.txt
sed -i '/.*psycopg2-binary.*/d' requirements.txt
sed -i '/.*python-dateutil.*/d' requirements.txt
sed -i '/.*reactivex.*/d' requirements.txt
sed -i '/.*six.*/d' requirements.txt
sed -i '/.*typing_extensions.*/d' requirements.txt
sed -i '/.*urllib3.*/d' requirements.txt
python3.11.8 -m venv env
source env/bin/activate
pip install -r requirements.txt
cd service_aggregator/
python manage.py runserver ${INTERFACE_SERVICE_AGGREGATOR}:${PORT_SERVICE_AGGREGATOR}

