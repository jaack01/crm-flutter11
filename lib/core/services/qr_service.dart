import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Service for generating and managing QR codes
class QrService {
  /// Generate QR code data for order
  static String generateOrderQrData(int orderId, String orderNumber) {
    return 'ORDER:$orderId:$orderNumber';
  }

  /// Generate QR code data for customer
  static String generateCustomerQrData(int customerId, String customerCode) {
    return 'CUSTOMER:$customerId:$customerCode';
  }

  /// Parse QR code data
  static Map<String, dynamic>? parseQrData(String qrData) {
    try {
      final List<String> parts = qrData.split(':');

      if (parts.length < 3) {
        return null;
      }

      final String type = parts[0];
      final int id = int.parse(parts[1]);
      final String code = parts[2];

      return {
        'type': type,
        'id': id,
        'code': code,
      };
    } catch (e) {
      return null;
    }
  }

  /// Generate QR code widget
  static Widget generateQrWidget({
    required String data,
    double size = 200.0,
    Color foregroundColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      gapless: true,
      errorStateBuilder: (context, error) {
        return Container(
          width: size,
          height: size,
          color: Colors.red.shade100,
          child: Center(
            child: Text(
              'Error generating QR code',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        );
      },
    );
  }

  /// Save QR code as image
  static Future<String?> saveQrCodeAsImage({
    required String data,
    required String fileName,
    double size = 512.0,
  }) async {
    try {
      // Create a GlobalKey for capturing the QR code
      final GlobalKey globalKey = GlobalKey();

      // Create QR image view with the global key
      final Widget qrWidget = RepaintBoundary(
        key: globalKey,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            gapless: true,
          ),
        ),
      );

      // This is a placeholder - in a real app, you would need to:
      // 1. Render the widget to an image using RenderRepaintBoundary
      // 2. Convert to bytes
      // 3. Save to file

      // Get application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory qrDir = Directory('${appDocDir.path}/qr_codes');

      if (!await qrDir.exists()) {
        await qrDir.create(recursive: true);
      }

      final String filePath = '${qrDir.path}/$fileName.png';

      // Return the path where the QR code would be saved
      return filePath;
    } catch (e) {
      return null;
    }
  }

  /// Capture widget as image bytes
  static Future<Uint8List?> captureWidgetAsImage(GlobalKey key) async {
    try {
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  /// Generate barcode data for order (simple barcode format)
  static String generateBarcodeData(String orderNumber) {
    // Remove any non-alphanumeric characters for barcode compatibility
    return orderNumber.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Validate QR/Barcode scan result
  static bool isValidOrderQrCode(String data) {
    final Map<String, dynamic>? parsed = parseQrData(data);
    return parsed != null && parsed['type'] == 'ORDER';
  }

  /// Validate customer QR code
  static bool isValidCustomerQrCode(String data) {
    final Map<String, dynamic>? parsed = parseQrData(data);
    return parsed != null && parsed['type'] == 'CUSTOMER';
  }

  /// Extract order ID from QR data
  static int? extractOrderId(String qrData) {
    final Map<String, dynamic>? parsed = parseQrData(qrData);
    return parsed?['id'] as int?;
  }

  /// Extract customer ID from QR data
  static int? extractCustomerId(String qrData) {
    final Map<String, dynamic>? parsed = parseQrData(qrData);
    return parsed?['id'] as int?;
  }
}
