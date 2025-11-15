import '../constants/app_constants.dart';

class Validators {
  // Prevent instantiation
  Validators._();

  /// Validate required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final RegExp emailRegExp = RegExp(AppConstants.emailRegex);
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final String cleanValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanValue.length < AppConstants.minPhoneLength ||
        cleanValue.length > AppConstants.maxPhoneLength) {
      return 'Please enter a valid phone number';
    }
    final RegExp phoneRegExp = RegExp(AppConstants.phoneRegex);
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int length, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int length, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > length) {
      return '$fieldName must not exceed $length characters';
    }
    return null;
  }

  /// Validate number
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  /// Validate integer
  static String? integer(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName must be a valid integer';
    }
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, {String fieldName = 'This field'}) {
    final String? numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final double? numValue = double.tryParse(value!);
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be a positive number';
    }
    return null;
  }

  /// Validate minimum value
  static String? minValue(String? value, double min, {String fieldName = 'This field'}) {
    final String? numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final double? numValue = double.tryParse(value!);
    if (numValue == null || numValue < min) {
      return '$fieldName must be at least $min';
    }
    return null;
  }

  /// Validate maximum value
  static String? maxValue(String? value, double max, {String fieldName = 'This field'}) {
    final String? numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final double? numValue = double.tryParse(value!);
    if (numValue == null || numValue > max) {
      return '$fieldName must not exceed $max';
    }
    return null;
  }

  /// Validate value in range
  static String? range(String? value, double min, double max, {String fieldName = 'This field'}) {
    final String? numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final double? numValue = double.tryParse(value!);
    if (numValue == null || numValue < min || numValue > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }
    return null;
  }

  /// Validate confirm password
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    final Uri? uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validate date
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    if (DateTime.tryParse(value) == null) {
      return 'Please enter a valid date';
    }
    return null;
  }

  /// Validate future date
  static String? futureDate(String? value) {
    final String? dateError = date(value);
    if (dateError != null) return dateError;

    final DateTime? dateValue = DateTime.tryParse(value!);
    if (dateValue == null || dateValue.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }
    return null;
  }

  /// Validate past date
  static String? pastDate(String? value) {
    final String? dateError = date(value);
    if (dateError != null) return dateError;

    final DateTime? dateValue = DateTime.tryParse(value!);
    if (dateValue == null || dateValue.isAfter(DateTime.now())) {
      return 'Date must be in the past';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final String? error = validator();
      if (error != null) return error;
    }
    return null;
  }
}
