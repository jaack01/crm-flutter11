import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../blocs/customer/customer_bloc.dart';
import '../pages/splash/splash_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/customers/customers_page.dart';
import '../pages/customers/customer_form_page.dart';

class AppRouter {
  // Prevent instantiation
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String customers = '/customers';
  static const String customerDetail = '/customers/:id';
  static const String addCustomer = '/customers/add';
  static const String editCustomer = '/customers/edit/:id';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String addOrder = '/orders/add';
  static const String editOrder = '/orders/edit/:id';
  static const String payments = '/payments';
  static const String inventory = '/inventory';
  static const String employees = '/employees';
  static const String reports = '/reports';
  static const String settings = '/settings';

  /// Create GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      debugLogDiagnostics: true,
      routes: [
        // Splash Screen
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (BuildContext context, GoRouterState state) {
            return const SplashPage();
          },
        ),

        // Dashboard
        GoRoute(
          path: dashboard,
          name: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPage();
          },
        ),

        // Customers routes
        GoRoute(
          path: customers,
          name: 'customers',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<CustomerBloc>(
              create: (context) => getIt<CustomerBloc>(),
              child: const CustomersPage(),
            );
          },
        ),

        // Add Customer
        GoRoute(
          path: addCustomer,
          name: 'add_customer',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<CustomerBloc>(
              create: (context) => getIt<CustomerBloc>(),
              child: const CustomerFormPage(),
            );
          },
        ),

        // More routes will be added in future phases
      ],
      errorBuilder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Page not found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  state.uri.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(dashboard),
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
