# Movie Vault 🎬

## About
Movie Vault is a modern OTT-style Flutter application that lets users browse movies, watch official YouTube trailers, and manage their watchlist. Built with **Flutter**, **Firebase**, and the **YouTube iFrame Player API**, it runs on Web, Android, and Windows.

> **Note:** This app does **not** stream or host full movies. All video content consists of official YouTube trailers embedded via the iFrame API, which is fully compliant with YouTube's Terms of Service.

---

## Live Demo
🔗 [Movie Vault on Vercel](https://movie-vault-git-main-eshwarnaths-projects.vercel.app?_vercel_share=FfCdYxCmoC5r2kJboOxQW1oOXKAaGANZ)

---

## Features

### 🎬 Content
- 🎥 **Trailer Playback** — Watch official YouTube trailers inline (Web + Mobile)
- 🔥 **Trending & Carousel** — Dynamic movie sections powered by Firestore
- ▶️ **Continue Watching** — Tracks recently viewed trailers per user

### 🔍 Smart Search
- **Fuzzy Title Search** — Typo-tolerant search using Levenshtein edit distance; finds movies even with spelling mistakes (e.g. `"mastter"` → *Master*, `"star war"` → *Star Wars*)
- **Relevance Scoring** — Results ranked by priority: exact match → starts with → contains → fuzzy similarity
- **Live Suggestions** — Autocomplete dropdown updates as you type, also fuzzy-matched and sorted by relevance (max 8)
- **Recent Searches** — Remembers your last 8 queries for quick re-use
- **Trending Chips** — Curated trending search shortcuts

### 🎛️ Filters
- **Content Type** — Movie, Series, Kids, Documentary, Original
- **Genre** — Action, Adventure, Animation, Comedy, Crime, Drama, Fantasy, Horror, Romance, Sci-Fi, Thriller, Documentary, Nature, Family
- **Language** — English, Hindi, Tamil, Telugu
- **Minimum Rating** — Slider from 0–10 (0.5 step)
- **Duration** — Any / Short (<30 min) / Medium (30–90 min) / Long (>90 min)

### 🔐 User Management
- **Authentication** — Email/password sign-in & sign-up via Firebase Auth
- **Profile Management** — Edit profile, change password, delete account
- **Subscription Plans** — Starter, Premium, and Enterprise tiers

### 📱 Other
- 📥 **Downloads UI** — Download management interface with storage tracking

---

## Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Firebase Firestore |
| Authentication | Firebase Auth |
| Video Player | `youtube_player_iframe` (YouTube iFrame API) |
| Search Algorithm | Custom Levenshtein fuzzy matching (zero-dependency, on-device) |
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
    ├── Bottom Navbar/           # Profile, Search (fuzzy), Downloads, Edit Password
    ├── Firebase/                # Firestore database helpers (users, movies)
    ├── Menu/                    # Delete account, Contact support
    └── subscription/            # Subscription plans & payment UI
```

---

## Search Algorithm

The search system uses a **self-contained, zero-dependency fuzzy matching engine** implemented directly in Dart (no external packages).

### Scoring (`_scoreTitle`)

| Score | Condition | Example |
|-------|-----------|---------|
| `4.0` | Exact match | `"titanic"` → *Titanic* |
| `3.0` | Title starts with query | `"star"` → *Star Wars* |
| `2.0` | Title contains query | `"wars"` → *Star Wars* |
| `0–1` | Fuzzy similarity ≥ 0.5 | `"mastter"` → *Master* |
| `0.0` | No match — excluded | — |

### Levenshtein Distance

Edit distance is computed with a **two-row rolling DP** array (O(m×n) time, O(n) space).
Normalised similarity = `1 - distance / max(len_a, len_b)`.
The query is compared against both the full title and each individual word, so short queries correctly match multi-word titles.

### Tuning
Change `_kFuzzyThreshold` in `searchPage.dart` (default `0.5`):
- Higher (e.g. `0.7`) → stricter, fewer false positives
- Lower (e.g. `0.3`) → looser, catches more aggressive typos

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
