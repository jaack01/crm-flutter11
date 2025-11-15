import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      page: const _DashboardTab(),
    ),
    _NavigationItem(
      icon: Icons.people,
      label: 'Customers',
      page: const _ComingSoonTab(title: 'Customers'),
    ),
    _NavigationItem(
      icon: Icons.shopping_bag,
      label: 'Orders',
      page: const _ComingSoonTab(title: 'Orders'),
    ),
    _NavigationItem(
      icon: Icons.inventory,
      label: 'Inventory',
      page: const _ComingSoonTab(title: 'Inventory'),
    ),
    _NavigationItem(
      icon: Icons.settings,
      label: 'Settings',
      page: const _ComingSoonTab(title: 'Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navigationItems[_selectedIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: _navigationItems[_selectedIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: _navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  _NavigationItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

// Dashboard Tab
class _DashboardTab extends StatelessWidget {
  const _DashboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_laundry_service,
                    size: 48,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to ${AppConstants.appName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your laundry business efficiently',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Cards
          Text(
            'Today\'s Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: const [
              _StatCard(
                title: 'Orders',
                value: '0',
                icon: Icons.shopping_bag,
                color: AppColors.primaryColor,
              ),
              _StatCard(
                title: 'Revenue',
                value: '₹0',
                icon: Icons.attach_money,
                color: AppColors.successColor,
              ),
              _StatCard(
                title: 'Pending',
                value: '0',
                icon: Icons.pending,
                color: AppColors.warningColor,
              ),
              _StatCard(
                title: 'Customers',
                value: '0',
                icon: Icons.people,
                color: AppColors.secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _QuickActionButton(
                icon: Icons.add_shopping_cart,
                label: 'New Order',
                color: AppColors.primaryColor,
              ),
              _QuickActionButton(
                icon: Icons.person_add,
                label: 'Add Customer',
                color: AppColors.secondaryColor,
              ),
              _QuickActionButton(
                icon: Icons.payment,
                label: 'Record Payment',
                color: AppColors.successColor,
              ),
              _QuickActionButton(
                icon: Icons.assessment,
                label: 'View Reports',
                color: AppColors.infoColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label - Coming in Phase 2!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// Coming Soon Tab
class _ComingSoonTab extends StatelessWidget {
  final String title;

  const _ComingSoonTab({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '$title Module',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming in Phase 2!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
