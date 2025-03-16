import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Registration',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  int _remainingWords = 150; // ✅ Remaining words counter

  String? _gender;
  String? _selectedCity;
  File? _selectedImage;
  Uint8List? _webImage;
  bool _obscurePassword = true; // ✅ Password visibility toggle

  final List<String> _cities = [
    'Nankana Sahib', 'Lahore', 'Quetta', 'Islamabad', 'Gujranwala', 'Peshawar'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    }
  }

  bool _isStrongPassword(String password) {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
  }

  // ✅ Save Data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text); // ✅ Password saved
    await prefs.setString('gender', _gender ?? '');
    await prefs.setString('city', _selectedCity ?? '');
    await prefs.setString('address', _addressController.text);
  }

  // ✅ Word count validation
  void _updateRemainingWords(String text) {
    setState(() {
      _remainingWords = 150 - text.split(RegExp(r'\s+')).length;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _webImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a picture')),
        );
        return;
      }
      _saveData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted & Saved Successfully!')),
      );

      // ✅ Navigate to login page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('User Registration',
            style: GoogleFonts.montserrat(
                fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_nameController, 'Name', Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  const SizedBox(height: 16),

                  // ✅ Password Field with Toggle Visibility
                  _buildTextField(
                    _passwordController, 
                    'Password', 
                    Icons.lock, 
                    isPassword: true
                  ),

                  const SizedBox(height: 16),
                  Text('Gender', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _buildRadioButton('Male'),
                      _buildRadioButton('Female'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    decoration: _inputDecoration('City'),
                    items: _cities
                        .map((city) =>
                            DropdownMenuItem(value: city, child: Text(city)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCity = value),
                    validator: (value) => value == null ? 'Select a city' : null,
                  ),
                  const SizedBox(height: 16),

                  // ✅ Address Field with Remaining Words Counter
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    onChanged: _updateRemainingWords, // ✅ Track word count
                    decoration: _inputDecoration('Address').copyWith(
                      prefixIcon: const Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter your address';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Remaining words: $_remainingWords',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Upload Picture'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        if (_webImage != null) Image.memory(_webImage!, height: 100),
                        if (_selectedImage != null) Image.file(_selectedImage!, height: 100),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gender,
          onChanged: (val) => setState(() => _gender = val),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {bool isPassword = false}
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: _inputDecoration(label).copyWith(
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.teal,
                ),
                onPressed: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
              )
            : null,
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );
}
