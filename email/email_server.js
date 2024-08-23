const express = require('express');
const nodemailer = require('nodemailer');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Create a transporter using SMTP
const transporter = nodemailer.createTransport({
  host: 'smtp-relay.brevo.com',
  port: 587,
  secure: false, // Use TLS
  auth: {
    user: '757f73002@smtp-brevo.com',
    // pass: 'xsmtpsib-c419fc80a33e2f89b2a90aeb5cf8c5e6d48d589e140739f5f41e0846371f1176-t8X1Jr34IEH9fSpn',
    pass:'EBPA58w9sIfdTWrk'
    
  }
});

// API endpoint to send email
app.post('/send-email', async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: 'Email address is required' });
  }

  try {
    // Send mail with defined transport object
    const info = await transporter.sendMail({
        from: '"Salesmart" <757f73002@smtp-brevo.com>',
        to: email,
        subject: "SaleSmart Account Registration",
        text: `Hello! Please verify your email for SaleSmart. Your verification link is: [Insert verification URL here]`,
        html: `
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Verify Your SaleSmart Account</title>
          </head>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
            <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f8f9fa; border-radius: 5px;">
              <tr>
                <td style="padding: 20px;">
                  <h1 style="color: #0056b3; text-align: center;">Welcome to SaleSmart!</h1>
                  <p style="font-size: 16px;">Hello,</p>
                  <p style="font-size: 16px;">Thank you for signing up to SaleSmart Business Manager. We're excited to have you on board! We will send you platform updates via this email. This email will also be used to issue transaction invoices:</p>
                  <p style="font-size: 16px;">If you didn't create an account with SaleSmart, please ignore this email.</p>
                  <p style="font-size: 16px;">Best regards,<br>The SaleSmart Team</p>
                </td>
              </tr>
            </table>
            <p style="text-align: center; font-size: 12px; color: #6c757d; margin-top: 20px;">This is an automated message, please do not reply directly to this email.</p>
          </body>
          </html>
        `
      });

    console.log('Message sent: %s', info.messageId);
    res.json({ message: 'Email sent successfully' });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({ error: 'Failed to send email' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});