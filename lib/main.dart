import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/truck_tickets_provider.dart';
import 'package:timbertrack_mill_app/services/local_storage.dart';
import 'package:timbertrack_mill_app/providers/user_provider.dart';
import 'package:timbertrack_mill_app/providers/auth_provider.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/screens/authentication/check_authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseEnv.initializeEnv();

  await LocalStorage.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => HandleProvider()),
        ChangeNotifierProvider(create: (context) => ContractProvider()),
        ChangeNotifierProvider(create: (context) => TruckTicketsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: FirebaseEnv.environmentType == 'develop',
        title: 'MobileTrack Maintenance App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const CheckAuthentication(),
      ),
    );
  }
}
