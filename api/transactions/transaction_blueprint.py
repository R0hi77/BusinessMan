from flask import Blueprint, request ,jsonify,g,session
from api.database.model import Transaction,TransactionItem,Shop,Inventory
from api.database.core import db
from flask_jwt_extended import jwt_required,get_jwt,get_jwt_identity
import uuid
import requests
from .payments import create_charge
import os
from sqlalchemy.orm import joinedload

transaction_bp=Blueprint('transactions',__name__,url_prefix='/api/transaction')


"""
Post transaction details to database momo
"""
@transaction_bp.post('/')
@jwt_required()
def complete_transact():
    try:
        transaction_data = request.json
        number = transaction_data['number']
        total = transaction_data['cash_in']
        provider = transaction_data['provider']

        jwt = get_jwt()
        shop_id = jwt.get("shop_id")
        g.shop_id = shop_id
        attendant_id = jwt.get('attendant_id')

        with db.session.begin_nested() as nested:
            inventory_list = db.session.query(Inventory).join(Shop).filter(Shop.id == uuid.UUID(shop_id)).all()

            transaction_id = uuid.uuid4()
            transaction = Transaction(
                id=transaction_id,
                cash_in=transaction_data['cash_in'],
                payment_type=transaction_data['payment_type'],
                balance=transaction_data['balance'],
                shop_id=shop_id,
                attendant_id=attendant_id,
                completed_by=jwt.get('identity')
            )
            db.session.add(transaction)

            items = transaction_data['items']
            updated_inventory_list = []

            for item in items:
                transaction_item = TransactionItem(
                    transaction_id=transaction_id,
                    product_name=item['product_name'],
                    quantity=item['quantity'],
                    price_per_item=item['price_per_item']
                )
                db.session.add(transaction_item)

            for item in items:
                for product in inventory_list:
                    if product.name.lower() == item['product_name'].lower():
                        product.quantity -= item['quantity']
                        updated_inventory_list.append(product)

            for inv in updated_inventory_list:
                db.session.merge(inv)

            low_stock = {item.name: item.quantity for item in inventory_list if item.quantity <= item.reorder_level}
            if low_stock:
                client = requests.Session()
                url = "https://sms.arkesel.com/sms/api"
                params = {
                    "action": "send-sms",
                    "api_key": 'V1dSaWhlbWFsb3BVc0lISHZZc1A',
                    "to": session.get('shop_number'),
                    "from": "SaleSmart",
                    "sms": f"Low stock prompt. Take note and restock {low_stock}"
                }
                try:
                    response = client.get(url, params=params)
                    response.raise_for_status()
                    response_data = response.json()
                    return jsonify({'msg': "successfully sent", 'response': response_data})

                except requests.exceptions.RequestException as e:
                    return jsonify({"error": "Restocking prompt error", "details": str(e)}), 500

            # Send OTP via Paystack
            paystack_client = requests.Session()
            payload = {
                "amount": total,
                "email": "pyawinbe@gmail.com",
                "currency": "GHS",
                "mobile_money": {
                    "phone": number,
                    "provider": provider
                }
            }
            headers = {
                "Content-Type": "application/json",
                "Authorization": os.environ.get('PAYSTACK_KEY'),
            }
            try:
                response = paystack_client.post(url='https://api.paystack.co/charge', json=payload, headers=headers)
                response.raise_for_status()
                response_data = response.json()
                nested.commit()  # Commit nested transaction only if OTP is sent successfully
                return jsonify({'msg': "OTP sent successfully", 'response': response_data, 'transaction_id': str(transaction_id)}), 200
            except requests.exceptions.RequestException as e:
                return jsonify({"error": "Error occurred while sending OTP", "details": str(e)}), 500
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Transaction initiation failed", "details": str(e)}), 500
    

@transaction_bp.post('/confirm')
@jwt_required()
def confirm_otp():
    try:
        otp_data = request.json
        transaction_id = otp_data['transaction_id']
        otp_code = otp_data['otp']

        # Verify OTP with Paystack
        paystack_client = requests.Session()
        payload = {
            "transaction_id": transaction_id,
            "otp": otp_code
        }
        headers = {
            "Content-Type": "application/json",
            "Authorization": os.environ.get('PAYSTACK_KEY'),
        }
        try:
            response = paystack_client.post(url='https://api.paystack.co/charge/submit_otp', json=payload, headers=headers)
            response.raise_for_status()
            response_data = response.json()

            # Commit the transaction
            db.session.commit()
            return jsonify({'msg': "Transaction completed successfully", 'response': response_data}), 200
        except requests.exceptions.RequestException as e:
            db.session.rollback()
            return jsonify({"error": "OTP verification failed", "details": str(e)}), 500
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Verification failed", "details": str(e)}), 500
   
   
"""
Get all transaction information
"""

@transaction_bp.get('/')
@jwt_required()
def all_transactions():
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')

    # Query the transactions for the specific shop by shop_id
    transactions = db.session.query(Transaction).filter_by(shop_id=shop_id).options(
        joinedload(Transaction.transaction_items)
    ).all()

    if transactions:
        transaction_list = []
        for transaction in transactions:
            for item in transaction.transaction_items:
                transaction_list.append({
                    "id": transaction.id,
                    "transaction_date": transaction.transaction_date,
                    "cash": transaction.cash_in,
                    "payment_method": transaction.payment_type,
                    "balance": transaction.balance,
                    "attendant": transaction.completed_by,
                    "timestamp": transaction.timestamp,
                    "product": item.product_name,
                    "quantity": item.quantity,
                    "price": item.price_per_item,
                })
        return jsonify(transaction_list)
    else:
        return jsonify({'msg': 'No transactions available yet'})
    


"""
get single transaction from the database
"""
@transaction_bp.get('/<uuid:transaction_id>')
@jwt_required()
def get_transaction_by_id(transaction_id):
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')

    # Query the transaction by transaction_id and ensure it belongs to the shop_id
    transaction = db.session.query(Transaction).filter_by(id=transaction_id, shop_id=shop_id).options(
        joinedload(Transaction.transaction_items)
    ).first()

    if transaction:
        transaction_details = {
            "id": transaction.id,
            "transaction_date": transaction.transaction_date,
            "cash": transaction.cash_in,
            "payment_method": transaction.payment_type,
            "balance": transaction.balance,
            "attendant": transaction.completed_by,
            "timestamp": transaction.timestamp,
            "items": []
        }
        for item in transaction.transaction_items:
            transaction_details["items"].append({
                "product": item.product_name,
                "quantity": item.quantity,
                "price": item.price_per_item,
            })
        return jsonify(transaction_details)
    else:
        return jsonify({'msg': 'Transaction not found'}), 404


"""
delete a transaction record
"""   
# @transaction_bp.delete('/<int:id>')
# @jwt_required()
# def delete_record(id):
#     jwt=get_jwt
#     identity=get_jwt_identity
#     if identity == 'manager':
#         try:
#             transaction=db.session.query(Transaction).join(Shop).filter(Transaction.id==id).first()
#             db.session.delete(transaction)
#             db.session.commit()
        
#         except:
#             return jsonify({'msg':f'No such transaction with id{id} exists'})
#     else:
#         return jsonify({"msg":"You are not authorized to perform this action"}) 
    




    