import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'fan_entry_screen.dart';
import 'app_bar_actions.dart'; // Your AppBarActions component
// Import theme provider

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key}); // Removed all callbacks

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00ADEF);
    const Color darkBlue = Color(0xFF0078D4);
    const Color accentOrange = Color(0xFFFF9500);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Uses theme
        
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Modern App Bar with imported actions
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Logo/Name
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/Illustration.png',
                        width: 40,
                        height: 40,
                        fit:
                            BoxFit
                                .cover, // or BoxFit.contain depending on your need
                      ),

                      const SizedBox(width: 8),
                      const Text(
                        "Gamtaa",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  AppBarActions(
                          notificationCount: 0,
                          onLanguageChanged: (language) {
                            print('Language changed to: $language');
                          },
                          onNotificationsTap: () {
                            print('Notifications tapped');
                          },
                          showNotifications: false, // ✅ Hide notifications
                        )
                ],
              ),
            ),

            // 🔹 Expanded content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Container
                    Container(
                      width: 300,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(161, 143, 225, 252), 
                            blurRadius: 50,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/Illustration.png', // Replace with your image path
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Welcome Text with modern typography
                    Column(
                      children: [
                        ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                colors: [primaryBlue, darkBlue],
                              ).createShader(bounds),
                          child: const Text(
                            "WELCOME TO",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color:
                                  Colors
                                      .white, // This will be overridden by shader
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "GAMTAA APP",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accentOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentOrange.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        "Smart Banking. Simple Living",
                        style: TextStyle(
                          color: accentOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Feature highlights
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(Icons.security, "Secure"),
                        _buildFeatureItem(Icons.bolt, "Fast"),
                        _buildFeatureItem(Icons.phone_iphone, "Mobile"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Bottom buttons section
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),       
              child: Column(
                children: [
                  // Get Started Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7, // 50% of screen
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FanEntryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: primaryBlue,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: primaryBlue, width: 2),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "GET STARTED",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          SizedBox(width: 8),
                          
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login Button with gradient
                  SizedBox(
                     width: MediaQuery.of(context).size.width * 0.7, 
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryBlue, darkBlue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_open,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "LOGIN NOW",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF00ADEF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF00ADEF), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter for background dots pattern
class _DotsPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    const double spacing = 15;
    const double radius = 1.5;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
