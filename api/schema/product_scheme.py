from pydantic import BaseModel
from datetime import datetime


class Product(BaseModel):
    name:str
    category:str


class Stock(BaseModel):
    quantity:int
    batchNumber:str
    orderQuantity:int
    reorderLevel:int

class Price(BaseModel):
    costPrice:int
    sellingPrice:int

class ExpriryInfornation(BaseModel):
    expiryDate:datetime | None

class Transaction(BaseModel):
    transactionDate:datetime
    quantity:int
    cashIn:float
    balance:float
    #paymentType:list['cash','mobile money']

class Supplier (BaseModel):
    supplierName: str | None
    supplierContact: str | None
