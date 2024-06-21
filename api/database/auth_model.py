from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import uuid

from .core import db

class Shop (db.Model):
    __tablename__='shops'

    id=db.Column(db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
    shopName= db.Column(db.String(255),unique=True, nullable= False)
    email = db.Column(db.String(255),unique=True, nullable=False)
    password= db.Column(db.String, nullable=False)
    isVerified=db.Column(db.Boolean, default= False)
    created= db.Column(db.DateTime, default=datetime.now())
    

class Manager (db.Model):
    __tablename__ = 'managers'

    id=db.Column(db.String,default=lambda: str(uuid.uuid4()), primary_key=True)
    password= db.Column(db.String,nullable=False)
    shopID = db.Column(db.String, db.ForeignKey('shops.id'), nullable=False)

class Attendant (db.Model):
    id=db.Column(db.String,default=lambda: str(uuid.uuid4()), primary_key=True)
    attendantName= db.Column(db.Text,nullable=False)
    password = db.Column(db.String,nullable=False)
    created = db.Column(db.DateTime,default= datetime.now())
    shopID=db.Column(db.String,db.ForeignKey("shops.id"),nullable=False)
    # Consider a foreign key to a Manager model if attendants report to managers
    # managerID=db.Column(db.String, db.ForeignKey("managers.id"),nullable=False)


class BlockedTokens(db.Model):
    id = db.Column(db.Integer(),primary_key=True,autoincrement=True)
    token=db.Column(db.String(),nullable=False)
    created =db.Column(db.DateTime(),default=datetime.now())

    def __repr__(self):
          return f'{self.token}'
