from flask import Flask
from .database.core import db
from dotenv import load_dotenv, dotenv_values
from os import getenv 
from api.auth.email_token import mail
load_dotenv()
config = dotenv_values()

def create_app(test_config=config):
    app= Flask(__name__,instance_relative_config=True)
    
    if test_config is None:
        app.config.from_mapping(
            SECRET_KEY=getenv('SECRET_KEY'),
            SQLALCHEMY_DATABASE_URI=getenv('SQLALCHEMY_DATABASE_URI'),
            SECURITY_PASSWORD_SALT=getenv('SECURITY_PASSWORD_SALT')
        )
    else:
        app.config.from_mapping(test_config)
    db.init_app(app)
    mail.init_app(app)

    return app