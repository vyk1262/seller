import 'package:firebase_auth/firebase_auth.dart';
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

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for Sign In
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for Sign Up
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print('Please enter valid credentials');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase sign-in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } on FirebaseAuthException catch (e) {
      print('Sign-in failed: ${e.message}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        location.isEmpty) {
      print('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      print('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase sign-up with email and password
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      print('Signed up with Email: $email, Name: $name, Location: $location');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } on FirebaseAuthException catch (e) {
      print('Sign-up failed: ${e.message}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading) ...[
              TextButton(
                onPressed: () => FirebaseCrashlytics.instance.crash(),
                child: Text("Force Crash (for testing)"),
              ),
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
              _isSignIn ? _buildSignInForm() : _buildSignUpForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
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
          controller: _signUpEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _signUpPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
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
