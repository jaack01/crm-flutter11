class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'Laundry CRM';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Laundry Shop Management System';

  // Order Status
  static const String orderStatusReceived = 'Received';
  static const String orderStatusProcessing = 'Processing';
  static const String orderStatusReady = 'Ready';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusCancelled = 'Cancelled';

  static const List<String> orderStatuses = [
    orderStatusReceived,
    orderStatusProcessing,
    orderStatusReady,
    orderStatusDelivered,
    orderStatusCancelled,
  ];

  // Payment Status
  static const String paymentStatusPending = 'Pending';
  static const String paymentStatusPartial = 'Partial';
  static const String paymentStatusPaid = 'Paid';

  static const List<String> paymentStatuses = [
    paymentStatusPending,
    paymentStatusPartial,
    paymentStatusPaid,
  ];

  // Payment Methods
  static const String paymentMethodCash = 'Cash';
  static const String paymentMethodCard = 'Card';
  static const String paymentMethodUPI = 'UPI';
  static const String paymentMethodWallet = 'Wallet';
  static const String paymentMethodBank = 'Bank Transfer';

  static const List<String> paymentMethods = [
    paymentMethodCash,
    paymentMethodCard,
    paymentMethodUPI,
    paymentMethodWallet,
    paymentMethodBank,
  ];

  // Customer Types
  static const String customerTypeNew = 'New';
  static const String customerTypeRegular = 'Regular';
  static const String customerTypeVip = 'VIP';

  static const List<String> customerTypes = [
    customerTypeNew,
    customerTypeRegular,
    customerTypeVip,
  ];

  // Employee Roles
  static const String roleManager = 'Manager';
  static const String roleCashier = 'Cashier';
  static const String roleOperator = 'Operator';
  static const String roleDelivery = 'Delivery';

  static const List<String> employeeRoles = [
    roleManager,
    roleCashier,
    roleOperator,
    roleDelivery,
  ];

  // Stock Transaction Types
  static const String transactionTypePurchase = 'Purchase';
  static const String transactionTypeUsage = 'Usage';
  static const String transactionTypeAdjustment = 'Adjustment';

  static const List<String> transactionTypes = [
    transactionTypePurchase,
    transactionTypeUsage,
    transactionTypeAdjustment,
  ];

  // Expense Categories
  static const String expenseCategoryRent = 'Rent';
  static const String expenseCategoryElectricity = 'Electricity';
  static const String expenseCategoryWater = 'Water';
  static const String expenseCategorySalary = 'Salary';
  static const String expenseCategorySupplies = 'Supplies';
  static const String expenseCategoryMaintenance = 'Maintenance';
  static const String expenseCategoryOther = 'Other';

  static const List<String> expenseCategories = [
    expenseCategoryRent,
    expenseCategoryElectricity,
    expenseCategoryWater,
    expenseCategorySalary,
    expenseCategorySupplies,
    expenseCategoryMaintenance,
    expenseCategoryOther,
  ];

  // Inventory Units
  static const String unitKilogram = 'kg';
  static const String unitLiter = 'liter';
  static const String unitPiece = 'piece';
  static const String unitBottle = 'bottle';
  static const String unitPacket = 'packet';

  static const List<String> inventoryUnits = [
    unitKilogram,
    unitLiter,
    unitPiece,
    unitBottle,
    unitPacket,
  ];

  // Date Formats
  static const String dateFormatDisplay = 'dd MMM yyyy';
  static const String dateFormatFull = 'dd MMMM yyyy';
  static const String dateFormatWithTime = 'dd MMM yyyy, hh:mm a';
  static const String dateFormatDatabase = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormatDateOnly = 'yyyy-MM-dd';
  static const String timeFormat = 'hh:mm a';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Paths
  static const String backupFolderName = 'backups';
  static const String receiptsFolderName = 'receipts';
  static const String reportsFolderName = 'reports';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // Number Formats
  static const int currencyDecimalPlaces = 2;
  static const String currencySymbol = '₹';

  // Dashboard Refresh Interval (in seconds)
  static const int dashboardRefreshInterval = 30;

  // Low Stock Threshold
  static const double defaultLowStockThreshold = 10.0;

  // Default Values
  static const int defaultDeliveryDays = 3;
  static const double defaultTaxRate = 18.0;
  static const double defaultRushOrderPremium = 50.0; // Percentage

  // Notification IDs
  static const int notificationIdOrderReady = 1;
  static const int notificationIdPaymentReminder = 2;
  static const int notificationIdLowStock = 3;
  static const int notificationIdDeliveryReminder = 4;

  // Shared Preferences Keys
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyLanguage = 'language';
  static const String prefKeyIsFirstLaunch = 'is_first_launch';
  static const String prefKeyLastBackupDate = 'last_backup_date';
  static const String prefKeyNotificationsEnabled = 'notifications_enabled';

  // Theme Modes
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';
  static const String themeModeSystem = 'system';

  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s-()]+$';
  static const String numberOnlyRegex = r'^[0-9]+$';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorDatabase = 'Database error. Please try again.';
  static const String errorInvalidInput = 'Invalid input. Please check your data.';
  static const String errorNotFound = 'Item not found.';
  static const String errorPermission = 'Permission denied.';

  // Success Messages
  static const String successSaved = 'Saved successfully!';
  static const String successUpdated = 'Updated successfully!';
  static const String successDeleted = 'Deleted successfully!';
  static const String successCreated = 'Created successfully!';

  // Confirmation Messages
  static const String confirmDelete = 'Are you sure you want to delete this item?';
  static const String confirmCancel = 'Are you sure you want to cancel this order?';
  static const String confirmLogout = 'Are you sure you want to logout?';

  // Animation Durations (in milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;
}
