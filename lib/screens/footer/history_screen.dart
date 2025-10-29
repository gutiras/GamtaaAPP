import 'package:flutter/material.dart';
import '../base_scaffold.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0; // 0: All, 1: Income, 2: Expense
  final List<String> _filters = ['All', 'Income', 'Expense'];
  
  // Time filter state
  int _selectedTimeFilter = 0;
  final List<String> _timeFilters = ['All Time', 'Last 7 Days', 'Last 30 Days', 'Last 3 Months'];

  final List<Map<String, dynamic>> _allTransactions = [
    {
      'icon': Icons.arrow_upward,
      'title': 'Sent to Abel Tesfaye',
      'subtitle': 'Mobile Transfer',
      'amount': '-ETB 1,500.00',
      'time': '2 hours ago',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'color': Colors.red,
      'type': 'expense',
    },
    {
      'icon': Icons.arrow_downward,
      'title': 'Received from Coop Market',
      'subtitle': 'Refund',
      'amount': '+ETB 750.00',
      'time': 'Yesterday',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'color': Colors.green,
      'type': 'income',
    },
    {
      'icon': Icons.shopping_cart,
      'title': 'Coop Market Purchase',
      'subtitle': 'Groceries',
      'amount': '-ETB 2,340.00',
      'time': 'Dec 12, 2024',
      'date': DateTime(2024, 12, 12),
      'color': Colors.red,
      'type': 'expense',
    },
    {
      'icon': Icons.phone_android,
      'title': 'Airtime Top-up',
      'subtitle': '0911XXXXXX',
      'amount': '-ETB 100.00',
      'time': 'Dec 11, 2024',
      'date': DateTime(2024, 12, 11),
      'color': Colors.red,
      'type': 'expense',
    },
    {
      'icon': Icons.arrow_downward,
      'title': 'Salary Deposit',
      'subtitle': 'Monthly Salary',
      'amount': '+ETB 15,000.00',
      'time': 'Dec 5, 2024',
      'date': DateTime(2024, 12, 5),
      'color': Colors.green,
      'type': 'income',
    },
    {
      'icon': Icons.account_balance,
      'title': 'Bank Transfer',
      'subtitle': 'To Commercial Bank',
      'amount': '-ETB 5,000.00',
      'time': 'Dec 1, 2024',
      'date': DateTime(2024, 12, 1),
      'color': Colors.red,
      'type': 'expense',
    },
    {
      'icon': Icons.arrow_downward,
      'title': 'Interest Earned',
      'subtitle': 'Savings Account',
      'amount': '+ETB 250.50',
      'time': 'Nov 28, 2024',
      'date': DateTime(2024, 11, 28),
      'color': Colors.green,
      'type': 'income',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    List<Map<String, dynamic>> filtered = _allTransactions;

    // Apply time filter
    filtered = _applyTimeFilter(filtered);

    // Apply type filter
    if (_selectedFilter != 0) {
      filtered = filtered.where((transaction) {
        return _selectedFilter == 1
            ? transaction['type'] == 'income'
            : transaction['type'] == 'expense';
      }).toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> _applyTimeFilter(List<Map<String, dynamic>> transactions) {
    final now = DateTime.now();
    
    switch (_selectedTimeFilter) {
      case 1: // Last 7 days
        return transactions.where((transaction) {
          return transaction['date'].isAfter(now.subtract(const Duration(days: 7)));
        }).toList();
      case 2: // Last 30 days
        return transactions.where((transaction) {
          return transaction['date'].isAfter(now.subtract(const Duration(days: 30)));
        }).toList();
      case 3: // Last 3 months
        return transactions.where((transaction) {
          return transaction['date'].isAfter(now.subtract(const Duration(days: 90)));
        }).toList();
      default: // All Time
        return transactions;
    }
  }

  void _downloadStatement() {
    // Show download options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Statement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select statement period:'),
            const SizedBox(height: 16),
            _buildStatementOption('Last 30 Days', Icons.calendar_today),
            _buildStatementOption('Last 3 Months', Icons.calendar_month),
            _buildStatementOption('Last 6 Months', Icons.date_range),
            _buildStatementOption('Custom Range', Icons.edit_calendar),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startDownload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADEF),
            ),
            child: const Text('DOWNLOAD'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00ADEF)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _startDownload();
      },
    );
  }

  void _startDownload() {
    // Show download progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00ADEF)),
              const SizedBox(height: 20),
              const Text(
                'Preparing Statement...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Filter: ${_timeFilters[_selectedTimeFilter]}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close progress dialog
      _showDownloadComplete();
    });
  }

  void _showDownloadComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Statement downloaded successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () {
            // Open the downloaded file
          },
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Filter Transactions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Time Period',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._timeFilters.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  return RadioListTile<int>(
                    title: Text(title),
                    value: index,
                    groupValue: _selectedTimeFilter,
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedTimeFilter = value!;
                      });
                    },
                    activeColor: const Color(0xFF00ADEF),
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Apply the filter
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADEF),
                ),
                child: const Text('APPLY FILTER'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Transaction History',
      userName: 'Gutu Rarie',
      notificationCount: 0,
      showBackButton: false,
      initialTabIndex: 3, // History tab index
      body: Column(
        children: [
          // Header with Download Button
          _buildHeader(),
          
          // Filter Chips
          _buildFilterChips(),
          
          // Transactions Summary
          _buildSummaryCard(),
          
          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_timeFilters[_selectedTimeFilter]} • ${_filteredTransactions.length} transactions',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF00ADEF)),
            onPressed: _downloadStatement,
            tooltip: 'Download Statement',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF00ADEF)),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
  return Container(
    height: 35,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _filters.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedFilter == index;
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Material(
            color: isSelected 
                ? const Color(0xFF00ADEF) 
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
           
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
  Widget _buildSummaryCard() {
    final income = _filteredTransactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + _parseAmount(t['amount']));
    
    final expense = _filteredTransactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, t) => sum + _parseAmount(t['amount']).abs());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00ADEF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00ADEF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Income', '+ETB ${income.toStringAsFixed(2)}', Colors.green),
          _buildSummaryItem('Expense', '-ETB ${expense.toStringAsFixed(2)}', Colors.red),
          _buildSummaryItem('Balance', 'ETB ${(income - expense).toStringAsFixed(2)}', const Color(0xFF00ADEF)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  double _parseAmount(String amount) {
    // Keep digits, dot and leading sign (+/-), remove everything else
    final cleaned = amount.replaceAll(RegExp(r'[^0-9\.\-\+]'), '');
    if (cleaned.isEmpty) return 0.0;
    try {
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (transaction['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(transaction['icon'] as IconData, 
                     color: transaction['color'], size: 20),
        ),
        title: Text(
          transaction['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(transaction['subtitle'] as String),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction['amount'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction['color'],
                fontSize: 16,
              ),
            ),
            Text(
              transaction['time'] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          _showTransactionDetails(transaction);
        },
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', transaction['type'] == 'income' ? 'Income' : 'Expense'),
            _buildDetailRow('Amount', transaction['amount'] as String),
            _buildDetailRow('Description', transaction['subtitle'] as String),
            _buildDetailRow('Date', transaction['time'] as String),
            _buildDetailRow('Status', 'Completed'),
            _buildDetailRow('Transaction ID', 'TXN${DateTime.now().millisecondsSinceEpoch}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Share transaction
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADEF),
            ),
            child: const Text('SHARE'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text(
            'No transactions found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try changing your filters',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 0;
                _selectedTimeFilter = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADEF),
            ),
            child: const Text('RESET FILTERS'),
          ),
        ],
      ),
    );
  }
}