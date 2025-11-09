import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit {
  final SupabaseClient supabase;
  final SharedPreferences sp;

  AuthCubit({required this.supabase, required this.sp}) : super(null);

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);

      return response.user != null;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<bool> isAuthenticated() async {
    return supabase.auth.currentUser != null;
  }
}
