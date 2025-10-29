import 'package:flutter/material.dart';
import 'get_started_screen.dart';

class CustomerInfoSuccessScreen extends StatefulWidget {
  const CustomerInfoSuccessScreen({super.key});

  @override
  State<CustomerInfoSuccessScreen> createState() => _CustomerInfoSuccessScreenState();
}

class _CustomerInfoSuccessScreenState extends State<CustomerInfoSuccessScreen> {
  bool _isNavigating = false;

  void _navigateToGetStarted(BuildContext context) {
    if (_isNavigating) return; // Prevent multiple taps
    
    setState(() {
      _isNavigating = true;
    });

    // Use a small delay to ensure the button press animation completes
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GetStartedScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00ADEF);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: primaryBlue,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your account application has been submitted successfully. '
                'Please wait for a few hours until your account is approved. '
                'You will receive a notification once your account is ready.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isNavigating ? null : () => _navigateToGetStarted(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isNavigating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'BACK TO HOME',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}