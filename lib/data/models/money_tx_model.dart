import '../../domain/entities/money_tx.dart';

class MoneyTxModel extends MoneyTx {
  const MoneyTxModel({
    required super.id,
    required super.categoryId,
    required super.amountCents,
    required super.trxDate,
    super.note,
  });

  factory MoneyTxModel.fromJson(Map<String, dynamic> json) {
    return MoneyTxModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      amountCents: json['amount_cents'] as int,
      trxDate: DateTime.parse(json['trx_date'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toInsert() => {
    'category_id': categoryId,
    'amount_cents': amountCents,
    'trx_date': trxDate.toIso8601String().substring(0, 10), // YYYY-MM-DD
    'note': note,
  };
}
