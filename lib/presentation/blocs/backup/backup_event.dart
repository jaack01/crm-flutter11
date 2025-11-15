import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

/// Load all backups
class LoadBackups extends BackupEvent {
  const LoadBackups();
}

/// Create new backup
class CreateBackupEvent extends BackupEvent {
  final String? notes;
  final bool isAutoBackup;

  const CreateBackupEvent({this.notes, this.isAutoBackup = false});

  @override
  List<Object?> get props => [notes, isAutoBackup];
}

/// Restore from backup
class RestoreBackupEvent extends BackupEvent {
  final String filePath;

  const RestoreBackupEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Delete backup
class DeleteBackupEvent extends BackupEvent {
  final int id;

  const DeleteBackupEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Export data to JSON
class ExportDataEvent extends BackupEvent {
  const ExportDataEvent();
}
