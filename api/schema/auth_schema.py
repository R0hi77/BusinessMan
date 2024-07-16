# from pydantic import BaseModel, field_validator,Field

from pydantic import BaseModel, EmailStr, Field

class ShopSchema(BaseModel):
    shopName: str
    number: str
    password: str = Field(min_length=8)

class Login(BaseModel):
    number: str
    password: str

   