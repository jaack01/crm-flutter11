import 'package:equatable/equatable.dart';

/// Shop settings entity containing business profile and configuration
class ShopSettings extends Equatable {
  final int? id;
  final String shopName;
  final String? shopAddress;
  final String? shopPhone;
  final String? shopEmail;
  final String? shopLogo;
  final String? gstNumber;
  final double taxRate;
  final String currency;
  final String currencySymbol;
  final String receiptHeader;
  final String receiptFooter;
  final bool printLogoOnReceipt;
  final bool enableGst;
  final bool enableSms;
  final bool enableEmail;
  final DateTime? updatedAt;

  const ShopSettings({
    this.id,
    required this.shopName,
    this.shopAddress,
    this.shopPhone,
    this.shopEmail,
    this.shopLogo,
    this.gstNumber,
    this.taxRate = 0.0,
    this.currency = 'INR',
    this.currencySymbol = '₹',
    this.receiptHeader = 'Thank you for your business!',
    this.receiptFooter = 'Visit again!',
    this.printLogoOnReceipt = true,
    this.enableGst = false,
    this.enableSms = false,
    this.enableEmail = false,
    this.updatedAt,
  });

  ShopSettings copyWith({
    int? id,
    String? shopName,
    String? shopAddress,
    String? shopPhone,
    String? shopEmail,
    String? shopLogo,
    String? gstNumber,
    double? taxRate,
    String? currency,
    String? currencySymbol,
    String? receiptHeader,
    String? receiptFooter,
    bool? printLogoOnReceipt,
    bool? enableGst,
    bool? enableSms,
    bool? enableEmail,
    DateTime? updatedAt,
  }) {
    return ShopSettings(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      shopPhone: shopPhone ?? this.shopPhone,
      shopEmail: shopEmail ?? this.shopEmail,
      shopLogo: shopLogo ?? this.shopLogo,
      gstNumber: gstNumber ?? this.gstNumber,
      taxRate: taxRate ?? this.taxRate,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      receiptHeader: receiptHeader ?? this.receiptHeader,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      printLogoOnReceipt: printLogoOnReceipt ?? this.printLogoOnReceipt,
      enableGst: enableGst ?? this.enableGst,
      enableSms: enableSms ?? this.enableSms,
      enableEmail: enableEmail ?? this.enableEmail,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shopName,
        shopAddress,
        shopPhone,
        shopEmail,
        shopLogo,
        gstNumber,
        taxRate,
        currency,
        currencySymbol,
        receiptHeader,
        receiptFooter,
        printLogoOnReceipt,
        enableGst,
        enableSms,
        enableEmail,
        updatedAt,
      ];
}
