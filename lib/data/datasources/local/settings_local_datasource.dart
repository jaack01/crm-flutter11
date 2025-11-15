import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/shop_settings_model.dart';
import '../../models/notification_settings_model.dart';

abstract class SettingsLocalDataSource {
  /// Get shop settings
  Future<ShopSettingsModel> getShopSettings();

  /// Update shop settings
  Future<int> updateShopSettings(ShopSettingsModel settings);

  /// Get notification settings
  Future<NotificationSettingsModel> getNotificationSettings();

  /// Update notification settings
  Future<int> updateNotificationSettings(NotificationSettingsModel settings);

  /// Get setting value by key
  Future<String?> getSettingValue(String key);

  /// Set setting value
  Future<void> setSettingValue(String key, String value);

  /// Reset all settings to default
  Future<void> resetToDefaults();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final DatabaseHelper databaseHelper;

  SettingsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<ShopSettingsModel> getShopSettings() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'shop_settings',
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Shop settings not found');
    }

    return ShopSettingsModel.fromJson(maps.first);
  }

  @override
  Future<int> updateShopSettings(ShopSettingsModel settings) async {
    final Database db = await databaseHelper.database;

    final Map<String, dynamic> data = settings.toJson();
    data['updated_at'] = DateTime.now().toIso8601String();

    if (settings.id != null) {
      return await db.update(
        'shop_settings',
        data,
        where: 'id = ?',
        whereArgs: [settings.id],
      );
    } else {
      // If no existing record, insert new
      return await db.insert('shop_settings', data);
    }
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'notification_settings',
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Notification settings not found');
    }

    return NotificationSettingsModel.fromJson(maps.first);
  }

  @override
  Future<int> updateNotificationSettings(NotificationSettingsModel settings) async {
    final Database db = await databaseHelper.database;

    final Map<String, dynamic> data = settings.toJson();
    data['updated_at'] = DateTime.now().toIso8601String();

    if (settings.id != null) {
      return await db.update(
        'notification_settings',
        data,
        where: 'id = ?',
        whereArgs: [settings.id],
      );
    } else {
      // If no existing record, insert new
      return await db.insert('notification_settings', data);
    }
  }

  @override
  Future<String?> getSettingValue(String key) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      columns: ['setting_value'],
      where: 'setting_key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps.first['setting_value'] as String?;
  }

  @override
  Future<void> setSettingValue(String key, String value) async {
    final Database db = await databaseHelper.database;

    await db.insert(
      'settings',
      {
        'setting_key': key,
        'setting_value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> resetToDefaults() async {
    final Database db = await databaseHelper.database;

    await db.transaction((txn) async {
      // Reset shop settings
      await txn.delete('shop_settings');
      await txn.rawInsert('''
        INSERT INTO shop_settings (
          shop_name, tax_rate, currency, currency_symbol,
          receipt_header, receipt_footer, print_logo_on_receipt,
          enable_gst, enable_sms, enable_email
        ) VALUES (
          'My Laundry Shop', 18.0, 'INR', '₹',
          'Thank you for your business!', 'Visit again!', 1,
          0, 0, 0
        )
      ''');

      // Reset notification settings
      await txn.delete('notification_settings');
      await txn.rawInsert('''
        INSERT INTO notification_settings (
          enable_notifications, notify_order_ready, notify_payment_due,
          notify_delivery, notify_low_stock, notify_new_order,
          payment_reminder_days, notification_sound, vibrate,
          quiet_hours_start, quiet_hours_end
        ) VALUES (
          1, 1, 1, 1, 1, 1, 3, 'default', 1, '22:00', '08:00'
        )
      ''');
    });
  }
}
