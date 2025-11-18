import 'package:equatable/equatable.dart';

/// Revenue analytics data
class RevenueAnalytics extends Equatable {
  final double totalRevenue;
  final double paidAmount;
  final double pendingAmount;
  final int totalOrders;
  final double averageOrderValue;

  const RevenueAnalytics({
    required this.totalRevenue,
    required this.paidAmount,
    required this.pendingAmount,
    required this.totalOrders,
    required this.averageOrderValue,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        paidAmount,
        pendingAmount,
        totalOrders,
        averageOrderValue,
      ];
}

/// Service popularity data
class ServicePopularity extends Equatable {
  final String serviceName;
  final int orderCount;
  final double revenue;
  final double percentage;

  const ServicePopularity({
    required this.serviceName,
    required this.orderCount,
    required this.revenue,
    required this.percentage,
  });

  @override
  List<Object?> get props => [serviceName, orderCount, revenue, percentage];
}

/// Order status breakdown
class OrderStatusBreakdown extends Equatable {
  final String status;
  final int count;
  final double percentage;

  const OrderStatusBreakdown({
    required this.status,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [status, count, percentage];
}

/// Payment status breakdown
class PaymentStatusBreakdown extends Equatable {
  final String status;
  final int count;
  final double amount;
  final double percentage;

  const PaymentStatusBreakdown({
    required this.status,
    required this.count,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [status, count, amount, percentage];
}

/// Customer analytics
class CustomerAnalytics extends Equatable {
  final int totalCustomers;
  final int activeCustomers;
  final int newCustomers;
  final int vipCustomers;
  final double averageCustomerValue;
  final Map<String, int> customersByType;

  const CustomerAnalytics({
    required this.totalCustomers,
    required this.activeCustomers,
    required this.newCustomers,
    required this.vipCustomers,
    required this.averageCustomerValue,
    required this.customersByType,
  });

  @override
  List<Object?> get props => [
        totalCustomers,
        activeCustomers,
        newCustomers,
        vipCustomers,
        averageCustomerValue,
        customersByType,
      ];
}

/// Daily revenue data point
class DailyRevenue extends Equatable {
  final DateTime date;
  final double revenue;
  final int orderCount;

  const DailyRevenue({
    required this.date,
    required this.revenue,
    required this.orderCount,
  });

  @override
  List<Object?> get props => [date, revenue, orderCount];
}

/// Complete analytics report
class AnalyticsReport extends Equatable {
  final RevenueAnalytics revenueAnalytics;
  final List<ServicePopularity> servicePopularity;
  final List<OrderStatusBreakdown> orderStatusBreakdown;
  final List<PaymentStatusBreakdown> paymentStatusBreakdown;
  final CustomerAnalytics customerAnalytics;
  final List<DailyRevenue> dailyRevenue;
  final DateTime generatedAt;

  const AnalyticsReport({
    required this.revenueAnalytics,
    required this.servicePopularity,
    required this.orderStatusBreakdown,
    required this.paymentStatusBreakdown,
    required this.customerAnalytics,
    required this.dailyRevenue,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        revenueAnalytics,
        servicePopularity,
        orderStatusBreakdown,
        paymentStatusBreakdown,
        customerAnalytics,
        dailyRevenue,
        generatedAt,
      ];
}
