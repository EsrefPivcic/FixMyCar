import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_repair_shop/constants.dart';
import 'home_screen.dart';
import 'master_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.login(
          _usernameController.text,
          _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      showBackButton: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.defaultPadding),
          child: SizedBox(
            width: 400,
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.loginLabel,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: AppConstants.usernameLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppRadius.textFieldRadius),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppConstants.usernameError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: AppConstants.passwordLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppRadius.textFieldRadius),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppConstants.passwordError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      const SizedBox(height: 8.0),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHigh,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.buttonRadius),
                                ),
                              ),
                              child: const Text(AppConstants.loginButtonLabel),
                            ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child:
                            const Text("Don't have an account? Register here."),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
