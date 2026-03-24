import 'package:eontech_tourist_mobile/core/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/businesses_provider.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/providers/offers_provider.dart';
import 'core/providers/places_provider.dart';
import 'core/services/notification_service.dart';
import 'core/theme.dart';
import 'firebase_options.dart';
import 'shared/providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => OffersProvider()),
        ChangeNotifierProvider(create: (_) => BusinessesProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const SouthSriLankaApp(),
    ),
  );
}

class SouthSriLankaApp extends StatelessWidget {
  const SouthSriLankaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<AppProvider>().themeMode;
    return MaterialApp.router(
      title: 'South Sri Lanka',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}