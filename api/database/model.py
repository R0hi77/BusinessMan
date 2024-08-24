from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import uuid
from sqlalchemy.dialects.postgresql import JSON, UUID
from sqlalchemy import Enum

from api.database.core import db

class Shop(db.Model):
    __tablename__ = 'shops'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(255), unique=True, nullable=False)
    number = db.Column(db.String(255), unique=True, nullable=False)
    email= db.Column(db.String(255),unique=True,nullable=False)
    business_address = db.Column(db.String(255),unique=False,nullable=False)
    password = db.Column(db.String, nullable=True)
    is_verified = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.now())
    
    managers = db.relationship('Manager', back_populates='shop', cascade="all, delete-orphan")
    attendants = db.relationship('Attendant', back_populates='shop', cascade="all, delete-orphan")
    inventories = db.relationship('Inventory', back_populates='shop', cascade="all, delete-orphan")
    transactions = db.relationship('Transaction', back_populates='shop', cascade="all, delete-orphan")

class Manager(db.Model):
    __tablename__ = 'managers'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False)
    password= db.Column(db.String(100), nullable=False)
    shop_id = db.Column(UUID(as_uuid=True), db.ForeignKey('shops.id'), nullable=False)

    shop = db.relationship('Shop', back_populates='managers')

class Attendant(db.Model):
    __tablename__ = 'attendants'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(), nullable=False)
    password = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now())
    manager_id=db.Column(UUID(as_uuid=True),db.ForeignKey('managers.id'),nullable=False)
    shop_id = db.Column(UUID(as_uuid=True), db.ForeignKey('shops.id'), nullable=False)
    # Consider adding a manager relationship if attendants report to managers
    # manager_id = db.Column(UUID(as_uuid=True), db.ForeignKey("managers.id"), nullable=True)

    shop = db.relationship('Shop', back_populates='attendants')

class BlockedTokens(db.Model):
    __tablename__ = 'blocked_tokens'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    token = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now)

    def __repr__(self):
        return f'{self.token}'

class Inventory(db.Model):
    __tablename__ = 'inventories'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.Text, nullable=False)
    category = db.Column(db.String, nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    batch_number = db.Column(db.String, nullable=False)
    order_quantity = db.Column(db.Integer, nullable=False)
    reorder_level = db.Column(db.Integer, nullable=True)
    cost_price = db.Column(db.Float, nullable=False)
    selling_price = db.Column(db.Float, nullable=False)
    expiry_date = db.Column(db.DateTime, nullable=True)
    supplier_name = db.Column(db.String, nullable=True)
    supplier_contact = db.Column(db.String, nullable=True)
    shop_id = db.Column(UUID(as_uuid=True), db.ForeignKey('shops.id'), nullable=False)
    attendant_id = db.Column(UUID(as_uuid=True), db.ForeignKey('attendants.id'), nullable=False)
    created=db.Column(db.DateTime, default=datetime.now())

    shop = db.relationship('Shop', back_populates='inventories')
    # transactions = db.relationship('Transaction', back_populates='inventory')

class Transaction(db.Model):
    __tablename__ = 'transactions'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    transaction_date = db.Column(db.DateTime, default=datetime.now, nullable=False)
    cash_in = db.Column(db.Float, nullable=False)
    payment_type = db.Column(db.Enum('cash', 'mobile money', name='payment_type'), nullable=False)
    balance = db.Column(db.Float, default=0.00)

    shop_id = db.Column(UUID(as_uuid=True), db.ForeignKey('shops.id'), nullable=False)
    attendant_id = db.Column(UUID(as_uuid=True), db.ForeignKey('attendants.id'), nullable=False)
    completed_by = db.Column(db.String(255), nullable=True)
    created=db.Column(db.DateTime, default=datetime.now())
    shop = db.relationship('Shop', back_populates='transactions')
    transaction_items = db.relationship('TransactionItem', back_populates='transaction')


class TransactionItem(db.Model):
    __tablename__ = 'transaction_items'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    transaction_id = db.Column(UUID(as_uuid=True), db.ForeignKey('transactions.id'), nullable=False)
    product_name = db.Column(db.String, nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price_per_item = db.Column(db.Float, nullable=False)
    created=db.Column(db.DateTime, default=datetime.now())
    transaction = db.relationship('Transaction', back_populates='transaction_items')

# result = db.session.query(Shop).join(Transaction).join(TransactionItem).options(
#     joinedload(Shop.transactions).joinedload(Transaction.transaction_items)
# ).all()



