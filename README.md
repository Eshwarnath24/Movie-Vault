# Movie Vault 🎬

## About
Movie Vault is a modern OTT-style Flutter application that lets users browse movies, watch official YouTube trailers, and manage their watchlist. Built with **Flutter**, **Firebase**, and the **YouTube iFrame Player API**, it runs on Web, Android, and Windows.

> **Note:** This app does **not** stream or host full movies. All video content consists of official YouTube trailers embedded via the iFrame API, which is fully compliant with YouTube's Terms of Service.

---

## Live Demo
🔗 [Movie Vault on Vercel](https://movie-vault-git-main-eshwarnaths-projects.vercel.app?_vercel_share=FfCdYxCmoC5r2kJboOxQW1oOXKAaGANZ)

---

## Features
- 🎥 **Trailer Playback** — Watch official YouTube trailers inline (Web + Mobile)
- 🔥 **Trending & Carousel** — Dynamic movie sections powered by Firestore
- ▶️ **Continue Watching** — Tracks recently viewed trailers per user
- 🔍 **Search & Filter** — Search movies by title, filter by genre
- 🔐 **Authentication** — Email/password sign-in & sign-up via Firebase Auth
- 📱 **Subscription Plans** — Starter, Premium, and Enterprise tiers
- 👤 **Profile Management** — Edit profile, change password, delete account
- 📥 **Downloads UI** — Download management interface with storage tracking

---

## Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Firebase Firestore |
| Authentication | Firebase Auth |
| Video Player | `youtube_player_iframe` (YouTube iFrame API) |
| Hosting | Vercel (Web) |

---

## Project Structure
```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase config
└── pages/
    ├── Authorization/           # Sign-in, Sign-up, Forgot Password, Splash Screen
    ├── Main/                    # Home page, Movie detail page, Movie data models
    ├── Bottom Navbar/           # Profile, Search, Downloads, Edit Password
    ├── Firebase/                # Firestore database helpers (users, movies)
    ├── Menu/                    # Delete account, Contact support
    └── subscription/            # Subscription plans & payment UI
```

---

## Setup & Run

### Prerequisites
- Flutter SDK (≥ 3.8.1)
- Firebase project with Firestore & Auth enabled

### Steps
```bash
# Clone the repo
git clone https://github.com/Eshwarnath24/Movie-Vault.git
cd Movie-Vault

# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run -d android

# Build for web deployment
flutter build web
```

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password provider)
3. Enable **Cloud Firestore**
4. Run `flutterfire configure` to generate `firebase_options.dart`
5. If deploying to Vercel, add your Vercel domain under **Authentication → Settings → Authorized domains**

---

## Legal Disclaimer
This application embeds official YouTube trailers using the YouTube iFrame Player API. No copyrighted movies are hosted, stored, or illegally streamed. All movie poster images are used for informational/educational purposes within this college project.
