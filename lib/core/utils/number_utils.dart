import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class NumberUtils {
  // Prevent instantiation
  NumberUtils._();

  /// Format number as currency
  static String formatCurrency(double amount, {String? symbol}) {
    final String currencySymbol = symbol ?? AppConstants.currencySymbol;
    final NumberFormat formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: AppConstants.currencyDecimalPlaces,
    );
    return formatter.format(amount);
  }

  /// Format number as currency without symbol
  static String formatAmount(double amount) {
    final NumberFormat formatter = NumberFormat(
      '#,##0.${List.filled(AppConstants.currencyDecimalPlaces, '0').join()}',
    );
    return formatter.format(amount);
  }

  /// Format number with thousand separators
  static String formatNumber(num number) {
    final NumberFormat formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Parse string to double
  static double? parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      return null;
    }
  }

  /// Parse string to int
  static int? parseInt(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return int.parse(value.replaceAll(',', ''));
    } catch (e) {
      return null;
    }
  }

  /// Round to specified decimal places
  static double roundToDecimal(double value, int places) {
    final double mod = pow(10.0, places) as double;
    return (value * mod).round().toDouble() / mod;
  }

  /// Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate percentage value
  static double calculatePercentageValue(double total, double percentage) {
    return (total * percentage) / 100;
  }

  /// Calculate discount amount
  static double calculateDiscount(double originalPrice, double discountPercent) {
    return calculatePercentageValue(originalPrice, discountPercent);
  }

  /// Calculate final price after discount
  static double calculateDiscountedPrice(double originalPrice, double discountPercent) {
    final double discount = calculateDiscount(originalPrice, discountPercent);
    return originalPrice - discount;
  }

  /// Calculate tax amount
  static double calculateTax(double amount, double taxRate) {
    return calculatePercentageValue(amount, taxRate);
  }

  /// Calculate total with tax
  static double calculateTotalWithTax(double amount, double taxRate) {
    final double tax = calculateTax(amount, taxRate);
    return amount + tax;
  }

  /// Check if value is numeric
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return double.tryParse(value.replaceAll(',', '')) != null;
  }

  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Format duration (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Generate random number between min and max
  static int randomInt(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
}

/// Extension method to use pow function
double pow(double base, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
