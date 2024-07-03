from flask import Blueprint,request,jsonify
from schema.product_scheme import Product
from pydantic import ValidationError
from flask_jwt_extended import jwt_required,get_jwt
from database.core import db
from database.inventory_model import Inventory
from database.auth_model import Shop

inventory_blueprint= Blueprint("inventory",__name__,url_prefix='api/inventory')


"""
add to inventory
"""

@inventory_blueprint.post('/')
def addproduct():
    raw_data=request.json()
    try:
        validation_data=Product(raw_data['name'],
                                raw_data['category'],
                                raw_data['quantity'],
                                raw_data['batchNumber'],
                                raw_data['orderQuantity'],
                                raw_data['reorderLevel'],
                                raw_data['costPrice'],
                                raw_data['sellingPrice'],
                                raw_data['expiryDate'],
                                raw_data['supplierName'])
    except ValidationError as e:
        return jsonify({'data entry error':str(e)})
    product=Product(name=validation_data.name,
                    category=validation_data.category,
                    quantity=validation_data.quantity,
                    batchNumber=validation_data.batchNumber,
                    orderQuantity=validation_data.orderQuantity,
                    reorderLevel=validation_data.reorderLevel,
                    costPrice=validation_data.costPrice,
                    sellingPrice=validation_data.sellingPrice,
                    expiryDate=validation_data.expiryDate,
                    supplierName=validation_data.supplierName,
                    supplierContact=validation_data.supplierContact
                    )
    db.session.add(product)
    db.session.commit()
    return jsonify({'':''})

"""
get all from inventory
"""
@inventory_blueprint.get('/')
@jwt_required()
def getinventoryList():
    jwt=get_jwt()
    claims=jwt['additional_claims']
    shop_name=claims['shop_name']

    try: 
        inventory_items = db.session.query(Inventory).join(Shop).filter(Shop.name == shop_name).all()
        if inventory_items:
            inventory_list = []
            for item in inventory_items:
                inventory_list.append({
                    "id": item.id,
                    "name": item.name,
                    "category": item.category,
                    "quantity": item.quantity,
                    "batch_number": item.batchNumber,
                    "order_quantity": item.orderQuantity,
                    "reorder_level": item.reorderLevel,
                    "cost_price": item.costPrice,
                    "selling_price": item.sellingPrice,
                    "expiry_date": item.expiryDate.isoformat() if item.expiryDate else None,
                    "supplier_name": item.supplierName,
                    "supplier_contact": item.supplierContact
                })
            
            return jsonify(inventory_list), 200
        else:
            return jsonify({'msg':'No stock added yet'})
    except:
        return jsonify({'msg':"No shop name found in jwt claims"})
    
"""
get single inventory item
"""   
@inventory_blueprint.get('/<int:id>')
@jwt_required()
def get_inventory_by_id(id):
        inventory_item = Inventory.query.filter_by(id=id).first()
        if not inventory_item:
            return jsonify({"msg": "Inventory item not found"}), 404
        inventory_dict = {
            "id": inventory_item.id,
            "product_name": inventory_item.name,
            "category": inventory_item.category,
            "quantity": inventory_item.quantity,
            "batchNumber": inventory_item.batchNumber,
            "orderQuantity": inventory_item.orderQuantity,
            "reorderLevel": inventory_item.reorderLevel,
            "costPrice": inventory_item.costPrice,
            "sellingPrice": inventory_item.sellingPrice,
            "expiryDate": inventory_item.expiryDate.strftime('%Y-%m-%d') if inventory_item.expiryDate else None,
            "supplierName": inventory_item.supplierName,
            "supplierContact": inventory_item.supplierContact,
        }

        return jsonify(inventory_dict), 200

"""
update an entry
"""
@inventory_blueprint.put('/<int:id>')
@jwt_required()
def edit_an_input(id):
    claims = get_jwt()
    shop_name = claims.get('shop_name')

    if not shop_name:
        return jsonify({"msg": "Shop name not found in token"}), 400

    data = request.get_json()
    inventory_item = db.session.query(Inventory).join(Shop).filter(
        Shop.name == shop_name,
        Inventory.id == id
    ).first()
    if not inventory_item:
        return jsonify({"msg": "Inventory item not found or does not belong to your shop"}), 404
    inventory_item.name = data.get('product_name', inventory_item.name)
    inventory_item.category = data.get('category', inventory_item.category)
    inventory_item.quantity = data.get('quantity', inventory_item.quantity)
    inventory_item.batchNumber = data.get('batchNumber', inventory_item.batchNumber)
    inventory_item.orderQuantity = data.get('orderQuantity', inventory_item.orderQuantity)
    inventory_item.reorderLevel = data.get('reorderLevel', inventory_item.reorderLevel)
    inventory_item.CostPrice = data.get('costPrice', inventory_item.CostPrice)
    inventory_item.sellingPrice = data.get('sellingPrice', inventory_item.sellingPrice)
    inventory_item.expiryDate = data.get('expiryDate', inventory_item.expiryDate)
    inventory_item.supplierName = data.get('supplierName', inventory_item.supplierName)
    inventory_item.supplierContact = data.get('supplierContact', inventory_item.supplierContact)

    merged_item = db.session.merge(inventory_item)
    db.session.commit()
    return jsonify({"msg": "updated successfully"}), 200
    

"""
delete an entry
"""
@inventory_blueprint.delete('/<int:id>')
@jwt_required()
def delete_item(id):
      jwt=get_jwt
      claims=jwt['addtional_claims']
      shop_name=claims['shop_name']
      inventory_item = db.session.query(Inventory).join(Shop).filter(
            Shop.shopName == shop_name,
            Inventory.id == id
        ).first()
      if inventory_item:
          db.session.delete(inventory_item)
          db.session.commit()
         
              
         
    
  