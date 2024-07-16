from flask import Blueprint,request,jsonify
from api.schema.product_scheme import Product
from pydantic import ValidationError
from flask_jwt_extended import jwt_required,get_jwt
from api.database.core import db
from api.database.model import Inventory
from api.database.model import Shop
import uuid
from datetime import datetime
inventory_blueprint= Blueprint("inventory",__name__,url_prefix='/api/inventory')


"""
add to inventory
"""

@inventory_blueprint.post('/')
@jwt_required()
def addproduct():
    raw_data=request.get_json()
    try:
        validation_data=Product(name=raw_data['name'],
                                category=raw_data['category'],
                               quantity= raw_data['quantity'],
                                batchNumber=raw_data['batch number'],
                                orderQuantity=raw_data['order quantity'],
                               reorderLevel= raw_data['reorder level'],
                                costPrice=raw_data['cost price'],
                                sellingPrice=raw_data['selling price'],
                                expiryDate=raw_data['expiry date'],
                                supplierName=raw_data['supplier name'])
    except ValidationError as e:
        return jsonify({'data entry error':str(e)})
    jwt=get_jwt()
    
    shop_id=jwt.get('shop_id')
    attendant_id=jwt.get('shop_id')
    manager_id=jwt.get('shop_id')
    # claims={"shop":shop_id,
    #         "attendant":attendant_id,
    #         "manager":manager_id}
   
        
    product=Inventory(name=validation_data.name,
                    category=validation_data.category,
                    quantity=validation_data.quantity,
                    batch_number=validation_data.batchNumber,
                    order_quantity=validation_data.orderQuantity,
                    reorder_level=validation_data.reorderLevel,
                    cost_price=validation_data.costPrice,
                    selling_price=validation_data.sellingPrice,
                    expiry_date=validation_data.expiryDate,
                    supplier_name=validation_data.supplierName,
                    supplier_contact=validation_data.supplierContact,
                    shop_id=uuid.UUID(shop_id),
                    attendant_id=uuid.UUID(attendant_id)
                    )
    db.session.add(product)
    db.session.commit()
    return jsonify({'id':product.id,
                    "name":product.name,
                    "category":product.category,
                    "quantity":product.quantity,
                    "order quantity":product.order_quantity,
                    "reorder level":product.reorder_level,
                    "cost price":product.cost_price,
                    "selling price":product.selling_price,
                    "supplier name":product.supplier_name,
                    "supplier contact":product.supplier_contact
                    })

"""
get all from inventory
"""

@inventory_blueprint.get('/')
@jwt_required()
def getinventoryList():
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')
    print(shop_id)

    if shop_id is None:
        return jsonify({'msg': "No shop id found in JWT claims"}), 400

    try:
        # Fetch all inventory items for the specific shop
        inventory_items = db.session.query(Inventory).join(Shop).filter(Inventory.shop_id == uuid.UUID(shop_id)).all()
        
        if inventory_items:
            inventory_list = []
            counter=1
            for item in inventory_items:
                inventory_list.append({
                    "count":counter,
                    "id": item.id,
                    "name": item.name,
                    "category": item.category,
                    "quantity": item.quantity,
                    "batch_number": item.batch_number,
                    "order_quantity": item.order_quantity,
                    "reorder_level": item.reorder_level,
                    "cost_price": item.cost_price,
                    "selling_price": item.selling_price,
                    "expiry_date": item.expiry_date,
                    "supplier_name": item.supplier_name,
                    "supplier_contact": item.supplier_contact
                })
                counter+=1
            return jsonify(inventory_list), 200
        else:
            return jsonify({'msg': 'No stock added yet'}), 404
    except Exception as e:
        return jsonify({'msg': f"An error occurred: {str(e)}"}), 500

    
"""
get single inventory item
"""   
@inventory_blueprint.get('/<uuid:id>')
@jwt_required()
def get_inventory_by_id(id):
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')
    
    # Ensure shop_id is valid
    try:
        shop_id = uuid.UUID(shop_id)
    except ValueError:
        return jsonify({"msg": "Invalid shop_id in JWT claims"}), 400

    try:
        # Query to fetch the specific inventory item by id and shop_id
        inventory_item = db.session.query(Inventory).join(Shop).filter(
            Inventory.shop_id == shop_id,
            Inventory.id == id
        ).first()

        if not inventory_item:
            return jsonify({"msg": f"No inventory item with id {id} found"}), 404

        inventory_dict = {
            "id": inventory_item.id,
            "product_name": inventory_item.name,
            "category": inventory_item.category,
            "quantity": inventory_item.quantity,
            "batchNumber": inventory_item.batch_number,
            "orderQuantity": inventory_item.order_quantity,
            "reorderLevel": inventory_item.reorder_level,
            "costPrice": inventory_item.cost_price,
            "sellingPrice": inventory_item.selling_price,
            "expiryDate": inventory_item.expiry_date.strftime('%Y-%m-%d') if inventory_item.expiry_date else None,
            "supplierName": inventory_item.supplier_name,
            "supplierContact": inventory_item.supplier_contact,
        }

        return jsonify(inventory_dict), 200
    except Exception as e:
        return jsonify({'msg': f"An error occurred: {str(e)}"}), 500

"""
update an entry
"""
@inventory_blueprint.put('/<uuid:id>')
@jwt_required()
def edit_an_input(id):
    claims = get_jwt()
    shop_id = claims.get('shop_id')

    if not shop_id:
        return jsonify({"msg": "Shop id not found in token"}), 400

    data = request.get_json()
    if not data:
        return jsonify({"msg": "Invalid input"}), 400

    inventory_item = db.session.query(Inventory).join(Shop).filter(
        Shop.id == uuid.UUID(shop_id),
        Inventory.id == id
    ).first()

    if not inventory_item:
        return jsonify({"msg": "Inventory item not found or does not belong to your shop"}), 404
    expiry_date=data['expiry date']
    inventory_expiry_date = datetime.strptime(expiry_date, '%Y-%m-%d')
    # Update fields
    updated=Inventory(
        id=id,
        name=data['name'],
        category=data['category'],
        quantity=data['quantity'],
        batch_number=data['batch number'],
        reorder_level=data["reorder level"],
        cost_price=data['cost price'],
        selling_price=data['selling price'],
        expiry_date=inventory_expiry_date,
        supplier_name=data['supplier name']
    )
    db.session.merge(updated)
    db.session.commit()

    return jsonify({
        'id': updated.id,
        "name": updated.name,
        "category": updated.category,
        "quantity": updated.quantity,
        "batchNumber": updated.batch_number,
        "orderQuantity": updated.order_quantity,
        "reorderLevel": updated.reorder_level,
        "costPrice": updated.cost_price,
        "sellingPrice": updated.selling_price,
        "expiryDate": updated.expiry_date.strftime('%Y-%m-%d') if inventory_item.expiry_date else None,
        "supplierName": updated.supplier_name,
        "supplierContact": updated.supplier_contact
    }), 200


    

"""
delete an entry
"""
@inventory_blueprint.delete('/<uuid:id>')
@jwt_required()
def delete_item(id):
      jwt=get_jwt()
      shop_id=jwt.get('shop_id')
      inventory_item = db.session.query(Inventory).join(Shop).filter(
        Shop.id == uuid.UUID(shop_id),
        Inventory.id == id
    ).first()
      
      if inventory_item:
          db.session.delete(inventory_item)
          db.session.commit()
          return jsonify({'msg':'Item deleted'})
      else:
          return jsonify({'msg':"Item  does not exist"})
         
              
         
    
  