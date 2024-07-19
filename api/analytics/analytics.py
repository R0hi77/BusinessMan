from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required,get_jwt
from database.core import db
from database.model import Shop, Transaction, TransactionItem
import datetime 
from sqlalchemy import func


analytics=Blueprint("analytics",__name__,url_prefix='/api/analytics')


@analytics.get('/dailysales/<date>')
@jwt_required()
def dailySales(date):
    jwt=get_jwt()
    shop_id=jwt.get('shop_id')
    target_date = datetime.datetime.strptime(date, '%Y-%m-%d')

    subquery = db.session.query(
        TransactionItem.product_name,
        func.sum(TransactionItem.quantity * TransactionItem.price_per_item).label('total_sales')
    ).join(Transaction).filter(
        Transaction.shop_id == shop_id,
        func.date(Transaction.transaction_date) == target_date.date()
    ).group_by(TransactionItem.product_name).subquery()

    highest_selling_product_query = db.session.query(
        subquery.c.name,
        subquery.c.total_sales
    ).order_by(subquery.c.total_sales.desc()).first()

    if highest_selling_product_query:
        result = {
            'product_name': highest_selling_product_query.product_name,
            'total_sales': highest_selling_product_query.total_sales
        }
    else:
        result = {'message': 'No data found for the given shop and date'}

    return jsonify(result)


