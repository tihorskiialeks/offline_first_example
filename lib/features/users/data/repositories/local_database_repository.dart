import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:offline_first/features/users/data/models/address.dart';
import 'package:offline_first/features/users/data/models/company.dart';
import 'package:offline_first/features/users/data/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


@lazySingleton
class LocalDatabaseRepository {
  static Database? _database;
  static const _version = 1;

  LocalDatabaseRepository();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _version,
      onCreate: _createDB,
      // onUpgrade: _upgradeDB,
    );
  }

  // Future<void> _upgradeDB(
  //   Database db,
  //   int oldVersion,
  //   int newVersion,
  // ) async {
  //   if (oldVersion < newVersion) {
  //     await db.execute('''
  //   CREATE TABLE deleted_users_ids (
  //     id INTEGER NOT NULL
  //   )
  //   ''');
  //   }
  // }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE addresses (
      id $idType,
      street $textType,
      suite $textType,
      city $textType,
      zipcode $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE companies (
      id $idType,
      name $textType,
      catchPhrase $textType,
      bs $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE deleted_users_ids (
      id INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE users (
      id $idType,
      name $textType,
      username $textType,
      email $textType,
      addressId INTEGER NOT NULL,
      phone $textType,
      website $textType,
      changedLocally $boolType DEFAULT 0,
      companyId INTEGER NOT NULL,
      FOREIGN KEY (addressId) REFERENCES addresses (id) ON DELETE CASCADE,
      FOREIGN KEY (companyId) REFERENCES companies (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> insertUser(User user) async {
    final userExistsInDB = await userExists(user.id);

    if (userExistsInDB) {
      await updateUser(user);
      return;
    } else {
      final db = await database;

      final addressId = await db.insert('addresses', user.address.toJson());
      final companyId = await db.insert('companies', user.company.toJson());

      await db.insert('users', {
        'id': user.id,
        'name': user.name,
        'username': user.username,
        'email': user.email,
        'addressId': addressId,
        'phone': user.phone,
        'website': user.website,
        'companyId': companyId
      });
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;

    final result = await db.rawQuery('''
       SELECT 
       users.id as userId,
       users.name as userName,
       users.username,
       users.email,
       users.phone,
       users.website,
       users.changedLocally,
        
       addresses.id as addressId, 
       addresses.street,
       addresses.suite,
       addresses.city,
       addresses.zipcode,
         
       companies.id as companyId,
       companies.name as companyName,
       companies.catchPhrase,
       companies.bs
      
       FROM users
       JOIN addresses ON users.addressId = addresses.id
       JOIN companies ON users.companyId = companies.id;
    ''');

    return result.map((row) {
      final address = Address(
        id: row['addressId'] as int,
        street: row['street'] as String,
        suite: row['suite'] as String,
        city: row['city'] as String,
        zipcode: row['zipcode'] as String,
      );

      final company = Company(
        id: row['companyId'] as int,
        name: row['companyName'] as String,
        catchPhrase: row['catchPhrase'] as String,
        bs: row['bs'] as String,
      );

      return User(
        id: row['userId'] as int,
        name: row['userName'] as String,
        username: row['username'] as String,
        email: row['email'] as String,
        address: address,
        phone: row['phone'] as String,
        website: row['website'] as String,
        changedLocally: (row['changedLocally'] as int) == 1,
        company: company,
      );
    }).toList();
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  Future<void> updateUser(User user) async {
    final db = await database;

    final userExistsInDB = await userExists(user.id);
    if (!userExistsInDB) {
      log('User doesnt exist');
      return;
    }
    await _updateAddress(user.address);
    await _updateCompany(user.company);

    await db.update(
      'users',
      {
        'name': user.name,
        'username': user.username,
        'email': user.email,
        'phone': user.phone,
        'website': user.website,
        'addressId': user.address.id,
        'companyId': user.company.id,
        'changedLocally': user.changedLocally,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> _updateAddress(Address address) async {
    final db = await database;

    return await db.update(
      'addresses',
      {
        'street': address.street,
        'suite': address.suite,
        'city': address.city,
        'zipcode': address.zipcode,
      },
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  Future<int> _updateCompany(Company company) async {
    final db = await database;

    return await db.update(
      'companies',
      {
        'name': company.name,
        'catchPhrase': company.catchPhrase,
        'bs': company.bs,
      },
      where: 'id = ?',
      whereArgs: [company.id],
    );
  }

  Future<bool> userExists(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> deleteUser(
    int userId, {
    bool deletedOnlyLocally = false,
  }) async {
    final db = await database;

    final isExists = await userExists(userId);

    if (isExists) {
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (deletedOnlyLocally) await _insertIdToDeletedUsersTable(userId);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> _insertIdToDeletedUsersTable(int userId) async {
    final db = await database;
    await db.insert(
      'deleted_users_ids',
      {'id': userId},
    );
  }

  Future<List<int>> getDeletedUserIds() async {
    final db = await database;
    try {
      final result = await db.query('deleted_users_ids');
      return result.map((row) => row['id'] as int).toList();
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  Future<void> clearDeletedUsersIds() async {
    final db = await database;
    await db.delete('deleted_users_ids');
  }

  Future close() async {
    final db = await database;
    await db.close();
  }
}
