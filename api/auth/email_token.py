from itsdangerous import URLSafeTimedSerializer
from os import environ, getenv
from flask import jsonify
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def create_token(email):
    serializer = URLSafeTimedSerializer(secret_key=environ.get("SECRET_KEY"))
    return serializer.dumps(email, salt=environ.get('SECURITY_PASSWORD_SALT'))

def confirm_token(token, expiration=3600):
    serializer = URLSafeTimedSerializer(secret_key=environ.get("SECRET_KEY"))
    try:
        email = serializer.loads(
            token,
            salt=environ.get("SECURITY_PASSWORD_SALT"),  # Corrected typo
            max_age=expiration
        )
    except Exception as e:  # Catch specific exceptions if needed
        print(f"Token confirmation error: {e}")
        return False
    return email

def send_email(to_email, token):
    from_email = getenv('MAIL_USERNAME')
    subject = "Your Verification Token"
    body = f"Please use the following token to verify your email: {token}"

    # Create the MIME message
    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = subject

    # Attach the body to the message
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(getenv('MAIL_SERVER'), int(getenv('MAIL_PORT')))
        server.starttls()
        server.login(getenv('MAIL_USERNAME'), getenv('MAIL_PASSWORD'))  # Use your SMTP server credentials
        server.sendmail(from_email, to_email, msg.as_string())
        server.quit()
        return str({"msg": "Email sent successfully!"}), 200
    except smtplib.SMTPException as e:
        return str({"msg": f"Error: unable to send email {str(e)}"}), 500
    except Exception as e:
        return str({"msg": f"Unexpected error: {str(e)}"}), 500

# Example usage
# Ensure you have the appropriate environment variables set
# send_email("example@domain.com", "your_verification_token")


   
      


