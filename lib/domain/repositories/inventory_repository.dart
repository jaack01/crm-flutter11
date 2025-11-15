import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/inventory_item.dart';
import '../entities/stock_transaction.dart';

abstract class InventoryRepository {
  // Inventory Item operations
  Future<Either<Failure, List<InventoryItem>>> getAllInventoryItems();
  Future<Either<Failure, InventoryItem>> getInventoryItemById(int id);
  Future<Either<Failure, List<InventoryItem>>> getInventoryItemsByCategory(String category);
  Future<Either<Failure, List<InventoryItem>>> getLowStockItems();
  Future<Either<Failure, InventoryItem>> addInventoryItem(InventoryItem item);
  Future<Either<Failure, InventoryItem>> updateInventoryItem(InventoryItem item);
  Future<Either<Failure, void>> deleteInventoryItem(int id);
  Future<Either<Failure, int>> getInventoryItemCount();

  // Stock Transaction operations
  Future<Either<Failure, List<StockTransaction>>> getAllTransactions();
  Future<Either<Failure, List<StockTransaction>>> getTransactionsByItem(int inventoryItemId);
  Future<Either<Failure, List<StockTransaction>>> getTransactionsByType(String type);
  Future<Either<Failure, List<StockTransaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, StockTransaction>> addStockTransaction(StockTransaction transaction);
  Future<Either<Failure, void>> deleteStockTransaction(int id);

  // Stock management
  Future<Either<Failure, void>> updateStock(int inventoryItemId, double quantity);
  Future<Either<Failure, double>> getTotalStockValue();
}
