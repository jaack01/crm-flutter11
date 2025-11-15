import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/service_pricing.dart';
import '../../../domain/entities/service.dart';
import '../../../domain/entities/item_type.dart';
import '../../blocs/pricing/pricing_bloc.dart';
import '../../blocs/pricing/pricing_event.dart';
import '../../blocs/pricing/pricing_state.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';

class ServicePricingPage extends StatefulWidget {
  const ServicePricingPage({super.key});

  @override
  State<ServicePricingPage> createState() => _ServicePricingPageState();
}

class _ServicePricingPageState extends State<ServicePricingPage> {
  List<ServicePricing> _allPricing = [];
  List<Service> _services = [];
  List<ItemType> _itemTypes = [];
  int? _selectedServiceFilter;
  int? _selectedItemTypeFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<PricingBloc>().add(const LoadAllServicePricing());
    context.read<ServiceBloc>().add(const LoadServices());
  }

  List<ServicePricing> get _filteredPricing {
    var filtered = _allPricing;

    if (_selectedServiceFilter != null) {
      filtered = filtered.where((p) => p.serviceId == _selectedServiceFilter).toList();
    }

    if (_selectedItemTypeFilter != null) {
      filtered = filtered.where((p) => p.itemTypeId == _selectedItemTypeFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Pricing Matrix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PricingBloc, PricingState>(
            listener: (context, state) {
              if (state is AllServicePricingLoaded) {
                setState(() {
                  _allPricing = state.pricingList;
                });
              } else if (state is PricingOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadData();
              } else if (state is PricingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<ServiceBloc, ServiceState>(
            listener: (context, state) {
              if (state is ServicesLoaded) {
                setState(() {
                  _services = state.services;
                  // Extract item types from services (simplified approach)
                  // In a full implementation, this would come from a separate ItemTypeBloc
                });
              }
            },
          ),
        ],
        child: Column(
          children: [
            _buildFilterSection(),
            Expanded(
              child: BlocBuilder<PricingBloc, PricingState>(
                builder: (context, state) {
                  if (state is PricingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_filteredPricing.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildPricingList();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPricingDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Pricing'),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: _selectedServiceFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Service',
                    border: OutlineInputBorder(),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Services')),
                    ..._services.map((service) => DropdownMenuItem(
                      value: service.id,
                      child: Text(service.serviceName),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceFilter = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: _selectedItemTypeFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Item Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Item Types')),
                    ..._itemTypes.map((itemType) => DropdownMenuItem(
                      value: itemType.id,
                      child: Text(itemType.itemName),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedItemTypeFilter = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.price_change_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Pricing Configured',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Add pricing for service and item type combinations'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddPricingDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Pricing'),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPricing.length,
      itemBuilder: (context, index) {
        final pricing = _filteredPricing[index];
        return _buildPricingCard(pricing);
      },
    );
  }

  Widget _buildPricingCard(ServicePricing pricing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pricing.serviceName ?? 'Service #${pricing.serviceId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.checkroom, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            pricing.itemTypeName ?? 'Item Type #${pricing.itemTypeId}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!pricing.isActive)
                  Chip(
                    label: const Text('Inactive', style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPriceInfo(
                    'Regular Price',
                    pricing.price,
                    AppColors.primaryColor,
                  ),
                ),
                if (pricing.rushOrderPrice != null)
                  Expanded(
                    child: _buildPriceInfo(
                      'Rush Price',
                      pricing.rushOrderPrice!,
                      Colors.orange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditPricingDialog(pricing),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _confirmDelete(pricing),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPricingDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PricingBloc>(),
        child: _PricingFormDialog(
          services: _services,
          itemTypes: _itemTypes,
          onSave: (pricing) {
            context.read<PricingBloc>().add(AddServicePricingEvent(pricing));
          },
        ),
      ),
    );
  }

  void _showEditPricingDialog(ServicePricing pricing) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PricingBloc>(),
        child: _PricingFormDialog(
          pricing: pricing,
          services: _services,
          itemTypes: _itemTypes,
          onSave: (updatedPricing) {
            context.read<PricingBloc>().add(UpdateServicePricingEvent(updatedPricing));
          },
        ),
      ),
    );
  }

  void _confirmDelete(ServicePricing pricing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pricing'),
        content: Text(
          'Are you sure you want to delete pricing for ${pricing.serviceName} - ${pricing.itemTypeName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PricingBloc>().add(DeleteServicePricingEvent(pricing.id!));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PricingFormDialog extends StatefulWidget {
  final ServicePricing? pricing;
  final List<Service> services;
  final List<ItemType> itemTypes;
  final Function(ServicePricing) onSave;

  const _PricingFormDialog({
    this.pricing,
    required this.services,
    required this.itemTypes,
    required this.onSave,
  });

  @override
  State<_PricingFormDialog> createState() => _PricingFormDialogState();
}

class _PricingFormDialogState extends State<_PricingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _rushPriceController;
  int? _selectedServiceId;
  int? _selectedItemTypeId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.pricing?.price.toString() ?? '',
    );
    _rushPriceController = TextEditingController(
      text: widget.pricing?.rushOrderPrice?.toString() ?? '',
    );
    _selectedServiceId = widget.pricing?.serviceId;
    _selectedItemTypeId = widget.pricing?.itemTypeId;
    _isActive = widget.pricing?.isActive ?? true;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _rushPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pricing != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Pricing' : 'Add Pricing'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedServiceId,
                decoration: const InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
                items: widget.services
                    .map((service) => DropdownMenuItem(
                          value: service.id,
                          child: Text(service.serviceName),
                        ))
                    .toList(),
                onChanged: isEditing ? null : (value) {
                  setState(() {
                    _selectedServiceId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedItemTypeId,
                decoration: const InputDecoration(
                  labelText: 'Item Type',
                  border: OutlineInputBorder(),
                ),
                items: widget.itemTypes
                    .map((itemType) => DropdownMenuItem(
                          value: itemType.id,
                          child: Text(itemType.itemName),
                        ))
                    .toList(),
                onChanged: isEditing ? null : (value) {
                  setState(() {
                    _selectedItemTypeId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Regular Price',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rushPriceController,
                decoration: const InputDecoration(
                  labelText: 'Rush Order Price (Optional)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid price';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than 0';
                    }
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
                contentPadding: EdgeInsets.zero,
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
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final pricing = ServicePricing(
        id: widget.pricing?.id,
        serviceId: _selectedServiceId!,
        itemTypeId: _selectedItemTypeId!,
        price: double.parse(_priceController.text),
        rushOrderPrice: _rushPriceController.text.isEmpty
            ? null
            : double.parse(_rushPriceController.text),
        isActive: _isActive,
        createdAt: widget.pricing?.createdAt ?? DateTime.now(),
        serviceName: widget.pricing?.serviceName,
        itemTypeName: widget.pricing?.itemTypeName,
      );

      widget.onSave(pricing);
      Navigator.pop(context);
    }
  }
}
