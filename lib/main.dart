import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holom_said/config/routes.dart';
import 'package:holom_said/config/themes.dart';
import 'package:holom_said/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/utils/helper_methods/error.dart';

late final WidgetsBinding widgetsBinding;

void main() async {
  widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  print('Before dotenv');
  try {
    await dotenv.load(fileName: ".env");
    print('Loaded .env');
  } catch (e) {
    debugPrint('Warning: .env file not found or could not be loaded');
  }

  print('Before GetStorage');
  await GetStorage.init();
  print('GetStorage initialized');

  print('Before Supabase');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  print('Supabase initialized');

  print('Before NotificationService');
  // await NotificationService.init(Supabase.instance.client);
  print('NotificationService initialization moved to home screen');

  FlutterNativeSplash.remove();
  print('Splash removed');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: ErrorUtils.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      routes: AppRoutes.routes,
      initialRoute: '/startup',
    );
  }
}
