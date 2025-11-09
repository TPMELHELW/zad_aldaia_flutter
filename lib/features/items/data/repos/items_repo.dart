import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/features/items/data/models/item.dart';

class ItemsRepo {
  final SupabaseClient _supabase;

  ItemsRepo(this._supabase);

  List<Item> items = [];

  Future<List<Item>> searchItems(Map<String, dynamic> eqMap, Map<String, dynamic> likeMap) async {
    print("eqMap: ${eqMap}");
    print("likeMap: ${likeMap}");
    var query = _supabase.from('article_items').select('*');
    for (var element in eqMap.entries) {
      query = query.eq(element.key, element.value);
    }
    for (var element in likeMap.entries) {
      query = query.like(element.key, "%${element.value}%");
    }
    final response = await query.order('order', ascending: true);
    final items = response.map<Item>((item) => Item.fromJson(item)).toList();
    return items;
  }

  Future updateItem(String id, Map<String, dynamic> data) async {
    await _supabase.from('article_items').update(data).eq('id', id).timeout(Duration(seconds: 30));
  }

  Future insertItem(Map<String, dynamic> data) async {
    await _supabase.from('article_items').insert(data).timeout(Duration(seconds: 30));
  }

  Future<bool> swapItemsOrder(String id1, String id2, int index1, int index2) async {
    try {
      // final response = await _supabase.from('article_items').select('id, order').or('id.eq.$id1,id.eq.$id2');

      // if (response.length != 2) {
      //   print('❌ One or both IDs not found.');
      //   return false;
      // }

      // final order1 = response.firstWhere((item) => item['id'] == id1)['order'];
      // print('order1: $order1');
      // final order2 = response.firstWhere((item) => item['id'] == id2)['order'];
      // print('order2: $order2');

      await _supabase.from('article_items').update({'order': index2}).eq('id', id1);
      await _supabase.from('article_items').update({'order': index1}).eq('id', id2);

      print('✅ Orders swapped between ID $id1 and ID $id2');
      return true;
    } catch (e) {
      print('Error swapping article item orders: $e');
      return false;
    }
  }
}
