import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/backup/create_backup.dart';
import '../../../domain/usecases/backup/restore_backup.dart';
import '../../../domain/usecases/backup/get_all_backups.dart';
import 'backup_event.dart';
import 'backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final CreateBackup createBackup;
  final RestoreBackup restoreBackup;
  final GetAllBackups getAllBackups;

  BackupBloc({
    required this.createBackup,
    required this.restoreBackup,
    required this.getAllBackups,
  }) : super(const BackupInitial()) {
    on<LoadBackups>(_onLoadBackups);
    on<CreateBackupEvent>(_onCreateBackup);
    on<RestoreBackupEvent>(_onRestoreBackup);
  }

  Future<void> _onLoadBackups(
    LoadBackups event,
    Emitter<BackupState> emit,
  ) async {
    emit(const BackupLoading());

    final result = await getAllBackups();

    result.fold(
      (failure) => emit(BackupError(_mapFailureToMessage(failure))),
      (backups) => emit(BackupsLoaded(backups)),
    );
  }

  Future<void> _onCreateBackup(
    CreateBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(const BackupLoading());

    final result = await createBackup(
      notes: event.notes,
      isAutoBackup: event.isAutoBackup,
    );

    result.fold(
      (failure) => emit(BackupError(_mapFailureToMessage(failure))),
      (backupInfo) {
        emit(BackupCreated(backupInfo));
        emit(const BackupOperationSuccess('Backup created successfully'));
      },
    );
  }

  Future<void> _onRestoreBackup(
    RestoreBackupEvent event,
    Emitter<BackupState> emit,
  ) async {
    emit(const BackupLoading());

    final result = await restoreBackup(event.filePath);

    result.fold(
      (failure) => emit(BackupError(_mapFailureToMessage(failure))),
      (_) {
        emit(const BackupRestored());
        emit(const BackupOperationSuccess('Backup restored successfully'));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is DatabaseFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'Unexpected error occurred';
  }
}
