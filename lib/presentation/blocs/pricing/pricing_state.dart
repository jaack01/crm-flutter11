import 'package:equatable/equatable.dart';
import '../../../domain/entities/service_pricing.dart';

abstract class PricingState extends Equatable {
  const PricingState();

  @override
  List<Object?> get props => [];
}

class PricingInitial extends PricingState {
  const PricingInitial();
}

class PricingLoading extends PricingState {
  const PricingLoading();
}

class AllServicePricingLoaded extends PricingState {
  final List<ServicePricing> pricingList;

  const AllServicePricingLoaded(this.pricingList);

  @override
  List<Object?> get props => [pricingList];
}

class ServicePricingLoaded extends PricingState {
  final ServicePricing pricing;

  const ServicePricingLoaded(this.pricing);

  @override
  List<Object?> get props => [pricing];
}

class PricingListLoaded extends PricingState {
  final List<ServicePricing> pricingList;

  const PricingListLoaded(this.pricingList);

  @override
  List<Object?> get props => [pricingList];
}

class PricingOperationSuccess extends PricingState {
  final String message;

  const PricingOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PricingError extends PricingState {
  final String message;

  const PricingError(this.message);

  @override
  List<Object?> get props => [message];
}
