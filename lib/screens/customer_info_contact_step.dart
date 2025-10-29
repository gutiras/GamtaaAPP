import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomerInfoContactStep extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final Function(String) onCountryCodeChanged;
  final Color cardColor;
  final Color onSurfaceColor;
  final Color onSurfaceSecondaryColor;
  final String? phoneError;
  final String? emailError;
  final String? addressError;

  const CustomerInfoContactStep({
    super.key,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onCountryCodeChanged,
    required this.cardColor,
    required this.onSurfaceColor,
    required this.onSurfaceSecondaryColor,
    this.phoneError,
    this.emailError,
    this.addressError,
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
          _buildPhoneFieldWithCountryCode(),
          if (phoneError != null) _buildErrorText(phoneError!),
          const SizedBox(height: 20),
          _buildEmailField(),
          if (emailError != null) _buildErrorText(emailError!),
          const SizedBox(height: 20),
          _buildAddressField(),
          if (addressError != null) _buildErrorText(addressError!),
        ],
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
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
          child: const Icon(Icons.contact_phone_outlined, color: Color(0xFF00ADEF), size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          'Contact Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Update your contact information',
          style: TextStyle(
            color: onSurfaceSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFieldWithCountryCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Container(
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
          child: IntlPhoneField(
            controller: phoneController,
            style: TextStyle(color: onSurfaceColor),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              labelStyle: TextStyle(color: onSurfaceSecondaryColor),
              hintStyle: TextStyle(color: onSurfaceSecondaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: cardColor,
              suffixIcon: const Icon(Icons.edit, color: Colors.orange, size: 20),
              errorBorder: phoneError != null ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ) : null,
            ),
            initialCountryCode: 'ET', // Ethiopia by default
            onCountryChanged: (country) {
              onCountryCodeChanged('+${country.dialCode}');
            },
            dropdownTextStyle: TextStyle(color: onSurfaceColor),
            dropdownIcon: Icon(Icons.arrow_drop_down, color: onSurfaceSecondaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: onSurfaceColor),
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              labelStyle: TextStyle(color: onSurfaceSecondaryColor),
              hintStyle: TextStyle(color: onSurfaceSecondaryColor),
              prefixIcon: Container(
                width: 50,
                alignment: Alignment.center,
                child: const Icon(Icons.email, color: Color(0xFF00ADEF)),
              ),
              suffixIcon: const Icon(Icons.edit, color: Colors.orange, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: cardColor,
              errorBorder: emailError != null ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: addressController,
            style: TextStyle(color: onSurfaceColor),
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: 'Enter your current address',
              labelStyle: TextStyle(color: onSurfaceSecondaryColor),
              hintStyle: TextStyle(color: onSurfaceSecondaryColor),
              prefixIcon: Container(
                width: 50,
                alignment: Alignment.center,
                child: const Icon(Icons.home, color: Color(0xFF00ADEF)),
              ),
              suffixIcon: const Icon(Icons.edit, color: Colors.orange, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: cardColor,
              errorBorder: addressError != null ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ) : null,
            ),
          ),
        ),
      ],
    );
  }
}