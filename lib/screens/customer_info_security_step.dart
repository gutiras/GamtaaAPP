import 'package:flutter/material.dart';

class CustomerInfoSecurityStep extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final Color cardColor;
  final Color onSurfaceColor;
  final Color onSurfaceSecondaryColor;

  const CustomerInfoSecurityStep({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.cardColor,
    required this.onSurfaceColor,
    required this.onSurfaceSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildStepHeader(),
          const SizedBox(height: 32),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 16),
          _buildPasswordRequirements(),
        ],
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF00ADEF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.lock_outline, color: Color(0xFF00ADEF), size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          'Account Security',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your password',
          style: TextStyle(
            color: onSurfaceSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: obscurePassword,
        style: TextStyle(color: onSurfaceColor),
        decoration: InputDecoration(
          labelText: 'New Password',
          hintText: 'Create a secure password',
          prefixIcon: Container(
            width: 50,
            alignment: Alignment.center,
            child: const Icon(Icons.lock, color: Color(0xFF00ADEF)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: onSurfaceSecondaryColor,
            ),
            onPressed: onTogglePasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: cardColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: confirmPasswordController,
        obscureText: obscureConfirmPassword,
        style: TextStyle(color: onSurfaceColor),
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Re-enter your password',
          prefixIcon: Container(
            width: 50,
            alignment: Alignment.center,
            child: const Icon(Icons.lock, color: Color(0xFF00ADEF)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: onSurfaceSecondaryColor,
            ),
            onPressed: onToggleConfirmPasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: cardColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00ADEF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00ADEF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirement('At least 6 characters', passwordController.text.length >= 6),
          _buildRequirement('Contains letters and numbers', 
              RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(passwordController.text)),
          _buildRequirement('Passwords match', 
              passwordController.text.isNotEmpty && 
              passwordController.text == confirmPasswordController.text),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}