import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class AppDateUtils {
  // Prevent instantiation
  AppDateUtils._();

  /// Format date to display format (dd MMM yyyy)
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplay).format(date);
  }

  /// Format date to full format (dd MMMM yyyy)
  static String formatDateFull(DateTime date) {
    return DateFormat(AppConstants.dateFormatFull).format(date);
  }

  /// Format date with time (dd MMM yyyy, hh:mm a)
  static String formatDateWithTime(DateTime date) {
    return DateFormat(AppConstants.dateFormatWithTime).format(date);
  }

  /// Format date to database format (yyyy-MM-dd HH:mm:ss)
  static String formatDateForDatabase(DateTime date) {
    return DateFormat(AppConstants.dateFormatDatabase).format(date);
  }

  /// Format date to date only (yyyy-MM-dd)
  static String formatDateOnly(DateTime date) {
    return DateFormat(AppConstants.dateFormatDateOnly).format(date);
  }

  /// Format time only (hh:mm a)
  static String formatTime(DateTime date) {
    return DateFormat(AppConstants.timeFormat).format(date);
  }

  /// Parse database date string to DateTime
  static DateTime? parseDatabaseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get today's date at midnight
  static DateTime getToday() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get start of week (Monday)
  static DateTime getStartOfWeek() {
    final DateTime now = DateTime.now();
    final int weekday = now.weekday;
    return now.subtract(Duration(days: weekday - 1));
  }

  /// Get end of week (Sunday)
  static DateTime getEndOfWeek() {
    final DateTime now = DateTime.now();
    final int weekday = now.weekday;
    return now.add(Duration(days: 7 - weekday));
  }

  /// Get start of month
  static DateTime getStartOfMonth() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Get end of month
  static DateTime getEndOfMonth() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }

  /// Get start of year
  static DateTime getStartOfYear() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  /// Get end of year
  static DateTime getEndOfYear() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, 12, 31);
  }

  /// Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get relative date string (Today, Yesterday, Tomorrow, or formatted date)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDate(date);
    }
  }

  /// Add days to date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Subtract days from date
  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}
