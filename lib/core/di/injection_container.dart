import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';

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
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
