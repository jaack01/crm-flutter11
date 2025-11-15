import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

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

  // ============================================================================
  // Data Sources
  // ============================================================================

  // Will be added in Phase 2
  // Example:
  // getIt.registerLazySingleton<CustomerLocalDataSource>(
  //   () => CustomerLocalDataSourceImpl(databaseHelper: getIt()),
  // );

  // ============================================================================
  // Repositories
  // ============================================================================

  // Will be added in Phase 2
  // Example:
  // getIt.registerLazySingleton<CustomerRepository>(
  //   () => CustomerRepositoryImpl(localDataSource: getIt()),
  // );

  // ============================================================================
  // Use Cases
  // ============================================================================

  // Will be added in Phase 2
  // Example:
  // getIt.registerLazySingleton(() => GetCustomers(repository: getIt()));
  // getIt.registerLazySingleton(() => AddCustomer(repository: getIt()));

  // ============================================================================
  // BLoCs
  // ============================================================================

  // Will be added in Phase 2
  // Example:
  // getIt.registerFactory(
  //   () => CustomerBloc(
  //     getCustomers: getIt(),
  //     addCustomer: getIt(),
  //   ),
  // );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
