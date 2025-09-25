import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../domain/entities/money_tx.dart';
import '../models/money_tx_model.dart';

class TxRepository {
  final SupabaseClient _c = SupabaseConfig.client;

  Future<List<MoneyTx>> getByMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(
      month.year,
      month.month + 1,
      1,
    ).subtract(const Duration(days: 1));
    final rows = await _c
        .from('transactions')
        .select()
        .gte('trx_date', start.toIso8601String().substring(0, 10))
        .lte('trx_date', end.toIso8601String().substring(0, 10))
        .order('trx_date', ascending: false)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => MoneyTxModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insert(MoneyTx tx) async {
    final m = MoneyTxModel(
      id: tx.id,
      categoryId: tx.categoryId,
      amountCents: tx.amountCents,
      trxDate: tx.trxDate,
      note: tx.note,
    );
    await _c.from('transactions').insert(m.toInsert());
  }
}
