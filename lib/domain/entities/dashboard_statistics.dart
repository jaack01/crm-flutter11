import 'package:equatable/equatable.dart';

class DashboardStatistics extends Equatable {
  final int totalCustomers;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final double todayRevenue;
  final double monthRevenue;
  final double totalOutstanding;
  final int lowStockItems;
  final int activeEmployees;

  const DashboardStatistics({
    this.totalCustomers = 0,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.todayRevenue = 0.0,
    this.monthRevenue = 0.0,
    this.totalOutstanding = 0.0,
    this.lowStockItems = 0,
    this.activeEmployees = 0,
  });

  @override
  List<Object?> get props => [
        totalCustomers,
        totalOrders,
        pendingOrders,
        completedOrders,
        todayRevenue,
        monthRevenue,
        totalOutstanding,
        lowStockItems,
        activeEmployees,
      ];
}
