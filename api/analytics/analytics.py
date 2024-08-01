from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required,get_jwt
from database.core import db
from database.model import Shop, Transaction, TransactionItem
from datetime import datetime, timedelta 
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


@analytics.get('/sales_daily', methods=['GET'])
@jwt_required()
def get_sales_trend():
    # Get the JWT token from the Authorization header
    jwt=get_jwt()
    shop_id=jwt.get('shop_id')
    
    
    if not shop_id:
        return jsonify({"error": "Invalid or missing token"}), 401

    # Get the start and end of the last 7 days
    end_date = datetime.now()
    start_date = end_date - timedelta(days=6)

    # Query the database to sum the sales per day for the specific shop
    sales_data = db.session.query(
        func.date(Transaction.transaction_date).label('date'),
        func.sum(Transaction.cash_in).label('total_sales')
    ).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= start_date,
        Transaction.transaction_date <= end_date
    ).group_by(
        func.date(Transaction.transaction_date)
    ).order_by('date').all()

    # Prepare the data for the line chart
    data_points = [
        {
            "x": (item.date - start_date).days,  # X-axis: Days since start_date
            "y": item.total_sales  # Y-axis: Total sales
        }
        for item in sales_data
    ]

    return jsonify(data_points)



@analytics.get('/sales_weekly', methods=['GET'])
@jwt_required()
def get_weekly_sales_trend():
    # Get the JWT token from the Authorization header
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')
    
    if not shop_id:
        return jsonify({"error": "Invalid or missing token"}), 401

    # Get the start and end of the last 7 weeks
    end_date = datetime.now()
    start_date = end_date - timedelta(weeks=6)

    # Query the database to sum the sales per week for the specific shop
    sales_data = db.session.query(
        func.date_trunc('week', Transaction.transaction_date).label('week'),
        func.sum(Transaction.cash_in).label('total_sales')
    ).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= start_date,
        Transaction.transaction_date <= end_date
    ).group_by(
        func.date_trunc('week', Transaction.transaction_date)
    ).order_by('week').all()

    # Prepare the data for the line chart
    data_points = [
        {
            "x": (item.week - start_date).days // 7,  # X-axis: Weeks since start_date
            "y": item.total_sales  # Y-axis: Total sales
        }
        for item in sales_data
    ]

    return jsonify(data_points)


@analytics.get('/sales_monthly', methods=['GET'])
@jwt_required()
def get_monthly_sales_trend():
    # Get the JWT token from the Authorization header
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')
    
    if not shop_id:
        return jsonify({"error": "Invalid or missing token"}), 401

    # Get the start and end of the last 6 months
    end_date = datetime.now()
    start_date = end_date - timedelta(days=30*5)  # Approximate 6 months

    # Query the database to sum the sales per month for the specific shop
    sales_data = db.session.query(
        func.date_trunc('month', Transaction.transaction_date).label('month'),
        func.sum(Transaction.cash_in).label('total_sales')
    ).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= start_date,
        Transaction.transaction_date <= end_date
    ).group_by(
        func.date_trunc('month', Transaction.transaction_date)
    ).order_by('month').all()

    # Prepare the data for the line chart
    data_points = [
        {
            "x": (item.month.year - start_date.year) * 12 + (item.month.month - start_date.month),  # X-axis: Months since start_date
            "y": item.total_sales  # Y-axis: Total sales
        }
        for item in sales_data
    ]

    return jsonify(data_points)
