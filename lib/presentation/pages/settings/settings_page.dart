import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/shop_settings.dart';
import '../../../domain/entities/notification_settings.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/settings/settings_event.dart';
import '../../blocs/settings/settings_state.dart';
import '../../blocs/backup/backup_bloc.dart';
import '../../blocs/backup/backup_event.dart';
import '../../blocs/backup/backup_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_display_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ShopSettings? _shopSettings;
  NotificationSettings? _notificationSettings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSettings();
  }

  void _loadSettings() {
    context.read<SettingsBloc>().add(const LoadShopSettings());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Shop', icon: Icon(Icons.store)),
            Tab(text: 'Notifications', icon: Icon(Icons.notifications)),
            Tab(text: 'Backup', icon: Icon(Icons.backup)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShopSettingsTab(),
          _buildNotificationSettingsTab(),
          _buildBackupTab(),
        ],
      ),
    );
  }

  Widget _buildShopSettingsTab() {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Reload settings after update
          context.read<SettingsBloc>().add(const LoadShopSettings());
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const LoadingWidget(message: 'Loading settings...');
        }

        if (state is ShopSettingsLoaded) {
          _shopSettings = state.settings;
        }

        if (_shopSettings == null) {
          return const Center(child: Text('No settings found'));
        }

        return _buildShopSettingsForm(_shopSettings!);
      },
    );
  }

  Widget _buildShopSettingsForm(ShopSettings settings) {
    final TextEditingController shopNameController =
        TextEditingController(text: settings.shopName);
    final TextEditingController addressController =
        TextEditingController(text: settings.shopAddress);
    final TextEditingController phoneController =
        TextEditingController(text: settings.shopPhone);
    final TextEditingController emailController =
        TextEditingController(text: settings.shopEmail);
    final TextEditingController gstController =
        TextEditingController(text: settings.gstNumber);
    final TextEditingController taxRateController =
        TextEditingController(text: settings.taxRate.toString());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: shopNameController,
            decoration: const InputDecoration(
              labelText: 'Shop Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: gstController,
            decoration: const InputDecoration(
              labelText: 'GST Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: taxRateController,
            decoration: const InputDecoration(
              labelText: 'Tax Rate (%)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final updatedSettings = settings.copyWith(
                  shopName: shopNameController.text,
                  shopAddress: addressController.text.isEmpty
                      ? null
                      : addressController.text,
                  shopPhone: phoneController.text.isEmpty
                      ? null
                      : phoneController.text,
                  shopEmail: emailController.text.isEmpty
                      ? null
                      : emailController.text,
                  gstNumber: gstController.text.isEmpty
                      ? null
                      : gstController.text,
                  taxRate: double.tryParse(taxRateController.text) ?? 0.0,
                  updatedAt: DateTime.now(),
                );

                context
                    .read<SettingsBloc>()
                    .add(UpdateShopSettingsEvent(updatedSettings));
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Save Settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Notification Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Coming soon...'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsBloc>().add(const LoadNotificationSettings());
            },
            child: const Text('Load Notification Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupTab() {
    return BlocConsumer<BackupBloc, BackupState>(
      listener: (context, state) {
        if (state is BackupOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.read<BackupBloc>().add(const LoadBackups());
        } else if (state is BackupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BackupLoading) {
          return const LoadingWidget(message: 'Processing backup...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Backup & Restore',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.backup, color: Colors.blue),
                  title: const Text('Create Backup'),
                  subtitle: const Text('Backup all your data'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<BackupBloc>().add(
                            const CreateBackupEvent(notes: 'Manual backup'),
                          );
                    },
                    child: const Text('Backup Now'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.restore, color: Colors.orange),
                  title: const Text('Restore Backup'),
                  subtitle: const Text('Restore from previous backup'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<BackupBloc>().add(const LoadBackups());
                    },
                    child: const Text('View Backups'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.download, color: Colors.green),
                  title: const Text('Export Data'),
                  subtitle: const Text('Export data to JSON'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement export
                    },
                    child: const Text('Export'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (state is BackupsLoaded) ...[
                const Text(
                  'Recent Backups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.backups.length > 5 ? 5 : state.backups.length,
                  itemBuilder: (context, index) {
                    final backup = state.backups[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          backup.isAutoBackup
                              ? Icons.schedule
                              : Icons.backup_outlined,
                        ),
                        title: Text(backup.fileName),
                        subtitle: Text(
                          '${backup.backupDate.toString().split('.')[0]}\n'
                          'Size: ${backup.fileSizeFormatted}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
