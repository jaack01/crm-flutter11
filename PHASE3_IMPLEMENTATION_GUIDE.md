# Phase 3 Implementation Guide - Advanced Features

## Overview

Phase 3 builds upon the solid foundation from Phases 1 and 2, adding Inventory Management, Employee Management, and comprehensive Reports & Analytics. This document provides the complete blueprint for implementation.

## ✅ Domain Layer - COMPLETED

The following domain entities and repositories have been created:

### Entities Created
1. **InventoryItem** (`lib/domain/entities/inventory_item.dart`)
   - Complete inventory item with stock tracking
   - Low stock detection
   - Stock status helpers

2. **StockTransaction** (`lib/domain/entities/stock_transaction.dart`)
   - Purchase, Usage, Adjustment tracking
   - Reference to orders or purchase records

3. **Employee** (`lib/domain/entities/employee.dart`)
   - Employee information with roles
   - Salary and commission tracking

4. **Expense** (`lib/domain/entities/expense.dart`)
   - Business expense tracking
   - Category-based organization

5. **DashboardStatistics** (`lib/domain/entities/dashboard_statistics.dart`)
   - Comprehensive dashboard metrics
   - Real-time business insights

### Repository Interfaces Created
1. **InventoryRepository** - 16 operations for inventory and stock management
2. **EmployeeRepository** - 8 operations for employee management
3. **StatisticsRepository** - 6 operations for reports and analytics

---

## 📋 Implementation Roadmap

### Module 1: Inventory Management

#### Data Layer

**Files to Create:**

1. `lib/data/models/inventory_item_model.dart`
```dart
class InventoryItemModel extends InventoryItem {
  // JSON serialization
  factory InventoryItemModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  InventoryItem toEntity();
}
```

2. `lib/data/models/stock_transaction_model.dart`
```dart
class StockTransactionModel extends StockTransaction {
  // JSON serialization with item details
  factory StockTransactionModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

3. `lib/data/datasources/local/inventory_local_datasource.dart`
```dart
abstract class InventoryLocalDataSource {
  // Inventory CRUD
  Future<List<InventoryItemModel>> getAllInventoryItems();
  Future<InventoryItemModel> getInventoryItemById(int id);
  Future<List<InventoryItemModel>> getLowStockItems();
  Future<int> insertInventoryItem(InventoryItemModel item);
  Future<int> updateInventoryItem(InventoryItemModel item);

  // Stock Transactions
  Future<List<StockTransactionModel>> getAllTransactions();
  Future<int> insertStockTransaction(StockTransactionModel transaction);
  Future<void> updateStock(int itemId, double quantity);

  // Code generation
  Future<String> generateNextItemCode();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  // Implementation with proper error handling
  // Use transactions for stock updates
  // Query with JOINs for populated fields
}
```

4. `lib/data/repositories/inventory_repository_impl.dart`
```dart
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  // Implement all 16 methods
  // Handle stock transactions atomically
  // Update inventory quantities correctly
}
```

#### Use Cases

**File:** `lib/domain/usecases/inventory/inventory_usecases.dart`

```dart
// Inventory Operations
class GetAllInventoryItems { }
class GetInventoryItemById { }
class GetLowStockItems { }
class AddInventoryItem { }
class UpdateInventoryItem { }
class DeleteInventoryItem { }

