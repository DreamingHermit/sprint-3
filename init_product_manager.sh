#!/bin/bash
export PRIVATE_IP_BUSINESS_DATABASE="${PRIVATE_IP_BUSINESS_DATABASE}"
export PORT_BUSINESS_DATABASE="${PORT_BUSINESS_DATABASE}"
export POSTGRESQL_DB_NAME="${POSTGRESQL_DB_NAME}"
export POSTGRESQL_DB_USER="${POSTGRESQL_DB_USER}"
export POSTGRESQL_DB_PASSWORD="${POSTGRESQL_DB_PASSWORD}"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 -y
git init product_manager/
cd product_manager/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "requirements.txt" >> .git/info/sparse-checkout
echo "product_manager/" >> .git/info/sparse-checkout
git pull origin main 
sed -i '/.*certifi.*/d' requirements.txt
sed -i '/.*influxdb-client.*/d' requirements.txt
sed -i '/.*python-dateutil.*/d' requirements.txt
sed -i '/.*reactivex.*/d' requirements.txt
sed -i '/.*six.*/d' requirements.txt
sed -i '/.*typing_extensions.*/d' requirements.txt
sed -i '/.*urllib3.*/d' requirements.txt
python3.11 -m venv env --without-pip
source env/bin/activate
curl https://bootstrap.pypa.io/get-pip.py | python
pip install -r requirements.txt
cd product_manager/
python manage.py makemigrations
python manage.py migrate
python manage.py runserver ${INTERFACE_PRODUCT_MANAGER}:${PORT_PRODUCT_MANAGER}