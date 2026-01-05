import smtplib
import ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from app.core.config import settings


def get_otp_email_template(otp_code: str) -> str:
    """
    Returns a premium-styled HTML email template for OTP verification.
    Matches ARTEPIX dark theme with primary accent color.
    """
    return f"""
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kode Verifikasi ARTEPIX</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0a1214;">
    <table role="presentation" style="width: 100%; border-collapse: collapse;">
        <tr>
            <td align="center" style="padding: 40px 20px;">
                <table role="presentation" style="width: 100%; max-width: 480px; border-collapse: collapse; background: linear-gradient(145deg, #0D1B1E 0%, #142428 100%); border-radius: 24px; box-shadow: 0 20px 60px rgba(0,0,0,0.4); overflow: hidden;">
                    
                    <!-- Header with Logo -->
                    <tr>
                        <td style="padding: 40px 40px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.05);">
                            <div style="display: inline-block; padding: 12px 24px; background: rgba(184, 255, 0, 0.1); border-radius: 50px; margin-bottom: 16px;">
                                <span style="color: #B8FF00; font-size: 24px; font-weight: 700; letter-spacing: 3px;">ARTEPIX</span>
                            </div>
                            <p style="color: rgba(255,255,255,0.5); font-size: 14px; margin: 0;">Smart Packaging Solutions</p>
                        </td>
                    </tr>
                    
                    <!-- Main Content -->
                    <tr>
                        <td style="padding: 40px;">
                            <h1 style="color: #ffffff; font-size: 22px; font-weight: 600; margin: 0 0 16px; text-align: center;">
                                Kode Verifikasi Anda
                            </h1>
                            <p style="color: rgba(255,255,255,0.6); font-size: 15px; line-height: 1.6; margin: 0 0 32px; text-align: center;">
                                Masukkan kode berikut untuk memverifikasi akun Anda. Kode ini berlaku selama <strong style="color: #B8FF00;">5 menit</strong>.
                            </p>
                            
                            <!-- OTP Code Box -->
                            <div style="background: linear-gradient(135deg, rgba(184,255,0,0.15) 0%, rgba(184,255,0,0.05) 100%); border: 2px solid rgba(184,255,0,0.3); border-radius: 16px; padding: 28px; text-align: center; margin-bottom: 32px;">
                                <span style="font-size: 42px; font-weight: 700; letter-spacing: 12px; color: #B8FF00; font-family: 'Courier New', monospace;">{otp_code}</span>
                            </div>
                            
                            <!-- Warning -->
                            <div style="background: rgba(255,100,100,0.1); border-left: 3px solid #ff6b6b; padding: 16px; border-radius: 8px; margin-bottom: 24px;">
                                <p style="color: rgba(255,255,255,0.8); font-size: 13px; margin: 0; line-height: 1.5;">
                                    ⚠️ Jangan bagikan kode ini kepada siapapun. Tim ARTEPIX tidak pernah meminta kode verifikasi Anda.
                                </p>
                            </div>
                            
                            <p style="color: rgba(255,255,255,0.4); font-size: 13px; text-align: center; margin: 0;">
                                Jika Anda tidak meminta kode ini, abaikan email ini.
                            </p>
                        </td>
                    </tr>
                    
                    <!-- Footer -->
                    <tr>
                        <td style="padding: 24px 40px; background: rgba(0,0,0,0.2); border-top: 1px solid rgba(255,255,255,0.05);">
                            <table role="presentation" style="width: 100%;">
                                <tr>
                                    <td style="text-align: center;">
                                        <p style="color: rgba(255,255,255,0.3); font-size: 12px; margin: 0 0 8px;">
                                            © 2025 PT Artepix Multi Industri
                                        </p>
                                        <p style="color: rgba(255,255,255,0.25); font-size: 11px; margin: 0;">
                                            Jl. Contoh Alamat No. 123, Jakarta, Indonesia
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
"""


def send_email(to: str, subject: str, html_body: str) -> bool:
    """
    Send an email using SSL SMTP connection.
    Returns True if successful, False otherwise.
    """
    try:
        message = MIMEMultipart("alternative")
        message["Subject"] = subject
        message["From"] = f"ARTEPIX <{settings.SMTP_EMAIL}>"
        message["To"] = to
        
        html_part = MIMEText(html_body, "html")
        message.attach(html_part)
        
        # Create SSL context
        context = ssl.create_default_context()
        
        # Connect and send
        with smtplib.SMTP_SSL(settings.SMTP_HOST, settings.SMTP_PORT, context=context) as server:
            server.login(settings.SMTP_EMAIL, settings.SMTP_PASSWORD)
            server.sendmail(settings.SMTP_EMAIL, to, message.as_string())
        
        return True
    except Exception as e:
        print(f"Email send error: {e}")
        return False


def send_otp_email(to: str, otp_code: str) -> bool:
    """
    Send OTP verification email with premium template.
    """
    subject = "🔐 Kode Verifikasi ARTEPIX Anda"
    html_body = get_otp_email_template(otp_code)
    return send_email(to, subject, html_body)
