# Mood Note 📝

A clean, elegant, and privacy-focused personal diary application built with Flutter.

[简体中文](README_CN.md) | English

## ✨ Features

- **Daily Reflection**: Record your mood and thoughts with a minimalist interface.
- **Weather Integration**: Automatically fetch current weather info via QWeather API.
- **Smart Search**: Quickly find past memories with keyword filtering.
- **Local Storage**: Securely store all your data locally using SQLite.
- **Backup & Restore**: Export/Import your diaries to JSON files for data safety.
- **User Onboarding**: Interactive tutorial for new users.
- **Themes**: Full support for Light and Dark modes.

## 🚀 Getting Started

### Prerequisites

1.  **Flutter SDK**: Ensure you have Flutter installed (Stable channel recommended).
2.  **QWeather API Key**: This project uses **QWeather (和风天气)** for weather services. Due to security reasons, the developer's API key is not provided in the source code.

### Configuration

Before running the project, you **must** configure your own API key:

1.  Apply for a free/developer key at [QWeather Console](https://console.qweather.com/).
2.  Navigate to `lib/const/api_key.dart`.
3.  Fill in your key:
    ```dart
    const String qWeatherKey = 'YOUR_API_KEY_HERE';
    const String HostAPI = "YOUR_HOST_API_HERE";
    ```

> **Note**: The pre-built APK (if provided in Releases) includes a working key, but for source code development, you need your own.

### Installation

```bash
# Clone the repository
git clone [https://github.com/MT-Y-TM/mood_note.git](https://github.com/MT-Y-TM/mood_note.git)

# Install dependencies
flutter pub get

# Run the app
flutter run

```

## 🛠️ Tech Stack

* **Framework**: Flutter
* **State Management**: Provider
* **Database**: Sqflite (SQLite)
* **Networking**: Dio
* **Utilities**: Shared Preferences, Intl, UUID

---

## 📄 License

This project is for educational purposes.

