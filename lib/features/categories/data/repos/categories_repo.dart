import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/core/helpers/language.dart';
import 'package:zad_aldaia/features/categories/data/models/category.dart';

class CategoriesRepo {
  final SupabaseClient _supabase;

  CategoriesRepo(this._supabase);

  List<Category> categories = [];

  Future<List<Category>> searchCategories(Map<String, dynamic> eqMap) async {
    var query = _supabase.from('categories').select('*, categories(count)');
    eqMap['lang'] = await Lang.get();
    for (var element in eqMap.entries) {
      query = query.eq(element.key, element.value);
    }
    if (Supabase.instance.client.auth.currentUser == null) {
      query = query.eq('is_active', true);
    }
    final response = await query.order('order', ascending: true);
    final categories = response.map<Category>((item) => Category.fromJson(item)).toList();
    return categories;
  }

  Future<List<Category>> fetchCategories(String? parentId) async {
    // NOTE: articlesCount and categoriesCount are REQUIRED in form screens to prevent missing data.
    var query = _supabase.from('categories').select('*, categories(count), articles(count)');
    if (parentId != null) {
      query = query.eq('parent_id', parentId);
    } else {
      query = query.isFilter('parent_id', null);
    }
    query = query.eq('lang', await Lang.get());
    final response = await query.order('order', ascending: true);
    final categories = response.map<Category>((item) => Category.fromJson(item)).toList();
    return categories;
  }

  Future updateCategory(String id, Map<String, dynamic> data) async {
    await _supabase.from('categories').update(data).eq('id', id).timeout(Duration(seconds: 30));
  }

  Future insertCategory(Map<String, dynamic> data) async {
    await _supabase.from('categories').insert(data).timeout(Duration(seconds: 30));
  }

  Future<bool> swapCategoriesOrder(String id1, String id2, int index1, int index2) async {
    try {
      // final response = await _supabase.from('categories').select('id, order').or('id.eq.$id1,id.eq.$id2');
      // print('❌✅❌✅❌✅❌✅❌✅');
      // print(response);
      // if (response.length != 2) {
      //   print('❌ One or both IDs not found.');
      //   return false;
      // }

      // final order1 = response.firstWhere((item) => item['id'] == id1)['order'];
      // print('order1: $order1');
      // final order2 = response.firstWhere((item) => item['id'] == id2)['order'];
      // print('order2: $order2');

      await _supabase.from('categories').update({'order': index2}).eq('id', id1);
      await _supabase.from('categories').update({'order': index1}).eq('id', id2);

      print('✅ Orders swapped between ID $id1 and ID $id2');
      return true;
    } catch (e) {
      print('Error swapping article item orders: $e');
      return false;
    }
  }
}
