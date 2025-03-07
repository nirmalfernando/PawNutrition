class User {
  final int id;
  String email;
  String name;
  String? photoUrl;
  String? phone;
  List<Address> addresses;
  List<PaymentMethod> paymentMethods;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phone,
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  // Convert User object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phone': phone,
    };
  }

  // Create User object from a map (from database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      phone: map['phone'],
    );
  }
}

class Address {
  final int? id;
  String name; // Home, Work, etc.
  String street;
  String city;
  String state;
  String zipCode;
  bool isDefault;

  Address({
    this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault ? 1 : 0,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      name: map['name'],
      street: map['street'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      isDefault: map['isDefault'] == 1,
    );
  }
}

class PaymentMethod {
  final int? id;
  String cardType; // Visa, Mastercard, etc.
  String lastFourDigits;
  String cardholderName;
  String expiryDate;
  bool isDefault;

  PaymentMethod({
    this.id,
    required this.cardType,
    required this.lastFourDigits,
    required this.cardholderName,
    required this.expiryDate,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardType': cardType,
      'lastFourDigits': lastFourDigits,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'isDefault': isDefault ? 1 : 0,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'],
      cardType: map['cardType'],
      lastFourDigits: map['lastFourDigits'],
      cardholderName: map['cardholderName'],
      expiryDate: map['expiryDate'],
      isDefault: map['isDefault'] == 1,
    );
  }
}
