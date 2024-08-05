from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt
from api.database.core import db
from api.database.model import Shop, Manager, Attendant

profile_bp = Blueprint('profile', __name__, url_prefix='/api/profile')

@profile_bp.get('/')
@jwt_required()
def account_details():
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')
    
    if not shop_id:
        return jsonify({'msg': 'Shop ID not found in token'}), 400

    # Query database
    shop = Shop.query.get(shop_id)
    
    if not shop:
        return jsonify({'msg': 'Shop not found'}), 404

    managers = Manager.query.filter_by(shop_id=shop_id).all()
    attendants = Attendant.query.filter_by(shop_id=shop_id).all()

    return jsonify({
        "shop": shop.name,
        "managers": [manager.name for manager in managers],
        "attendants": [attendant.name for attendant in attendants]
    }), 200