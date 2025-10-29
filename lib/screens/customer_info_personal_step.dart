import 'package:flutter/material.dart';

class CustomerInfoPersonalStep extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Color cardColor;
  final Color onSurfaceColor;
  final Color onSurfaceSecondaryColor;

  const CustomerInfoPersonalStep({
    super.key,
    required this.userData,
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
          Column(
            children: [
              _buildInfoItem('Full Name', userData['fullName'], Icons.person),
              _buildInfoItem('Date of Birth', userData['dateOfBirth'], Icons.cake),
              _buildInfoItem('Gender', userData['gender'], Icons.people),
              _buildInfoItem('Nationality', userData['nationality'], Icons.flag),
            ],
          ),
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
          child: const Icon(Icons.person_outline, color: Color(0xFF00ADEF), size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Verified from your digital ID',
          style: TextStyle(
            color: onSurfaceSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00ADEF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: onSurfaceSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}