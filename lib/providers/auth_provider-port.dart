// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as devtools;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:timbertrack_mill_app/constants/constants.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/dialogs/alert_dialog.dart';
import 'package:timbertrack_mill_app/services/local_storage.dart';
import 'package:timbertrack_mill_app/providers/user_provider.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/screens/main_tabbar/main_tabbar.dart';
import 'package:timbertrack_mill_app/screens/authentication/verify_email.dart';
import 'package:timbertrack_mill_app/screens/authentication/check_authentication.dart';

enum AuthStatus { initial, signedIn, signedOut }

Map<String, String> errorCodes = {
  'email-already-in-use': 'The email address is already in use by another account. Please logtin using that account',
  'error-cloud-service': 'There was an error when running verifyEmailRole service',
  'registration-issue': 'Your Registration has been made. You should hear from the Administrator shortly.',
  'no-handle': 'There was an issue retrieving app handle',
};

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.initial;

  void logout(BuildContext context) async {
    authStatus = AuthStatus.signedOut;
    await FirebaseEnv.firebaseAuth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CheckAuthentication()));
  }

  Future<void> authenticateTest(BuildContext context) async {
    await FirebaseEnv.firebaseAuth.signOut();
    final handle = await context.read<HandleProvider>().setHandle('barney');
    final credential = await FirebaseEnv.firebaseAuth.signInWithEmailAndPassword(
      email: 'blakewoodjr84@gmail.com',
      password: 'qwerty',
    );

    authStatus = AuthStatus.signedIn;

    await context.read<UserProvider>().subUser(credential.user!.email!, handle!);

    notifyListeners();
  }

  Future<AuthStatus?> authenticateUser(BuildContext context) async {
    final user = FirebaseEnv.firebaseAuth.currentUser;
    final handle = await context.read<HandleProvider>().fetchHandle();

    // Will Forward to Email Verification Screen if somehow the user's email was never verified
    if (user != null && !user.emailVerified) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyEmail(user: user)));
      return null;
    }

    if (user != null) {
      authStatus = AuthStatus.signedIn;
      final email = user.email!;
      await context.read<UserProvider>().subUser(email, handle!);
    } else {
      authStatus = AuthStatus.signedOut;
      (handle != null && handle.isNotEmpty) //
          ? await context.read<HandleProvider>().checkHandleAndNavigate(handle, context)
          : null;
    }
    notifyListeners();
    return authStatus;
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final handle = context.read<HandleProvider>().handle;

      // Handle shouldn't come back null here, handle should be assigned before LoginScreen is visited
      if (handle == null) {
        throw FirebaseAuthException(
          code: 'no-handle',
          message: 'There was an issue retrieving app handle',
        );
      }

      // Sign In First (will throw error if invalid)
      final credentials = await FirebaseEnv.firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Check email has been verify
      if (!credentials.user!.emailVerified) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyEmail(user: credentials.user!)));
        return;
      }

      // Verify Email Role is available
      final verify = await verifyEmailRole(
        email: email,
        handle: handle,
        appName: APP_NAME,
        isRegistration: false,
      );

      verify.fold(
        // Error
        (l) => throw FirebaseAuthException(
          code: 'verify-email-role',
          message: 'Error Verifying Email Role',
        ),
        // Success
        (response) async {
          devtools.log(response.toString());
          // Roles and Email Exists ?
          if (response['exists'] as bool && response['roles'].isNotEmpty) {
            // Sub User
            await context.read<UserProvider>().subUser(email, handle);

            // Set User email to local storage
            await LocalStorage().setString('email', email);

            // Move to MainTabbar Screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainTabbar()));
          } else {
            // Invalid Registration, Roles or Email does not exist yet
            await showAlertDialog(
              context: context,
              error: true,
              title: 'registration-issue',
              content: 'Your Registration has been made. You should hear from the Administrator shortly.',
              dialogOptions: () => {'Ok': true},
            );
            FirebaseEnv.firebaseAuth.signOut();
          }
        },
      );
    } on FirebaseAuthException catch (error) {
      await showAlertDialog(
        context: context,
        error: true,
        title: error.code,
        content: error.message,
        dialogOptions: () => {'Ok': true},
      );
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) async {
    try {
      final handle = await context.read<HandleProvider>().fetchHandle();

      if (handle == null) {
        throw FirebaseAuthException(
          code: 'no-handle',
          message: 'There was an issue retrieving app handle',
        );
      }
      await FirebaseEnv.firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final verify = await verifyEmailRole(
        email: email,
        handle: handle,
        appName: APP_NAME,
        firstName: firstName,
        lastName: lastName,
        isRegistration: true,
      );

      verify.fold(
        (l) => throw FirebaseAuthException(
          code: 'verify-email-role',
          message: 'Error Verifying Email Role',
        ),
        (r) => null,
      );

      final user = FirebaseEnv.firebaseAuth.currentUser;

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyEmail(user: user!)));
    } on FirebaseAuthException catch (error) {
      await showAlertDialog(
        context: context,
        error: true,
        title: error.code,
        content: error.message,
        dialogOptions: () => {'Ok': true},
      );
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseEnv.firebaseAuth.sendPasswordResetEmail(email: email);
      await showAlertDialog(
        context: context,
        title: 'A Reset Password link has been sent to email',
        dialogOptions: () => {'Ok': true},
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      await showAlertDialog(
        context: context,
        error: true,
        title: error.code,
        content: error.message,
        dialogOptions: () => {'Ok': true},
      );
    }
  }

  Future<Either<Unit, Map>> verifyEmailRole({
    required String email,
    required String handle,
    required String appName,
    required bool isRegistration,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final doc = await FirebaseEnv.firebaseFirestore.collection('$handle/users/users').doc(email).get();

      if (doc.exists) {
        final data = doc.data();
        return right({'exists': true, 'roles': data!['roles'] ?? []});
      } else {
        // Only submit User's info for Admin if Registration Event
        if (isRegistration) {
          final defaultScheduleData = await FirebaseEnv.firebaseFirestore
              .collection('_mobiletrack/settings/defaultSettings')
              .doc(APP_NAME)
              .get();
          final response = defaultScheduleData.data();

          final defaultSchedule = response!['defaultSchedule'] as Map<String, dynamic>;

          await FirebaseEnv.firebaseFirestore.collection('$handle/users/users').doc(email).set({
            'firstName': firstName,
            'lastName': lastName,
            'deleted': false,
            'activated': false,
            'request': true,
            'schedule': {...defaultSchedule}
          });
        }

        return right({'exists': false});
      }
    } on FirebaseException catch (error) {
      devtools.log('Error executing Verify Email Role: ${error.message}', error: error);
      return left(unit);
    }
  }

  Future<void> sendEmailVerification(User user) => user.sendEmailVerification();
}
