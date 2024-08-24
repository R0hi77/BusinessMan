from flask import Blueprint, request, jsonify
from api.schema.auth_schema import ShopSchema, Login
from api.database.model import Shop, Attendant, Manager,BlockedTokens
from api.database.core import db
from api.auth.otp import generate_otp,verify_otp
from pydantic import ValidationError
import requests
import os 
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required,get_jwt,decode_token
from flask import session
import uuid
authentication_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

"""
Creating shop account
"""

@authentication_bp.post('/register')
def register():
    raw_data= request.get_json()
    try:
       validation_data = ShopSchema(
           shopName=raw_data['shop_name'],
           number=raw_data['number'],
           password=raw_data['password'],
           email=raw_data['email'],
           business_address=raw_data['business_address']

       )
            
    
    except ValidationError as e:
        return jsonify({'create shop account entry error':str(e)})
    
    test_number= Shop.query.filter_by(number=validation_data.number).first()
    if test_number is not None and  test_number.is_verified is True:
        return jsonify({"msg":"Number already taken use a different"})
    else:

        #temporarily push to the database
        shop=Shop(name=validation_data.shopName,
                  number=validation_data.number,
                  password=generate_password_hash(validation_data.password),
                  email=validation_data.email,
                  business_address=validation_data.business_address)
        db.session.add(shop)
        db.session.commit()
        print(shop.number)

        # send otp
        otp=generate_otp()
        client = requests.Session()
        url = "https://sms.arkesel.com/sms/api"
        params = {
        "action": "send-sms",
        "api_key": 'V1dSaWhlbWFsb3BVc0lISHZZc1A',
        "to": validation_data.number,
        "from": "SaleSmart",
        "sms": f"SaleSmart Business Manager OTP is {otp}"
        }
        try:
            response = client.get(url, params=params)
            response.raise_for_status()
            response_data=response.json()
            session['shop_number']=validation_data.number

            return jsonify ({'msg':"successfully sent",
                             "otp":otp,
                             'response':response_data
                             }),200
            
        except requests.exceptions.RequestException as e:
            db.session.delete(shop)  # Rollback shop creation if OTP sending fails
            db.session.commit()
            return jsonify({"error": "Error occurred while sending OTP", "details": str(e)}), 500
            
            

"""
confirm the OTP
"""
@authentication_bp.post('/confirm')
def confirm():
    try:
        # Get OTP from request
        otp_data = request.get_json()
        print(otp_data)
        if not otp_data:
            return jsonify({'msg': 'OTP data is required'}), 400

        number = otp_data.get('number')
        otp = otp_data.get('otp')
        
        if not number or not otp:
            return jsonify({'msg': 'Both number and OTP are required'}), 400
        
        print(number)
        print(otp)

        # Verify OTP
        if not verify_otp(int(otp)):
            return jsonify({'msg': 'Invalid OTP entered'}), 400

        # Find shop in database
        shop = Shop.query.filter_by(number=number).first()
        if not shop:
            return jsonify({'msg': 'Shop not found'}), 404

        # Update shop verification status
        try:
            shop.is_verified = True
            db.session.commit()
        except Exception as db_err:
            db.session.rollback()
            print(f"Database error during shop verification: {str(db_err)}")
            return jsonify({'msg': 'Failed to verify shop due to a database error'}), 500

        # Send confirmation email
        try:
            mail_client = requests.Session()
            url = 'http://localhost:3000/send-email'
            headers = {"Content-Type": "application/json"}
            payload = {"email": shop.email}
            response = mail_client.post(url=url, headers=headers, json=payload)
            response.raise_for_status()  # Raises an HTTPError for bad responses
        except requests.exceptions.RequestException as e:
            # Log the error, but don't return - we still want to confirm the account
            print(f"Error sending confirmation email: {str(e)}")

        return jsonify({'msg': 'Shop account successfully created and verified'}), 200

    except Exception as e:
        # Log the error for debugging (stack trace can be logged for more detail)
        print(f"Unexpected error in confirm route: {str(e)}")
        return jsonify({'msg': 'An unexpected error occurred'}), 500


"""
resend otp
"""

@authentication_bp.post('/resend')
def resend_otp():
        number=request.get_json('number')

        otp=generate_otp()
        client = requests.Session()
        url = "https://sms.arkesel.com/sms/api"
        params = {
        "action": "send-sms",
        "api_key": 'V1dSaWhlbWFsb3BVc0lISHZZc1A',
        "to": number,
        "from": "SaleSmart",
        "sms": f"SaleSmart Business Manager OTP is {otp}"
        }
        try:
            response = client.get(url, params=params)
            response.raise_for_status()
            response_data=response.json()
            session['shop_number']=number

            return jsonify ({'msg':"successfully sent",
                             "otp":otp,
                             'response':response_data
                             }),200
            
        except requests.exceptions.RequestException as e:
            return jsonify({"error": "Error occurred while sending OTP", "details": str(e)}), 500




