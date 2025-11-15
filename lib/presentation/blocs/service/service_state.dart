import 'package:equatable/equatable.dart';
import '../../../domain/entities/service.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

class ServiceLoading extends ServiceState {
  const ServiceLoading();
}

class ServicesLoaded extends ServiceState {
  final List<Service> services;

  const ServicesLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServiceLoaded extends ServiceState {
  final Service service;

  const ServiceLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ServiceOperationSuccess extends ServiceState {
  final String message;

  const ServiceOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
