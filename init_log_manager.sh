#!/bin/bash
export PRIVATE_IP_LOG_DATABASE="${PRIVATE_IP_LOG_DATABASE}"
export PORT_LOG_DATABASE="${PORT_LOG_DATABASE}"
export LOG_DB_NAME="${LOG_DB_NAME}"
export LOG_DB_USER="${LOG_DB_USER}"
export LOG_DB_PASSWORD="${LOG_DB_PASSWORD}"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11.8
git init log_manager/
cd log_manager/
git remote add -f origin https://github.com/arquisoft-genesis-202401/sprint-2-final.git
git config core.sparseCheckout true
echo "requirements.txt" >> .git/info/sparse-checkout
echo "log_manager/" >> .git/info/sparse-checkout
git pull origin main 
sed -i '/.*psycopg2-binary.*/d' requirements.txt
python3.11.8 -m venv env
source env/bin/activate
pip install -r requirements.txt
cd log_manager/
python manage.py runserver ${INTERFACE_LOG_MANAGER}:${PORT_LOG_MANAGER}