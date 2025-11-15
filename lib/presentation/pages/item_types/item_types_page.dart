import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/item_type.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';

class ItemTypesPage extends StatefulWidget {
  const ItemTypesPage({super.key});

  @override
  State<ItemTypesPage> createState() => _ItemTypesPageState();
}

class _ItemTypesPageState extends State<ItemTypesPage> {
  List<ItemType> _itemTypes = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadItemTypes();
  }

  void _loadItemTypes() {
    // Note: This would need a dedicated ItemTypeBloc in a full implementation
    // For now, we'll show a simplified version
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading item types...')),
    );
  }

  List<ItemType> get _filteredItemTypes {
    if (_selectedCategory == 'All') {
      return _itemTypes;
    }
    return _itemTypes.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Types'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Clothing'),
                _buildCategoryChip('Household'),
                _buildCategoryChip('Accessories'),
                _buildCategoryChip('Other'),
              ],
            ),
          ),
        ),
      ),
      body: _filteredItemTypes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Item Types Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Add item types to categorize laundry items'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddItemTypeDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item Type'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredItemTypes.length,
              itemBuilder: (context, index) {
                final itemType = _filteredItemTypes[index];
                return _buildItemTypeCard(itemType);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemTypeDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildItemTypeCard(ItemType itemType) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: itemType.isActive
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          child: Icon(
            Icons.checkroom,
            color: itemType.isActive ? AppColors.primaryColor : Colors.grey,
          ),
        ),
        title: Text(
          itemType.itemName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${itemType.category}'),
            if (itemType.description != null && itemType.description!.isNotEmpty)
              Text(
                itemType.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!itemType.isActive)
              Chip(
                label: const Text('Inactive', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditItemTypeDialog(itemType),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => _ItemTypeFormDialog(
        onSave: (itemType) {
          setState(() {
            _itemTypes.add(itemType);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item type added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showEditItemTypeDialog(ItemType itemType) {
    showDialog(
      context: context,
      builder: (context) => _ItemTypeFormDialog(
        itemType: itemType,
        onSave: (updatedItemType) {
          setState(() {
            final index = _itemTypes.indexWhere((item) => item.id == updatedItemType.id);
            if (index != -1) {
              _itemTypes[index] = updatedItemType;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item type updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

class _ItemTypeFormDialog extends StatefulWidget {
  final ItemType? itemType;
  final Function(ItemType) onSave;

  const _ItemTypeFormDialog({
    this.itemType,
    required this.onSave,
  });

  @override
  State<_ItemTypeFormDialog> createState() => _ItemTypeFormDialogState();
}

class _ItemTypeFormDialogState extends State<_ItemTypeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _category;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.itemType?.itemName ?? '');
    _descriptionController = TextEditingController(text: widget.itemType?.description ?? '');
    _category = widget.itemType?.category ?? 'Clothing';
    _isActive = widget.itemType?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemType == null ? 'Add Item Type' : 'Edit Item Type'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Clothing', 'Household', 'Accessories', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
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
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final itemType = ItemType(
        id: widget.itemType?.id,
        itemName: _nameController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isActive: _isActive,
        createdAt: widget.itemType?.createdAt ?? DateTime.now(),
      );

      widget.onSave(itemType);
      Navigator.pop(context);
    }
  }
}
