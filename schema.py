from pydantic import BaseModel,field_validatorv,Field
from typing import Optional


class Shop():
    shopName:str
    email:str
    password:str