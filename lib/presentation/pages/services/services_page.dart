import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/service.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_display_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    context.read<ServiceBloc>().add(const LoadServices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: BlocConsumer<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is ServiceOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadServices();
          } else if (state is ServiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const LoadingWidget(message: 'Loading services...');
          }

          if (state is ServiceError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadServices,
            );
          }

          if (state is ServicesLoaded) {
            if (state.services.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.local_laundry_service,
                title: 'No Services Found',
                message: 'Start by adding your first service',
                actionLabel: 'Add Service',
                onAction: () => _showAddServiceDialog(context),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadServices();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  return _buildServiceCard(service);
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: service.isActive
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          child: Icon(
            Icons.local_laundry_service,
            color: service.isActive ? AppColors.primaryColor : Colors.grey,
          ),
        ),
        title: Text(
          service.serviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${service.serviceCode}'),
            if (service.description != null && service.description!.isNotEmpty)
              Text(
                service.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            Text('Base Price: ₹${service.basePrice.toStringAsFixed(2)}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!service.isActive)
              Chip(
                label: const Text('Inactive', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditServiceDialog(context, service),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ServiceBloc>(),
        child: const _ServiceFormDialog(),
      ),
    );
  }

  void _showEditServiceDialog(BuildContext context, Service service) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ServiceBloc>(),
        child: _ServiceFormDialog(service: service),
      ),
    );
  }
}

class _ServiceFormDialog extends StatefulWidget {
  final Service? service;

  const _ServiceFormDialog({this.service});

  @override
  State<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<_ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.serviceName ?? '');
    _codeController = TextEditingController(text: widget.service?.serviceCode ?? '');
    _descriptionController = TextEditingController(text: widget.service?.description ?? '');
    _priceController = TextEditingController(
      text: widget.service?.basePrice.toString() ?? '0',
    );
    _isActive = widget.service?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Service Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Base Price',
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter base price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveService,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final service = Service(
        id: widget.service?.id,
        serviceName: _nameController.text.trim(),
        serviceCode: _codeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        basePrice: double.parse(_priceController.text),
        isActive: _isActive,
        createdAt: widget.service?.createdAt ?? DateTime.now(),
      );

      if (widget.service == null) {
        context.read<ServiceBloc>().add(AddServiceEvent(service));
      } else {
        context.read<ServiceBloc>().add(UpdateServiceEvent(service));
      }

      Navigator.pop(context);
    }
  }
}
