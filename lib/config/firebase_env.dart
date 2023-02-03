import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:timbertrack_mill_app/firebase_options_development.dart';
import 'package:timbertrack_mill_app/firebase_options_production.dart';

class FirebaseEnv {
  FirebaseEnv._();

  static final FirebaseEnv _instance = FirebaseEnv._();
  factory FirebaseEnv() => _instance;

  late final FirebaseApp _app;

  static FirebaseApp get app => _instance._app;

  static String get environmentType => const String.fromEnvironment('ENV');

  static FirebaseAuth get firebaseAuth => FirebaseAuth.instanceFor(app: _instance._app);

  static FirebaseStorage get firebaseStorage => FirebaseStorage.instanceFor(app: _instance._app);

  static FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instanceFor(app: _instance._app);

  static Future<void> initializeEnv() async {
    const enviromentType = String.fromEnvironment('ENV');
    await _instance._initializeFirebase(enviromentType);
  }

  Future<void> _initializeFirebase(String environmentType) async {
    final options = environmentType == 'develop'
        ? DefaultFirebaseOptionsDevelopment.currentPlatform
        : DefaultFirebaseOptionsProduction.currentPlatform;

    final app = await Firebase.initializeApp(
      options: options,
    );

    _app = app;
  }
}
