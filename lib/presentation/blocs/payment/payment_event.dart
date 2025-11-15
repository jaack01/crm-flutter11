import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPayments extends PaymentEvent {
  const LoadPayments();
}

class LoadPaymentsByOrder extends PaymentEvent {
  final int orderId;

  const LoadPaymentsByOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class AddPaymentEvent extends PaymentEvent {
  final Payment payment;

  const AddPaymentEvent(this.payment);

  @override
  List<Object?> get props => [payment];
}
