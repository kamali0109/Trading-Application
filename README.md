# Trading Mobile App

This is a Flutter-based mobile application for trading purposes. The app provides functionalities for both clients and administrators, including dashboards, login, registration, trade execution, trade history, and more.

## Features

- **Client Features:**
  - Login and Registration
  - Profile Management
  - Dashboard for tracking trades
  - Trade Execution
  - Trade History
  - Request Management
  - Trade Tracking

- **Admin Features:**
  - Admin Dashboard for managing client activities

## Project Structure

The project is organized as follows:
lib/
├── main.dart                // Entry point of the application
├── screens/                 // Contains all the UI screens
│   ├── login_screen.dart    // Login screen for users
│   ├── register_screen.dart // Registration screen for new users
│   ├── dashboard_screen.dart // Dashboard for clients
│   ├── trade_screen.dart    // Screen for executing trades
│   ├── history_screen.dart  // Trade history screen
│   └── admin_dashboard.dart // Admin dashboard screen
├── models/                  // Contains data models
│   ├── user_model.dart      // User data model
│   ├── trade_model.dart     // Trade data model
├── services/                // Contains service classes for API calls and business logic
│   ├── auth_service.dart    // Authentication service
│   ├── trade_service.dart   // Trade-related services
├── providers/               // Contains state management providers
│   ├── user_provider.dart   // User state management
│   ├── trade_provider.dart  // Trade state management
├── utils/                   // Utility classes and helpers
│   ├── constants.dart       // App-wide constants
│   ├── validators.dart      // Input validation helpers
├── widgets/                 // Reusable widgets
│   ├── custom_button.dart   // Custom button widget
│   ├── trade_card.dart      // Widget for displaying trade details
├── themes/                  // Contains app themes and styles
│   ├── app_theme.dart       // Main theme configuration
├── routes/                  // App routing configuration
│   ├── app_routes.dart      // Route definitions
