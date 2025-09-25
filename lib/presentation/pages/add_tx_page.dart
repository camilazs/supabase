import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/money_tx.dart';
import '../../domain/entities/category.dart';
import '../../data/repositories/tx_repository.dart';
import '../controllers/dashboard_controller.dart';

class AddTxPage extends StatefulWidget {
  const AddTxPage({super.key});

  @override
  State<AddTxPage> createState() => _AddTxPageState();
}

class _AddTxPageState extends State<AddTxPage> {
  final _form = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  Category? _cat;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dash = Get.find<DashboardController>();
    final cats = dash.categories;
    final fmtDate = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo movimiento')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Category>(
              value: _cat,
              items: cats
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.name} (${c.type})'),
                    ),
                  )
                  .toList(),
              onChanged: (c) => setState(() => _cat = c),
              decoration: const InputDecoration(labelText: 'Categoría'),
              validator: (v) => v == null ? 'Selecciona una categoría' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto (usa signo: + ingreso, - gasto)',
                hintText: 'Ej: 120000 o -35000',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Monto requerido';
                if (int.tryParse(v.trim()) == null)
                  return 'Debe ser número entero (centavos opc.)';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteCtrl,
              decoration: const InputDecoration(labelText: 'Nota (opcional)'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha'),
              subtitle: Text(fmtDate.format(_date)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                if (!_form.currentState!.validate()) return;
                final amount = int.parse(_amountCtrl.text.trim());
                final repo = TxRepository();
                await repo.insert(
                  MoneyTx(
                    id: 'tmp',
                    categoryId: _cat!.id,
                    amountCents: amount,
                    trxDate: _date,
                    note: _noteCtrl.text.trim().isEmpty
                        ? null
                        : _noteCtrl.text.trim(),
                  ),
                );
                await dash.loadAll();
                Get.back();
                Get.snackbar(
                  'OK',
                  'Movimiento agregado',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
