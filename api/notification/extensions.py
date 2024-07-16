from flask_socketio import SocketIO
from flask_apscheduler import APScheduler
from api.notification.prompt import check_for_low_stock
from flask import g
socketio=SocketIO()

scheduler=APScheduler()

def init_scheduler(app):
    scheduler.init_app(app)
    scheduler.start()

    # Schedule the stock check
    @scheduler.task('interval', id='check_stock', seconds=60)
    def scheduled_stock_check():
        with app.app_context():
            check_for_low_stock(shop_id=g.shop_id) 