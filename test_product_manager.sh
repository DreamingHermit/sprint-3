curl -X GET -H "Content-Type: application/json" -d '{
    "basic_info": {
        "FirstName": "John",
        "LastName": "Doe",
        "Country": "CountryX",
        "State": "StateY",
        "City": "CityZ",
        "MobileNumber": "1234567890",
        "Email": "john.doe@example.com"
    },
    "economic_info": {
        "Profession": "Software Developer",
        "EconomicActivity": "Software",
        "CompanyName": "Company Inc.",
        "PositionInCompany": "Senior Developer",
        "CompanyContact": "123-456-7890",
        "Income": 50000,
        "Expenses": 2000,
        "Assets": 15000,
        "Liabilities": 5000,
        "NetWorth": 10000,
        "FullAddress": "123 Main St, CityZ, StateY, CountryX"
    }
}' "http://0.0.0.0:8080/assess-application/1/"