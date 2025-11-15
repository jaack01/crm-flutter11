import '../../domain/entities/shop_settings.dart';

class ShopSettingsModel extends ShopSettings {
  const ShopSettingsModel({
    super.id,
    required super.shopName,
    super.shopAddress,
    super.shopPhone,
    super.shopEmail,
    super.shopLogo,
    super.gstNumber,
    super.taxRate,
    super.currency,
    super.currencySymbol,
    super.receiptHeader,
    super.receiptFooter,
    super.printLogoOnReceipt,
    super.enableGst,
    super.enableSms,
    super.enableEmail,
    super.updatedAt,
  });

  factory ShopSettingsModel.fromJson(Map<String, dynamic> json) {
    return ShopSettingsModel(
      id: json['id'] as int?,
      shopName: json['shop_name'] as String,
      shopAddress: json['shop_address'] as String?,
      shopPhone: json['shop_phone'] as String?,
      shopEmail: json['shop_email'] as String?,
      shopLogo: json['shop_logo'] as String?,
      gstNumber: json['gst_number'] as String?,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      currencySymbol: json['currency_symbol'] as String? ?? '₹',
      receiptHeader: json['receipt_header'] as String? ?? 'Thank you for your business!',
      receiptFooter: json['receipt_footer'] as String? ?? 'Visit again!',
      printLogoOnReceipt: (json['print_logo_on_receipt'] as int?) == 1,
      enableGst: (json['enable_gst'] as int?) == 1,
      enableSms: (json['enable_sms'] as int?) == 1,
      enableEmail: (json['enable_email'] as int?) == 1,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_phone': shopPhone,
      'shop_email': shopEmail,
      'shop_logo': shopLogo,
      'gst_number': gstNumber,
      'tax_rate': taxRate,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'receipt_header': receiptHeader,
      'receipt_footer': receiptFooter,
      'print_logo_on_receipt': printLogoOnReceipt ? 1 : 0,
      'enable_gst': enableGst ? 1 : 0,
      'enable_sms': enableSms ? 1 : 0,
      'enable_email': enableEmail ? 1 : 0,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ShopSettings toEntity() {
    return ShopSettings(
      id: id,
      shopName: shopName,
      shopAddress: shopAddress,
      shopPhone: shopPhone,
      shopEmail: shopEmail,
      shopLogo: shopLogo,
      gstNumber: gstNumber,
      taxRate: taxRate,
      currency: currency,
      currencySymbol: currencySymbol,
      receiptHeader: receiptHeader,
      receiptFooter: receiptFooter,
      printLogoOnReceipt: printLogoOnReceipt,
      enableGst: enableGst,
      enableSms: enableSms,
      enableEmail: enableEmail,
      updatedAt: updatedAt,
    );
  }

  factory ShopSettingsModel.fromEntity(ShopSettings entity) {
    return ShopSettingsModel(
      id: entity.id,
      shopName: entity.shopName,
      shopAddress: entity.shopAddress,
      shopPhone: entity.shopPhone,
      shopEmail: entity.shopEmail,
      shopLogo: entity.shopLogo,
      gstNumber: entity.gstNumber,
      taxRate: entity.taxRate,
      currency: entity.currency,
      currencySymbol: entity.currencySymbol,
      receiptHeader: entity.receiptHeader,
      receiptFooter: entity.receiptFooter,
      printLogoOnReceipt: entity.printLogoOnReceipt,
      enableGst: entity.enableGst,
      enableSms: entity.enableSms,
      enableEmail: entity.enableEmail,
      updatedAt: entity.updatedAt,
    );
  }
}
