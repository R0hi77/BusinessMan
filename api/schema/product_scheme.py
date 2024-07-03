from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from enum import Enum

class PaymentMethod(str, Enum):
    cash='cash'
    mobileMoney='Mobile money'




class Product(BaseModel):
    name:str
    category:str
    quantity:int
    batchNumber:str
    orderQuantity:Optional[int]=None
    reorderLevel:int
    costPrice:int
    sellingPrice:int
    expiryDate:Optional[datetime]=None
    supplierName: Optional[str]=None
    supplierContact: Optional[str]=None

class Transaction(BaseModel):
    transactionDate:datetime
    productName:str
    quantity:int
    cashIn:float
    PaymentType:PaymentMethod
    balance:float
    
