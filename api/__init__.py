from flask import Flask
from .database.core import db
from.database.auth_model import BlockedTokens
from dotenv import load_dotenv, dotenv_values
from os import getenv 
from api.auth.auth_blueprint import authentication_bp
from flask_jwt_extended import JWTManager
from flask_migrate import Migrate
# from setuptools import strtobool
from os import environ
load_dotenv()
config = dotenv_values()

def create_app(test_config=config):
    app= Flask(__name__,instance_relative_config=True)
     
    
    if test_config is None:
        app.config.from_mapping(
            SECRET_KEY=getenv('SECRET_KEY'),
            SQLALCHEMY_DATABASE_URI=getenv('SQLALCHEMY_DATABASE_URI'),
            SECURITY_PASSWORD_SALT=getenv('SECURITY_PASSWORD_SALT'),
            JWT_SECRET_KEY=getenv('JWT_SECRET_KEY'),
            MAIL_SERVER=getenv('MAIL_SERVER'),
            MAIL_USERNAME=getenv('MAIL_USERNAME'),
            MAIL_PASSWORD=getenv('MAIL_PASSWORD'),
            MAIL_PORT=getenv('MAIL_PORT'),
            MAIL_USE_SSL=getenv('MAIL_USER_SSL'),
            MAIL_USER_TLS=getenv("MAIL_USER_TLS")
        )
    else:
        app.config.from_mapping(test_config)
    jwt=JWTManager(app)
    migrate= Migrate(app,db)
    db.init_app(app)
   
   
    # register blueprint
    
    app.register_blueprint(authentication_bp)

# jwt call back fucntions
    @jwt.token_in_blocklist_loader
    def token_in_blocklist_callback(jwt_header,jwt_data):
        jti=jwt_data['jti']
        token=db.session.query(BlockedTokens).filter(BlockedTokens.token==jti).scalar()
        return token is not None
    return app