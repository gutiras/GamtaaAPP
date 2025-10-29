import 'package:flutter/material.dart';
import 'customer_info_personal_step.dart';
import 'customer_info_contact_step.dart';
import 'customer_info_security_step.dart';
import 'customer_info_success_screen.dart';
import 'get_started_screen.dart';

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String _selectedCountryCode = '+251'; // Ethiopia by default
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 0;

  // Error state variables
  String? _phoneError;
  String? _emailError;
  String? _addressError;
  String? _passwordError;
  String? _confirmPasswordError;

  final Map<String, dynamic> _userData = {
    'fullName': 'Gutu Rarie',
    'dateOfBirth': '1990-05-15',
    'gender': 'Male',
    'nationality': 'Ethiopian',
  };

  @override
  void initState() {
    super.initState();
    
    // Add listeners to clear errors when user starts typing
    _phoneController.addListener(() {
      if (_phoneError != null) {
        setState(() {
          _phoneError = null;
        });
      }
    });
    
    _emailController.addListener(() {
      if (_emailError != null) {
        setState(() {
          _emailError = null;
        });
      }
    });
    
    _addressController.addListener(() {
      if (_addressError != null) {
        setState(() {
          _addressError = null;
        });
      }
    });
    
    _passwordController.addListener(() {
      if (_passwordError != null || _confirmPasswordError != null) {
        setState(() {
          _passwordError = null;
          _confirmPasswordError = null;
        });
      }
    });
    
    _confirmPasswordController.addListener(() {
      if (_confirmPasswordError != null) {
        setState(() {
          _confirmPasswordError = null;
        });
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showSuccessScreen();
    }
  }

  void _showSuccessScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomerInfoSuccessScreen()),
      (route) => false,
    );
  }

  void _navigateToGetStarted() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const GetStartedScreen()),
      (route) => false,
    );
  }

  void _nextStep() {
    bool isStepValid = _validateCurrentStep();
    
    if (isStepValid && _currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1: // Contact Details
        _phoneError = null;
        _emailError = null;
        _addressError = null;

        bool isValid = true;

        if (_phoneController.text.isEmpty) {
          _phoneError = 'Phone number is required';
          isValid = false;
        } else if (_phoneController.text.length < 9) {
          _phoneError = 'Phone number is too short';
          isValid = false;
        }

        if (_emailController.text.isEmpty) {
          _emailError = 'Email address is required';
          isValid = false;
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
          _emailError = 'Please enter a valid email address';
          isValid = false;
        }

        if (_addressController.text.isEmpty) {
          _addressError = 'Address is required';
          isValid = false;
        }

        setState(() {}); // Trigger rebuild to show errors
        return isValid;
      
      case 2: // Security
        _passwordError = null;
        _confirmPasswordError = null;

        bool isValid = true;

        if (_passwordController.text.isEmpty) {
          _passwordError = 'Password is required';
          isValid = false;
        } else if (_passwordController.text.length < 6) {
          _passwordError = 'Password must be at least 6 characters';
          isValid = false;
        }

        if (_confirmPasswordController.text.isEmpty) {
          _confirmPasswordError = 'Please confirm your password';
          isValid = false;
        } else if (_passwordController.text != _confirmPasswordController.text) {
          _confirmPasswordError = 'Passwords do not match';
          isValid = false;
        }

        setState(() {}); // Trigger rebuild to show errors
        return isValid;
      
      default:
        return true;
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00ADEF);
    const Color darkBlue = Color(0xFF0078D4);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Complete Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(primaryBlue),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: _buildCurrentStep(),
              ),
            ),
          ),
          // Navigation Buttons
          _buildNavigationButtons(primaryBlue, darkBlue),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Personal Info', 'Contact Details', 'Security']
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final label = entry.value;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: index <= _currentStep ? primaryBlue : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: index < _currentStep
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: index <= _currentStep ? Colors.white : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: index <= _currentStep ? primaryBlue : Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey.shade200,
            color: primaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(Color primaryBlue, Color darkBlue) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryBlue,
                  side: BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('BACK'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(colors: [primaryBlue, darkBlue]),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
              child: ElevatedButton(
                onPressed: _currentStep == 2 ? _submitForm : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentStep == 2 ? 'SUBMIT' : 'CONTINUE',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    final cardColor = Theme.of(context).cardColor;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceSecondaryColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    switch (_currentStep) {
      case 0:
        return CustomerInfoPersonalStep(
          userData: _userData,
          cardColor: cardColor,
          onSurfaceColor: onSurfaceColor,
          onSurfaceSecondaryColor: onSurfaceSecondaryColor,
        );
      case 1:
        return CustomerInfoContactStep(
          phoneController: _phoneController,
          emailController: _emailController,
          addressController: _addressController,
          onCountryCodeChanged: (code) {
            setState(() {
              _selectedCountryCode = code;
            });
          },
          cardColor: cardColor,
          onSurfaceColor: onSurfaceColor,
          onSurfaceSecondaryColor: onSurfaceSecondaryColor,
          phoneError: _phoneError,
          emailError: _emailError,
          addressError: _addressError,
        );
      case 2:
        return CustomerInfoSecurityStep(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          onToggleConfirmPasswordVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          cardColor: cardColor,
          onSurfaceColor: onSurfaceColor,
          onSurfaceSecondaryColor: onSurfaceSecondaryColor,
         
        );
      default:
        return CustomerInfoPersonalStep(
          userData: _userData,
          cardColor: cardColor,
          onSurfaceColor: onSurfaceColor,
          onSurfaceSecondaryColor: onSurfaceSecondaryColor,
        );
    }
  }
}