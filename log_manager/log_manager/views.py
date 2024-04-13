import json
from datetime import datetime
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
from .settings import INFLUXDB_CONFIG 
from datetime import datetime, timezone


client = InfluxDBClient(url=INFLUXDB_CONFIG['url'], token=INFLUXDB_CONFIG['token'], org=INFLUXDB_CONFIG['org'])
write_api = client.write_api(write_options=SYNCHRONOUS)

@require_http_methods(["POST"])
def log_event(request):
    try:
        data = json.loads(request.body.decode('utf-8'))
        application_id = data['application_id']
        application_status = data['application_status']

        point = Point("log").tag("application_id", application_id).field("application_status", application_status).time(datetime.now(timezone.utc), WritePrecision.MS)
        write_api.write(bucket=INFLUXDB_CONFIG['bucket'], record=point)

        return JsonResponse({"status": "success", "message": "Log stored successfully."}, status=201)
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON data received."}, status=400)
    except KeyError as e:
        return JsonResponse({"error": f"Missing field: {str(e)}"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
