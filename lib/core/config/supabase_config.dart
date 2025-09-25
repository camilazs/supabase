import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Credenciales del proyecto actual (bhuyiwpwejypwsoaixyk)
  static const _url = 'https://bhuyiwpwejypwsoaixyk.supabase.co';
  static const _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJodXlpd3B3ZWp5cHdzb2FpeHlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg3NjExODYsImV4cCI6MjA3NDMzNzE4Nn0.w4KiUSwayxUcWynCEcWq2uh214sIqD-alIZ6odDm8UY';

  static Future<void> init() async {
    await Supabase.initialize(url: _url, anonKey: _anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
