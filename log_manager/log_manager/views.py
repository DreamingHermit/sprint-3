import json
import requests
from datetime import datetime
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from .settings import INFLUXDB_CONFIG 
from datetime import datetime, timezone

@require_http_methods(["POST"])
def log_event(request):
    try:
        data = json.loads(request.body.decode('utf-8'))
        application_id = data.get('application_id')
        application_status = data.get('application_status')

        if application_id is None or application_status is None:
            return JsonResponse({'error': 'Missing application_id or application_status'}, status=400)

        INFLUXDB_URL = f"{INFLUXDB_CONFIG['host']}/write?db={INFLUXDB_CONFIG['database']}"
        
        # Get current UTC time in ISO 8601 format
        current_time = datetime.now(timezone.utc).isoformat()
        
        # Prepare the data
        influx_data = f'app_status,application_id={application_id} application_status="{application_status}" {current_time}'

        # Make the POST request
        response = requests.post(INFLUXDB_URL, data=influx_data, auth=(INFLUXDB_CONFIG['username'], INFLUXDB_CONFIG['password']))

        if response.status_code == 204:
            return JsonResponse({'message': 'Log entry inserted successfully.'})
        else:
            return JsonResponse({'error': 'Failed to insert log entry', 'details': str(response.content)}, status=500)

    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    except Exception as e:
        return JsonResponse({'error': 'Server error', 'details': str(e)}, status=500)