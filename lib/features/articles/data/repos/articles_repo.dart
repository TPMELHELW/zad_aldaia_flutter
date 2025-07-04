import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/features/articles/data/models/article.dart';

class ArticlesRepo {
  final SupabaseClient _supabase;

  ArticlesRepo(this._supabase);

  Future<List<Article>> searchArticles(Map<String, dynamic> eqMap) async {
    var query = _supabase.from('articles').select('*');
    for (var element in eqMap.entries) {
      query = query.eq(element.key, element.value);
    }
    final response = await query; //.order('order', ascending: true)
    final articles = response.map<Article>((item) => Article.fromJson(item)).toList();
    return articles;
  }

  Future updateArticle(String id, Map<String, dynamic> data) async {
    return await _supabase.from('articles').update(data).eq('id', id).timeout(Duration(seconds: 30));
  }

  Future insertArticle(Map<String, dynamic> data) async {
    return await _supabase.from('articles').insert(data).timeout(Duration(seconds: 30));
  }
}
