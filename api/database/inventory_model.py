from core import  db
import uuid
from auth_model import Shop

class Inventory(db.Model):
    __tablename__='Inventory'

    id = db.Column(db.String(), default=lambda: str(uuid.uuid4()), primary_key=True)
    name = db.Column(db.Text(), nullable=False)
    category = db.Column(db.String(), nullable=False)
    quantity=db.Column(db.Integer(),nullable=False)
    batchNumber=db.Column(db.String(),nullable=False)
    orderQuantity=db.Column(db.Integer(),nullable=False)
    reorderLevel=db.Column(db.Integer(),nullable=True)
    CostPrice=db.Column(db.Float(),nullable=False)
    sellingPrice=db.Column(db.Float(),nullable=False)
    expiryDate=db.Column(db.DateTime,nullable=True)
    supplierName=db.Column(db.String(),nullable=True)
    supplierContact=db.Column(db.String(),nullable=True)
    ShopID= db.Column(db.String(),db.ForeignKey('shop.id'),nullable=False)

class Transaction(db.Model):
    __tablename__='transactions'

    id = db.Column(db.String(), primary_key=True)
    transactionDate = db.Column(db.DateTime, nullable=False)
    ProductName=db.Column(db.String(),nullable=False)
    quantity = db.Column(db.Float, nullable=False)
    cashIn = db.Column(db.Float, nullable=False)
    paymentType = db.Column(db.Enum('cash', 'mobile money', name='payment_type'), nullable=False)
    balance=db.Column(db.Float(),default=0.00)
    InventoryID=db.Column(db.String(),db.ForeignKey('inventory.id'),nullable=False)
