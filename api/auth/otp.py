from flask import request
import pyotp
import os

totp = pyotp.TOTP("mmyyApprandomStringHere",interval=600)

def generate_otp():
    otp = totp.now()
    return otp

def verify_otp(user_otp):
    totp = pyotp.TOTP("mmyyApprandomStringHere",interval=600)
    return totp.verify(user_otp)

   
      


