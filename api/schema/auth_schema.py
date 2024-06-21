# from pydantic import BaseModel, field_validator,Field

from pydantic import BaseModel, EmailStr, Field

class ShopSchema(BaseModel):
    shopName: str
    email: EmailStr
    password: str = Field(min_length=6)

class Login(BaseModel):
    email: EmailStr
    password: str

   