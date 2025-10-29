import 'package:flutter/material.dart';
import 'base_scaffold.dart';
class HomeScreen extends StatefulWidget {


  const HomeScreen({
    super.key,
   
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBalanceHidden = false;

  final Map<String, String> balances = {
    'Wallet': 'ETB 2,450.00',
    'Saving': 'ETB 12,300.50',
    'Checking': 'ETB 3,520.75',
    'Credit': 'ETB -1,200.00',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: balances.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Home',
      userName: 'Gutu Rarie', // Your username
      notificationCount: 0,
      showBackButton: false,
      body: Column(
        children: [

            // Balance Card
            _buildBalanceCard(),

            // Quick Actions
            _buildQuickActions(),

            // Mini Apps Section
            Expanded(child: _buildMiniAppsSection()),

            
           ],
      ),
    );
  }

  
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Actions Row (without Card)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.add, 'Top Up', const Color(0xFF00ADEF)),
              _buildActionButton(Icons.send, 'Send', const Color(0xFF34C759)),
              _buildActionButton(Icons.download,'Deposit',const Color(0xFFFF9500),),
              _buildActionButton(Icons.upload,'Withdraw',const Color(0xFFFF3B30),),
              _buildActionButton(Icons.receipt,'Statement',const Color(0xFFFF3B30),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF00ADEF), Color(0xFF0078D4)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Tab Chips
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        balances.keys.map((title) {
                          final selected =
                              _tabController.index ==
                              balances.keys.toList().indexOf(title);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap:
                                  () => setState(
                                    () =>
                                        _tabController.index = balances.keys
                                            .toList()
                                            .indexOf(title),
                                  ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      selected
                                          ? Colors.white.withOpacity(0.5)
                                          : const Color.fromARGB(
                                            0,
                                            255,
                                            255,
                                            255,
                                          ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(
                                      selected ? 1 : 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Balance Display
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pie_chart_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isBalanceHidden
                                ? '••••••••'
                                : balances.values.elementAt(
                                  _tabController.index,
                                ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Available balance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isBalanceHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed:
                          () => setState(
                            () => _isBalanceHidden = !_isBalanceHidden,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniAppsSection() {
    final miniApps = [
      {
        'icon': 'assets/icons/coop engae.png',
        'label': 'Coop Engage',
        'color': const Color(0xFF34C759),
      },
      {
        'icon': 'assets/icons/CoopCard.png',
        'label': 'Coop Card',
        'color': const Color(0xFF007AFF),
      },
      {
        'icon': 'assets/icons/coop stream.png',
        'label': 'Coop Stream',
        'color': const Color(0xFFFF3B30),
      },
      {
        'icon': 'assets/icons/coop market.png',
        'label': 'Coop Market',
        'color': const Color(0xFF5856D6),
      },
      {
        'icon': 'assets/icons/ebirr.png',
        'label': 'EBirr',
        'color': const Color(0xFFFF9500),
      },
      {
        'icon': 'assets/icons/ashewa.png',
        'label': 'Ashewa',
        'color': const Color(0xFFFF2D55),
      },
      {
        'icon': 'assets/icons/abol jobs.png',
        'label': 'Abol Jobs',
        'color': const Color(0xFF4CD964),
      },
      {
        'icon': 'assets/icons/awrastore.png',
        'label': 'Awra Store',
        'color': const Color(0xFF5AC8FA),
      },
      {
        'icon': 'assets/icons/ethio lottery.png',
        'label': 'Ethio Lottery',
        'color': const Color(0xFF5AC8FA),
      },
      {
        'icon': 'assets/icons/delivery addis.png',
        'label': ' Delivery Addis',
        'color': const Color(0xFF5AC8FA),
      },
      {
        'icon': 'assets/icons/dallol gabeya.png',
        'label': 'Dallol Gabeya',
        'color': const Color(0xFF5AC8FA),
      },
      {
        'icon': 'assets/icons/E-Statement.png',
        'label': 'E-Statement',
        'color': const Color(0xFF5AC8FA),
      },
      {
        'icon': 'assets/icons/ethio railway.png',
        'label': 'Ethio Railway',
        'color': const Color(0xFF5AC8FA),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              'Services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: miniApps.length,
                  itemBuilder:
                      (context, index) => _buildMiniAppButton(miniApps[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildMiniAppButton(Map<String, dynamic> app) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (app['color'] as Color).withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(app['icon'] as String, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          app['label'] as String,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }


}