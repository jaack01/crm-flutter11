import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color primaryColorDark = Color(0xFF1976D2); // Dark Blue
  static const Color primaryColorLight = Color(0xFF64B5F6); // Light Blue

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF009688); // Teal
  static const Color secondaryColorDark = Color(0xFF00796B); // Dark Teal
  static const Color secondaryColorLight = Color(0xFF4DB6AC); // Light Teal

  // Error Colors
  static const Color errorColor = Color(0xFFB00020); // Red
  static const Color errorColorLight = Color(0xFFCF6679); // Light Red

  // Success Colors
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color successColorLight = Color(0xFF81C784); // Light Green

  // Warning Colors
  static const Color warningColor = Color(0xFFFF9800); // Orange
  static const Color warningColorLight = Color(0xFFFFB74D); // Light Orange

  // Info Colors
  static const Color infoColor = Color(0xFF2196F3); // Blue
  static const Color infoColorLight = Color(0xFF64B5F6); // Light Blue

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFFAFAFA); // Very Light Grey
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color textPrimaryLight = Color(0xFF212121); // Almost Black
  static const Color textSecondaryLight = Color(0xFF757575); // Medium Grey
  static const Color textHintLight = Color(0xFFBDBDBD); // Light Grey
  static const Color dividerLight = Color(0xFFE0E0E0); // Light Grey
  static const Color iconLight = Color(0xFF616161); // Dark Grey

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF121212); // Very Dark Grey
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark Grey
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Light Grey
  static const Color textHintDark = Color(0xFF757575); // Medium Grey
  static const Color dividerDark = Color(0xFF424242); // Medium Dark Grey
  static const Color iconDark = Color(0xFFE0E0E0); // Light Grey

  // Status Colors
  static const Color statusReceived = Color(0xFF2196F3); // Blue
  static const Color statusProcessing = Color(0xFFFF9800); // Orange
  static const Color statusReady = Color(0xFF4CAF50); // Green
  static const Color statusDelivered = Color(0xFF9E9E9E); // Grey
  static const Color statusCancelled = Color(0xFFB00020); // Red

  // Payment Status Colors
  static const Color paymentPending = Color(0xFFFF9800); // Orange
  static const Color paymentPartial = Color(0xFF2196F3); // Blue
  static const Color paymentPaid = Color(0xFF4CAF50); // Green

  // Customer Type Colors
  static const Color customerVip = Color(0xFFFFD700); // Gold
  static const Color customerRegular = Color(0xFF2196F3); // Blue
  static const Color customerNew = Color(0xFF4CAF50); // Green

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFF44336), // Red
    Color(0xFF009688), // Teal
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF795548), // Brown
  ];

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColorDark, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColorDark, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% Black
  static const Color shadowDark = Color(0x33000000); // 20% Black

  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000); // 4% Black
  static const Color overlayDark = Color(0x14FFFFFF); // 8% White

  // Shimmer Colors (for loading states)
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);
}
