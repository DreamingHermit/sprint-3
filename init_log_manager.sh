#!/bin/bash
cd ~
echo 'export PRIVATE_IP_LOG_DATABASE="${PRIVATE_IP_LOG_DATABASE}"' >> ~/.profile
echo 'export PORT_LOG_DATABASE="${PORT_LOG_DATABASE}"' >> ~/.profile
echo 'export LOG_DB_NAME="${LOG_DB_NAME}"' >> ~/.profile
echo 'export LOG_DB_USER="${LOG_DB_USER}"' >> ~/.profile
echo 'export LOG_DB_PASSWORD="${LOG_DB_PASSWORD}"' >> ~/.profile
source ~/.profile
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 -y
git init log_manager/
cd log_manager/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "requirements.txt" >> .git/info/sparse-checkout
echo "log_manager/" >> .git/info/sparse-checkout
git pull origin main 
sed -i '/.*psycopg2-binary.*/d' requirements.txt
python3.11 -m venv env --without-pip
source env/bin/activate
curl https://bootstrap.pypa.io/get-pip.py | python
pip install -r requirements.txt
cd log_manager/
until nc -z ${PRIVATE_IP_LOG_DATABASE} ${PORT_LOG_DATABASE}; do
  echo "Waiting for log database to be reachable..."
  sleep 10
done
echo "Log database is up and running."
python manage.py runserver ${INTERFACE_LOG_MANAGER}:${PORT_LOG_MANAGER}