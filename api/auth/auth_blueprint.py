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
           password=raw_data['password']
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
                  password=generate_password_hash(validation_data.password))
        db.session.add(shop)
        db.session.commit()

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
        otp=request.get_json()
        shop_number=session['shop_number']
        otp_data=otp['otp']
        
        status=verify_otp(int(otp_data))
        print(otp_data)
        print (status)
        if status:
            shop=Shop.query.filter_by(number=shop_number).first()
            if shop:
                shop.is_verified=True
                db.session.commit()
                return jsonify({'msg':'Shop account succesfully created'}),200
            else:
                return jsonify({'msg':'Shop number not found'})
        else:
            return jsonify({'msg':'Invalid OTP entered'}),400






"""
Shop account login
"""
@authentication_bp.post('/loginasshop')
def login():
    raw_data = request.get_json()
    try:
        validation_data = Login(
            number=raw_data['number'],
            password=raw_data['password']
        )
    except ValidationError as e:
        return jsonify({'msg': str(e)}), 400

    shop = Shop.query.filter_by(number=validation_data.number).first()
    if shop and check_password_hash(shop.password, validation_data.password):
        session['shop_id']=shop.id

        claims={"shop_name":shop.name,
                "shop_id":shop.id}
        access_token = create_access_token(identity='shop',
                                           additional_claims=claims)
        refresh_token = create_refresh_token(identity='shop',
                                             additional_claims=claims)
        return jsonify({
            'shop  id':shop.id,
            'shop_name': shop.name,
            'number':shop.number,
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    
    else:
        return jsonify({'msg': 'Invalid log in credentials'}), 401


"""
create manager account

"""
@authentication_bp.post('/createmanager')
def set_manager_password():
    data=request.get_json()
    shop_id=session['shop_id']
    manager=Manager(name=data['username'],
        password=generate_password_hash(data['password']),
                    shop_id=shop_id)
    
    db.session.add(manager)
    db.session.commit()

    return jsonify(
        {
            "id":manager.id,
            "username":manager.name,
        }
    )



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

