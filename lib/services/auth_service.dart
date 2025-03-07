import 'package:flutter/material.dart';
import '../models/user.dart';
import '../data/database_helper.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> register(String email, String name, String password) async {
    try {
      int userId = await _dbHelper.registerUser(email, name, password);
      _currentUser = User(
        id: userId,
        email: email,
        name: name,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _currentUser = await _dbHelper.loginUser(email, password);
      if (_currentUser != null) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String? phone) async {
    if (_currentUser == null) return false;

    try {
      _currentUser!.name = name;
      _currentUser!.phone = phone;

      await _dbHelper.updateUserProfile(_currentUser!);
      notifyListeners();
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> addAddress(Address address) async {
    if (_currentUser == null) return false;

    try {
      int addressId = await _dbHelper.addAddress(_currentUser!.id, address);
      address = Address(
        id: addressId,
        name: address.name,
        street: address.street,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        isDefault: address.isDefault,
      );

      _currentUser!.addresses.add(address);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add address error: $e');
      return false;
    }
  }

  Future<bool> updateAddress(Address address) async {
    if (_currentUser == null) return false;

    try {
      await _dbHelper.updateAddress(address);

      int index = _currentUser!.addresses.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        _currentUser!.addresses[index] = address;

        // If this is now default, update other addresses in memory
        if (address.isDefault) {
          for (int i = 0; i < _currentUser!.addresses.length; i++) {
            if (i != index) {
              _currentUser!.addresses[i].isDefault = false;
            }
          }
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('Update address error: $e');
      return false;
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    if (_currentUser == null) return false;

    try {
      await _dbHelper.deleteAddress(addressId);
      _currentUser!.addresses.removeWhere((address) => address.id == addressId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete address error: $e');
      return false;
    }
  }

  Future<bool> addPaymentMethod(PaymentMethod paymentMethod) async {
    if (_currentUser == null) return false;

    try {
      int paymentId =
          await _dbHelper.addPaymentMethod(_currentUser!.id, paymentMethod);
      paymentMethod = PaymentMethod(
        id: paymentId,
        cardType: paymentMethod.cardType,
        lastFourDigits: paymentMethod.lastFourDigits,
        cardholderName: paymentMethod.cardholderName,
        expiryDate: paymentMethod.expiryDate,
        isDefault: paymentMethod.isDefault,
      );

      _currentUser!.paymentMethods.add(paymentMethod);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add payment method error: $e');
      return false;
    }
  }

  Future<bool> updatePaymentMethod(PaymentMethod paymentMethod) async {
    if (_currentUser == null) return false;

    try {
      await _dbHelper.updatePaymentMethod(paymentMethod);

      int index = _currentUser!.paymentMethods
          .indexWhere((p) => p.id == paymentMethod.id);
      if (index != -1) {
        _currentUser!.paymentMethods[index] = paymentMethod;

        // If this is now default, update other payment methods in memory
        if (paymentMethod.isDefault) {
          for (int i = 0; i < _currentUser!.paymentMethods.length; i++) {
            if (i != index) {
              _currentUser!.paymentMethods[i].isDefault = false;
            }
          }
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('Update payment method error: $e');
      return false;
    }
  }

  Future<bool> deletePaymentMethod(int paymentMethodId) async {
    if (_currentUser == null) return false;

    try {
      await _dbHelper.deletePaymentMethod(paymentMethodId);
      _currentUser!.paymentMethods
          .removeWhere((method) => method.id == paymentMethodId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete payment method error: $e');
      return false;
    }
  }
}
