import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

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
      version: 1,
      onCreate: _onCreate,
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
