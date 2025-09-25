import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';
import 'add_tx_page.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final c = Get.put(DashboardController());
  final money = NumberFormat.currency(locale: 'es_CO', symbol: r'$');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 140,
              backgroundColor: cs.primary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 16,
                  bottom: 12,
                ),
                title: Text(
                  c.monthLabel,
                  style: TextStyle(color: cs.onPrimary),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: cs.onPrimary,
                  onPressed: c.prevMonth,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: cs.onPrimary,
                  onPressed: c.nextMonth,
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Resumen
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _kpi(
                      'Ingresos',
                      money.format(c.totalIncome / 100),
                      Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _kpi(
                      'Gastos',
                      money.format(c.totalExpense.abs() / 100),
                      Colors.red,
                    ),
                    const SizedBox(width: 12),
                    _kpi(
                      'Balance',
                      money.format(c.balance / 100),
                      c.balance >= 0 ? Colors.teal : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            // Lista
            SliverList.builder(
              itemCount: c.txs.length,
              itemBuilder: (ctx, i) {
                final t = c.txs[i];
                final isIncome = t.amountCents > 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isIncome ? Colors.green : Colors.red,
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    money.format(t.amountCents / 100),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(t.trxDate)),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddTxPage()),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  Widget _kpi(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
