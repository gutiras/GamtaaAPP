// lib/screens/app_bar_actions.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart'; // ✅ Import provider

class AppBarActions extends StatefulWidget {
  final int notificationCount;
  final Function(String) onLanguageChanged;
  final VoidCallback onNotificationsTap;
  final bool showNotifications; // ✅ New parameter

  const AppBarActions({
    super.key,
    this.notificationCount = 0,
    required this.onLanguageChanged,
    required this.onNotificationsTap,
    this.showNotifications = true, // ✅ Default to true
  });

  @override
  State<AppBarActions> createState() => _AppBarActionsState();
}

class _AppBarActionsState extends State<AppBarActions> {
  String _currentLanguage = 'English';
  final _languageKey = GlobalKey();
  final _notificationKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleTheme() {
    // ✅ Simple one-liner that works across entire app!
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Watch for theme changes to update the icon
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDarkTheme;

    return Row(
      children: [
        // Theme Changer
        _buildAppBarAction(
          key: Key('theme_$isDarkTheme'),
          icon: isDarkTheme ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onPressed: _toggleTheme,
          tooltip: 'Toggle Theme',
        ),
        
        const SizedBox(width: 8),
        
        // Language Selector
        _buildAppBarAction(
          key: _languageKey,
          icon: Icons.language_outlined,
          onPressed: _showLanguageDropdown,
          tooltip: 'Change Language',
        ),
        
        // ✅ Conditionally show notifications
        if (widget.showNotifications) ...[
          const SizedBox(width: 8),
          _buildNotificationButton(),
        ],
      ],
    );
  }

  Widget _buildAppBarAction({
    required Key key,
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      key: key,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      key: _notificationKey,
      children: [
        _buildAppBarAction(
          key: Key('notification_${DateTime.now().millisecondsSinceEpoch}'),
          icon: Icons.notifications_outlined,
          onPressed: _showNotificationDropdown,
          tooltip: 'Notifications',
        ),
        if (widget.notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.notificationCount > 9 ? '9+' : widget.notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showLanguageDropdown() {
    _removeOverlay();
    
    final RenderBox renderBox = _languageKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: offset.dy + renderBox.size.height + 8,
            right: MediaQuery.of(context).size.width - offset.dx - renderBox.size.width,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Select Language',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...['English', 'Amharic', 'Afaan Oromoo', 'Tigrigna'].map((language) {
                      return ListTile(
                        dense: true,
                        title: Text(language),
                        trailing: _currentLanguage == language 
                            ? const Icon(Icons.check, color: Colors.green, size: 16) 
                            : null,
                        onTap: () {
                          setState(() => _currentLanguage = language);
                          widget.onLanguageChanged(language);
                          _removeOverlay();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showNotificationDropdown() {
    _removeOverlay();
    
    final RenderBox renderBox = _notificationKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: offset.dy + renderBox.size.height + 8,
            right: MediaQuery.of(context).size.width - offset.dx - renderBox.size.width,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Add your notification items here
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No new notifications'),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Text(
                        'View All Notifications',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}