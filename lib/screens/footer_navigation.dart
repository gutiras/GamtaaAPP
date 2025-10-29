import 'package:flutter/material.dart';

class FooterNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FooterNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.apps, 'Apps', 1),
          _buildNavItem(Icons.qr_code, 'Scan', 2),
          _buildNavItem(Icons.history, 'History', 3),
          _buildNavItem(Icons.person, 'Me', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;
    final color = isActive ? const Color(0xFF00ADEF) : Colors.grey;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}