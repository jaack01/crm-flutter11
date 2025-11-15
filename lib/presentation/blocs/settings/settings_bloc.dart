import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/settings/get_shop_settings.dart';
import '../../../domain/usecases/settings/update_shop_settings.dart';
import '../../../domain/usecases/settings/get_notification_settings.dart';
import '../../../domain/usecases/settings/update_notification_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetShopSettings getShopSettings;
  final UpdateShopSettings updateShopSettings;
  final GetNotificationSettings getNotificationSettings;
  final UpdateNotificationSettings updateNotificationSettings;

  SettingsBloc({
    required this.getShopSettings,
    required this.updateShopSettings,
    required this.getNotificationSettings,
    required this.updateNotificationSettings,
  }) : super(const SettingsInitial()) {
    on<LoadShopSettings>(_onLoadShopSettings);
    on<UpdateShopSettingsEvent>(_onUpdateShopSettings);
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<ResetSettingsToDefaults>(_onResetSettingsToDefaults);
  }

  Future<void> _onLoadShopSettings(
    LoadShopSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await getShopSettings();

    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(ShopSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateShopSettings(
    UpdateShopSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await updateShopSettings(event.settings);

    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) {
        emit(ShopSettingsLoaded(settings));
        emit(const SettingsOperationSuccess('Shop settings updated successfully'));
      },
    );
  }

  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await getNotificationSettings();

    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(NotificationSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await updateNotificationSettings(event.settings);

    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) {
        emit(NotificationSettingsLoaded(settings));
        emit(const SettingsOperationSuccess(
          'Notification settings updated successfully',
        ));
      },
    );
  }

  Future<void> _onResetSettingsToDefaults(
    ResetSettingsToDefaults event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    // TODO: Implement reset to defaults
    // This would require adding a use case for resetting settings

    emit(const SettingsError('Reset to defaults not yet implemented'));
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
