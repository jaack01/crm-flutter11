# Phase 2 Implementation Guide

This document outlines the complete implementation of Phase 2 features. Due to the extensive nature of this phase, this serves as both documentation and implementation guide.

## Implementation Status

### ✅ Completed
- Domain entities (Customer, Service, ItemType, ServicePricing, Order, OrderItem, Payment)
- Repository interfaces for all domains
- Customer data model with JSON serialization

### 🚧 In Progress
- Data sources implementation
- Use cases creation
- BLoC state management
- UI components

## Data Layer Implementation

### Required Files

#### Data Models (lib/data/models/)
All models extend domain entities and add JSON serialization:

1. **customer_model.dart** ✅ - Created
2. **service_model.dart** - Extends Service entity
3. **item_type_model.dart** - Extends ItemType entity
4. **service_pricing_model.dart** - Extends ServicePricing entity
5. **order_model.dart** - Extends Order entity
6. **order_item_model.dart** - Extends OrderItem entity
7. **payment_model.dart** - Extends Payment entity

Each model must implement:
- `fromJson()` - Convert from database Map
- `toJson()` - Convert to database Map
- `fromEntity()` - Convert from domain entity
- `toEntity()` - Convert to domain entity

#### Data Sources (lib/data/datasources/local/)

1. **customer_local_datasource.dart**
   - getAllCustomers()
   - getCustomerById(id)
   - getCustomerByPhone(phone)
   - searchCustomers(query)
   - insertCustomer(customer)
   - updateCustomer(customer)
   - deleteCustomer(id)
   - generateNextCustomerCode()

2. **service_local_datasource.dart**
   - Service CRUD operations
   - ItemType CRUD operations
   - ServicePricing CRUD operations
   - getPricingMatrix()

3. **order_local_datasource.dart**
   - Order CRUD operations with transaction support
   - OrderItem CRUD operations
   - Status updates
   - Statistics queries (revenue, counts)
   - generateNextOrderNumber()

4. **payment_local_datasource.dart**
   - Payment CRUD operations
   - Payment aggregations
   - Payment history queries

#### Repository Implementations (lib/data/repositories/)

1. **customer_repository_impl.dart**
   - Implements CustomerRepository interface
   - Uses CustomerLocalDataSource
   - Handles error mapping to Failures
   - Returns Either<Failure, T>

2. **service_repository_impl.dart**
   - Implements ServiceRepository interface
   - Manages services, item types, and pricing

3. **order_repository_impl.dart**
   - Implements OrderRepository interface
   - Handles complex order creation with items
   - Manages transactions

4. **payment_repository_impl.dart**
   - Implements PaymentRepository interface
   - Updates order payment status

## Domain Layer - Use Cases

### Customer Use Cases (lib/domain/usecases/customer/)

1. **get_all_customers.dart**
2. **get_customer_by_id.dart**
3. **search_customers.dart**
4. **add_customer.dart**
5. **update_customer.dart**
6. **delete_customer.dart**

Pattern:
```dart
class GetAllCustomers {
  final CustomerRepository repository;

  GetAllCustomers(this.repository);

  Future<Either<Failure, List<Customer>>> call() {
    return repository.getAllCustomers();
  }
}
```

### Service Use Cases (lib/domain/usecases/service/)

1. **get_all_services.dart**
2. **get_all_item_types.dart**
3. **get_service_pricing.dart**
4. **add_service.dart**
5. **add_item_type.dart**
6. **update_service_pricing.dart**

### Order Use Cases (lib/domain/usecases/order/)

1. **get_all_orders.dart**
2. **get_order_by_id.dart**
3. **create_order.dart**
4. **update_order_status.dart**
5. **get_orders_by_status.dart**
6. **calculate_order_total.dart**

### Payment Use Cases (lib/domain/usecases/payment/)

1. **add_payment.dart**
2. **get_payments_by_order.dart**
3. **get_payment_history.dart**

## Presentation Layer - BLoC

### Customer BLoC (lib/presentation/blocs/customer/)

