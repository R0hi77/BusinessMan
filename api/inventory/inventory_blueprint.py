from flask import Blueprint,request,jsonify
from schema.product_scheme import Product
from pydantic import ValidationError
from database.core import db

inventory_blueprint= Blueprint("inventory",__name__,url_prefix='api/inventory')


"""
add to product table
"""

@inventory_blueprint('/post')
def addproduct():
    raw_data=request.json()
    try:
        validation_data=Product(raw_data['name'],
                                raw_data['category'])
    except ValidationError as e:
        return jsonify({'data entry error':str(e)})
    product=Product(name=validation_data.name,
                    category=validation_data.category)
    db.session.add(product)
    db.session.commit()
    return jsonify({'':''})
  