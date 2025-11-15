import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/customer.dart';
import '../../blocs/customer/customer_bloc.dart';
import '../../blocs/customer/customer_event.dart';
import '../../blocs/customer/customer_state.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;

  const CustomerFormPage({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _alternatePhoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _notesController;

  late String _customerType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.customer?.firstName);
    _lastNameController = TextEditingController(text: widget.customer?.lastName);
    _phoneController = TextEditingController(text: widget.customer?.phone);
    _emailController = TextEditingController(text: widget.customer?.email);
    _alternatePhoneController = TextEditingController(text: widget.customer?.alternatePhone);
    _addressController = TextEditingController(text: widget.customer?.address);
    _cityController = TextEditingController(text: widget.customer?.city);
    _pincodeController = TextEditingController(text: widget.customer?.pincode);
    _notesController = TextEditingController(text: widget.customer?.notes);
    _customerType = widget.customer?.customerType ?? 'Regular';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _alternatePhoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final Customer customer = Customer(
      id: widget.customer?.id,
      customerCode: widget.customer?.customerCode ?? '',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      alternatePhone: _alternatePhoneController.text.trim().isEmpty
          ? null
          : _alternatePhoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      pincode: _pincodeController.text.trim().isEmpty
          ? null
          : _pincodeController.text.trim(),
      customerType: _customerType,
      loyaltyPoints: widget.customer?.loyaltyPoints ?? 0,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.customer == null) {
      context.read<CustomerBloc>().add(AddCustomerEvent(customer));
    } else {
      context.read<CustomerBloc>().add(UpdateCustomerEvent(customer));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerOperationSuccess) {
            setState(() {
              _isLoading = false;
            });
            context.pop();
          } else if (state is CustomerError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CustomerLoading) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Personal Information Section
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => Validators.required(value, fieldName: 'First name'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => Validators.phone(value),
              ),
              const SizedBox(height: 16),

              // Alternate Phone
              TextFormField(
                controller: _alternatePhoneController,
                decoration: const InputDecoration(
                  labelText: 'Alternate Phone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return Validators.email(value);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Address Section
              Text(
                'Address Information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // City
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Pincode
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Customer Type
              Text(
                'Customer Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _customerType,
                decoration: const InputDecoration(
                  labelText: 'Customer Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items: AppConstants.customerTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _customerType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Notes
              Text(
                'Additional Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveCustomer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(widget.customer == null ? 'Add Customer' : 'Update Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
