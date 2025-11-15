import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../../data/datasources/local/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/customer/customer_usecases.dart';
import '../../presentation/blocs/customer/customer_bloc.dart';

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

  // Customer
  getIt.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  // Customer
  getIt.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(localDataSource: getIt()),
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
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
