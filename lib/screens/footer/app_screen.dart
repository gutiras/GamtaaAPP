import 'package:flutter/material.dart';
import '../base_scaffold.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredApps = [];
  int _selectedCategory = 0; // 0: All, 1: Banking, 2: E-commerce, 3: Transport, 4: Others
  final List<String> _categories = ['All', 'Banking', 'E-commerce', 'Transport', 'Others'];

  final List<Map<String, dynamic>> _allApps = [
    // Banking Apps
    {
      'icon': 'assets/icons/coop engae.png',
      'label': 'Coop Engage',
      'category': 'banking',
    },
    {
      'icon': 'assets/icons/CoopCard.png',
      'label': 'Coop Card',
      'category': 'banking',
    },
    {
      'icon': 'assets/icons/E-Statement.png',
      'label': 'E-Statement',
      'category': 'banking',
    },
    {
      'icon': 'assets/icons/ebirr.png',
      'label': 'EBirr',
      'category': 'banking',
    },

    // E-commerce Apps
    {
      'icon': 'assets/icons/coop market.png',
      'label': 'Coop Market',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/ashewa.png',
      'label': 'Ashewa',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/awrastore.png',
      'label': 'Awra Store',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/dallol gabeya.png',
      'label': 'Dallol Gabeya',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/coin market.png',
      'label': 'Coin Market',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/jiji.png',
      'label': 'Jiji',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/tina mart.png',
      'label': 'Tina Mart',
      'category': 'ecommerce',
    },
    {
      'icon': 'assets/icons/hello market.png',
      'label': 'Hello Market',
      'category': 'ecommerce',
    },

    // Transport Apps
    {
      'icon': 'assets/icons/Ride.png',
      'label': 'Ride',
      'category': 'transport',
    },
    {
      'icon': 'assets/icons/yango.png',
      'label': 'Yango',
      'category': 'transport',
    },
    {
      'icon': 'assets/icons/ethio railway.png',
      'label': 'Ethio Railway',
      'category': 'transport',
    },
    {
      'icon': 'assets/icons/ethiopian airlines.png',
      'label': 'Ethiopian Airlines',
      'category': 'transport',
    },
    {
      'icon': 'assets/icons/delivery addis.png',
      'label': 'Delivery Addis',
      'category': 'transport',
    },

    // Others (Entertainment, Jobs, Travel)
    {
      'icon': 'assets/icons/coop stream.png',
      'label': 'Coop Stream',
      'category': 'others',
    },
    {
      'icon': 'assets/icons/ethio lottery.png',
      'label': 'Ethio Lottery',
      'category': 'others',
    },
    {
      'icon': 'assets/icons/abol jobs.png',
      'label': 'Abol Jobs',
      'category': 'others',
    },
    {
      'icon': 'assets/icons/hulu.png',
      'label': 'Hulu',
      'category': 'others',
    },
    {
      'icon': 'assets/icons/Visit Oromia.png',
      'label': 'Visit Oromia',
      'category': 'others',
    },
    {
      'icon': 'assets/icons/Visit Ethiopia.png',
      'label': 'Visit Ethiopia',
      'category': 'others',
    },
  ];

  List<Map<String, dynamic>> get _filteredAppsByCategory {
    if (_selectedCategory == 0) return _filteredApps;
    
    final categoryMap = {
      1: 'banking',
      2: 'ecommerce',
      3: 'transport',
      4: 'others',
    };
    
    final selectedCategory = categoryMap[_selectedCategory];
    return _filteredApps.where((app) => app['category'] == selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _filteredApps = _allApps;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredApps = _allApps;
      } else {
        _filteredApps = _allApps.where((app) {
          final appName = app['label'].toString().toLowerCase();
          final appCategory = app['category'].toString().toLowerCase();
          return appName.contains(query) || appCategory.contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredApps = _allApps;
    });
  }

  void _onAppTap(Map<String, dynamic> app) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${app['label']}...'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayApps = _filteredAppsByCategory;
    
    return BaseScaffold(
      title: 'Apps & Services',
      userName: 'Gutu Rarie',
      notificationCount: 0,
      showBackButton: false,
      initialTabIndex: 1,
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Category Filter
          _buildCategoryFilter(),
          
          // Apps Count
          _buildAppsCount(displayApps.length),
          
          // Apps Grid
          Expanded(
            child: displayApps.isEmpty
                ? _buildEmptyState()
                : _buildAppsGrid(displayApps),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search apps and services...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade500),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected 
                  ? const Color(0xFF00ADEF) 
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppsCount(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        '$count ${count == 1 ? 'app' : 'apps'} available',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildAppsGrid(List<Map<String, dynamic>> apps) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7, // Reduced from 0.9 to 0.8
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) => _buildAppButton(apps[index]),
    ),
  );
}

  Widget _buildAppButton(Map<String, dynamic> app) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onAppTap(app),
      child: Container(
        padding: const EdgeInsets.all(6), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 55, // Slightly smaller
              height: 55,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  app['icon'] as String,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.apps,
                      color: Theme.of(context).colorScheme.primary,
                       // Smaller icon
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6), // Reduced spacing
            
            // App Name with better text constraints
            SizedBox(
              height: 28, // Fixed height for text
              child: Text(
                app['label'] as String,
                style: TextStyle(
                  fontSize: 10, // Smaller font
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Category Badge
            const SizedBox(height: 2), // Reduced spacing
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: _getCategoryColor(app['category']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                _getCategoryLabel(app['category']),
                style: TextStyle(
                  fontSize: 7, // Smaller font
                  color: _getCategoryColor(app['category']),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'banking': return 'BANKING';
      case 'ecommerce': return 'E-COMMERCE';
      case 'transport': return 'TRANSPORT';
      case 'others': return 'OTHER';
      default: return 'OTHER';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'banking': return const Color(0xFF00ADEF);
      case 'ecommerce': return const Color(0xFF34C759);
      case 'transport': return const Color(0xFFFF9500);
      case 'others': return const Color(0xFF5856D6);
      default: return const Color(0xFF8E8E93);
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No apps found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 0;
                _searchController.clear();
                _filteredApps = _allApps;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADEF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Show All Apps'),
          ),
        ],
      ),
    );
  }
}