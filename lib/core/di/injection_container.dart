import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';
import '../services/statistics_service.dart';
import '../services/analytics_service.dart';
import '../services/pdf_service.dart';

// Customer
import '../../data/datasources/local/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/customer/customer_usecases.dart';
import '../../presentation/blocs/customer/customer_bloc.dart';

// Settings
import '../../data/datasources/local/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/settings/get_shop_settings.dart';
import '../../domain/usecases/settings/update_shop_settings.dart';
import '../../domain/usecases/settings/get_notification_settings.dart';
import '../../domain/usecases/settings/update_notification_settings.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';

// Notifications
import '../../data/datasources/local/notification_local_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';

// Backup
import '../../data/datasources/local/backup_local_datasource.dart';
import '../../data/repositories/backup_repository_impl.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/usecases/backup/create_backup.dart';
import '../../domain/usecases/backup/restore_backup.dart';
import '../../domain/usecases/backup/get_all_backups.dart';
import '../../presentation/blocs/backup/backup_bloc.dart';

// Order
import '../../data/datasources/local/order_local_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/order/get_all_orders.dart';
import '../../domain/usecases/order/get_order_by_id.dart';
import '../../domain/usecases/order/get_orders_by_customer.dart';
import '../../domain/usecases/order/get_orders_by_status.dart';
import '../../domain/usecases/order/search_orders.dart';
import '../../domain/usecases/order/add_order.dart';
import '../../domain/usecases/order/update_order.dart';
import '../../domain/usecases/order/update_order_status.dart';
import '../../presentation/blocs/order/order_bloc.dart';

// Service
import '../../data/datasources/local/service_local_datasource.dart';
import '../../data/datasources/local/item_type_local_datasource.dart';
import '../../data/datasources/local/service_pricing_local_datasource.dart';
import '../../data/repositories/service_repository_impl.dart';
import '../../domain/repositories/service_repository.dart';

// Payment
import '../../data/datasources/local/payment_local_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/payment/get_all_payments.dart';
import '../../domain/usecases/payment/get_payments_by_order.dart';
import '../../domain/usecases/payment/add_payment.dart';
import '../../presentation/blocs/payment/payment_bloc.dart';

// Service Use Cases
import '../../domain/usecases/service/get_all_services.dart';
import '../../domain/usecases/service/get_service_by_id.dart';
import '../../domain/usecases/service/add_service.dart';
import '../../domain/usecases/service/update_service.dart';
import '../../presentation/blocs/service/service_bloc.dart';

