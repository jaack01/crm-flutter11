# Laundry CRM - Professional Laundry Shop Management System

A production-grade CRM application for laundry shops built with Flutter and SQLite, supporting both Windows and Android platforms.

## Features

### Phase 1 - Foundation (Completed ✅)
- ✅ Clean Architecture setup
- ✅ Material Design 2 UI theme (Light & Dark mode)
- ✅ SQLite database with comprehensive schema
- ✅ Dependency injection with GetIt
- ✅ Navigation with GoRouter
- ✅ Core utilities and constants
- ✅ Splash screen and dashboard

### Phase 2 - Customer Management (Completed ✅)
- ✅ Complete Customer CRUD operations
- ✅ Customer search and filtering
- ✅ Customer type management (New, Regular, VIP)
- ✅ Auto-generated customer codes
- ✅ Form validation and error handling
- ✅ BLoC state management
- ✅ Common widgets library
- 🔄 Order Management (Planned)
- 🔄 Service & Pricing Configuration (Planned)
- 🔄 Billing & Payments (Planned)

### Phase 3 - Advanced Features (Domain Layer Complete ✅)
- ✅ Inventory domain entities (InventoryItem, StockTransaction)
- ✅ Employee domain entity
- ✅ Expense domain entity
- ✅ DashboardStatistics entity
- ✅ InventoryRepository interface (16 operations)
- ✅ EmployeeRepository interface (8 operations)
- ✅ StatisticsRepository interface (6 operations)
- ✅ Comprehensive implementation guide
- 🔄 Data layer implementation (Planned)
- 🔄 UI pages and BLoCs (Planned)

### Phase 4 - Enhancement & Polish (Completed ✅)
- ✅ Settings Management (Shop & Notification settings)
- ✅ Local Notifications (Scheduled & immediate)
- ✅ QR Code Integration (Order & customer QR codes)
- ✅ Data Backup & Restore (Full database backup)
- ✅ Data Export (JSON & CSV)
- ✅ Settings UI with tabs
- ✅ Notification Service integration
- ✅ Backup history tracking

### Phase 5 - Order Management System (Completed ✅)
- ✅ Complete Order CRUD operations
- ✅ Order items management
- ✅ Customer integration with orders
- ✅ Order status workflow (Received, Processing, Ready, Delivered, Cancelled)
- ✅ Search and filtering by status
- ✅ Auto order number generation
- ✅ Financial tracking (subtotal, discount, tax, payments)
- ✅ Orders list UI with status chips
- ✅ OrderBloc with 7 events and 6 states

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** BLoC Pattern
- **Database:** SQLite (sqflite + sqflite_common_ffi for Windows)
- **Dependency Injection:** GetIt
- **Navigation:** GoRouter
- **UI:** Material Design 2

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── theme/             # Material Design 2 themes
│   ├── utils/             # Utility functions
│   ├── error/             # Error handling
│   ├── database/          # SQLite database setup
│   └── di/                # Dependency injection
├── data/
│   ├── datasources/       # Local data sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
├── presentation/
│   ├── blocs/             # BLoC state management
│   ├── pages/             # Screen widgets
│   ├── widgets/           # Reusable widgets
│   └── routes/            # Navigation configuration
└── main.dart              # App entry point
```

## Database Schema

The application uses SQLite with the following main tables:

- **customers** - Customer information and contact details
- **orders** - Order tracking and status
- **order_items** - Individual items in orders
- **services** - Available laundry services
- **item_types** - Types of items (shirt, pants, etc.)
- **service_pricing** - Pricing matrix for services
- **payments** - Payment records
- **employees** - Staff management
- **inventory_items** - Supply inventory
- **stock_transactions** - Inventory movements
- **expenses** - Business expenses
- **settings** - App configuration
- **shop_settings** - Shop profile and configuration (Phase 4)
- **notification_settings** - Notification preferences (Phase 4)
- **notifications** - App notifications (Phase 4)
- **backup_history** - Backup tracking (Phase 4)

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- For Windows: Visual Studio 2022 with C++ tools
- For Android: Android Studio with SDK

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd crm-flutter11
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:

For Windows:
```bash
flutter run -d windows
```

For Android:
```bash
flutter run -d android
```

## Development

### Code Style

The project follows the official Flutter style guide and uses `flutter_lints` for linting.

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Building for Production

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### Windows
```bash
flutter build windows --release
```

## Configuration

### Theme

The app uses Material Design 2 with customizable themes. Colors can be modified in:
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_theme.dart`

### Database

Database schema and migrations are managed in:
- `lib/core/database/database_helper.dart`
- `lib/core/database/database_tables.dart`

## Contributing

This is a private project. For any questions or issues, please contact the development team.

## License

Proprietary - All rights reserved

## Version

**Current Version:** 1.0.0 (Phase 1 Complete)

## Documentation

- **README.md** - Project overview and quick start
- **DEVELOPMENT.md** - Development guidelines and best practices
- **CHANGELOG.md** - Version history and changes
- **PHASE2_IMPLEMENTATION.md** - Detailed Phase 2 technical guide
- **PHASE2_COMPLETE.md** - Phase 2 completion summary
- **PHASE3_IMPLEMENTATION_GUIDE.md** - Complete Phase 3 implementation blueprint
- **PHASE3_FOUNDATION.md** - Phase 3 domain layer completion summary

## Roadmap

- [x] Phase 1: Project Setup & Foundation ✅
- [x] Phase 2: Customer Management Module ✅
- [x] Phase 3: Advanced Features - Domain Layer ✅
- [ ] Phase 3+: Inventory, Employee, Reports - Full Implementation (Planned)
- [ ] Phase 4: Order Management, Services, Payments (Planned)
- [ ] Phase 5: Enhancement & Polish (Planned)
- [ ] Phase 6: Testing & Optimization (Planned)
- [ ] Phase 7: Platform-Specific Setup (Planned)
- [ ] Phase 8: Deployment & Documentation (Planned)

## Quick Start

See **PHASE2_COMPLETE.md** for testing the Customer Management module.

## Support

For support, please contact the development team or create an issue in the repository.
