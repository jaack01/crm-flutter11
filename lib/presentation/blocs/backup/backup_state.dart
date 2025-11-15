import 'package:equatable/equatable.dart';
import '../../../domain/entities/backup_info.dart';

abstract class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BackupInitial extends BackupState {
  const BackupInitial();
}

/// Loading state
class BackupLoading extends BackupState {
  const BackupLoading();
}

/// Backups loaded
class BackupsLoaded extends BackupState {
  final List<BackupInfo> backups;

  const BackupsLoaded(this.backups);

  @override
  List<Object?> get props => [backups];
}

/// Backup created
class BackupCreated extends BackupState {
  final BackupInfo backupInfo;

  const BackupCreated(this.backupInfo);

  @override
  List<Object?> get props => [backupInfo];
}

/// Backup restored
class BackupRestored extends BackupState {
  const BackupRestored();
}

/// Data exported
class DataExported extends BackupState {
  final String filePath;

  const DataExported(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Backup operation success
class BackupOperationSuccess extends BackupState {
  final String message;

  const BackupOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Backup error
class BackupError extends BackupState {
  final String message;

  const BackupError(this.message);

  @override
  List<Object?> get props => [message];
}
