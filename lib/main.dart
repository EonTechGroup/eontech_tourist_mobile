import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EontechApp(),
    ),
  );
}

class EontechApp extends ConsumerWidget {        // ← ConsumerWidget for Riverpod
  const EontechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Eontech Tourist',
      theme: AppTheme.light,                     // ← was: AppTheme.lightTheme
      darkTheme: AppTheme.dark,                  // ← was: AppTheme.darkTheme
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}