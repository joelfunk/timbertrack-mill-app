import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:simple_forms/widgets/form_input.dart';
import 'package:simple_forms/models/app_form_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:timbertrack_mill_app/shared/constants.dart';
import 'package:timbertrack_mill_app/extensions/is_tablet.dart';
import 'package:timbertrack_mill_app/services/local_storage.dart';
import 'package:timbertrack_mill_app/extensions/is_portrait.dart';
import 'package:timbertrack_mill_app/providers/auth_provider.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/shared/widgets/loading_overlay.dart';
import 'package:timbertrack_mill_app/screens/authentication/registration.dart';
import 'package:timbertrack_mill_app/screens/authentication/check_handle.dart';
import 'package:timbertrack_mill_app/screens/authentication/password_reset.dart';

class LoginFormState extends AppFormState<String, String> {
  LoginFormState()
      : super(
          {
            'email': '',
            'password': '',
          },
        );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formState = LoginFormState();
  final _formKey = GlobalKey<FormState>();
  final _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formState['email'] = LocalStorage.getString('email') ?? '';
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _loading.value = true;
      await context.read<AuthProvider>().loginUser(
            email: _formState['email'].trim(),
            password: _formState['password'],
            context: context,
          );
      if (mounted) _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyLogo = context.read<HandleProvider>().companyInfo['logoUrl'];

    final size = MediaQuery.of(context).size;
    final isTablet = context.isTablet;
    final isPortrait = context.isPortrait;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: size.height,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: SizedBox(
                      width: size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * .15,
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: isTablet ? 150 : 100),
                            child: companyLogo == null
                                ? Image.asset('assets/images/company_placeholder.png')
                                : CachedNetworkImage(
                                    imageUrl: companyLogo,
                                    progressIndicatorBuilder: (context, url, progress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.green,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: size.height * .05,
                          ),
                          SizedBox(
                            width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .5),
                            child: FormInput(
                              key: const Key('email'),
                              formState: _formState,
                              formStateKey: 'email',
                              validator: (val) => !isEmail(val!.trim()) ? 'Invalid Email' : null,
                              labelText: 'Email Address',
                              fontSize: isTablet ? 20 : null,
                              textInputType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          SizedBox(
                            width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .5),
                            child: FormInput(
                              key: const Key('password'),
                              formState: _formState,
                              formStateKey: 'password',
                              obscureText: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              labelText: 'Password',
                              fontSize: isTablet ? 20 : null,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          SizedBox(
                            width: isTablet ? size.width * .5 : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PasswordReset()),
                                  ),
                                  child: Text(
                                    'Forgot Password? Click Here',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : null,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  key: const Key('login-button'),
                                  onPressed: _login, //=> login()},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : null,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * .03),
                          SizedBox(
                            width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .5),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                                    ),
                                    child: Text(
                                      'Register a New User',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .5),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CheckHandle(),
                                      ),
                                    ),
                                    child: Text(
                                      'Change Company ID',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
