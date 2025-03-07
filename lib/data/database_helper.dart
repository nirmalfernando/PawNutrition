import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dog_nutrition.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT,
        rating REAL,
        reviewCount INTEGER,
        category TEXT
      )
    ''');

    // Cart table
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER,
        FOREIGN KEY (productId) REFERENCES products(id)
      )
    ''');

    // Education content table
    await db.execute('''
      CREATE TABLE education_content(
        id INTEGER PRIMARY KEY,
        title TEXT,
        summary TEXT,
        content TEXT,
        imageUrl TEXT,
        category TEXT
      )
    ''');

    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        name TEXT,
        password TEXT,
        photoUrl TEXT,
        phone TEXT
      )
    ''');

    // Addresses table
    await db.execute('''
      CREATE TABLE addresses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        name TEXT,
        street TEXT,
        city TEXT,
        state TEXT,
        zipCode TEXT,
        isDefault INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Payment methods table
    await db.execute('''
      CREATE TABLE payment_methods(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        cardType TEXT,
        lastFourDigits TEXT,
        cardholderName TEXT,
        expiryDate TEXT,
        isDefault INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables for version 2
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE,
          name TEXT,
          password TEXT,
          photoUrl TEXT,
          phone TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE addresses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          name TEXT,
          street TEXT,
          city TEXT,
          state TEXT,
          zipCode TEXT,
          isDefault INTEGER,
          FOREIGN KEY (userId) REFERENCES users(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE payment_methods(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          cardType TEXT,
          lastFourDigits TEXT,
          cardholderName TEXT,
          expiryDate TEXT,
          isDefault INTEGER,
          FOREIGN KEY (userId) REFERENCES users(id)
        )
      ''');
    }
  }

  // User operations
  Future<int> registerUser(String email, String name, String password) async {
    Database db = await database;
    return await db.insert('users', {
      'email': email,
      'name': name,
      'password': password, // In production, this should be hashed
    });
  }

  Future<User?> loginUser(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);

      // Load addresses
      List<Map<String, dynamic>> addressMaps = await db.query(
        'addresses',
        where: 'userId = ?',
        whereArgs: [user.id],
      );

      // Load payment methods
      List<Map<String, dynamic>> paymentMaps = await db.query(
        'payment_methods',
        where: 'userId = ?',
        whereArgs: [user.id],
      );

      user.addresses = addressMaps.map((map) => Address.fromMap(map)).toList();
      user.paymentMethods =
          paymentMaps.map((map) => PaymentMethod.fromMap(map)).toList();

      return user;
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);

      // Load addresses
      List<Map<String, dynamic>> addressMaps = await db.query(
        'addresses',
        where: 'userId = ?',
        whereArgs: [user.id],
      );

      // Load payment methods
      List<Map<String, dynamic>> paymentMaps = await db.query(
        'payment_methods',
        where: 'userId = ?',
        whereArgs: [user.id],
      );

      user.addresses = addressMaps.map((map) => Address.fromMap(map)).toList();
      user.paymentMethods =
          paymentMaps.map((map) => PaymentMethod.fromMap(map)).toList();

      return user;
    }
    return null;
  }

  Future<int> updateUserProfile(User user) async {
    Database db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Address operations
  Future<int> addAddress(int userId, Address address) async {
    Database db = await database;

    // If this is set as default, clear other defaults first
    if (address.isDefault) {
      await db.update('addresses', {'isDefault': 0},
          where: 'userId = ?', whereArgs: [userId]);
    }

    return await db.insert('addresses', {
      'userId': userId,
      'name': address.name,
      'street': address.street,
      'city': address.city,
      'state': address.state,
      'zipCode': address.zipCode,
      'isDefault': address.isDefault ? 1 : 0,
    });
  }

  Future<int> updateAddress(Address address) async {
    Database db = await database;

    // If this is set as default, clear other defaults first
    if (address.isDefault) {
      await db.rawQuery(
          'UPDATE addresses SET isDefault = 0 WHERE userId = (SELECT userId FROM addresses WHERE id = ?)',
          [address.id]);
    }

    return await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<int> deleteAddress(int addressId) async {
    Database db = await database;
    return await db.delete(
      'addresses',
      where: 'id = ?',
      whereArgs: [addressId],
    );
  }

  // Payment method operations
  Future<int> addPaymentMethod(int userId, PaymentMethod paymentMethod) async {
    Database db = await database;

    // If this is set as default, clear other defaults first
    if (paymentMethod.isDefault) {
      await db.update('payment_methods', {'isDefault': 0},
          where: 'userId = ?', whereArgs: [userId]);
    }

    return await db.insert('payment_methods', {
      'userId': userId,
      'cardType': paymentMethod.cardType,
      'lastFourDigits': paymentMethod.lastFourDigits,
      'cardholderName': paymentMethod.cardholderName,
      'expiryDate': paymentMethod.expiryDate,
      'isDefault': paymentMethod.isDefault ? 1 : 0,
    });
  }

  Future<int> updatePaymentMethod(PaymentMethod paymentMethod) async {
    Database db = await database;

    // If this is set as default, clear other defaults first
    if (paymentMethod.isDefault) {
      await db.rawQuery(
          'UPDATE payment_methods SET isDefault = 0 WHERE userId = (SELECT userId FROM payment_methods WHERE id = ?)',
          [paymentMethod.id]);
    }

    return await db.update(
      'payment_methods',
      paymentMethod.toMap(),
      where: 'id = ?',
      whereArgs: [paymentMethod.id],
    );
  }

  Future<int> deletePaymentMethod(int paymentMethodId) async {
    Database db = await database;
    return await db.delete(
      'payment_methods',
      where: 'id = ?',
      whereArgs: [paymentMethodId],
    );
  }

  // Product operations
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'category': product.category,
    });
  }

  Future<List<Product>> getProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        imageUrl: maps[i]['imageUrl'],
        rating: maps[i]['rating'],
        reviewCount: maps[i]['reviewCount'],
        category: maps[i]['category'],
      );
    });
  }

  // Cart operations
  Future<int> addToCart(int productId, int quantity) async {
    Database db = await database;

    // Debug - check if product exists
    final product = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (product.isEmpty) {
      print(
          "WARNING: Trying to add non-existent product with ID $productId to cart");
      throw Exception("Product not found in database");
    }

    // Check if product is already in cart
    List<Map<String, dynamic>> existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      // Update quantity if already in cart
      return await db.update(
        'cart',
        {'quantity': existing.first['quantity'] + quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } else {
      // Add new item to cart
      return await db.insert('cart', {
        'productId': productId,
        'quantity': quantity,
      });
    }
  }

  Future<List<CartItem>> getCartItems() async {
    Database db = await database;

    try {
      // First check if there are any items in cart
      final cartCount =
          Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cart'));
      print("Cart item count: $cartCount");

      if (cartCount == 0) {
        return [];
      }

      // Join cart and products tables with alias to avoid column name conflicts
      List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT c.id as cart_id, c.quantity, 
               p.id, p.name, p.description, p.price, p.imageUrl, 
               p.rating, p.reviewCount, p.category
        FROM cart c
        JOIN products p ON c.productId = p.id
      ''');

      print("Raw query results: $maps");

      return List.generate(maps.length, (i) {
        Product product = Product(
          id: maps[i]['id'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          price: maps[i]['price'],
          imageUrl: maps[i]['imageUrl'],
          rating: maps[i]['rating'],
          reviewCount: maps[i]['reviewCount'],
          category: maps[i]['category'],
        );

        return CartItem(
          product: product,
          quantity: maps[i]['quantity'],
        );
      });
    } catch (e) {
      print("Error getting cart items: $e");
      rethrow; // Re-throw the error after logging it
    }
  }

  Future<int> updateCartItemQuantity(int productId, int quantity) async {
    Database db = await database;

    if (quantity <= 0) {
      return await db.delete(
        'cart',
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } else {
      return await db.update(
        'cart',
        {'quantity': quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }
  }

  Future<int> clearCart() async {
    Database db = await database;
    return await db.delete('cart');
  }

  // Debug method to check database state
  Future<void> debugDatabase() async {
    Database db = await database;

    print("--- DEBUG DATABASE ---");

    // Check if tables exist
    var tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("Tables: $tables");

    // Check product count
    var productCount = await db.rawQuery("SELECT COUNT(*) FROM products");
    print("Product count: $productCount");

    // Check cart count
    var cartCount = await db.rawQuery("SELECT COUNT(*) FROM cart");
    print("Cart count: $cartCount");

    // See cart contents
    var cartItems = await db.query("cart");
    print("Cart items: $cartItems");

    print("--- END DEBUG ---");
  }
}
