#!/bin/bash
cd ~
echo 'export PRIVATE_IP_BUSINESS_DATABASE="10.128.0.59"' >> ~/.profile
echo 'export PORT_BUSINESS_DATABASE="5432"' >> ~/.profile
echo 'export POSTGRESQL_DB_NAME="business_db"' >> ~/.profile
echo 'export POSTGRESQL_DB_USER="badmin_user"' >> ~/.profile
echo 'export POSTGRESQL_DB_PASSWORD="isis2503"' >> ~/.profile
source ~/.profile
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 -y
sed -i '/.*certifi.*/d' requirements.txt
sed -i '/.*charset-normalizer.*/d' requirements.txt
sed -i '/.*idna.*/d' requirements.txt
sed -i '/.*requests.*/d' requirements.txt
sed -i '/.*urllib3.*/d' requirements.txt
python3.11 -m venv env --without-pip
source env/bin/activate
curl https://bootstrap.pypa.io/get-pip.py | python
pip install -r requirements.txt
cd product_manager/
until nc -z ${PRIVATE_IP_BUSINESS_DATABASE} ${PORT_BUSINESS_DATABASE}; do
  echo "Waiting for business database to be reachable..."
  sleep 10
done
echo "Business database is up and running."
python manage.py makemigrations product_manager
python manage.py migrate product_manager
python manage.py runserver ${INTERFACE_PRODUCT_MANAGER}:${PORT_PRODUCT_MANAGER}
