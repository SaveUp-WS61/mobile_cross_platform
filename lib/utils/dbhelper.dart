import 'package:saveup/models/cart.dart';
import 'package:saveup/models/account.dart';
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
      database.execute('CREATE TABLE account(id INTEGER PRIMARY KEY, tableId INTEGER, email TEXT, name TEXT, address TEXT, department TEXT, district TEXT, phoneNumber TEXT, password TEXT, repeatPassword TEXT, lastName TEXT, ruc TEXT, points INTEGER, type TEXT)');

      database.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, productId INTEGER, quantity INTEGER)');
    }, version: version);

    return dbSaveup!;
  }

  // Metodos crud
  Future<int> insertAccount(Account account) async {
    int id = await this.dbSaveup!.insert(
      'account', account.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace); // Si hay un conflicto (si el registro existe), lo reemplaza

    return id;
  }

  Future<int> insertProductToCart(Cart cart) async {
    int id = await this.dbSaveup!.insert(
      'cart', cart.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace); // Si hay un conflicto (si el registro existe), lo reemplaza

    return id;
  }

  Future<List<Account>> getAccounts() async {
    final List<Map<String, dynamic>> maps = await dbSaveup!.query('account');

    return List.generate(maps.length, (i){
      return Account(
        maps[i]['id'],
        maps[i]['tableId'],
        maps[i]['email'],
        maps[i]['name'],
        maps[i]['address'],
        maps[i]['department'],
        maps[i]['district'],
        maps[i]['phoneNumber'],
        maps[i]['password'],
        maps[i]['repeatPassword'],
        maps[i]['lastName'],
        maps[i]['ruc'],
        maps[i]['points'],
        maps[i]['type']
      );
    });
  }

  Future<List<Cart>> getCart() async {
    final List<Map<String, dynamic>> maps = await dbSaveup!.query('cart');

    return List.generate(maps.length, (i){
      return Cart(
        maps[i]['id'],
        maps[i]['productId'],
        maps[i]['quantity']
      );
    });
  }

  Future<void> updateAccount(int accountId, Account updatedAccount) async {
  final db = await openDb();
  await db.update(
    'account',
    updatedAccount.toMap(),
    where: 'id = ?',
    whereArgs: [accountId],
  );
}

  Future<void> updateUserPasswordAndRepeatPassword(int userId, String newPassword, String newRepeatPassword) async {
    final db = await openDb();
    await db.update(
      'account',
      {
        'password': newPassword,
        'repeatPassword': newRepeatPassword,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
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

  // Función para aumentar en uno la cantidad del objeto Cart
  Future<void> increaseQuantityInCart(int productId) async {
    final db = await openDb();
    await db.rawUpdate('UPDATE cart SET quantity = quantity + 1 WHERE productId = ?', [productId]);
  }

  // Función para reducir en uno la cantidad del objeto Cart
  Future<void> decreaseQuantityInCart(int productId) async {
    final db = await openDb();
    await db.rawUpdate('UPDATE cart SET quantity = quantity - 1 WHERE productId = ?', [productId]);
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

  Future<void> deleteAllAccounts() async {
    final db = await openDb();
    await db.delete('account');
  }
}