import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _c = SupabaseConfig.client;

  Future<List<Category>> getAll() async {
    final rows = await _c
        .from('categories')
        .select()
        .order('type')
        .order('name');
    return (rows as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
