from .extensions import socketio
from flask import request, jsonify, Blueprint

user_sessions={}
socket= Blueprint("socket",__name__)

@socketio.on ("connect",namespace='/')
def handle_connection():
    user_id=request.args.get('user_id')
    if user_id:
        user_sessions[user_id] = request.sid
    print (f"User {user_id} connected with session ID {request.sid}")


@socketio.on('disconnect')
def handle_disconnect():
    user_id = None
    for uid, sid in user_sessions.items():
        if sid == request.sid:
            user_id = uid
            break
    if user_id:
        del user_sessions[user_id]
    print(f"User {user_id} disconnected")







    

