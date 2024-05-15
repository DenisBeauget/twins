import 'package:flutter/material.dart';
import 'package:twins_front/change/registration_controller.dart';
import 'package:twins_front/utils/validador.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final GlobalKey<FormState> formKey;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _registrationController = RegistrationController();

  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        key: formKey,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/img/twins_logo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Inscris-toi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Enter e-mail address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: Validator.emailValidator,
              onChanged: (newValue) {
                _registrationController.email = newValue;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Créer un mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: Validator.passwordValidator,
              onChanged: (newValue) {
                _registrationController.password = newValue;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Répéter le mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: Validator.passwordValidator,
              onChanged: (newValue) {
                _registrationController.password = newValue;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'I have read the Terms of Service',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_termsAccepted) {
                    _registrationController.authenticateWithEmailAndPassword(
                        context: context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Continuer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
