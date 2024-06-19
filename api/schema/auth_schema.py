from pydantic import BaseModel, field_validator,Field

class ShopSchema(BaseModel):
    shopName:str 
    email:str
    password:str=Field(min_length=8,max_length=32)

    @field_validator('email')
    def email_validation(cls,value):
        if '@' not in value or  '.com' not in value:
            raise ValueError('Provide a valid email')
        return value
    
   