# Holom Said

<div align="center">
    
*A Comprehensive E-learning Mobile Application with Admin and User Management*

[Features](#features) · [Installation](#installation) · [Documentation](#documentation) · [Contact](#contact)

</div>

## Overview

Holom Said is an educational and intuitive e-learning platform built with Flutter and Supabase, offering a seamless experience for both administrators and users. The platform features comprehensive course management, exams passing, user authentication, real-time messaging, and a robust admin dashboard for content management.

## Demo Videos

<div align="center">
  <table>
    <tr>
      <td align="center" width="50%">
        <strong>Admin Features</strong><br>
        <details>
          <summary>Click to play</summary>
          <img src="assets/0e024cf004444f65b6cc63a3df47a83a.gif" alt="Admin Dashboard Demo" width="100%">
        </details>
      </td>
      <td align="center" width="50%">
        <strong>Users Features</strong><br>
        <details>
          <summary>Click to play</summary>
          <img src="assets/f2bb49f979814ff68e50544aa16d3929.gif" alt="User Interface Demo" width="100%">
        </details>
      </td>
    </tr>
  </table>
</div>

## Features

### 🎯 Core Capabilities

- **Authentication & Authorization**
  - Email/password registration and login
  - Google Sign-In integration
  - Role-based access control (Admin/User)
  - Secure session management

- **Admin Dashboard**
  - Course management and creation
  - Trainer profiles management
  - User management and analytics
  - Events scheduling and management
  - Content moderation
  - Admin preview for the user interface

- **User Features**
  - Personal profile customization
  - Course enrollment
  - Real-time messaging with administrators
  - Events announcement
  - Exams passing

- **Common Features**
  - Dark/Light theme support
  - Multi-language support (Arabic/English)
  - Push Notifications
  - Personal account management

- **Content Management**
  - Course, events, exams, and trainers creation and organization
  - Rich media support
  - Assessment tools

### 🔒 Security Features
- Secure authentication with Supabase
- Environment variable protection
- Row Level Security (RLS)
- Secure file storage
- Session management

## Technical Stack

- **Frontend:** Flutter
- **Backend:** Supabase
- **State Management:** Riverpod
- **Key Packages:**
  - flutter_riverpod
  - supabase_flutter
  - get_storage
  - google_sign_in
  - flutter_localizations
  - cached_network_image
  - connectivity_plus
  - image_picker

## Installation

```bash
# Clone the repository
git clone https://github.com/jaliil-9/holom-said-elearning-flutter-mobile-app.git

# Navigate to project directory
cd holom_said

# Create .env file and add your credentials
cp .env.example .env

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### System Requirements

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Supabase Account
- Google Cloud Console Account (for OAuth)

### Environment Setup

Create a `.env` file with the following:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_WEB_CLIENT_ID=your_web_client_id
GOOGLE_IOS_CLIENT_ID=your_ios_client_id
ADMIN_EMAIL_DOMAIN=your_admin_domain
```

## Project Structure

```
lib/
├── config/         # App configuration
├── core/          # Core utilities and helpers
├── features/      # Feature modules
│   ├── authentication/
│   ├── for_admin/
│   ├── for_user/
│   ├── messaging/
│   └── personalization/
└── generated/     # Generated localization files
```

## Documentation

For detailed documentation, please see:
- [User Guide](docs/USER_GUIDE.md)
- [Technical Documentation](docs/TECHNICAL.md)
- [API Documentation](docs/API.md)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## About the Developer

I am Abdeldjalil Bouziane, a Biotechnology Engineer specializing in Health Biotechnology, with expertise in:
- Cross-platform Mobile Development (Flutter)
- Machine Learning and Deep Learning
- Genetic Data Analysis

## Contact

- Email: jalilbouziane@protonmail.com
- LinkedIn: [Abdeldjalil Bouziane](https://www.linkedin.com/in/abdeldjalil-bouziane-0a7079288/)
