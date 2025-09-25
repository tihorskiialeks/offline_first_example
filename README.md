# Offline First Flutter App

This project demonstrates how to build an **Offline-First** application in **Flutter** using **Clean Architecture** principles.  
The app synchronizes user data between a **local SQLite database** and **Firebase Firestore**, ensuring that it works seamlessly with or without an internet connection.

---

## ✨ Features

- **Offline-First Approach**
  - Local persistence with SQLite (`sqflite`).
  - Changes tracked with `changedLocally` flag and `deleted_users_ids` table.
  - Automatic synchronization with Firestore when internet becomes available.

- **Clean Architecture**
  - **Domain Layer**: Entities, Use Cases.
  - **Data Layer**: Models, Repositories (local + remote), Mappers.
  - **Presentation Layer**: Cubits (`flutter_bloc`), States, UI.
  - Clear separation of concerns with dependency injection (`get_it` + `injectable`).

- **Error Handling**
  - Centralized `ErrorHandler` for API, Firebase, and local errors.
  - Unified `Failure` model with codes and messages.

- **Connectivity Aware**
  - Uses `connectivity_plus` to detect online/offline state.

---

## 🏗️ Architecture Overview


- **UsersRepositoryImpl**  
  Orchestrates synchronization between **LocalDatabaseRepository** (SQLite) and **FirebaseRepository** (Firestore).  
  - Offline: works only with SQLite.  
  - Online: synchronizes changes (updates + deletions) and merges remote data into local DB.  

  Presentation (Page, Cubit, State)
        │
        ▼
   UseCases (Domain)
        │
        ▼
Repositories (Abstractions)
        │
 ┌──────┴─────────┐
 ▼                ▼
Local DB        Remote DB
(SQLite)       (Firestore)


---

## 📂 Tech Stack

- **Flutter** (3.32.8) & **Dart** (3.6)
- **State Management**: `flutter_bloc`
- **Navigation**: `auto_route`
- **Networking**: `dio` + `retrofit`
- **Local Storage**: `sqflite`
- **Remote Storage**: `cloud_firestore`
- **Dependency Injection**: `get_it` + `injectable`
- **Functional Programming**: `dartz`
- **Code Generation**: `json_serializable`, `retrofit_generator`, `auto_route_generator`

---

## 🚀 Getting Started

### Clone the repository
```bash
git clone https://github.com/tihorskiialeks/offline_first_example.git
cd offline_first


- Install dependencies

flutter pub get

- Generate code

flutter pub run build_runner build --delete-conflicting-outputs

### Configure Firebase
- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
- Enable **Firestore** in your Firebase project.

Run the app

flutter run