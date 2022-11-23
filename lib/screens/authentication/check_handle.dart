import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_forms/widgets/form_input.dart';
import 'package:simple_forms/models/app_form_state.dart';

import 'package:timbertrack_mill_app/shared/constants.dart';
import 'package:timbertrack_mill_app/extensions/is_tablet.dart';
import 'package:timbertrack_mill_app/extensions/is_portrait.dart';
import 'package:timbertrack_mill_app/services/local_storage.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/shared/widgets/loading_overlay.dart';

class HandleFormState extends AppFormState<String, String> {
  HandleFormState()
      : super(
          {
            'handle': '',
          },
        );
}

class CheckHandle extends StatefulWidget {
  const CheckHandle({Key? key}) : super(key: key);

  @override
  State<CheckHandle> createState() => _CheckHandleState();
}

class _CheckHandleState extends State<CheckHandle> {
  final _formState = HandleFormState();
  final _formKey = GlobalKey<FormState>();
  final _loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Check's local storage for saved handle
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final handle = LocalStorage.getString('handle') ?? '';
      _formState['handle'] = handle;
    });
  }

  void _handleNextScreen() async {
    if (_formKey.currentState!.validate()) {
      _loading.value = true;
      // Checks to see if handle exists, the navigates or shows error dialog
      final formHandle = _formState['handle'] as String;
      await context.read<HandleProvider>().checkHandleAndNavigate(formHandle, context);
      if (mounted) _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final size = MediaQuery.of(context).size;
    final isPortrait = context.isPortrait;
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isPortrait ? size.height * .15 : size.height * .1,
                        ),
                        SizedBox(
                          height: isTablet ? size.width * .35 : (isPortrait ? 200 : 130),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        SizedBox(
                          height: isPortrait ? size.height * .06 : size.height * .08,
                        ),
                        SizedBox(
                          width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .6),
                          child: FormInput(
                            key: const Key('handle-input'),
                            formState: _formState,
                            formStateKey: 'handle',
                            labelText: 'Company ID',
                            fontSize: isTablet ? 20 : null,
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter a handle';
                              }
                              return null;
                            },
                            focusBorderColor: Colors.lightBlue,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        SizedBox(
                          width: isTablet ? size.width * .5 : (isPortrait ? null : size.width * .6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _handleNextScreen,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: isTablet ? 20 : null,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
          ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, bool value, child) {
              if (value) {
                return const LoadingOverlay();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
