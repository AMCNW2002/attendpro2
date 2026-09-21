
# 📱 AttendPro – Student Attendance Management App

<p align="center">
  <h1 align="center">AttendPro</h1>
  <p align="center">
    A Simple Offline Student Attendance Management Application
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android"/>
  <img src="https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter"/>
  <img src="https://img.shields.io/badge/Dart-Programming%20Language-blue?logo=dart"/>
  <img src="https://img.shields.io/badge/Mode-Offline-orange"/>
</p>

---

## 📌 Project Overview

**AttendPro** is an offline student attendance management mobile application developed to simplify the process of recording and monitoring student attendance.

The application allows users to mark students as Present or Absent and view attendance statistics through a visual pie chart.

AttendPro focuses on providing a simple, user-friendly, and efficient attendance management experience without requiring an internet connection.

---

## 🎯 Project Objectives

- Simplify student attendance recording.
- Reduce manual attendance tracking.
- Provide a simple and user-friendly interface.
- Display attendance statistics visually.
- Support offline attendance management.
- Improve the efficiency of daily attendance activities.

---

## ✨ Key Features

### 👨‍🎓 Student Attendance

- Display a predefined student list.
- Mark students as Present.
- Mark students as Absent.
- View student attendance status.
- Simple attendance management interface.

### 📊 Attendance Statistics

- Display Present student count.
- Display Absent student count.
- Visualize attendance data using a pie chart.
- Provide a quick overview of attendance statistics.

### 📱 Offline Functionality

- Access the application without an internet connection.
- Manage attendance using a simple mobile interface.
- No online account registration required.

> Note: Attendance persistence and date-based history depend on the implemented application features.

---

## 🔄 Application Workflow

```text id="3p7xkq"
       Open AttendPro App
               │
               ▼
      View Student List
               │
               ▼
      Mark Attendance
        ┌──────┴──────┐
        │             │
        ▼             ▼
     Present       Absent
        │             │
        └──────┬──────┘
               │
               ▼
    View Attendance Summary
               │
               ▼
       Pie Chart Display
```

---

## 🏗️ Application Architecture

AttendPro is designed as an offline mobile attendance application.

```text id="m1p5xw"
┌──────────────────────────┐
│      AttendPro App       │
│      Flutter / Dart      │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│    Student List Module   │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│ Attendance Marking       │
│ Present / Absent         │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│ Attendance Statistics    │
│ Pie Chart Visualization  │
└──────────────────────────┘
```

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile Application Development |
| Dart | Programming Language |
| Material Design | User Interface |
| Flutter Chart Library | Attendance Visualization |
| Android | Mobile Platform |

> Update the chart library name based on the package used in your project.

---

## 📂 Project Structure

```text id="j8g5fz"
attendpro/
│
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── widgets/
│   ├── models/
│   └── utils/
│
├── assets/
├── test/
├── pubspec.yaml
├── .gitignore
└── README.md
```

> Update the folder structure to match your actual project.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio
- VS Code (Optional)

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/attendpro.git
```

### 2. Navigate to Project

```bash
cd attendpro
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run Application

```bash
flutter run
```

### 5. Build Release APK

```bash
flutter build apk --release
```

---

## 🖼️ Screenshots

Add screenshots of the implemented application screens.

Recommended screenshots:

- Home Screen
- Student List
- Attendance Marking Screen
- Attendance Summary
- Pie Chart


---

## 🔒 Application Limitations

- Student records are predefined.
- No student registration or database management.
- No online synchronization.
- Attendance history depends on implemented storage functionality.

---

## 🔮 Future Improvements

- Student registration and management.
- Local database integration using SQLite or Hive.
- Date-wise attendance history.
- Export attendance reports as PDF.
- Search and filter students.
- Cloud backup and synchronization.
- Teacher login and authentication.

---

## 🎓 Project Purpose

AttendPro was developed as a practical mobile application project to demonstrate skills in:

- Flutter Mobile Application Development.
- Dart Programming.
- User Interface Design.
- Attendance Management Logic.
- Data Visualization.
- Problem Solving.

---

## 👨‍💻 Developer

**AMC Sandaruwan**

Information Technology Undergraduate

Sri Lanka Institute of Advanced Technological Education (SLIATE)

### Connect With Me

- GitHub: [Your GitHub Profile](https://github.com/AMCNW2002/)
  

---

## 📄 License

This project is developed for educational and portfolio purposes.

Add an appropriate open-source license if you intend to distribute the source code.
