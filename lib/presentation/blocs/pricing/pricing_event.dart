import 'package:equatable/equatable.dart';
import '../../../domain/entities/service_pricing.dart';

abstract class PricingEvent extends Equatable {
  const PricingEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllServicePricing extends PricingEvent {
  const LoadAllServicePricing();
}

class LoadServicePricing extends PricingEvent {
  final int serviceId;
  final int itemTypeId;

  const LoadServicePricing(this.serviceId, this.itemTypeId);

  @override
  List<Object?> get props => [serviceId, itemTypeId];
}

class LoadPricingByService extends PricingEvent {
  final int serviceId;

  const LoadPricingByService(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

class LoadPricingByItemType extends PricingEvent {
  final int itemTypeId;

  const LoadPricingByItemType(this.itemTypeId);

  @override
  List<Object?> get props => [itemTypeId];
}

class AddServicePricingEvent extends PricingEvent {
  final ServicePricing pricing;

  const AddServicePricingEvent(this.pricing);

  @override
  List<Object?> get props => [pricing];
}

class UpdateServicePricingEvent extends PricingEvent {
  final ServicePricing pricing;

  const UpdateServicePricingEvent(this.pricing);

  @override
  List<Object?> get props => [pricing];
}

class DeleteServicePricingEvent extends PricingEvent {
  final int id;

  const DeleteServicePricingEvent(this.id);

  @override
  List<Object?> get props => [id];
}
