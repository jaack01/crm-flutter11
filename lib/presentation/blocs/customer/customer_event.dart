import 'package:equatable/equatable.dart';
import '../../../domain/entities/customer.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {
  const LoadCustomers();
}

class SearchCustomersEvent extends CustomerEvent {
  final String query;

  const SearchCustomersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterCustomersByType extends CustomerEvent {
  final String type;

  const FilterCustomersByType(this.type);

  @override
  List<Object?> get props => [type];
}

class AddCustomerEvent extends CustomerEvent {
  final Customer customer;

  const AddCustomerEvent(this.customer);

  @override
  List<Object?> get props => [customer];
}

class UpdateCustomerEvent extends CustomerEvent {
  final Customer customer;

  const UpdateCustomerEvent(this.customer);

  @override
  List<Object?> get props => [customer];
}

class DeleteCustomerEvent extends CustomerEvent {
  final int customerId;

  const DeleteCustomerEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class GetCustomerByIdEvent extends CustomerEvent {
  final int customerId;

  const GetCustomerByIdEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
