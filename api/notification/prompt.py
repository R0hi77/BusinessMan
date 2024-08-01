# # from .extensions import socketio
# from api.database.model import Shop, Inventory
# from api.database.core import db
# import uuid
# # from .events import user_sessions
# from flask_socketio import emit

# def notify_users(item):
#       from .extensions import socketio
#       from .events import user_sessions
#       for sid in user_sessions.values():
#             socketio.emit('notification',{'message':f'Stock for {item.name} is at threshold'}, to=sid)

# def check_for_low_stock(shop_id):
        
#         inventory_list= db.session.query(Inventory).join(Shop).filter(
#         Shop.id == uuid.UUID(shop_id)).all()

#         for item in inventory_list:
#             if item.quantity == item.reorder_level:
#                   notify_users(item)
                  
    