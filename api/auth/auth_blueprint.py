from flask import Blueprint, request, jsonify
from api.schema.auth_schema import ShopSchema, Login
from api.database.auth_model import Shop, Attendant, Manager,BlockedTokens
from api.database.core import db
from api.auth.email_token import create_token, confirm_token, send_email
from pydantic import ValidationError
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required,get_jwt

authentication_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

"""
Creating shop account
"""

@authentication_bp.post('/register')
def register():
    raw_data= request.get_json()
    try:
        validation_data= ShopSchema(shopName=raw_data['shop_name'],
                              email=raw_data['email'],
                              password=raw_data['password'])
    except ValidationError as e:
        return jsonify({'create shop account entry error':str(e)})
    
    test_email= Shop.query.filter_by(email=validation_data.email).first()
    if test_email is not None and  test_email.isVerified is True:
        return jsonify({"msg":"Email already exists"})
    else:

        #temporarily push to the database
        shop=Shop(shopName=validation_data.shopName,
                  email=validation_data.email,
                  password=generate_password_hash(validation_data.password))
        db.session.add(shop)
        db.session.commit()

        # send email confirmation token
        token=create_token(validation_data.email)
        sol=send_email(validation_data.email,token)
        return jsonify({'msg':sol})


@authentication_bp.post('/confirm')
def confirm():
        token= request.get_json()
        try:
            email=confirm_token(token)
        except:
            return jsonify({'msg':'Token has expired'})
        shop = Shop.query.filter_by(email=email).first()
        #shop_final=Shop(shopName=validation_data.shopName,email=validation_data.email,password=validation_data.password)
        shop.isVerified=True
        db.session.commit()
        return jsonify({'msg':'confirmation success'})
"""
Shop account login
"""
@authentication_bp.post('/loginasshop')
def login():
    raw_data = request.get_json()
    try:
        validation_data = Login(
            email=raw_data['email'],
            password=raw_data['password']
        )
    except ValidationError as e:
        return jsonify({'msg': str(e)}), 400

    user = Shop.query.filter_by(email=validation_data.email).first()
    if user and check_password_hash(user.password, validation_data.password):
        access_token = create_access_token(identity='shop',
                                           additional_claims={'shop_name':user.shopName})
        refresh_token = create_refresh_token(identity='shop',
                                             additional_claims={'shop_name':user.shopName})
        return jsonify({
            'shop_name': user.shopName,
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    return jsonify({'msg': 'Invalid email or password'}), 401

"""
Login as manager
"""
@authentication_bp.post('/loginasmanager')
@jwt_required()
def manager_login():
    raw_data = request.get_json()
    password = raw_data.get('password')
    jwt=get_jwt()
    claims=jwt['additional_claims']
    if not password:
        return jsonify({'msg': 'Password is required'}), 400

    manager = Manager.query.filter_by(password=generate_password_hash(password)).first()
    if manager:
        access_token = create_access_token(identity='manager',additional_claims=claims)
        refresh_token = create_refresh_token(identity='manager',additional_claims=claims)
        return jsonify({
            'user': 'manager',
            'access_token': access_token,
            'refresh_token': refresh_token
        }), 200
    return jsonify({'msg': 'Invalid password'}), 401

"""
Create attendant account
"""
@authentication_bp.post('/attendantaccount')
@jwt_required()
def create_attendant_account():
    raw_data = request.get_json()
    try:
        attendant = Attendant(
            attendantName=raw_data['name'],
            password=generate_password_hash(raw_data['password'])
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
    claims=jwt['additional_claims']
    attendant = Attendant.query.filter_by(attendantName=raw_data['name']).first()
    if attendant and check_password_hash(attendant.password, raw_data['password']):
        access_token = create_access_token(identity='attendant',additional_claims=claims)
        refresh_token = create_refresh_token(identity='attendant',additional_claims=claims)
        return jsonify({
            'username': attendant.attendantName,
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
    blocked= BlockedTokens(token=jti)
    db.session.add(blocked)
    db.session.commit()

    return jsonify({'msg':'Logged out'})

