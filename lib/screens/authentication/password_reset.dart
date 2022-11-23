import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:simple_forms/widgets/form_input.dart';
import 'package:simple_forms/models/app_form_state.dart';

import 'package:timbertrack_mill_app/shared/constants.dart';
import 'package:timbertrack_mill_app/extensions/is_tablet.dart';
import 'package:timbertrack_mill_app/extensions/is_portrait.dart';
import 'package:timbertrack_mill_app/providers/auth_provider.dart';
import 'package:timbertrack_mill_app/shared/widgets/loading_overlay.dart';

class PasswordFormState extends AppFormState<String, String> {
  PasswordFormState()
      : super(
          {
            'email': '',
          },
        );
}

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _loading = ValueNotifier<bool>(false);
  final _formState = PasswordFormState();
  final _formKey = GlobalKey<FormState>();

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _loading.value = true;
      await context.read<AuthProvider>().resetPassword(
            email: _formState['email'].trim(),
            context: context,
          );
      if (mounted) _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = context.isTablet;
    final isPortrait = context.isPortrait;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      iconSize: isTablet ? 40 : null,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: size.height * .2),
                  SizedBox(
                    width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .65),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          FormInput(
                            formState: _formState,
                            formStateKey: 'email',
                            labelText: 'Email Address',
                            validator: (val) => !isEmail(val!.trim()) ? 'Invalid Email' : null,
                            fontSize: isTablet ? 20 : null,
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _resetPassword();
                                  }
                                }, //=> login()},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : null,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, bool loading, child) {
              if (loading) {
                return const LoadingOverlay();
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }
}
