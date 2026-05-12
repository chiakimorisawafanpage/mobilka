import 'order_status.dart';
import 'payment_method.dart';

class OrderHeader {
  const OrderHeader({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.total,
    required this.address,
    required this.comment,
    required this.paymentMethod,
    required this.status,
  });

  final int id;
  final int? userId;
  final String createdAt;
  final double total;
  final String address;
  final String? comment;
  final PaymentMethod paymentMethod;
  final OrderStatus status;

  factory OrderHeader.fromMap(Map<String, Object?> map) {
    return OrderHeader(
      id: (map['id'] as int?) ?? (map['id'] as num?)!.toInt(),
      userId: map['userId'] != null
          ? (map['userId'] as int?) ?? (map['userId'] as num?)!.toInt()
          : null,
      createdAt: map['createdAt']! as String,
      total: (map['total'] as num?)!.toDouble(),
      address: map['address']! as String,
      comment: map['comment'] as String?,
      paymentMethod: PaymentMethod.fromDb(map['paymentMethod']! as String),
      status: OrderStatus.fromDb(map['status']! as String),
    );
  }
}
