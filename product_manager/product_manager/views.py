import json, time
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from .models import Application, CardOffer

@require_http_methods(["GET"])
def assess_application(request, application_id):
    try:
        client_info = json.loads(request.body)
        basic_info = client_info.get("basic_info", {})
        economic_info = client_info.get("economic_info", {})
        assessment_result = simulate_viability_engine(basic_info, economic_info)

        if assessment_result["approved"]:
            offers = generate_card_offers(assessment_result)
            result, status = store_offers(application_id, offers)

            if status != 200:
                return JsonResponse(result, status=status)

            return JsonResponse({
                "applicationId": application_id,
                "assessment": assessment_result,
                "storedOffers": offers
            })

        else:
            return JsonResponse({
                "applicationId": application_id,
                "assessment": assessment_result,
                "error": "Application not approved based on the assessment."
            }, status=400)

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON data received."}, status=400)
    except KeyError:
        return JsonResponse({"error": "Required client information is missing."}, status=400)

def store_offers(application_id, offers):
    if not application_id or not offers:
        return {'error': 'Missing required fields or no offers provided'}, 400

    application = Application.objects.get(id=application_id)

    offer_ids = []

    for offer in offers:
        card_type = offer.get('card_type')
        franchise = offer.get('franchise')
        credit_limit = offer.get('credit_limit')
        apr = offer.get('apr')
        rewards = offer.get('rewards')
        annual_fee = offer.get('fees', {}).get("annualFee")

        if not all([card_type, franchise, credit_limit, apr, rewards, annual_fee]):
            continue  # Skip offers with missing fields

        new_offer = CardOffer.objects.create(
            ApplicationID=application,
            CardType=card_type,
            Franchise=franchise,
            CreditLimit=credit_limit,
            APR=apr,
            Rewards=rewards,
            AnnualFee=annual_fee
        )
        offer_ids.append(new_offer.id)

    if not offer_ids:  # No offers were created, likely due to missing fields in all offers
        return {'error': 'No valid offers provided to store'}, 400

    return {'success': True, 'offer_ids': offer_ids}, 200


def simulate_viability_engine(basic_info, economic_info):
    # mock function for the viability API
    time.sleep(0.5)  # Simulate a 100 ms processing delay
    income = float(economic_info.get("Income", 0))
    expenses = float(economic_info.get("Expenses", 0))
    score = (income - expenses) * 0.1
    approved = score > 500  # Simple approval criteria
    return {"score": score, "approved": approved}

def generate_card_offers(assessment_result):
    # Placeholder logic for deciding on card offers based on assessment results
    # This could be enhanced with more sophisticated logic
    if assessment_result["approved"]:
        score = assessment_result["score"]
        if score > 1000:
            offers = [
                {"card_type": "Platinum", "franchise": "Visa", "credit_limit": 15000, "apr": 5.9, "rewards": "3x points on travel", "fees": {"annualFee": 200}},
                {"card_type": "Gold", "franchise": "MasterCard", "credit_limit": 10000, "apr": 7.9, "rewards": "2x points on dining", "fees": {"annualFee": 100}}
            ]
        elif score > 750:
            offers = [
                {"card_type": "Gold", "franchise": "MasterCard", "credit_limit": 10000, "apr": 7.9, "rewards": "2x points on dining", "fees": {"annualFee": 100}}
            ]
        else:
            offers = [
                {"card_type": "Standard", "franchise": "Visa", "credit_limit": 5000, "apr": 10.9, "rewards": "1x points on all purchases", "fees": {"annualFee": 0}}
            ]
        return offers
    return []

def health_check(request):
    return JsonResponse({'message': 'OK'}, status=200)
