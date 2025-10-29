import 'package:flutter/material.dart';
import '../base_scaffold.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Profile',
      userName: 'Gutu Rarie',
      notificationCount: 0,
      showBackButton: false,
      initialTabIndex: 4, // Me tab index
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Quick Actions (Removed duplicates)
            _buildQuickActions(),
            const SizedBox(height: 24),

            // Settings Section (Simplified)
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00ADEF).withOpacity(0.1),
                border: Border.all(
                  color: const Color(0xFF00ADEF).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.person, size: 40, color: Color(0xFF00ADEF)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gutu Rarie',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'gutu.rarie@example.com',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+251 91 234 5678',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Verified Account',
                      style: TextStyle(
                        color: Color(0xFF34C759),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF00ADEF)),
              onPressed: () {
                // Navigate to edit profile
                _showEditProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildProfileAction(Icons.qr_code_2, 'My QR', () {
          // Navigate to QR code - This is unique to profile
        }),
        _buildProfileAction(Icons.credit_card, 'My Cards', () {
          // Navigate to cards - This is unique to profile
        }),
        _buildProfileAction(Icons.share, 'Share App', () {
          // Share app functionality
          _shareApp();
        }),
      ],
    );
  }

  Widget _buildProfileAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF00ADEF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF00ADEF), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // Removed duplicates: Accounts, Transaction History, E-Statements, Payment Methods
            // (These are available in other sections of the app)
            
            // Profile & Security
            _buildSettingsItem(
              Icons.person_outline,
              'Edit Profile',
              'Update your personal information',
              onTap: _showEditProfile,
            ),
            _buildSettingsItem(
              Icons.lock_outline,
              'Security',
              'Change password & security settings',
              onTap: () {
                // Navigate to security settings
              },
            ),
            _buildSettingsItem(
              Icons.fingerprint,
              'Biometric Login',
              'Enabled',
              onTap: () {
                // Toggle biometric login
              },
            ),

            // App Preferences
            _buildSettingsItem(
              Icons.notifications_outlined,
              'Notifications',
              'Manage app notifications',
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            _buildSettingsItem(
              Icons.language,
              'Language',
              'English',
              onTap: () {
                // Navigate to language settings
              },
            ),

            // Support
            _buildSettingsItem(
              Icons.help_outline,
              'Help & Support',
              'FAQs and customer support',
              onTap: () {
                // Navigate to help center
              },
            ),
            _buildSettingsItem(
              Icons.info_outline,
              'About',
              'App version 1.0.0',
              onTap: () {
                // Navigate to about page
              },
            ),

            // Logout
            _buildSettingsItem(
              Icons.logout,
              'Logout',
              'Sign out of your account',
              isLogout: true,
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF00ADEF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF00ADEF),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isLogout
          ? null
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showEditProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Edit profile feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    // Simulate share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share app feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}