import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trade_seller/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _userData;

  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        _emailController.text = user.email ?? '';
        final snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          _userData = snapshot;
          _nameController.text = _userData?['name'] ?? '';
          _phoneController.text = _userData?['phone'] ?? '';
        } else {
          await _firestore.collection('users').doc(user.uid).set({
            'name': '',
            'phone': '',
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setState(() {});
    }
  }

  Future<void> _saveUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'phone': _phoneController.text,
        }, SetOptions(merge: true)); // Merge: update only provided fields
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      print('Error saving user details: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildUserDetailsContent() {
    if (_userData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          TextField(
            controller: _emailController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            readOnly: !_isEditing,
            decoration: InputDecoration(
              labelText: 'Name',
              border: const OutlineInputBorder(),
              suffixIcon: _isEditing ? const Icon(Icons.edit) : null,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            readOnly: !_isEditing,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: const OutlineInputBorder(),
              suffixIcon: _isEditing ? const Icon(Icons.edit) : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveUserDetails();
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildUserDetailsContent(),
      ),
    );
  }
}
