from flask import Blueprint,jsonify
from flask_jwt_extended import jwt_required,get_jwt
from api.database.core import db
from api.database.model import Shop,Manager,Attendant

profile_blueprint=Blueprint(__name__,'profiles',url_prefix='/api/profile')

@profile_blueprint.get('/shop')
@jwt_required()
def shop_details():
    jwt=get_jwt()
    shop_id=jwt['shop_id']
    shop_info=db.session.query(Shop).filter_by(id=shop_id).first()
    if shop_info:
        return jsonify({"shop_name":shop_info.name,
                        "email":shop_info.email,
                        "number":shop_info.number,
                        "address":shop_info.business_address,}),200
    else:
        return jsonify({'msg':'no found'}),400
    
@profile_blueprint.get('/manager')
@jwt_required()
def shop_details():
    jwt=get_jwt()
    shop_id=jwt['shop_id']
    manager_info=db.session.query(Manager).filter_by(id=shop_id).first()
    if manager_info:
        return jsonify({"shop_name":manager_info.name,}),200
    else:
        return jsonify({'msg':'not found'}),400
    
@profile_blueprint.get('/attendant')
@jwt_required()
def shop_details():
    jwt=get_jwt()
    shop_id=jwt['shop_id']
    attendant_info=db.session.query(Manager).filter_by(id=shop_id).first()
    if attendant_info:
        return jsonify({"name":attendant_info.name,}),200
    else:
        return jsonify({'msg':'not found'}),400