enum OrderStatus {
  accepted('accepted'),
  shipping('shipping'),
  delivered('delivered');

  const OrderStatus(this.dbValue);
  final String dbValue;

  static OrderStatus fromDb(String v) {
    return OrderStatus.values.firstWhere(
      (e) => e.dbValue == v,
      orElse: () => OrderStatus.accepted,
    );
  }
}
