from flask import Blueprint, jsonify,request
from flask_jwt_extended import jwt_required,get_jwt
from database.core import db
from database.model import Shop, Transaction, TransactionItem
from datetime import datetime, timedelta 
from sqlalchemy import func


analytics=Blueprint("analytics",__name__,url_prefix='/api/analytics')


@analytics.post('/top_products')
@jwt_required()
def get_top_products():
    data = request.json()
    time_period = data.get('time_period')
    jwt=get_jwt()
    shop_id = jwt.get('shop_id')

    if not shop_id:
        return jsonify({'error': 'Shop ID is required.'}), 400

    if time_period not in ['day', 'week', 'month', 'year']:
        return jsonify({'error': 'Invalid time period. Choose day, week, month, or year.'}), 400

    # Calculate the start date based on the time period
    end_date = datetime.now()
    if time_period == 'day':
        start_date = end_date - timedelta(days=1)
    elif time_period == 'week':
        start_date = end_date - timedelta(weeks=1)
    elif time_period == 'month':
        start_date = end_date - timedelta(days=30)
    else:  # year
        start_date = end_date - timedelta(days=365)

    # Query to get top 5 products for a specific shop
    top_products = db.session.query(
        TransactionItem.product_name,
        func.sum(TransactionItem.quantity).label('total_quantity')
    ).join(
        Transaction, TransactionItem.transaction_id == Transaction.id
    ).join(
        Shop, Transaction.shop_id == Shop.id
    ).filter(
        Shop.id == shop_id,
        Transaction.transaction_date.between(start_date, end_date)
    ).group_by(
        TransactionItem.product_name
    ).order_by(
        func.sum(TransactionItem.quantity).desc()
    ).limit(10).all()

    # Format the results
    result = [
        {'product_name': product.product_name, 'total_quantity': product.total_quantity}
        for product in top_products
    ]

    return jsonify(result)


@analytics.get('/sales_daily')
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

@analytics.get('/daily_summary')
@jwt_required()
def daily_summary():
    # Get the JWT token from the Authorization header
    jwt = get_jwt()
    shop_id = jwt.get('shop_id')

    if not shop_id:
        return jsonify({"error": "Invalid or missing token"}), 401

    # Get today's date (start and end of the day)
    today_start = datetime.combine(datetime.today(), datetime.min.time())
    today_end = datetime.combine(datetime.today(), datetime.max.time())

    # Query to get total transaction value for the day
    total_transaction_value = db.session.query(
        func.sum(Transaction.cash_in)
    ).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= today_start,
        Transaction.transaction_date <= today_end
    ).scalar() or 0.0

    # Query to get the number of transactions for the day
    number_of_transactions = db.session.query(
        func.count(Transaction.id)
    ).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= today_start,
        Transaction.transaction_date <= today_end
    ).scalar() or 0

    # Query to get total profits made in a day
    total_profits = db.session.query(
        func.sum((TransactionItem.price_per_item * TransactionItem.quantity) - TransactionItem.price_per_item)
    ).join(Transaction).filter(
        Transaction.shop_id == shop_id,
        Transaction.transaction_date >= today_start,
        Transaction.transaction_date <= today_end
    ).scalar() or 0.0

    # Prepare and return the summary
    summary = {
        "total_transaction_value": total_transaction_value,
        "number_of_transactions": number_of_transactions,
        "total_profits": total_profits
    }

    return jsonify(summary), 200

