# MSL Manager

MSL is a password wallet app developed as a personal project for macOS using Dart/Flutter and Firebase. This application is designed to provide users with a secure, convenient, and easy-to-use solution for storing and managing passwords and sensitive credentials.

Feel free to fork this project, modify it, and adapt it to your own needs!

## Features

- **Cross-platform UI:** Built with Flutter for a smooth and native-like experience on macOS.
- **Secure Storage:** Utilizes Firebase for encrypted cloud storage of passwords.
- **Search and Organize:** Easily search, filter, and organize your credentials.
- **Clipboard Management:** Quick copy to clipboard with automatic clearing for added safety.
- **Backup and Restore:** Cloud sync to ensure your passwords are never lost.

## In Progress

- **Password Generator:** Generate strong, random passwords directly within the app.
- **Biometric Authentication:** (Planned) Support for Face ID/Touch ID on macOS devices.

## Screenshots

<!-- Add screenshots here if available. Example: -->
<!-- ![Login Screen](screenshots/login.png) -->
<!-- ![Password List](screenshots/password_list.png) -->

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- macOS device
- Firebase account (for backend setup)

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/mslazzuri/MSL-Manager.git
   cd MSL-Manager
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set up Firebase:**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Follow the instructions to add a macOS app and download the `GoogleService-Info.plist` file.
   - Place `GoogleService-Info.plist` in `macos/Runner/`.

4. **Run the app:**
   ```sh
   flutter run -d macos
   ```

### Building for Release

To build a release version for macOS:
```sh
flutter build macos
```
or

```sh
flutter build macos --release
```

## Project Structure

- `lib/` - Main Dart/Flutter source code
- `macos/` - macOS-specific files
- `cpp/` or `native/` - Native modules (C++, C, CMake)
- `test/` - Unit and widget tests

## Contributing

Contributions are welcome! Please open issues or submit pull requests for new features, bug fixes, or enhancements.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- Any additional resources or libraries used

---

For any questions or support, please open an issue on GitHub.