**customer_event.dart:**
```dart
abstract class CustomerEvent extends Equatable {}

class LoadCustomers extends CustomerEvent {}
class SearchCustomers extends CustomerEvent {
  final String query;
}
class AddCustomer extends CustomerEvent {
  final Customer customer;
}
class UpdateCustomer extends CustomerEvent {
  final Customer customer;
}
class DeleteCustomer extends CustomerEvent {
  final int id;
}
```

**customer_state.dart:**
```dart
abstract class CustomerState extends Equatable {}

class CustomerInitial extends CustomerState {}
class CustomerLoading extends CustomerState {}
class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
}
class CustomerError extends CustomerState {
  final String message;
}
class CustomerOperationSuccess extends CustomerState {
  final String message;
}
```

**customer_bloc.dart:**
- Maps events to states
- Calls use cases
- Handles errors

### Service BLoC
Similar structure for services, item types, and pricing

### Order BLoC
Manages order creation, updates, and tracking

### Common BLoC Pattern
All BLoCs follow the same pattern:
1. Define Events
2. Define States
3. Implement BLoC with event handlers
4. Use dependency injection

## Presentation Layer - UI

### Pages Structure

#### Customers Module (lib/presentation/pages/customers/)

1. **customers_page.dart**
   - List view with search bar
   - Customer cards showing name, phone, type
   - Floating action button to add new customer
   - Pull to refresh
   - Search and filter options
   - Navigate to customer details

2. **customer_form_page.dart**
   - Form for add/edit customer
   - Fields: name, phone, email, address, type
   - Validation
   - Image picker for photo
   - Save button

3. **customer_details_page.dart**
   - Customer information display
   - Order history
   - Payment history
   - Edit and delete options
   - Loyalty points display

#### Services Module (lib/presentation/pages/services/)

1. **services_page.dart**
   - Tab view: Services | Item Types | Pricing
   - List of services with edit/delete
   - Add new service

2. **service_pricing_page.dart**
   - Matrix view of pricing
   - Service x Item Type grid
   - Quick edit pricing
   - Rush pricing configuration

#### Orders Module (lib/presentation/pages/orders/)

1. **orders_page.dart**
   - List with status chips
   - Filter by status, date
   - Search by order number, customer
   - Color-coded by status

2. **create_order_page.dart**
   - Multi-step wizard:
     - Step 1: Select customer
     - Step 2: Add items (service + item type + quantity)
     - Step 3: Review and pricing
     - Step 4: Payment and delivery date
   - Real-time total calculation
   - Save as draft option

3. **order_details_page.dart**
   - Order information
   - Items list
   - Status timeline
   - Payment information
   - Actions: Update status, Add payment, Print

4. **order_tracking_page.dart**
   - Visual status indicator
   - Expected delivery date
   - Update status dialog

### Common Widgets (lib/presentation/widgets/common/)

1. **custom_text_field.dart**
   - Styled text input with validation

2. **custom_dropdown.dart**
   - Dropdown with search

3. **loading_indicator.dart**
   - Consistent loading animation

4. **error_widget.dart**
   - Error display with retry

5. **empty_state_widget.dart**
   - Empty list placeholder

6. **customer_card.dart**
   - Reusable customer display card

7. **order_card.dart**
   - Reusable order display card

8. **status_chip.dart**
   - Color-coded status badges

9. **stats_card.dart**
   - Dashboard statistics display

10. **custom_app_bar.dart**
    - Reusable app bar with search

## Navigation Updates

Update **app_router.dart** to include:

```dart
// Customers
GoRoute(
  path: '/customers',
  builder: (context, state) => const CustomersPage(),
),
GoRoute(
  path: '/customers/add',
  builder: (context, state) => const CustomerFormPage(),
),
GoRoute(
  path: '/customers/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return CustomerDetailsPage(customerId: id);
  },
),

// Orders
GoRoute(
  path: '/orders',
  builder: (context, state) => const OrdersPage(),
),
GoRoute(
  path: '/orders/create',
  builder: (context, state) => const CreateOrderPage(),
),
GoRoute(
  path: '/orders/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return OrderDetailsPage(orderId: id);
  },
),

// Services
GoRoute(
  path: '/services',
  builder: (context, state) => const ServicesPage(),
),
```

