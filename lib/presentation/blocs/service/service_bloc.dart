import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/service/get_all_services.dart';
import '../../../domain/usecases/service/get_service_by_id.dart';
import '../../../domain/usecases/service/add_service.dart';
import '../../../domain/usecases/service/update_service.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetAllServices getAllServices;
  final GetServiceById getServiceById;
  final AddService addService;
  final UpdateService updateService;

  ServiceBloc({
    required this.getAllServices,
    required this.getServiceById,
    required this.addService,
    required this.updateService,
  }) : super(const ServiceInitial()) {
    on<LoadServices>(_onLoadServices);
    on<LoadServiceById>(_onLoadServiceById);
    on<AddServiceEvent>(_onAddService);
    on<UpdateServiceEvent>(_onUpdateService);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    final result = await getAllServices();

    result.fold(
      (failure) => emit(ServiceError(_mapFailureToMessage(failure))),
      (services) => emit(ServicesLoaded(services)),
    );
  }

  Future<void> _onLoadServiceById(
    LoadServiceById event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    final result = await getServiceById(event.id);

    result.fold(
      (failure) => emit(ServiceError(_mapFailureToMessage(failure))),
      (service) => emit(ServiceLoaded(service)),
    );
  }

  Future<void> _onAddService(
    AddServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    final result = await addService(event.service);

    result.fold(
      (failure) => emit(ServiceError(_mapFailureToMessage(failure))),
      (service) {
        emit(ServiceLoaded(service));
        emit(const ServiceOperationSuccess('Service added successfully'));
      },
    );
  }

  Future<void> _onUpdateService(
    UpdateServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    final result = await updateService(event.service);

    result.fold(
      (failure) => emit(ServiceError(_mapFailureToMessage(failure))),
      (service) {
        emit(ServiceLoaded(service));
        emit(const ServiceOperationSuccess('Service updated successfully'));
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
