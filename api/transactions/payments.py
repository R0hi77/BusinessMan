import requests
from flask import jsonify

def create_charge(charge,number, provider,KEY):
    paystack_client=requests.Session()
    payload={"amount": charge,

    "email": "pyawinbe@gmail.com",
    "currency": "GHS",
    "mobile_money": {
    "phone" : number,
    "provider" : provider
    }
    }
    headers = {
    "Content-Type": "application/json",
    "Authorization": KEY,
    }
    try:
        response=paystack_client.post(url='https://api.paystack.co/charge',params=payload,headers=headers)
        response.raise_for_status()
        response_data=response.json()
        return jsonify ({'msg':"successfully sent",
                             'response':response_data
                             }),200
    except requests.exceptions.RequestException as e:
        return jsonify({"error": "Error occurred while sending OTP", "details": str(e)}),500
