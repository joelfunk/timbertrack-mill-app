// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:timbertrack_mill_app/constants/constants.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/dialogs/alert_dialog.dart';
import 'package:timbertrack_mill_app/providers/auth_provider-port.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/screens/main_tabbar/main_tabbar.dart';
import 'package:timbertrack_mill_app/screens/authentication/check_authentication.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late final handle = context.read<HandleProvider>().handle;
  late final company = context.read<HandleProvider>().companyInfo;
  late Timer? timer;

  @override
  void initState() {
    super.initState();

    _sendEmailVerification();

    // If the company info is not available, retrieve it to display info such as Logo
    if (company.isEmpty && handle != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final companyInfo = await context.read<HandleProvider>().fetchCompanyInfo(handle!);
        setState(() {
          company.addAll({...companyInfo ?? {}});
        });
      });
    }

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        final checkUser = FirebaseEnv.firebaseAuth.currentUser;
        checkUser?.reload();

        if (checkUser?.emailVerified ?? false) {
          timer.cancel();

          final verify = await context.read<AuthProvider>().verifyEmailRole(
                email: checkUser!.email!,
                handle: handle!,
                appName: APP_NAME,
                isRegistration: false,
              );

          verify.fold((l) {
            // Throw Error
          }, (r) async {
            if (r['exists'] as bool && r['roles'].isNotEmpty) {
              //
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainTabbar()));
              //
            } else {
              //
              await showAlertDialog(
                context: context,
                title: 'Thank you...',
                content: 'Your Registration has been made. You should hear from the Administrator shortly.',
                dialogOptions: () => {'Ok': true},
              );

              await FirebaseEnv.firebaseAuth.signOut();

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CheckAuthentication()));
            }
          });
        }
      },
    );
  }

  void _sendEmailVerification() async {
    try {
      await context.read<AuthProvider>().sendEmailVerification(widget.user);

      await showAlertDialog(
        context: context,
        title: 'An email has been sent!',
        content: 'An email has been sent to the following address: to ${widget.user.email}.'
            'Please look for this email and click on the verification link.',
        dialogOptions: () => {'Ok': true},
      );
    } on FirebaseAuthException catch (error) {
      await showAlertDialog(
        context: context,
        title: 'Error sending request!',
        content: error.message,
        dialogOptions: () => {'Ok': true},
      );
    }
  }

  void _signOut() async {
    try {
      timer?.cancel();
      await FirebaseEnv.firebaseAuth.signOut();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CheckAuthentication()));
    } on FirebaseAuthException catch (error) {
      await showAlertDialog(
        context: context,
        title: 'Error signing out!',
        content: error.message,
        dialogOptions: () => {'Ok': true},
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (company.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Image.network(company['logoUrl']),
                  ),
                if (company.isEmpty)
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/aerotec%2Flogo%2Fshield-icon.jpg?alt=media&token=607ad216-76bb-49df-8860-78275ed1ccbe',
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Please verify your email address by clicking the link below. Once your email has been verified you may log in again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendEmailVerification,
                  child: const Text('Resend Email Verification'),
                ),
                TextButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
