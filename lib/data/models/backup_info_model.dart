import '../../domain/entities/backup_info.dart';

class BackupInfoModel extends BackupInfo {
  const BackupInfoModel({
    super.id,
    required super.fileName,
    required super.filePath,
    required super.backupDate,
    required super.fileSize,
    super.backupType,
    super.customersCount,
    super.ordersCount,
    super.itemsCount,
    super.notes,
    super.isAutoBackup,
  });

  factory BackupInfoModel.fromJson(Map<String, dynamic> json) {
    return BackupInfoModel(
      id: json['id'] as int?,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      backupDate: DateTime.parse(json['backup_date'] as String),
      fileSize: json['file_size'] as int,
      backupType: json['backup_type'] as String? ?? 'full',
      customersCount: json['customers_count'] as int? ?? 0,
      ordersCount: json['orders_count'] as int? ?? 0,
      itemsCount: json['items_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      isAutoBackup: (json['is_auto_backup'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'file_name': fileName,
      'file_path': filePath,
      'backup_date': backupDate.toIso8601String(),
      'file_size': fileSize,
      'backup_type': backupType,
      'customers_count': customersCount,
      'orders_count': ordersCount,
      'items_count': itemsCount,
      'notes': notes,
      'is_auto_backup': isAutoBackup ? 1 : 0,
    };
  }

  BackupInfo toEntity() {
    return BackupInfo(
      id: id,
      fileName: fileName,
      filePath: filePath,
      backupDate: backupDate,
      fileSize: fileSize,
      backupType: backupType,
      customersCount: customersCount,
      ordersCount: ordersCount,
      itemsCount: itemsCount,
      notes: notes,
      isAutoBackup: isAutoBackup,
    );
  }

  factory BackupInfoModel.fromEntity(BackupInfo entity) {
    return BackupInfoModel(
      id: entity.id,
      fileName: entity.fileName,
      filePath: entity.filePath,
      backupDate: entity.backupDate,
      fileSize: entity.fileSize,
      backupType: entity.backupType,
      customersCount: entity.customersCount,
      ordersCount: entity.ordersCount,
      itemsCount: entity.itemsCount,
      notes: entity.notes,
      isAutoBackup: entity.isAutoBackup,
    );
  }
}
