import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/pricing/get_all_service_pricing.dart';
import '../../../domain/usecases/pricing/get_service_pricing.dart';
import '../../../domain/usecases/pricing/get_pricing_by_service.dart';
import '../../../domain/usecases/pricing/get_pricing_by_item_type.dart';
import '../../../domain/usecases/pricing/add_service_pricing.dart';
import '../../../domain/usecases/pricing/update_service_pricing.dart';
import '../../../domain/usecases/pricing/delete_service_pricing.dart';
import 'pricing_event.dart';
import 'pricing_state.dart';

class PricingBloc extends Bloc<PricingEvent, PricingState> {
  final GetAllServicePricing getAllServicePricing;
  final GetServicePricing getServicePricing;
  final GetPricingByService getPricingByService;
  final GetPricingByItemType getPricingByItemType;
  final AddServicePricing addServicePricing;
  final UpdateServicePricing updateServicePricing;
  final DeleteServicePricing deleteServicePricing;

  PricingBloc({
    required this.getAllServicePricing,
    required this.getServicePricing,
    required this.getPricingByService,
    required this.getPricingByItemType,
    required this.addServicePricing,
    required this.updateServicePricing,
    required this.deleteServicePricing,
  }) : super(const PricingInitial()) {
    on<LoadAllServicePricing>(_onLoadAllServicePricing);
    on<LoadServicePricing>(_onLoadServicePricing);
    on<LoadPricingByService>(_onLoadPricingByService);
    on<LoadPricingByItemType>(_onLoadPricingByItemType);
    on<AddServicePricingEvent>(_onAddServicePricing);
    on<UpdateServicePricingEvent>(_onUpdateServicePricing);
    on<DeleteServicePricingEvent>(_onDeleteServicePricing);
  }

  Future<void> _onLoadAllServicePricing(
    LoadAllServicePricing event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await getAllServicePricing();

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricingList) => emit(AllServicePricingLoaded(pricingList)),
    );
  }

  Future<void> _onLoadServicePricing(
    LoadServicePricing event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await getServicePricing(event.serviceId, event.itemTypeId);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricing) => emit(ServicePricingLoaded(pricing)),
    );
  }

  Future<void> _onLoadPricingByService(
    LoadPricingByService event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await getPricingByService(event.serviceId);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricingList) => emit(PricingListLoaded(pricingList)),
    );
  }

  Future<void> _onLoadPricingByItemType(
    LoadPricingByItemType event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await getPricingByItemType(event.itemTypeId);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricingList) => emit(PricingListLoaded(pricingList)),
    );
  }

  Future<void> _onAddServicePricing(
    AddServicePricingEvent event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await addServicePricing(event.pricing);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricing) {
        emit(ServicePricingLoaded(pricing));
        emit(const PricingOperationSuccess('Pricing added successfully'));
      },
    );
  }

  Future<void> _onUpdateServicePricing(
    UpdateServicePricingEvent event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await updateServicePricing(event.pricing);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (pricing) {
        emit(ServicePricingLoaded(pricing));
        emit(const PricingOperationSuccess('Pricing updated successfully'));
      },
    );
  }

  Future<void> _onDeleteServicePricing(
    DeleteServicePricingEvent event,
    Emitter<PricingState> emit,
  ) async {
    emit(const PricingLoading());

    final result = await deleteServicePricing(event.id);

    result.fold(
      (failure) => emit(PricingError(_mapFailureToMessage(failure))),
      (_) => emit(const PricingOperationSuccess('Pricing deleted successfully')),
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
