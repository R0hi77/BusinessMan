from flask import Flask
from database.core import db


def create_app(test_config=None):
    app= Flask(__name__,instance_relative_config=True)
    if test_config is None:
        app.config.from_mapping(
            SECRET_KEY="",
            SQLALCHEMY_DATABASE_URI=''
        )
    else:
        app.config.from_mapping(test_config)
    db.init_app(db)
    return app