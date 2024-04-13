# Sprint 2 Final

## Overview
This document outlines the steps for deploying Sprint 2 Final using Python 3.11.8.

## Deployment Instructions
1. Download the necessary templates:
    ```bash
    wget --no-cache https://raw.githubusercontent.com/arquisoft-genesis-202401/sprint-2-final/main/set_env_vars.sh.template
    wget --no-cache https://raw.githubusercontent.com/arquisoft-genesis-202401/sprint-2-final/main/deployment.yaml.template
    ```

2. Update `set_env_vars.sh.template` with the real values and save it as `set_env_vars.sh`.

3. Grant execution permission to the script:
    ```bash
    chmod +x set_env_vars.sh
    ```

4. Source the environment variables:
    ```bash
    source set_env_vars.sh
    ```

5. Create the deployment using `gcloud deployment-manager`:
    ```bash
    gcloud deployment-manager deployments create sprint-2-final-deployment --config deployment.yaml
    ```

6. To delete the deployment, run:
    ```bash
    gcloud deployment-manager deployments delete sprint-2-final-deployment
    ```

7. To update the deployment configuration, use:
    ```bash
    gcloud deployment-manager deployments update sprint-2-final-deployment --config deployment.yaml
    ```

## Additional Steps (Optional)
- View startup logs using:
    ```bash
    sudo journalctl -u google-startup-scripts.service
    ```
- Log in into the business database:
    ```bash
    psql -U <db_user> -d <db_name> --password
    ```
- Query the logs:
    ```bash
    influx -database '<db_name>' -execute "SELECT * FROM <measurements>"
    ```



