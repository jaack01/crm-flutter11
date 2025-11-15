import 'package:equatable/equatable.dart';

/// Backup information entity for data backup/restore
class BackupInfo extends Equatable {
  final int? id;
  final String fileName;
  final String filePath;
  final DateTime backupDate;
  final int fileSize;
  final String backupType;
  final int customersCount;
  final int ordersCount;
  final int itemsCount;
  final String? notes;
  final bool isAutoBackup;

  const BackupInfo({
    this.id,
    required this.fileName,
    required this.filePath,
    required this.backupDate,
    required this.fileSize,
    this.backupType = 'full',
    this.customersCount = 0,
    this.ordersCount = 0,
    this.itemsCount = 0,
    this.notes,
    this.isAutoBackup = false,
  });

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  BackupInfo copyWith({
    int? id,
    String? fileName,
    String? filePath,
    DateTime? backupDate,
    int? fileSize,
    String? backupType,
    int? customersCount,
    int? ordersCount,
    int? itemsCount,
    String? notes,
    bool? isAutoBackup,
  }) {
    return BackupInfo(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      backupDate: backupDate ?? this.backupDate,
      fileSize: fileSize ?? this.fileSize,
      backupType: backupType ?? this.backupType,
      customersCount: customersCount ?? this.customersCount,
      ordersCount: ordersCount ?? this.ordersCount,
      itemsCount: itemsCount ?? this.itemsCount,
      notes: notes ?? this.notes,
      isAutoBackup: isAutoBackup ?? this.isAutoBackup,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        filePath,
        backupDate,
        fileSize,
        backupType,
        customersCount,
        ordersCount,
        itemsCount,
        notes,
        isAutoBackup,
      ];
}

/// Backup types
class BackupType {
  static const String full = 'full';
  static const String incremental = 'incremental';
  static const String manual = 'manual';
  static const String automatic = 'automatic';
}
