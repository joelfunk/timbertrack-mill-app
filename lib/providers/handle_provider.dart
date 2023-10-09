// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:flutter/material.dart' show ChangeNotifier, BuildContext, MaterialPageRoute, Navigator;

import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/dialogs/alert_dialog.dart';
import 'package:timbertrack_mill_app/services/local_storage.dart';
import 'package:timbertrack_mill_app/screens/authentication/login.dart';

class HandleProvider extends ChangeNotifier {
  String? handle;
  final Map<String, dynamic> companyInfo = {};

  Future<String?> fetchHandle() async {
    handle = await LocalStorage().getString('handle');
    notifyListeners();
    return handle;
  }

  Future<String?> setHandle(String newHandle) async {
    await LocalStorage().setString('handle', newHandle);
    handle = newHandle;
    notifyListeners();
    return handle;
  }

  Future<Map<String, dynamic>?> fetchCompanyInfo(String handle) async =>
      (await FirebaseEnv.firebaseFirestore.collection('_companies').doc(handle).get()).data();

  Future<void> checkHandleAndNavigate(String newHandle, BuildContext context) async {
    // Check to see if handle exists
    final result = await FirebaseEnv.firebaseFirestore.collection('_companies').doc(newHandle).get();

    if (result.exists) {
      // Set the valid handle
      await context.read<HandleProvider>().setHandle(newHandle);
      // Gather company info (used on later screens)
      companyInfo.addAll({...result.data()!});
      // Navigate to the Login Screen
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      // Show Error, handle wasn't found
      showAlertDialog(
        context: context,
        error: true,
        title: 'Not Found',
        content: 'This company handle cannot be found. Please check for errors and try again.',
        dialogOptions: () => {'Ok': true},
      );
    }
  }
}
