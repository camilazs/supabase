import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/tx_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/money_tx.dart';

class DashboardController extends GetxController {
  final _catRepo = CategoryRepository();
  final _txRepo = TxRepository();

  final Rx<DateTime> month = DateTime.now().obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxList<MoneyTx> txs = <MoneyTx>[].obs;
  final RxBool loading = false.obs;

  String get monthLabel => DateFormat('MMMM yyyy').format(month.value);

  int get totalIncome =>
      txs.where((e) => e.amountCents > 0).fold(0, (a, b) => a + b.amountCents);
  int get totalExpense =>
      txs.where((e) => e.amountCents < 0).fold(0, (a, b) => a + b.amountCents);
  int get balance => totalIncome + totalExpense;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    try {
      loading.value = true;
      final results = await Future.wait([
        _catRepo.getAll(),
        _txRepo.getByMonth(month.value),
      ]);
      categories.assignAll(results[0] as List<Category>);
      txs.assignAll(results[1] as List<MoneyTx>);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar: $e');
    } finally {
      loading.value = false;
    }
  }

  void nextMonth() {
    month.value = DateTime(month.value.year, month.value.month + 1, 1);
    loadAll();
  }

  void prevMonth() {
    month.value = DateTime(month.value.year, month.value.month - 1, 1);
    loadAll();
  }
}
