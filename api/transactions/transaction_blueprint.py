from flask import Blueprint, request ,jsonify,g,session
from database.model import Transaction,TransactionItem,Shop,Inventory
from database.core import db
from flask_jwt_extended import jwt_required,get_jwt,get_jwt_identity
import uuid
import requests



transaction_bp=Blueprint('transactions',__name__,url_prefix='/api/transaction')


"""
Post transaction details to database
"""
@transaction_bp.post('/')
@jwt_required()
def complete_transact():
    transaction_data= request.json()
    #subtract user mobile money number if momo is transaction type
    number=transaction_data['number']
    #complete transaction with payment gateway

    
    inventory_list= db.session.query(Inventory).join(Shop).filter(
        Shop.id == uuid.UUID(shop_id)).all()
    
    product=transaction_data['items']
   
    # jwt extractions
    jwt=get_jwt()
    shop_id=jwt.get("shop_id")
    g.shop_id=shop_id
    attendant_id=jwt.get('attendant_id')
    #push to the database
    transaction_id=uuid.uuid4()
    transaction=Transaction(id=transaction_id,
                            cash_in=transaction_data['cash in'],
                            payment_type=transaction_data['payment type'],
                            balance=transaction_data['balance'],
                            shop_id=shop_id,
                            attendant_id=attendant_id,
                            completed_by=jwt.get())
    db.session.add(transaction)
    #transaction item
    items=transaction_data['item']
    updated_inventory_list=[]
    for item in items:                        
        transaction_item=TransactionItem(transaction_id=transaction_id,
                                     product_name=item['product_name'],
                                     quantity=item['quantity'],
                                     price_per_item=item['price per item']
                                     )
        db.session.add(transaction_item)

    #update inventory quantity 
    for item in transaction_data['items']:
        for product in inventory_list:
            if product['name'].lower() == item['product_name'].lower():
                product['quantity'] -= item['quantity']
                updated_inventory_list.append(product)
    #update inventory table
    for inv in updated_inventory_list:
        db.session.merge(inv)
    db.session.commit()


    low_stock={}
    for item in inventory_list:
        if item.quantity<=item.reorder_level:
            low_stock[item.name]=item.quantity

    client=requests.Session()
    url = "https://sms.arkesel.com/sms/api"
    params = {
        "action": "send-sms",
        "api_key": 'V1dSaWhlbWFsb3BVc0lISHZZc1A',
        "to": session['shop_number'],
        "from": "SaleSmart",
        "sms": f"Low stock prompt. Take note and restock {low_stock}"
        }
    try:
        response = client.get(url, params=params)
        response.raise_for_status()
        response_data=response.json()
        

        return jsonify ({'msg':"successfully sent",
                             'response':response_data
                             })
            
    except requests.exceptions.RequestException as e:
       
       return jsonify({"error": "Restocking prompt error", "details": str(e)}), 500
            
    


            
   


    

    
    
    return jsonify({'msg':'Transaction complete'})


@transaction_bp.get('/')
@jwt_required()
def all_transactions():

    jwt=get_jwt()
    claims=jwt['additional_claims']
    shop_name=claims['shop_name']

    transactions = db.session.query(Shop).join(Transaction).join(TransactionItem).options(
    joinedload(Shop.transactions).joinedload(Transaction.transaction_items)
).all()
    if transactions:
        transaction_list=[]
        for transaction in transactions:
            transaction_list.append({"id":transaction.id,
                                         "product":transaction.transaction_date,
                                         "cash":transaction.cash_in,
                                         "payment method":transaction.payment_type,
                                         "balance":transaction.balance,
                                         "attendant":transaction.completed_by,
                                         "timestamp":transaction.transaction_id,
                                         "product":transaction.product_name,
                                         "quantity":transaction.quantity,
                                         "price":transaction.price_per_item,})
        return jsonify(transaction_list)
    else:
        return jsonify({'msg':'No transactions available yet'})
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
    




    