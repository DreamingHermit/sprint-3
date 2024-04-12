# sprint-2-final

Python 3.11.8 is used

wget --no-cache https://raw.githubusercontent.com/arquisoft-genesis-202401/sprint-2-final/main/set_env_vars.sh.template
wget --no-cache https://raw.githubusercontent.com/arquisoft-genesis-202401/sprint-2-final/main/deployment.yaml.template
Update set_env_vars.sh.template with the real values, store this in set_env_vars.sh
chmod +x set_env_vars.sh
source set_env_vars.sh
gcloud deployment-manager deployments create sprint-2-final-deployment --config deployment.yaml
gcloud deployment-manager deployments delete sprint-2-final-deployment

gcloud deployment-manager deployments update sprint-2-final-deployment --config deployment.yaml
sudo journalctl -u google-startup-scripts.service

