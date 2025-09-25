import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'core/config/supabase_config.dart';
import 'presentation/pages/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load(fileName: '.env');
  }
  await SupabaseConfig.init();
  runApp(const CashyApp());
}

class CashyApp extends StatelessWidget {
  const CashyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF));
    return GetMaterialApp(
      title: 'Cashy Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      ),
      home: DashboardPage(),
    );
  }
}
