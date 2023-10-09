import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:simple_forms/widgets/form_input.dart';
import 'package:simple_forms/models/app_form_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:timbertrack_mill_app/constants/constants.dart';
import 'package:timbertrack_mill_app/extensions/is_tablet.dart';
import 'package:timbertrack_mill_app/extensions/is_portrait.dart';
import 'package:timbertrack_mill_app/providers/auth_provider-port.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/shared/widgets/loading_overlay.dart';

class RegistrationFormState extends AppFormState<String, String> {
  RegistrationFormState()
      : super(
          {
            'firstName': '',
            'lastName': '',
            'email': '',
            'password': '',
            'passwordConfirm': '',
          },
        );
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _loading = ValueNotifier<bool>(false);
  final _formState = RegistrationFormState();
  final _formKey = GlobalKey<FormState>();

  late final handle = context.read<HandleProvider>().handle;

  Future<void> _signupUser() async {
    if (_formKey.currentState!.validate()) {
      _loading.value = true;
      await context.read<AuthProvider>().registerUser(
            email: _formState['email'].trim(),
            password: _formState['password'],
            firstName: _formState['firstName'],
            lastName: _formState['lastName'],
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
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: Colors.black,
                          iconSize: isTablet ? 40 : null,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: size.height * .05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(maxHeight: isTablet ? 150 : 100),
                              width: double.infinity,
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
                              height: isPortrait ? size.height * .03 : size.height * .05,
                            ),
                            SizedBox(
                              width: isTablet ? size.width * .56 : (isPortrait ? null : size.width * .65),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: FormInput(
                                          formState: _formState,
                                          formStateKey: 'firstName',
                                          labelText: 'First Name',
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return 'Please enter First Name';
                                            }
                                            return null;
                                          },
                                          fontSize: isTablet ? 20 : null,
                                          textInputType: TextInputType.text,
                                          textCapitalization: TextCapitalization.words,
                                        ),
                                      ),
                                      SizedBox(width: isTablet ? 20 : 5),
                                      Expanded(
                                        flex: 2,
                                        child: FormInput(
                                          formState: _formState,
                                          formStateKey: 'lastName',
                                          labelText: 'Last Name',
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return 'Please enter Last Name';
                                            }
                                            return null;
                                          },
                                          fontSize: isTablet ? 20 : null,
                                          textInputType: TextInputType.text,
                                          textCapitalization: TextCapitalization.words,
                                        ),
                                      ),
                                    ],
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
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                  SizedBox(
                                    child: FormInput(
                                      obscureText: true,
                                      formState: _formState,
                                      formStateKey: 'password',
                                      labelText: 'Password',
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        return null;
                                      },
                                      fontSize: isTablet ? 20 : null,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                  SizedBox(
                                    child: FormInput(
                                      obscureText: true,
                                      formState: _formState,
                                      formStateKey: 'passwordConfirm',
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        if (val != _formState['password']) {
                                          return 'Password doesnt not match';
                                        }
                                        return null;
                                      },
                                      labelText: 'Confirm Password',
                                      fontSize: isTablet ? 20 : null,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _signupUser,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                          child: Text(
                                            'Sign Up',
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
                            )
                          ],
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
