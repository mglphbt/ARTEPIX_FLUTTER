# ARTEPIX Smart Packaging App

Enterprise-grade smart packaging ordering platform with AI-powered design generation, real-time pricing, and production tracking.

## 🚀 Project Overview

**ARTEPIX Smart Packaging** revolutionizes the packaging industry by combining:
- **AI Design Generation** (Stable Diffusion)
- **Real-time Pricing Engine** (Dynamic calculation based on dimensions)
- **3D Product Viewer** (Interactive package previews)
- **Production Tracking** (Real-time order status)
- **Multi-platform Support** (Android, iOS, Web)

## 📁 Project Structure

```
ARTEPIX_APPS/
├── backend/          # FastAPI backend (Python)
├── mobile/           # Flutter app (Dart)
└── docs/             # Documentation
```

## 🛠 Tech Stack

### Backend
- **Framework:** FastAPI (Python 3.11+)
- **Databases:** PostgreSQL (Relational) + MongoDB (NoSQL)
- **Authentication:** JWT + Google OAuth
- **Email:** SMTP with premium templates
- **Deployment:** Docker on VPS

### Mobile
- **Framework:** Flutter 3.24.5
- **State Management:** BLoC
- **Design:** Glassmorphism + Dark Mode
- **API Client:** Dio with interceptors
- **Storage:** flutter_secure_storage

## ⚙️ Setup Instructions

### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Mobile Setup
```bash
cd mobile
flutter pub get
flutter run -d chrome  # Web (recommended for testing)
# flutter run -d android  # Android (requires environment fix)
```

## 🔐 Environment Variables

Create `backend/.env`:
```env
DATABASE_URL=postgresql://user:password@localhost/artepix
MONGODB_URL=mongodb://localhost:27017/artepix
SECRET_KEY=your-secret-key
GOOGLE_CLIENT_ID=your-google-client-id
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_EMAIL=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

## 🎯 Current Status

✅ **Completed:**
- Authentication (Login, Signup, Google OAuth)
- Email OTP System (Premium templates)
- Backend API deployment (VPS)
- Mobile UI (Onboarding, Home, Product Detail)
- Design system (Glassmorphism, Dark Mode)

🔄 **In Progress:**
- Android APK build (environment issues - use CI/CD)
- E-commerce flow (Cart, Checkout)
- AI Design Generator integration

## 📱 Build & Deployment

### For Production APK (Recommended: GitHub Actions)
See `docs/build_deployment_guide.md` for detailed CI/CD setup.

**Quick CI/CD Setup:**
1. Push code to GitHub
2. Create `.github/workflows/build.yml`
3. APK builds automatically in cloud

### Manual Build (if environment is fixed)
```bash
cd mobile
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## 🐛 Known Issues

- **Android Build:** Local environment has JDK 21 incompatibility with NDK
  - **Solution:** Use GitHub Actions or Codemagic for cloud builds
- **Missing Assets:** `logo_text_white.png` path needs verification

## 👥 Team

- **Development:** AI-Assisted (Antigravity Agent)
- **Client:** PT Artepix Multi Industri

## 📄 License

Proprietary - All rights reserved to PT Artepix Multi Industri

---

**Last Updated:** 2026-01-05  
**Version:** 1.0.0-beta
