import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  final String googleIconPath = 'assets/icons/icons8-google.svg';
  // final String facebookIconPath = 'assets/icons/icons8-facebook.svg';
  final String anonymousIconPath = 'assets/icons/icons8-incognito-48.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Welcome message.
                  Text(
                    'Welcome NSTP Slaves!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text('Sign-in to gain your freedom.'),
                  const SizedBox(height: 40.0),

                  // Log in with Google.
                  FilledButton.tonal(
                    onPressed: () async {
                      // Show alert dialog.
                      await showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Coming Soon'),
                            content: const Text(
                              'This feature is coming soon.',
                            ),
                            actions: <TextButton>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          googleIconPath,
                          width: 24.0,
                          height: 24.0,
                          semanticsLabel: 'Google Icon Logo',
                        ),
                        const SizedBox(width: 8.0),
                        const Text('Log in with Google'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Log in Anonymously.
                  FilledButton.tonal(
                    onPressed: () {
                      // Show alert dialog.
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Coming Soon'),
                            content: const Text(
                              'This feature is coming soon.',
                            ),
                            actions: <TextButton>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          anonymousIconPath,
                          width: 24.0,
                          height: 24.0,
                          semanticLabel: 'Anonymous Icon',
                        ),
                        const SizedBox(width: 8.0),
                        const Text('Log in Anonymously'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Horizontal divider.
                  const Row(
                    children: <Widget>[
                      Expanded(child: Divider(endIndent: 8.0)),
                      Text('OR'),
                      Expanded(child: Divider(indent: 8.0)),
                    ],
                  ),
                  const SizedBox(height: 32.0),

                  SvgPicture.asset(
                    'assets/illustrations/undraw_secure_login_pdn4.svg',
                    width: 150.0,
                    height: 150.0,
                    semanticsLabel: 'Secure Login Illustration',
                  ),

                  const SizedBox(height: 70.0),

                  // Log in with Email form.
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Email text field.
          FormBuilderTextField(
            key: _emailFieldKey,
            name: 'email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
          ),
          const SizedBox(height: 32.0),

          // Password text field.
          FormBuilderTextField(
            name: 'password',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: _isPasswordVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                color: _isPasswordVisible
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ],
            ),
          ),

          // Forgot password?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                // Show alert dialog.
                await showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'This feature is coming soon.',
                      ),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 32.0),

          // Log in button.
          FilledButton(
            onPressed: () async {
              late final String email;
              late final String password;

              if (_formKey.currentState?.saveAndValidate() ?? false) {
                email = _formKey.currentState?.value['email'];
                password = _formKey.currentState?.value['password'];
              }

              // Logger.
              GetIt.I<Logger>().i('Email: $email | Password: $password');

              // Log in via appwrite auth.
              final Account account = GetIt.I<Account>();

              try {
                // Show loading dialog.
                showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logging in...'),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LoadingAnimationWidget.discreteCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 100.0,
                          ),
                        ],
                      ),
                    );
                  },
                );

                await account.createEmailPasswordSession(
                    email: email, password: password);

                if (context.mounted) {
                  // Close loading dialog.
                  Navigator.of(context).pop();

                  // Navigate to home page. Pass the email to the map page.
                  GoRouter.of(context).go('/nstp-map', extra: email);
                }
              } catch (e) {
                // Show alert dialog.
                if (context.mounted) {
                  await showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.toString()),
                        actions: <TextButton>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }

                // Close loading dialog.
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Log in'),
          ),
          const SizedBox(height: 16.0),

          // Don't have an account? Sign up.
          Row(
            children: <Widget>[
              const Text('Don\'t have an account? '),
              TextButton(
                onPressed: () async {
                  // Show alert dialog.
                  await showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Coming Soon'),
                        content: const Text(
                          'This feature is coming soon.',
                        ),
                        actions: <TextButton>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Sign up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
