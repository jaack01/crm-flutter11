# Development Guide

## Getting Started

### Prerequisites

1. **Flutter SDK**: Version 3.0 or higher
   ```bash
   flutter --version
   ```

2. **IDE Setup** (Choose one):
   - **VS Code** with Flutter and Dart extensions
   - **Android Studio** with Flutter plugin
   - **IntelliJ IDEA** with Flutter plugin

3. **Platform-Specific Tools**:
   - **For Android**: Android SDK, Android Studio
   - **For Windows**: Visual Studio 2022 with C++ desktop development tools

### Initial Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd crm-flutter11
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Verify Flutter setup:
   ```bash
   flutter doctor
   ```

4. Run the app:
   ```bash
   # For Windows
   flutter run -d windows

   # For Android
   flutter run -d android
   ```

## Architecture

This project follows **Clean Architecture** principles with **BLoC** for state management.

### Layer Structure

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, BLoCs, Pages, Widgets)           │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Entities, Use Cases, Repositories)    │
├─────────────────────────────────────────┤
│            Data Layer                   │
│  (Models, Data Sources, Repo Impl)      │
└─────────────────────────────────────────┘
```

### Dependency Rules

- **Presentation** depends on **Domain**
- **Domain** is independent (no dependencies)
- **Data** depends on **Domain**
- Dependencies flow inward (toward Domain)

## Coding Standards

### File Naming

- Use snake_case for file names: `customer_repository.dart`
- Use PascalCase for class names: `CustomerRepository`
- Use camelCase for variables and functions: `getUserById`

### Code Organization

1. **Imports Order**:
   ```dart
   // 1. Dart imports
   import 'dart:async';

   // 2. Package imports
   import 'package:flutter/material.dart';

   // 3. Project imports
   import 'package:laundry_crm/core/theme/app_colors.dart';
   ```

2. **Class Structure**:
   ```dart
   class MyClass {
     // 1. Static constants
     static const String myConstant = 'value';

     // 2. Instance variables
     final String myVariable;

     // 3. Constructor
     const MyClass({required this.myVariable});

     // 4. Public methods
     void myMethod() {}

     // 5. Private methods
     void _myPrivateMethod() {}
   }
   ```

### Comments

- Use `///` for documentation comments
- Use `//` for inline comments
- Write self-documenting code when possible

```dart
/// Fetches customer by ID from the database.
///
/// Returns [Customer] if found, null otherwise.
Future<Customer?> getCustomerById(int id) async {
  // Implementation
}
```

## State Management (BLoC)

### BLoC Structure

```dart
// Events
abstract class CustomerEvent extends Equatable {}

class LoadCustomers extends CustomerEvent {}

// States
abstract class CustomerState extends Equatable {}

class CustomerInitial extends CustomerState {}
class CustomerLoading extends CustomerState {}
class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  CustomerLoaded(this.customers);
}
class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}

// BLoC
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;

  CustomerBloc({required this.getCustomers}) : super(CustomerInitial());

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is LoadCustomers) {
      yield CustomerLoading();
      // Business logic
    }
  }
}
```

## Database

### Accessing Database

```dart
// Get database instance
final db = await DatabaseHelper.instance.database;

// Execute query
final results = await db.query('customers');

// Execute raw query
final results = await DatabaseHelper.instance.rawQuery(
  'SELECT * FROM customers WHERE id = ?',
  [customerId],
);
```

### Adding Migrations

1. Update `_databaseVersion` in `database_helper.dart`
2. Add migration logic in `_onUpgrade` method:

```dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE customers ADD COLUMN new_field TEXT');
  }
}
```

## Testing

### Unit Tests

Located in `test/unit/`

```dart
void main() {
  group('CustomerRepository', () {
    late CustomerRepository repository;

    setUp(() {
      repository = CustomerRepositoryImpl();
    });

    test('should return customer when found', () async {
      // Arrange
      final id = 1;

      // Act
      final result = await repository.getCustomerById(id);

      // Assert
      expect(result, isA<Customer>());
    });
  });
}
```

### Widget Tests

Located in `test/widget/`

```dart
void main() {
  testWidgets('Dashboard shows welcome message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    expect(find.text('Welcome to Laundry CRM'), findsOneWidget);
  });
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/unit/customer_repository_test.dart

# With coverage
flutter test --coverage
```

## Git Workflow

### Branch Naming

- Feature: `feature/customer-management`
- Bug fix: `bugfix/fix-payment-calculation`
- Hotfix: `hotfix/critical-database-issue`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add customer search functionality
fix: resolve payment calculation error
docs: update README with setup instructions
refactor: simplify order creation logic
test: add unit tests for CustomerRepository
```

### Pull Request Process

1. Create feature branch from `main`
2. Make changes and commit
3. Push to remote
4. Create pull request
5. Wait for code review
6. Merge after approval

## Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location
build/app/outputs/flutter-apk/app-release.apk
```

### Windows

```bash
# Build Windows executable
flutter build windows --release

# Output location
build/windows/runner/Release/
```

## Common Issues

### Issue: Flutter command not found
**Solution**: Add Flutter to PATH

### Issue: SQLite error on Windows
**Solution**: Ensure `sqflite_common_ffi` is properly configured

### Issue: Build fails with dependency conflicts
**Solution**: Run `flutter pub get` and `flutter clean`

## Performance Tips

1. **Use const constructors** when possible
2. **Avoid rebuilding widgets** unnecessarily
3. **Lazy load data** with pagination
4. **Optimize images** before adding to assets
5. **Profile performance** with DevTools

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [BLoC Library](https://bloclibrary.dev/)
- [Material Design](https://material.io/design)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Getting Help

- Check the README.md
- Review existing code examples
- Contact the development team
- Create an issue in the repository