"""
Shop account login
"""
@authentication_bp.post('/loginasshop')
def login():
    raw_data = request.get_json()
    # print(raw_data['password'])
    # print(raw_data['number'])
    try:
        validation_data = Login(
            number=raw_data['number'],
            password=raw_data['password']
        )
    except ValidationError as e:
        return jsonify({'msg': str(e)}), 400
    num=validation_data.number
    print(f'this is validation {num}')
    shop = db.session.query(Shop).filter_by(number=num).first()
    
    if shop and check_password_hash(shop.password, validation_data.password):
        session['shop_id'] = shop.id
        claims = {
            "shop_name": shop.name,
            "shop_id": shop.id
        }
        try:
            access_token = create_access_token(identity='shop', additional_claims=claims)
            refresh_token = create_refresh_token(identity='shop', additional_claims=claims)
        except Exception as e:
            return jsonify({'msg': 'Token generation failed', 'error': str(e)}), 500

        return jsonify({
            'shop_id': shop.id,  # Corrected key name
            'shop_name': shop.name,
            'number': shop.number,
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    else:
        return jsonify({'msg': 'Invalid login credentials'}), 401


"""
create manager account

"""
@authentication_bp.post('/createmanager')
@jwt_required()
def set_manager_password():
    data=request.get_json()
    jwt=get_jwt()
    shop_id=jwt['shop_id']

    shop_id = uuid.UUID(shop_id)

    manager = Manager(
        name=data['username'],
        password=generate_password_hash(data['password']),
        shop_id=shop_id
    )
    
    db.session.add(manager)
    db.session.commit()

    return jsonify(
        {
            "id":manager.id,
            "username":manager.name,
        }
    ),200



"""
Login as manager
"""
@authentication_bp.post('/loginasmanager')
@jwt_required()
def manager_login():
    raw_data = request.get_json()
    username=raw_data['username']
    password = raw_data['password']

    jwt = get_jwt()
    claims = jwt.get('additional_claims', {})


    manager = Manager.query.filter_by(name=username).first()
    if manager and check_password_hash(manager.password,password):
        updated_claims={**claims,"manager_id":manager.id}

        access_token = create_access_token(identity='manager',additional_claims=updated_claims)
        refresh_token = create_refresh_token(identity='manager',additional_claims=updated_claims)
        return jsonify({
            'id':manager.id,
            'manager': manager.name,
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    return jsonify({'msg': 'Invalid username or  password'}), 401


"""
Create attendant account
expecting manager id
"""
@authentication_bp.post('/attendantaccount')
@jwt_required()
def create_attendant_account():
    raw_data = request.get_json()
    name=raw_data['name']
    jwt = get_jwt()
    

    shop_id = session.get('shop_id')
    
    claims = jwt.get('additional_claims', {})
    manager_id = jwt['manager_id']
    
    fmanager_id=uuid.UUID(manager_id)
    
    #logging.info(f"shop_id: {shop_id}, manager_id: {manager_id}")
    
    if not shop_id or not manager_id:
        return jsonify({'msg': 'Shop ID or Manager ID is missing'}), 400
    
    try:
        # Create and save the new attendant account
        attendant = Attendant(
            name=name,
            password=generate_password_hash(raw_data['password']),
            shop_id=shop_id,
            manager_id=fmanager_id
        )
        db.session.add(attendant)
        db.session.commit()
        return jsonify({'msg': 'Successfully created attendant'}), 201
    except Exception as e:
        db.session.rollback()
        
        return jsonify({'msg': str(e)}), 500

"""
Login as attendant
"""
@authentication_bp.post('/loginasattendant')
@jwt_required()
def attendant_login():
    raw_data = request.get_json()
    jwt=get_jwt()
    # decoded_token=decode_token(jwt)
    shop_name=jwt.get("shop_name")
   

    attendant = Attendant.query.filter_by(name=raw_data['name']).first()
    if attendant and check_password_hash(attendant.password, raw_data['password']):
        claims = {
            'role': 'attendant',
            'name': attendant.name,
            'shop_id': attendant.shop_id,
            'manager_id': attendant.manager_id,
            'attendant_id': attendant.id,
            'shop_name':shop_name
        }
        print (claims)
        access_token = create_access_token(identity='attendant',additional_claims=claims)
        refresh_token = create_refresh_token(identity='attendant',additional_claims=claims)
        return jsonify({
            'username': attendant.name,
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    return jsonify({'msg': 'Invalid username or password'}), 401

"""
Reset manager account password
"""

@authentication_bp.post('/reset')
@jwt_required()
def manager_reset_pass():
    data = request.get_json()
    old_password = data['old_password']
    new_password = data['new_password']

    if not old_password or not new_password:
        return jsonify({'msg': 'Old password and new password are required'}), 400

    manager = Manager.query.filter_by(password=generate_password_hash(old_password)).first()
    if not manager:
        return jsonify({'msg': 'Old password is incorrect'}), 401

    manager.password = generate_password_hash(new_password)
    db.session.commit()
    return jsonify({'msg': 'Password successfully reset'}), 200


"""
Logout endpoint
try implementing it with the access token revoking approach
"""
@authentication_bp.get('/logout')
@jwt_required()
def logout():
    jwt=get_jwt()
    jti=jwt['jti']
    session.clear()
    blocked= BlockedTokens(token=jti)
    db.session.add(blocked)
    db.session.commit()

    return jsonify({'msg':'Logged out'})

