import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/dashboard_statistics.dart';

abstract class StatisticsRepository {
  /// Get dashboard statistics
  Future<Either<Failure, DashboardStatistics>> getDashboardStatistics();

  /// Get revenue by date range
  Future<Either<Failure, double>> getRevenueByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get orders count by status
  Future<Either<Failure, Map<String, int>>> getOrdersCountByStatus();

  /// Get customers count by type
  Future<Either<Failure, Map<String, int>>> getCustomersCountByType();

  /// Get monthly revenue trend (last 12 months)
  Future<Either<Failure, Map<String, double>>> getMonthlyRevenueTrend();

  /// Get top customers by revenue
  Future<Either<Failure, List<Map<String, dynamic>>>> getTopCustomers({int limit = 10});
}
