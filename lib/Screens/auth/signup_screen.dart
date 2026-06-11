import 'package:flutter/material.dart';
import 'package:love14/providers/auth_provider.dart';
import 'package:love14/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0; // 0: User 1, 1: User 2, 2: Couple details

  // User 1 fields
  final _name1Controller = TextEditingController();
  final _email1Controller = TextEditingController();
  final _password1Controller = TextEditingController();

  // User 2 fields
  final _name2Controller = TextEditingController();
  final _email2Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  // Couple fields
  final _coupleNameController = TextEditingController();
  DateTime? _anniversaryDate;

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  // TODO: Use for password confirmation field if implemented
  // bool _obscurePassword2Confirm = true;

  @override
  void dispose() {
    _name1Controller.dispose();
    _email1Controller.dispose();
    _password1Controller.dispose();
    _name2Controller.dispose();
    _email2Controller.dispose();
    _password2Controller.dispose();
    _coupleNameController.dispose();
    super.dispose();
  }

  void _handleSignup(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.signUpCouple(
        email1: _email1Controller.text.trim(),
        password1: _password1Controller.text,
        name1: _name1Controller.text.trim(),
        email2: _email2Controller.text.trim(),
        password2: _password2Controller.text,
        name2: _name2Controller.text.trim(),
        coupleName: _coupleNameController.text.trim().isEmpty
            ? null
            : _coupleNameController.text.trim(),
        anniversaryDate: _anniversaryDate,
      );

      if (mounted) {
        if (success) {
          // Navigation will happen automatically via auth state change
        } else if (authProvider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.errorMessage!)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Couple Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: List.generate(3, (index) {
                          final isActive = index <= _currentStep;
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 3,
                              color: isActive
                                  ? const Color(0xFFE31B48)
                                  : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                    ),

                    // Step indicator text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        _currentStep == 0
                            ? 'Person 1 Details'
                            : _currentStep == 1
                                ? 'Person 2 Details'
                                : 'Couple Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    // Error message
                    if (authProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            authProvider.errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ),

                    // Step 0: User 1
                    if (_currentStep == 0) ...[
                      TextFormField(
                        controller: _name1Controller,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _email1Controller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Your Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password1Controller,
                        obscureText: _obscurePassword1,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword1 ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword1 = !_obscurePassword1);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],

                    // Step 1: User 2
                    if (_currentStep == 1) ...[
                      TextFormField(
                        controller: _name2Controller,
                        decoration: InputDecoration(
                          labelText: "Partner's Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter partner name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _email2Controller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Partner's Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter partner email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password2Controller,
                        obscureText: _obscurePassword2,
                        decoration: InputDecoration(
                          labelText: "Partner's Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword2 ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword2 = !_obscurePassword2);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],

                    // Step 2: Couple details
                    if (_currentStep == 2) ...[
                      TextFormField(
                        controller: _coupleNameController,
                        decoration: InputDecoration(
                          labelText: 'Couple Name (Optional)',
                          hintText: 'e.g., John & Maria',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.favorite),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _anniversaryDate ?? DateTime.now(),
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _anniversaryDate = picked);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 8),
                            Text(
                              _anniversaryDate == null
                                  ? 'Select Anniversary Date'
                                  : 'Anniversary: ${_anniversaryDate!.toLocal().toString().split(' ')[0]}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'By creating an account, both of you will receive an email to verify your identity.',
                          style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Navigation buttons
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => _currentStep--);
                              },
                              child: const Text('Back'),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () {
                                    if (_currentStep < 2) {
                                      setState(() => _currentStep++);
                                    } else {
                                      _handleSignup(authProvider);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE31B48),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  _currentStep < 2 ? 'Next' : 'Create Account',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
