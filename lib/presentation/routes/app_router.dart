import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../blocs/customer/customer_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/backup/backup_bloc.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/service/service_bloc.dart';
import '../blocs/payment/payment_bloc.dart';
import '../blocs/pricing/pricing_bloc.dart';
import '../pages/splash/splash_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/customers/customers_page.dart';
import '../pages/customers/customer_form_page.dart';
import '../pages/customers/customer_details_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/orders/create_order_page.dart';
import '../pages/orders/order_details_page.dart';
import '../pages/services/services_page.dart';
import '../pages/payments/payments_page.dart';
import '../pages/item_types/item_types_page.dart';
import '../pages/pricing/service_pricing_page.dart';
import '../pages/reports/reports_page.dart';

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
  static const String services = '/services';
  static const String itemTypes = '/item-types';
  static const String pricing = '/pricing';
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

        // Customer Details
        GoRoute(
          path: customerDetail,
          name: 'customer_detail',
          builder: (BuildContext context, GoRouterState state) {
            final customerId = int.parse(state.pathParameters['id']!);
            return MultiBlocProvider(
              providers: [
                BlocProvider<CustomerBloc>(
                  create: (context) => getIt<CustomerBloc>(),
                ),
                BlocProvider<OrderBloc>(
                  create: (context) => getIt<OrderBloc>(),
                ),
              ],
              child: CustomerDetailsPage(customerId: customerId),
            );
          },
        ),

        // Edit Customer
        GoRoute(
          path: editCustomer,
          name: 'edit_customer',
          builder: (BuildContext context, GoRouterState state) {
            final customerId = int.parse(state.pathParameters['id']!);
            return BlocProvider<CustomerBloc>(
              create: (context) => getIt<CustomerBloc>(),
              child: CustomerFormPage(customerId: customerId),
            );
          },
        ),

        // Settings
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<SettingsBloc>(
                  create: (context) => getIt<SettingsBloc>(),
                ),
                BlocProvider<BackupBloc>(
                  create: (context) => getIt<BackupBloc>(),
                ),
              ],
              child: const SettingsPage(),
            );
          },
        ),

        // Orders
        GoRoute(
          path: orders,
          name: 'orders',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<OrderBloc>(
              create: (context) => getIt<OrderBloc>(),
              child: const OrdersPage(),
            );
          },
        ),

        // Add Order
        GoRoute(
          path: addOrder,
          name: 'add_order',
          builder: (BuildContext context, GoRouterState state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<OrderBloc>(
                  create: (context) => getIt<OrderBloc>(),
                ),
                BlocProvider<CustomerBloc>(
                  create: (context) => getIt<CustomerBloc>(),
                ),
                BlocProvider<ServiceBloc>(
                  create: (context) => getIt<ServiceBloc>(),
                ),
                BlocProvider<PricingBloc>(
                  create: (context) => getIt<PricingBloc>(),
                ),
              ],
              child: const CreateOrderPage(),
            );
          },
        ),

        // Order Details
        GoRoute(
          path: orderDetail,
          name: 'order_detail',
          builder: (BuildContext context, GoRouterState state) {
            final idParam = state.pathParameters['id'];
            final orderId = int.tryParse(idParam ?? '0') ?? 0;
            return BlocProvider<OrderBloc>(
              create: (context) => getIt<OrderBloc>(),
              child: OrderDetailsPage(orderId: orderId),
            );
          },
        ),

        // Services
        GoRoute(
          path: services,
          name: 'services',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<ServiceBloc>(
              create: (context) => getIt<ServiceBloc>(),
              child: const ServicesPage(),
            );
          },
        ),

        // Item Types
        GoRoute(
          path: itemTypes,
          name: 'item_types',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<ServiceBloc>(
              create: (context) => getIt<ServiceBloc>(),
              child: const ItemTypesPage(),
            );
          },
        ),

        // Service Pricing Matrix
        GoRoute(
          path: pricing,
          name: 'pricing',
          builder: (BuildContext context, GoRouterState state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<PricingBloc>(
                  create: (context) => getIt<PricingBloc>(),
                ),
                BlocProvider<ServiceBloc>(
                  create: (context) => getIt<ServiceBloc>(),
                ),
              ],
              child: const ServicePricingPage(),
            );
          },
        ),

        // Payments
        GoRoute(
          path: payments,
          name: 'payments',
          builder: (BuildContext context, GoRouterState state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<PaymentBloc>(
                  create: (context) => getIt<PaymentBloc>(),
                ),
                BlocProvider<OrderBloc>(
                  create: (context) => getIt<OrderBloc>(),
                ),
              ],
              child: const PaymentsPage(),
            );
          },
        ),

        // Reports & Analytics
        GoRoute(
          path: reports,
          name: 'reports',
          builder: (BuildContext context, GoRouterState state) {
            return const ReportsPage();
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
