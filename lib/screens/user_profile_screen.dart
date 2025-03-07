import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // For new address
  final _addressNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // For new payment method
  final _cardTypeController = TextEditingController();
  final _lastFourDigitsController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _isEditingProfile = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _cardTypeController.dispose();
    _lastFourDigitsController.dispose();
    _cardholderNameController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      bool success = await authService.updateProfile(
        _nameController.text.trim(),
        _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      if (success) {
        setState(() {
          _isEditingProfile = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to update profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddAddressDialog() async {
    bool isDefault = false;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Address'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _addressNameController,
                    decoration: const InputDecoration(
                      labelText: 'Address Name (e.g., Home, Work)',
                    ),
                  ),
                  TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(
                      labelText: 'Street Address',
                    ),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                    ),
                  ),
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                    ),
                  ),
                  TextField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Set as default address'),
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  if (_addressNameController.text.isEmpty ||
                      _streetController.text.isEmpty ||
                      _cityController.text.isEmpty ||
                      _stateController.text.isEmpty ||
                      _zipCodeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final address = Address(
                    name: _addressNameController.text,
                    street: _streetController.text,
                    city: _cityController.text,
                    state: _stateController.text,
                    zipCode: _zipCodeController.text,
                    isDefault: isDefault,
                  );

                  bool success = await authService.addAddress(address);

                  if (success) {
                    _addressNameController.clear();
                    _streetController.clear();
                    _cityController.clear();
                    _stateController.clear();
                    _zipCodeController.clear();

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Address added successfully')),
                    );
                    setState(() {}); // Refresh UI
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add address')),
                    );
                  }
                },
                child: const Text('ADD'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showAddPaymentDialog() async {
    bool isDefault = false;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Payment Method'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _cardTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Card Type (Visa, Mastercard, etc.)',
                    ),
                  ),
                  TextField(
                    controller: _lastFourDigitsController,
                    decoration: const InputDecoration(
                      labelText: 'Last 4 Digits',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                  TextField(
                    controller: _cardholderNameController,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                    ),
                  ),
                  TextField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Set as default payment method'),
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  if (_cardTypeController.text.isEmpty ||
                      _lastFourDigitsController.text.isEmpty ||
                      _cardholderNameController.text.isEmpty ||
                      _expiryDateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final paymentMethod = PaymentMethod(
                    cardType: _cardTypeController.text,
                    lastFourDigits: _lastFourDigitsController.text,
                    cardholderName: _cardholderNameController.text,
                    expiryDate: _expiryDateController.text,
                    isDefault: isDefault,
                  );

                  bool success =
                      await authService.addPaymentMethod(paymentMethod);

                  if (success) {
                    _cardTypeController.clear();
                    _lastFourDigitsController.clear();
                    _cardholderNameController.clear();
                    _expiryDateController.clear();

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Payment method added successfully')),
                    );
                    setState(() {}); // Refresh UI
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to add payment method')),
                    );
                  }
                },
                child: const Text('ADD'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    if (user == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info Section
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(_isEditingProfile ? Icons.save : Icons.edit),
                          onPressed: () {
                            if (_isEditingProfile) {
                              _updateProfile();
                            } else {
                              setState(() {
                                _isEditingProfile = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_isEditingProfile) ...[
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              enabled: _isEditingProfile,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              enabled: _isEditingProfile,
                              keyboardType: TextInputType.phone,
                            ),
                          ] else ...[
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Name'),
                              subtitle: Text(user.name),
                              dense: true,
                            ),
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: const Text('Email'),
                              subtitle: Text(user.email),
                              dense: true,
                            ),
                            if (user.phone != null)
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Phone'),
                                subtitle: Text(user.phone!),
                                dense: true,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Addresses Section
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Addresses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _showAddAddressDialog,
                          tooltip: 'Add Address',
                        ),
                      ],
                    ),
                    const Divider(),
                    if (user.addresses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text('No addresses added yet'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user.addresses.length,
                        itemBuilder: (context, index) {
                          final address = user.addresses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                '${address.name} ${address.isDefault ? ' (Default)' : ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!address.isDefault)
                                    IconButton(
                                      icon: const Icon(
                                          Icons.check_circle_outline),
                                      tooltip: 'Set as default',
                                      onPressed: () async {
                                        address.isDefault = true;
                                        final success =
                                            await Provider.of<AuthService>(
                                                    context,
                                                    listen: false)
                                                .updateAddress(address);
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Default address updated')),
                                          );
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Delete',
                                    onPressed: () async {
                                      // Show confirmation dialog
                                      bool confirm = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Delete Address'),
                                              content: const Text(
                                                  'Are you sure you want to delete this address?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text('DELETE'),
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      if (confirm) {
                                        final success =
                                            await Provider.of<AuthService>(
                                                    context,
                                                    listen: false)
                                                .deleteAddress(address.id!);
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Address deleted')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Payment Methods Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Methods',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _showAddPaymentDialog,
                          tooltip: 'Add Payment Method',
                        ),
                      ],
                    ),
                    const Divider(),
                    if (user.paymentMethods.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text('No payment methods added yet'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user.paymentMethods.length,
                        itemBuilder: (context, index) {
                          final payment = user.paymentMethods[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                payment.cardType.toLowerCase().contains('visa')
                                    ? Icons.credit_card
                                    : payment.cardType
                                            .toLowerCase()
                                            .contains('master')
                                        ? Icons.credit_card
                                        : Icons.credit_card,
                                size: 28,
                              ),
                              title: Text(
                                '${payment.cardType} ending in ${payment.lastFourDigits} ${payment.isDefault ? ' (Default)' : ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${payment.cardholderName} • Expires ${payment.expiryDate}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!payment.isDefault)
                                    IconButton(
                                      icon: const Icon(
                                          Icons.check_circle_outline),
                                      tooltip: 'Set as default',
                                      onPressed: () async {
                                        payment.isDefault = true;
                                        final success =
                                            await Provider.of<AuthService>(
                                                    context,
                                                    listen: false)
                                                .updatePaymentMethod(payment);
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Default payment method updated')),
                                          );
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Delete',
                                    onPressed: () async {
                                      // Show confirmation dialog
                                      bool confirm = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Delete Payment Method'),
                                              content: const Text(
                                                  'Are you sure you want to delete this payment method?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text('DELETE'),
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      if (confirm) {
                                        final success = await Provider.of<
                                                    AuthService>(context,
                                                listen: false)
                                            .deletePaymentMethod(payment.id!);
                                        if (success) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Payment method deleted')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
