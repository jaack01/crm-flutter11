import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/payment/get_all_payments.dart';
import '../../../domain/usecases/payment/get_payments_by_order.dart';
import '../../../domain/usecases/payment/add_payment.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetAllPayments getAllPayments;
  final GetPaymentsByOrder getPaymentsByOrder;
  final AddPayment addPayment;

  PaymentBloc({
    required this.getAllPayments,
    required this.getPaymentsByOrder,
    required this.addPayment,
  }) : super(const PaymentInitial()) {
    on<LoadPayments>(_onLoadPayments);
    on<LoadPaymentsByOrder>(_onLoadPaymentsByOrder);
    on<AddPaymentEvent>(_onAddPayment);
  }

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await getAllPayments();

    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onLoadPaymentsByOrder(
    LoadPaymentsByOrder event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await getPaymentsByOrder(event.orderId);

    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> _onAddPayment(
    AddPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await addPayment(event.payment);

    result.fold(
      (failure) => emit(PaymentError(_mapFailureToMessage(failure))),
      (payment) {
        emit(const PaymentOperationSuccess('Payment recorded successfully'));
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
