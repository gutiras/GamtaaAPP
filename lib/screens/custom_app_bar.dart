import 'package:flutter/material.dart';
import 'app_bar_actions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final int notificationCount;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? screenTitle; // Add this for back button screens

  const CustomAppBar({
    super.key,
    required this.userName,
    this.notificationCount = 0,
    this.showBackButton = false,
    this.onBackPressed,
    this.screenTitle, // Add this parameter
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Logo/App Icon or Back Button
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            else
              Image.asset(
                'assets/icons/Illustration.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            
            const SizedBox(width: 12),
            
            // Greeting Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showBackButton ? (screenTitle ?? '') : 'Welcome back,',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Reusable App Bar Actions
            AppBarActions(
              notificationCount: notificationCount,
              onLanguageChanged: (language) {
                print('Language changed to: $language');
              },
              onNotificationsTap: () {
                print('Notifications tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}