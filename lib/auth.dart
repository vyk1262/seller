import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:trade_seller/home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true; // To toggle between sign-in and sign-up

  // Controllers for Sign In
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for Sign Up
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _signUpPhoneNumberController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _signUpPhoneNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _signIn() {
    // Handle Sign In logic here
    final phoneNumber = _phoneNumberController.text;
    final password = _passwordController.text;
    print('Signing in with Phone: $phoneNumber, Password: $password');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
    // Add your sign-in logic (like API calls) here
  }

  void _signUp() {
    // Handle Sign Up logic here
    final name = _nameController.text;
    final phoneNumber = _signUpPhoneNumberController.text;
    final location = _locationController.text;
    print(
        'Signing up with Name: $name, Phone: $phoneNumber, Location: $location');
    // Add your sign-up logic (like API calls) here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => FirebaseCrashlytics.instance.crash(),
              child: Text("Force Crash (for testing)"),
            ),
            // Toggle between Sign In and Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _toggleForm,
                  icon: Icon(
                    _isSignIn ? Icons.person_add : Icons.login,
                    color: Colors.blue,
                  ),
                  label: Text(
                    _isSignIn ? 'Switch to Sign Up' : 'Switch to Sign In',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Conditionally render the Sign In or Sign Up form
            _isSignIn ? _buildSignInForm() : _buildSignUpForm(),
          ],
        ),
      ),
    );
  }

  // Build Sign In form
  Widget _buildSignInForm() {
    return Column(
      children: [
        TextField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _signIn,
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  // Build Sign Up form
  Widget _buildSignUpForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _signUpPhoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _signUp,
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