// Stock Transactions
class GetAllStockTransactions { }
class GetTransactionsByItem { }
class AddStockTransaction { }
class RecordStockPurchase { }
class RecordStockUsage { }
class AdjustStock { }
```

#### BLoC Layer

**Files:**
- `lib/presentation/blocs/inventory/inventory_event.dart`
- `lib/presentation/blocs/inventory/inventory_state.dart`
- `lib/presentation/blocs/inventory/inventory_bloc.dart`

**Events:**
```dart
LoadInventoryItems
LoadLowStockItems
SearchInventoryItems(query)
AddInventoryItem(item)
UpdateInventoryItem(item)
DeleteInventoryItem(id)
RecordStockTransaction(transaction)
```

**States:**
```dart
InventoryInitial
InventoryLoading
InventoryItemsLoaded(items)
LowStockItemsLoaded(items)
StockTransactionsLoaded(transactions)
InventoryOperationSuccess(message)
InventoryError(message)
```

#### UI Pages

1. **Inventory List Page** (`lib/presentation/pages/inventory/inventory_page.dart`)
   - List of all inventory items
   - Stock levels with visual indicators (green/yellow/red)
   - Low stock alerts
   - Search and filter
   - Categories tabs
   - Navigate to add/edit/transactions

2. **Add/Edit Inventory Form** (`lib/presentation/pages/inventory/inventory_form_page.dart`)
   - Item name, code, category
   - Unit selection dropdown
   - Current stock (for edit)
   - Minimum stock level
   - Unit price
   - Form validation

3. **Stock Transactions Page** (`lib/presentation/pages/inventory/stock_transactions_page.dart`)
   - List of all transactions
   - Filter by type (Purchase/Usage/Adjustment)
   - Filter by date range
   - Add new transaction
   - Transaction history per item

4. **Add Stock Transaction** (`lib/presentation/pages/inventory/add_stock_transaction_page.dart`)
   - Select inventory item
   - Transaction type selection
   - Quantity input
   - Notes
   - Automatic stock update

---

### Module 2: Employee Management

#### Data Layer

**Files to Create:**

1. `lib/data/models/employee_model.dart`
```dart
class EmployeeModel extends Employee {
  factory EmployeeModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

2. `lib/data/datasources/local/employee_local_datasource.dart`
```dart
abstract class EmployeeLocalDataSource {
  Future<List<EmployeeModel>> getAllEmployees();
  Future<EmployeeModel> getEmployeeById(int id);
  Future<List<EmployeeModel>> getEmployeesByRole(String role);
  Future<int> insertEmployee(EmployeeModel employee);
  Future<int> updateEmployee(EmployeeModel employee);
  Future<int> deleteEmployee(int id);
  Future<String> generateNextEmployeeCode();
}
```

3. `lib/data/repositories/employee_repository_impl.dart`

#### Use Cases

```dart
class GetAllEmployees { }
class GetEmployeeById { }
class GetEmployeesByRole { }
class AddEmployee { }
class UpdateEmployee { }
class DeleteEmployee { }
class GetEmployeeCount { }
```

#### BLoC Layer

Similar structure to CustomerBloc with employee-specific events and states.

#### UI Pages

1. **Employees List Page**
   - List with role badges
   - Contact information
   - Active/inactive status
   - Search and filter by role

2. **Add/Edit Employee Form**
   - Personal information
   - Role selection
   - Salary and commission
   - Joining date

---

### Module 3: Reports & Analytics

#### Data Layer

**Files:**

1. `lib/data/models/dashboard_statistics_model.dart`
2. `lib/data/datasources/local/statistics_local_datasource.dart`
```dart
abstract class StatisticsLocalDataSource {
  Future<DashboardStatisticsModel> getDashboardStatistics();
  Future<double> getRevenueByDateRange(DateTime start, DateTime end);
  Future<Map<String, int>> getOrdersCountByStatus();
  Future<Map<String, double>> getMonthlyRevenueTrend();
  // Complex aggregation queries
}
```

3. `lib/data/repositories/statistics_repository_impl.dart`

#### Use Cases

```dart
class GetDashboardStatistics { }
class GetRevenueReport { }
class GetOrdersReport { }
class GetCustomersReport { }
class GetMonthlyTrend { }
```

#### BLoC Layer

**DashboardBloc** or **StatisticsBloc**:
- Load statistics
- Refresh on demand
- Cache with TTL

#### UI Pages

1. **Updated Dashboard** (`lib/presentation/pages/dashboard/dashboard_page.dart`)
   - Real statistics from database
   - Refresh capability
   - Visual charts using fl_chart

2. **Reports Page** (`lib/presentation/pages/reports/reports_page.dart`)
   - Revenue reports
   - Orders by status (pie chart)
   - Monthly trends (line chart)
   - Top customers (bar chart)
   - Date range selector
   - Export to PDF/Excel

3. **Chart Widgets**
   - `lib/presentation/widgets/charts/revenue_chart.dart`
   - `lib/presentation/widgets/charts/orders_pie_chart.dart`
   - `lib/presentation/widgets/charts/monthly_trend_chart.dart`

---

## 🔧 Implementation Steps

### Step 1: Inventory Module (Week 5)

1. Create data models and datasources
2. Implement repository
3. Create use cases
4. Implement BLoC
5. Build UI pages
6. Wire up dependency injection
7. Add navigation routes
8. Test end-to-end

### Step 2: Employee Module (Week 5)

1. Follow same pattern as Customer module
2. Implement CRUD operations
3. Add role-based features
4. Test thoroughly

### Step 3: Dashboard & Reports (Week 6)

1. Implement statistics datasource
2. Create complex SQL queries for aggregations
3. Implement dashboard BLoC
4. Update dashboard with real data
5. Create reports page
6. Add charts using fl_chart
7. Implement export functionality

---

## 📊 Database Queries for Statistics

### Dashboard Statistics Query

```sql
-- Get comprehensive dashboard stats in one query
SELECT
  (SELECT COUNT(*) FROM customers WHERE is_active = 1) as total_customers,
  (SELECT COUNT(*) FROM orders) as total_orders,
  (SELECT COUNT(*) FROM orders WHERE status NOT IN ('Delivered', 'Cancelled')) as pending_orders,
  (SELECT COUNT(*) FROM orders WHERE status = 'Delivered') as completed_orders,
  (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(order_date) = DATE('now')) as today_revenue,
  (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE strftime('%Y-%m', order_date) = strftime('%Y-%m', 'now')) as month_revenue,
  (SELECT COALESCE(SUM(balance_amount), 0) FROM orders WHERE balance_amount > 0) as total_outstanding,
  (SELECT COUNT(*) FROM inventory_items WHERE current_stock <= min_stock_level AND is_active = 1) as low_stock_items,
  (SELECT COUNT(*) FROM employees WHERE is_active = 1) as active_employees
```

### Monthly Revenue Trend

```sql
SELECT
  strftime('%Y-%m', order_date) as month,
  SUM(total_amount) as revenue
FROM orders
WHERE order_date >= date('now', '-12 months')
GROUP BY month
ORDER BY month ASC
```

### Top Customers

```sql
SELECT
  c.id,
  c.customer_code,
  c.first_name || ' ' || COALESCE(c.last_name, '') as name,
  COUNT(o.id) as order_count,
  SUM(o.total_amount) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE c.is_active = 1
GROUP BY c.id
ORDER BY total_spent DESC
LIMIT 10
```

---

## 🎨 UI/UX Considerations

### Inventory Page
- **Color Coding**:
  - Green: In stock (current_stock > min_stock_level)
  - Yellow: Low stock (current_stock <= min_stock_level but > 0)
  - Red: Out of stock (current_stock <= 0)
- **Quick Actions**: Add stock, record usage
- **Alerts**: Low stock notifications

### Employee Page
- **Role Badges**: Color-coded by role
- **Commission Display**: Show commission rate for sales roles
- **Status Indicators**: Active/inactive visual feedback

### Reports Page
- **Interactive Charts**: Tap for details
- **Date Pickers**: Custom range selection
- **Export Options**: PDF, Excel, CSV
- **Refresh Button**: Update data on demand

---

## 🔗 Dependency Injection Updates

Update `lib/core/di/injection_container.dart`:

```dart
// Inventory
getIt.registerLazySingleton<InventoryLocalDataSource>(
  () => InventoryLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<InventoryRepository>(
  () => InventoryRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton(() => GetAllInventoryItems(getIt()));
getIt.registerFactory(() => InventoryBloc(...));

// Employee
getIt.registerLazySingleton<EmployeeLocalDataSource>(
  () => EmployeeLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<EmployeeRepository>(
  () => EmployeeRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton(() => GetAllEmployees(getIt()));
getIt.registerFactory(() => EmployeeBloc(...));

// Statistics
getIt.registerLazySingleton<StatisticsLocalDataSource>(
  () => StatisticsLocalDataSourceImpl(databaseHelper: getIt()),
);
getIt.registerLazySingleton<StatisticsRepository>(
  () => StatisticsRepositoryImpl(localDataSource: getIt()),
);
getIt.registerLazySingleton(() => GetDashboardStatistics(getIt()));
getIt.registerFactory(() => DashboardBloc(...));
```

---

## 🚀 Navigation Updates

Update `lib/presentation/routes/app_router.dart`:

```dart
// Inventory routes
GoRoute(
  path: '/inventory',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<InventoryBloc>(),
    child: const InventoryPage(),
  ),
),
GoRoute(
  path: '/inventory/add',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<InventoryBloc>(),
    child: const InventoryFormPage(),
  ),
),
GoRoute(
  path: '/inventory/transactions',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<InventoryBloc>(),
    child: const StockTransactionsPage(),
  ),
),

// Employee routes
GoRoute(
  path: '/employees',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<EmployeeBloc>(),
    child: const EmployeesPage(),
  ),
),

// Reports route
GoRoute(
  path: '/reports',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<DashboardBloc>(),
    child: const ReportsPage(),
  ),
),
```

---

## 📈 Testing Strategy

### Unit Tests
- Test inventory stock calculations
- Test transaction type handling
- Test statistics aggregations
- Mock database responses

### Integration Tests
- Test stock update flow
- Test employee CRUD
- Test dashboard data refresh

### Widget Tests
- Test inventory list rendering
- Test chart displays
- Test form validations

---

## 🎯 Success Criteria

### Inventory Management
- ✅ Add/edit/delete inventory items
- ✅ Record stock purchases
- ✅ Record stock usage
- ✅ Adjust stock levels
- ✅ Low stock alerts
- ✅ Stock value calculations

### Employee Management
- ✅ Add/edit/delete employees
- ✅ Role-based organization
- ✅ Salary tracking
- ✅ Commission management

### Reports & Analytics
- ✅ Real-time dashboard statistics
- ✅ Revenue reports
- ✅ Monthly trends
- ✅ Top customers analysis
- ✅ Visual charts
- ✅ Export functionality

---

## 💡 Best Practices

1. **Stock Transactions**: Always use database transactions when updating stock
2. **Statistics Caching**: Cache dashboard stats with 5-minute TTL
3. **Chart Performance**: Limit data points for large datasets
4. **Error Handling**: Gracefully handle aggregation failures
5. **User Feedback**: Show loading states for complex queries

---

## 🔄 Future Enhancements

- **Barcode Scanning**: For inventory items
- **Employee Attendance**: Track work hours
- **Advanced Analytics**: Predictive models
- **Automated Reordering**: When stock is low
- **Mobile Notifications**: For low stock and important events

---

## 📚 Resources

- [fl_chart Documentation](https://pub.dev/packages/fl_chart)
- [SQLite Aggregate Functions](https://www.sqlite.org/lang_aggfunc.html)
- [Flutter BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## ✅ Completion Checklist

- [ ] Inventory data layer implemented
- [ ] Employee data layer implemented
- [ ] Statistics data layer implemented
- [ ] All use cases created
- [ ] All BLoCs implemented
- [ ] All UI pages created
- [ ] Dependency injection updated
- [ ] Navigation routes added
- [ ] Tests written
- [ ] Documentation updated

---

**Estimated Time**: 2-3 weeks for complete implementation
**Complexity**: Medium-High
**Dependencies**: Phases 1 & 2 complete

This guide provides the complete blueprint. Follow the established patterns from Phase 2 (Customer Management) to implement each module systematically.
