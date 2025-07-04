import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:zad_aldaia/core/routing/app_router.dart';
import 'package:zad_aldaia/core/routing/routes.dart';
import 'package:zad_aldaia/core/theming/my_colors.dart';
import 'package:zad_aldaia/firebase_options.dart';
import 'package:zad_aldaia/core/di/dependency_injection.dart';
import 'package:zad_aldaia/generated/l10n.dart';

void main() async {
  // Initialize binding first - CORRECTED THIS LINE
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve splash screen - CORRECTED THIS LINE
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // Initialize dependencies
    await ScreenUtil.ensureScreenSize();
    setupGetIt();
    await getIt.allReady();
    await initializeSupabase();
    await initializeFirebase();
    
    // Remove splash screen and run app
    FlutterNativeSplash.remove();
    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint('App initialization failed: $e');
    debugPrint(stack.toString());
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'حدث خطأ في تهيئة التطبيق',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: "https://ehzdtklsgztuglrljgdd.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoemR0a2xzZ3p0dWdscmxqZ2RkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY1NDAwMTgsImV4cCI6MjA2MjExNjAxOH0.eqJK4bhQUV7mzgLcXE30r2bWk-tDyXtSKpVE5wVfqk8",
  );
}

Future<void> initializeFirebase() async {
  if (kIsWeb) {
    // Web initialization commented out
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  setupFirebaseCrashlytics();
}

void setupFirebaseCrashlytics() {
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScreenUtilInit(
          designSize: Size(constraints.maxWidth, constraints.maxHeight),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: MyRoutes.onboarding,
              onGenerateRoute: AppRouter().generateRoutes,
              supportedLocales: S.delegate.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(
                dividerColor: Colors.transparent,
                primaryColor: MyColors.primaryColor,
                fontFamily: "almarai_bold",
                scaffoldBackgroundColor: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}