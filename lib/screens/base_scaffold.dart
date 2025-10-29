import 'package:flutter/material.dart';
import 'footer_navigation.dart';
import 'custom_app_bar.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final String userName;
  final int notificationCount;
  final bool showBackButton;
  final bool showFooter;
  final VoidCallback? onBackPressed;
  final int initialTabIndex; // Add this to set active footer tab

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.userName,
    this.notificationCount = 0,
    this.showBackButton = false,
    this.showFooter = true,
    this.onBackPressed,
    this.initialTabIndex = 0, // Default to home tab
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Set the current index based on which screen we're on
    _currentIndex = widget.initialTabIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to respective pages only if we're not already there
    switch (index) {
      case 0: // Home
        if (ModalRoute.of(context)?.settings.name != '/home') {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 1: // Apps
        if (ModalRoute.of(context)?.settings.name != '/apps') {
          Navigator.pushNamed(context, '/apps');
        }
        break;
      case 2: // Scan
        if (ModalRoute.of(context)?.settings.name != '/scan') {
          Navigator.pushNamed(context, '/scan');
        }
        break;
      case 3: // History
        if (ModalRoute.of(context)?.settings.name != '/history') {
          Navigator.pushNamed(context, '/history');
        }
        break;
      case 4: // Me
        if (ModalRoute.of(context)?.settings.name != '/me') {
          Navigator.pushNamed(context, '/me');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        userName: widget.userName,
        notificationCount: widget.notificationCount,
        showBackButton: widget.showBackButton,
        onBackPressed: widget.onBackPressed,
        screenTitle: widget.showBackButton ? widget.title : null,
      ),
      body: Column(
        children: [
          Expanded(child: widget.body),
          if (widget.showFooter)
            FooterNavigation(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            ),
        ],
      ),
    );
  }
}