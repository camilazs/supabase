class MoneyTx {
  final String id;
  final String categoryId;
  final int amountCents; // positivo=ingreso, negativo=gasto
  final DateTime trxDate;
  final String? note;

  const MoneyTx({
    required this.id,
    required this.categoryId,
    required this.amountCents,
    required this.trxDate,
    this.note,
  });
}