// Pricing Use Cases
import '../../domain/usecases/pricing/get_all_service_pricing.dart';
import '../../domain/usecases/pricing/get_service_pricing.dart';
import '../../domain/usecases/pricing/get_pricing_by_service.dart';
import '../../domain/usecases/pricing/get_pricing_by_item_type.dart';
import '../../domain/usecases/pricing/add_service_pricing.dart';
import '../../domain/usecases/pricing/update_service_pricing.dart';
import '../../domain/usecases/pricing/delete_service_pricing.dart';
import '../../presentation/blocs/pricing/pricing_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // ============================================================================
  // Core
  // ============================================================================

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Shared Preferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Notification Service
  getIt.registerLazySingleton<NotificationService>(() => NotificationService.instance);
  await getIt<NotificationService>().initialize();

  // Statistics Service
  getIt.registerLazySingleton<StatisticsService>(
    () => StatisticsService(databaseHelper: getIt()),
  );

  // Analytics Service
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(databaseHelper: getIt()),
  );

  // PDF Service
  getIt.registerLazySingleton<PdfService>(() => PdfService());

  // ============================================================================
  // Data Sources
  // ============================================================================

  // Customer
  getIt.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Settings
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Notifications
  getIt.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Backup
  getIt.registerLazySingleton<BackupLocalDataSource>(
    () => BackupLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Order
  getIt.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Service
  getIt.registerLazySingleton<ServiceLocalDataSource>(
    () => ServiceLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Item Type
  getIt.registerLazySingleton<ItemTypeLocalDataSource>(
    () => ItemTypeLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Service Pricing
  getIt.registerLazySingleton<ServicePricingLocalDataSource>(
    () => ServicePricingLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // Payment
  getIt.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  // Customer
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(localDataSource: getIt()),
  );

  // Settings
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: getIt()),
  );

  // Notifications
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      localDataSource: getIt(),
      notificationsPlugin: getIt<NotificationService>().plugin,
    ),
  );

  // Backup
  getIt.registerLazySingleton<BackupRepository>(
    () => BackupRepositoryImpl(localDataSource: getIt()),
  );

  // Order
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: getIt()),
  );

  // Service
  getIt.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(
      localDataSource: getIt(),
      itemTypeLocalDataSource: getIt(),
      servicePricingLocalDataSource: getIt(),
    ),
  );

  // Payment
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(localDataSource: getIt()),
  );

  // ============================================================================
  // Use Cases
  // ============================================================================

  // Customer
  getIt.registerLazySingleton(() => GetAllCustomers(getIt()));
  getIt.registerLazySingleton(() => GetCustomerById(getIt()));
  getIt.registerLazySingleton(() => SearchCustomers(getIt()));
  getIt.registerLazySingleton(() => GetCustomersByType(getIt()));
  getIt.registerLazySingleton(() => AddCustomer(getIt()));
  getIt.registerLazySingleton(() => UpdateCustomer(getIt()));
  getIt.registerLazySingleton(() => DeleteCustomer(getIt()));
  getIt.registerLazySingleton(() => GetCustomerCount(getIt()));

  // Settings
  getIt.registerLazySingleton(() => GetShopSettings(getIt()));
  getIt.registerLazySingleton(() => UpdateShopSettings(getIt()));
  getIt.registerLazySingleton(() => GetNotificationSettings(getIt()));
  getIt.registerLazySingleton(() => UpdateNotificationSettings(getIt()));

  // Backup
  getIt.registerLazySingleton(() => CreateBackup(getIt()));
  getIt.registerLazySingleton(() => RestoreBackup(getIt()));
  getIt.registerLazySingleton(() => GetAllBackups(getIt()));

  // Order
  getIt.registerLazySingleton(() => GetAllOrders(getIt()));
  getIt.registerLazySingleton(() => GetOrderById(getIt()));
  getIt.registerLazySingleton(() => GetOrdersByCustomer(getIt()));
  getIt.registerLazySingleton(() => GetOrdersByStatus(getIt()));
  getIt.registerLazySingleton(() => SearchOrders(getIt()));
  getIt.registerLazySingleton(() => AddOrder(getIt()));
  getIt.registerLazySingleton(() => UpdateOrder(getIt()));
  getIt.registerLazySingleton(() => UpdateOrderStatus(getIt()));

  // Service
  getIt.registerLazySingleton(() => GetAllServices(getIt()));
  getIt.registerLazySingleton(() => GetServiceById(getIt()));
  getIt.registerLazySingleton(() => AddService(getIt()));
  getIt.registerLazySingleton(() => UpdateService(getIt()));

  // Pricing
  getIt.registerLazySingleton(() => GetAllServicePricing(getIt()));
  getIt.registerLazySingleton(() => GetServicePricing(getIt()));
  getIt.registerLazySingleton(() => GetPricingByService(getIt()));
  getIt.registerLazySingleton(() => GetPricingByItemType(getIt()));
  getIt.registerLazySingleton(() => AddServicePricing(getIt()));
  getIt.registerLazySingleton(() => UpdateServicePricing(getIt()));
  getIt.registerLazySingleton(() => DeleteServicePricing(getIt()));

  // Payment
  getIt.registerLazySingleton(() => GetAllPayments(getIt()));
  getIt.registerLazySingleton(() => GetPaymentsByOrder(getIt()));
  getIt.registerLazySingleton(() => AddPayment(getIt()));

  // ============================================================================
  // BLoCs
  // ============================================================================

  // Customer BLoC
  getIt.registerFactory(
    () => CustomerBloc(
      getAllCustomers: getIt(),
      getCustomerById: getIt(),
      searchCustomers: getIt(),
      getCustomersByType: getIt(),
      addCustomer: getIt(),
      updateCustomer: getIt(),
      deleteCustomer: getIt(),
    ),
  );

  // Settings BLoC
  getIt.registerFactory(
    () => SettingsBloc(
      getShopSettings: getIt(),
      updateShopSettings: getIt(),
      getNotificationSettings: getIt(),
      updateNotificationSettings: getIt(),
    ),
  );

  // Backup BLoC
  getIt.registerFactory(
    () => BackupBloc(
      createBackup: getIt(),
      restoreBackup: getIt(),
      getAllBackups: getIt(),
    ),
  );

  // Order BLoC
  getIt.registerFactory(
    () => OrderBloc(
      getAllOrders: getIt(),
      getOrderById: getIt(),
      getOrdersByStatus: getIt(),
      searchOrders: getIt(),
      addOrder: getIt(),
      updateOrder: getIt(),
      updateOrderStatus: getIt(),
    ),
  );

  // Service BLoC
  getIt.registerFactory(
    () => ServiceBloc(
      getAllServices: getIt(),
      getServiceById: getIt(),
      addService: getIt(),
      updateService: getIt(),
    ),
  );

  // Pricing BLoC
  getIt.registerFactory(
    () => PricingBloc(
      getAllServicePricing: getIt(),
      getServicePricing: getIt(),
      getPricingByService: getIt(),
      getPricingByItemType: getIt(),
      addServicePricing: getIt(),
      updateServicePricing: getIt(),
      deleteServicePricing: getIt(),
    ),
  );

  // Payment BLoC
  getIt.registerFactory(
    () => PaymentBloc(
      getAllPayments: getIt(),
      getPaymentsByOrder: getIt(),
      addPayment: getIt(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
