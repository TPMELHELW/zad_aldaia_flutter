import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/core/database/my_database.dart';
import 'package:zad_aldaia/core/networking/api_service.dart';
import 'package:zad_aldaia/core/networking/dio_factory.dart';
import 'package:zad_aldaia/features/articles/data/repos/articles_repo.dart';
import 'package:zad_aldaia/features/articles/logic/articles_cubit.dart';
import 'package:zad_aldaia/features/auth/auth_cubit.dart';
import 'package:zad_aldaia/features/categories/data/repos/categories_repo.dart';
import 'package:zad_aldaia/features/categories/logic/categories_cubit.dart';
import 'package:zad_aldaia/features/items/data/repos/items_repo.dart';
import 'package:zad_aldaia/features/items/logic/items_cubit.dart';
import 'package:zad_aldaia/features/upload/upload_cubit.dart';

final getIt = GetIt.instance;

setupGetIt() async {
  getIt.registerLazySingleton<MyDatabase>(() => MyDatabase());
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final Dio dio = DioFactory.getDio();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  getIt.registerSingleton<SharedPreferences>(sp);
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<SupabaseClient>(supabaseClient);
  getIt.registerFactory<AuthCubit>(() => AuthCubit(supabase: getIt(), sp: getIt()));
  getIt.registerFactory<CategoriesRepo>(() => CategoriesRepo(supabaseClient));
  getIt.registerFactory<CategoriesCubit>(() => CategoriesCubit(getIt()));
  getIt.registerFactory<ApiService>(() => ApiService(dio));
  getIt.registerFactory<UploadCubit>(() => UploadCubit(getIt()));
  getIt.registerFactory<ArticlesRepo>(() => ArticlesRepo(getIt()));
  getIt.registerFactory<ArticlesCubit>(() => ArticlesCubit(getIt()));
  getIt.registerFactory<ItemsRepo>(() => ItemsRepo(getIt()));
  getIt.registerFactory<ItemsCubit>(() => ItemsCubit(getIt()));
}
