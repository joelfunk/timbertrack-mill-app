import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/auth_provider-port.dart';
import 'package:timbertrack_mill_app/screens/main_tabbar/main_tabbar.dart';
import 'package:timbertrack_mill_app/screens/authentication/check_handle.dart';

class CheckAuthentication extends StatefulWidget {
  const CheckAuthentication({this.test = false, Key? key}) : super(key: key);
  final bool test;

  @override
  State<CheckAuthentication> createState() => _CheckAuthenticationState();
}

class _CheckAuthenticationState extends State<CheckAuthentication> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.test) {
          context.read<AuthProvider>().authenticateTest(context);
        } else {
          context.read<AuthProvider>().authenticateUser(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthStatus authStatus = context.watch<AuthProvider>().authStatus;

    switch (authStatus) {
      case AuthStatus.initial:
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(.5),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.signedIn:
        return const MainTabbar();
      case AuthStatus.signedOut:
        return const CheckHandle();
    }
  }
}
