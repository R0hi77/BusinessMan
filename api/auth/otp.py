from flask import request
import pyotp
import os

totp = pyotp.TOTP("mmyyApprandomStringHere",interval=300)

def generate_otp():
    otp = totp.now()
    return otp

def verify_otp(user_otp):
    totp = pyotp.TOTP("mmyyApprandomStringHere",interval=300)
    return totp.verify(user_otp)

   
      


