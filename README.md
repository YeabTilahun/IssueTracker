### Issue Tracker

IssueTracker is a mobile application developed using Flutter that allows users to report and track issues in various locations. The app provides a streamlined interface for users to submit issues, view details, and upvote or downvote issues based on urgency. The primary aim of the app is to enhance community engagement and assist authorities in prioritizing and addressing reported issues effectively.

## Screenshots

<p align="center">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/da619f2c-4794-405d-8c46-cfe09d4978be" width="200">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/d4080470-af4c-40ba-8445-9286b01a43a8" width="200">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/ec0f5461-a0bb-4592-a604-3e07f7718bd6" width="200">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/81722f74-8513-456e-a01f-a7dacd454c7b" width="200">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/0272811b-ece8-4d56-8182-0cde476b7686" width="200">
  <img src="https://github.com/YeabTilahun/IssueTracker/assets/74009399/be19152b-a15e-4809-85ee-ac86c543fada" width="200">
</p>

## Description

IssueTracker simplifies the process of reporting and tracking issues in your community. With this app, users can:
- Report issues with detailed descriptions and images.
- View a list of reported issues in various locations.
- Upvote or downvote issues to indicate their urgency.
- Get real-time updates on the status of reported issues.

The app leverages `Firebase` for real-time data synchronization, providing users with the most up-to-date information on community issues.

## Getting Started

Follow these steps to get started with the IssueTracker project:

### Prerequisites

Make sure you have the following installed:
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes bundled with Flutter
- Android Studio or Visual Studio Code: Recommended IDEs for Flutter development
- Firebase account: [Create a Firebase account](https://firebase.google.com/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YeabTilahun/issuetracker.git
   cd issuetracker
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**

- Go to the Firebase console and create a new project.
- Add an Android app to your Firebase project and download the google-services.json file.
- Place the google-services.json file in the `android/app` directory.
- Add an iOS app to your Firebase project and download the GoogleService-Info.plist file.
- Place the GoogleService-Info.plist file in the ios/Runner directory.

4. **Run the app:**
```bash
flutter run
```
The generated APK file will be located in the `build/app/outputs/flutter-apk/` directory.

