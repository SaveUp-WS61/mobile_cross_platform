import 'package:saveup/models/cart.dart';
import 'package:saveup/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final int version = 1;

  Database ? dbSaveup;

  static final DbHelper dbHelper = DbHelper.internal();
  DbHelper.internal();
  factory DbHelper() {
    return dbHelper;
  }

  Future<Database> openDb() async {
    dbSaveup ??= await openDatabase(join(await getDatabasesPath(),
    'saveup.db'),
    onCreate: (database, version) {
      // Tablas
      database.execute('CREATE TABLE user(id INTEGER PRIMARY KEY, tableId INTEGER, type TEXT)');

      database.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, productId INTEGER, quantity INTEGER)');
    }, version: version);

    return dbSaveup!;
  }

  // Metodos crud
  Future<int> insertUser(User user) async {
    int id = await this.dbSaveup!.insert(
      'user', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace); // Si hay un conflicto (si el registro existe), lo reemplaza

    return id;
  }

  Future<int> insertProductToCart(Cart cart) async {
    int id = await this.dbSaveup!.insert(
      'cart', cart.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace); // Si hay un conflicto (si el registro existe), lo reemplaza

    return id;
  }

  Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> maps = await dbSaveup!.query('user');

    return List.generate(maps.length, (i){
      return User(
        maps[i]['tableId'],
        maps[i]['type']
      );
    });
  }

  Future<List<Cart>> getCart() async {
    final List<Map<String, dynamic>> maps = await dbSaveup!.query('cart');

    return List.generate(maps.length, (i){
      return Cart(
        maps[i]['productId'],
        maps[i]['quantity']
      );
    });
  }

  Future<void> updateCartItemByProductId(Cart cart) async {
    final db = await openDb();
    await db.update(
      'cart',
      cart.toMap(),
      where: 'productId = ?',
      whereArgs: [cart.productId],
    );
  }

  Future<void> deleteCartItemByProductId(int productId) async {
    final db = await openDb();
    await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> deleteAllCartItems() async {
    final db = await openDb();
    await db.delete('cart');
  }

  Future<void> deleteAllUsers() async {
    final db = await openDb();
    await db.delete('user');
  }
}