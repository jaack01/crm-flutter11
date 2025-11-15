import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/usecases/customer/customer_usecases.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetAllCustomers getAllCustomers;
  final GetCustomerById getCustomerById;
  final SearchCustomers searchCustomers;
  final GetCustomersByType getCustomersByType;
  final AddCustomer addCustomer;
  final UpdateCustomer updateCustomer;
  final DeleteCustomer deleteCustomer;

  CustomerBloc({
    required this.getAllCustomers,
    required this.getCustomerById,
    required this.searchCustomers,
    required this.getCustomersByType,
    required this.addCustomer,
    required this.updateCustomer,
    required this.deleteCustomer,
  }) : super(const CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomersEvent>(_onSearchCustomers);
    on<FilterCustomersByType>(_onFilterCustomersByType);
    on<AddCustomerEvent>(_onAddCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<DeleteCustomerEvent>(_onDeleteCustomer);
    on<GetCustomerByIdEvent>(_onGetCustomerById);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, List<Customer>> result = await getAllCustomers();
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (List<Customer> customers) => emit(CustomersLoaded(customers)),
    );
  }

  Future<void> _onSearchCustomers(
    SearchCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, List<Customer>> result = await searchCustomers(event.query);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (List<Customer> customers) => emit(CustomersLoaded(customers)),
    );
  }

  Future<void> _onFilterCustomersByType(
    FilterCustomersByType event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, List<Customer>> result = await getCustomersByType(event.type);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (List<Customer> customers) => emit(CustomersLoaded(customers)),
    );
  }

  Future<void> _onAddCustomer(
    AddCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, Customer> result = await addCustomer(event.customer);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (Customer customer) {
        emit(CustomerOperationSuccess('Customer added successfully', customer: customer));
        // Reload customers list
        add(const LoadCustomers());
      },
    );
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, Customer> result = await updateCustomer(event.customer);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (Customer customer) {
        emit(CustomerOperationSuccess('Customer updated successfully', customer: customer));
        // Reload customers list
        add(const LoadCustomers());
      },
    );
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, void> result = await deleteCustomer(event.customerId);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (_) {
        emit(const CustomerOperationSuccess('Customer deleted successfully'));
        // Reload customers list
        add(const LoadCustomers());
      },
    );
  }

  Future<void> _onGetCustomerById(
    GetCustomerByIdEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final Either<Failure, Customer> result = await getCustomerById(event.customerId);
    result.fold(
      (Failure failure) => emit(CustomerError(_mapFailureToMessage(failure))),
      (Customer customer) => emit(CustomerDetailLoaded(customer)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is DatabaseFailure) {
      return failure.message;
    } else if (failure is NotFoundFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }
}
