import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:offline_first/di/di.dart';
import 'package:offline_first/di/locator.dart';
import 'package:offline_first/firebase_options.dart';
import 'package:offline_first/router/app_router.dart';


void main() async {
  await configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await initApiClients();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouterConfig = AppRouter().config();
    return MaterialApp.router(
      routerConfig: appRouterConfig,
    );
  }
}
