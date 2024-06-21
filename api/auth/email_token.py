from itsdangerous import URLSafeTimedSerializer
from  os import environ
from flask_mail import Mail, Message
import ssl

mail=Mail()

context = ssl.create_default_context()
context.set_ciphers('HIGH:!DH:!aNULL')
mail.context = context


def create_token(email):
    serializer=URLSafeTimedSerializer(secret_key=environ.get("SECRET_KEY"))
    return serializer.dumps(email, salt=environ.get('SECURITY_PASSWORD_SALT'))

def confirm_token(token,expiration=3600):
        serializer=URLSafeTimedSerializer(secret_key=environ.get("SECRET_KEY"))
        try:
              email = serializer.loads(
                    token,
                    salt=environ.get("SECRET_PASSWORD_SALT"),
                    max_age=expiration

              )
        except:
              return False
        return email

def send_email(to, token):
      msg= Message(
            subject= "Email confirmation code",
            recipients=[to],
            html=f'''<div>
            <h1>Enter this code to verify your email.</h1>
            <p><em>{token}</em></p>
            </div>''',
            sender=environ.get('MAIL_USERNAME')

      )
      mail.send(msg)


