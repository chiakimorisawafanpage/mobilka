enum PaymentMethod {
  cash('cash'),
  card('card'),
  sbp('sbp');

  const PaymentMethod(this.dbValue);
  final String dbValue;

  static PaymentMethod fromDb(String v) {
    return PaymentMethod.values.firstWhere(
      (e) => e.dbValue == v,
      orElse: () => PaymentMethod.cash,
    );
  }
}
