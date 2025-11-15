import 'package:equatable/equatable.dart';
import '../../../domain/entities/service.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadServices extends ServiceEvent {
  const LoadServices();
}

class LoadServiceById extends ServiceEvent {
  final int id;

  const LoadServiceById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddServiceEvent extends ServiceEvent {
  final Service service;

  const AddServiceEvent(this.service);

  @override
  List<Object?> get props => [service];
}

class UpdateServiceEvent extends ServiceEvent {
  final Service service;

  const UpdateServiceEvent(this.service);

  @override
  List<Object?> get props => [service];
}