## Dependency Injection Updates

Update **injection_container.dart**:

```dart
// Data Sources
getIt.registerLazySingleton<CustomerLocalDataSource>(
  () => CustomerLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<ServiceLocalDataSource>(
  () => ServiceLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<OrderLocalDataSource>(
  () => OrderLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<PaymentLocalDataSource>(
  () => PaymentLocalDataSourceImpl(databaseHelper: getIt()),
);

// Repositories
getIt.registerLazySingleton<CustomerRepository>(
  () => CustomerRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton<ServiceRepository>(
  () => ServiceRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton<OrderRepository>(
  () => OrderRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton<PaymentRepository>(
  () => PaymentRepositoryImpl(localDataSource: getIt()),
);

// Use Cases - Customer
getIt.registerLazySingleton(() => GetAllCustomers(getIt()));
getIt.registerLazySingleton(() => GetCustomerById(getIt()));
getIt.registerLazySingleton(() => SearchCustomers(getIt()));
getIt.registerLazySingleton(() => AddCustomer(getIt()));
getIt.registerLazySingleton(() => UpdateCustomer(getIt()));
getIt.registerLazySingleton(() => DeleteCustomer(getIt()));

// Use Cases - Service
getIt.registerLazySingleton(() => GetAllServices(getIt()));
getIt.registerLazySingleton(() => GetAllItemTypes(getIt()));
getIt.registerLazySingleton(() => GetServicePricing(getIt()));

// Use Cases - Order
getIt.registerLazySingleton(() => GetAllOrders(getIt()));
getIt.registerLazySingleton(() => CreateOrder(getIt()));
getIt.registerLazySingleton(() => UpdateOrderStatus(getIt()));

// Use Cases - Payment
getIt.registerLazySingleton(() => AddPayment(getIt()));
getIt.registerLazySingleton(() => GetPaymentsByOrder(getIt()));

// BLoCs
getIt.registerFactory(
  () => CustomerBloc(
    getAllCustomers: getIt(),
    searchCustomers: getIt(),
    addCustomer: getIt(),
    updateCustomer: getIt(),
    deleteCustomer: getIt(),
  ),
);
getIt.registerFactory(
  () => ServiceBloc(
    getAllServices: getIt(),
    getAllItemTypes: getIt(),
    getServicePricing: getIt(),
  ),
);
getIt.registerFactory(
  () => OrderBloc(
    getAllOrders: getIt(),
    createOrder: getIt(),
    updateOrderStatus: getIt(),
  ),
);
```

## Testing Strategy

### Unit Tests
- Test all use cases
- Test repository implementations
- Test data source operations
- Mock database operations

### Widget Tests
- Test individual widgets
- Test form validation
- Test user interactions

### Integration Tests
- Test complete workflows
- Test navigation
- Test state management

## Best Practices

1. **Error Handling**
   - Always wrap database operations in try-catch
   - Return proper Failure types
   - Display user-friendly error messages

2. **State Management**
   - Keep BLoCs focused and single-purpose
   - Use proper event naming
   - Emit appropriate states for all scenarios

3. **UI/UX**
   - Show loading states
   - Provide feedback for actions
   - Use consistent styling
   - Implement proper validation

4. **Performance**
   - Use pagination for large lists
   - Implement search debouncing
   - Cache frequently used data
   - Optimize database queries with indexes

## Next Steps

1. Implement remaining data models
2. Create data sources
3. Implement repository implementations
4. Create all use cases
5. Implement BLoCs
6. Build UI pages
7. Wire up dependency injection
8. Test all features
9. Fix bugs and refine UX

## Estimated Completion Time

- Data Layer: 4-6 hours
- Use Cases: 2-3 hours
- BLoC Layer: 4-6 hours
- UI Layer: 8-12 hours
- Testing & Debugging: 4-6 hours

**Total: 22-33 hours** (Full Phase 2 implementation)

## Simplified Implementation for Demo

For a working demo, prioritize:
1. Customer list and add customer
2. Simple order creation
3. Basic dashboard with stats
4. Navigation between modules

This can be achieved in 6-8 hours and will demonstrate the full architecture.
