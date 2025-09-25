import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/features/users/data/models/address.dart';
import 'package:offline_first/features/users/data/models/company.dart';
import 'package:offline_first/features/users/data/models/user.dart';
import 'package:offline_first/features/users/data/repositories/firebase_repository.dart';
import 'package:offline_first/features/users/data/repositories/local_database_repository.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/domain/repositories/user_repository.dart';
import 'package:offline_first/mock/users_json.dart';


@LazySingleton(as: UserRepository)
class UsersRepositoryImpl extends UserRepository {
  final LocalDatabaseRepository _localDatabaseRepository;
  final FirebaseRepository _firebaseRepository;

  UsersRepositoryImpl(this._localDatabaseRepository, this._firebaseRepository);

  @override
  Future<Either<Failure, List<UserEntity>>>
      getUsersAndSynchronyzeDatabases() async {
    //use when all users deleted.
    // await addMockUsersToFirebase();
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return await _handleGettingUsersFromLocalDatabase();
    } else {
      return await safeExecute(() async {
        return await _synchronizeDataAndGetUsers();
      });
    }
  }

  Future<Either<Failure, List<UserEntity>>>
      _handleGettingUsersFromLocalDatabase() async {
    return await safeExecute(() async {
      final usersFromLocalDB = await _getUsersFromLocalDataBase();
      return usersFromLocalDB.map((model) => model.mapToEntity()).toList();
    });
  }

  Future<List<UserEntity>> _synchronizeDataAndGetUsers() async {
    await _synchronizeData();

    final usersFromRemoteDatabase = await _getUsersFromRemoteDatabase();

    for (User user in usersFromRemoteDatabase) {
      await _localDatabaseRepository.insertUser(user);
    }
    return usersFromRemoteDatabase.map((model) => model.mapToEntity()).toList();
  }

  Future<void> _synchronizeData() async {
    final usersFromLocalDB = await _getUsersFromLocalDataBase();
    final changedLocallyUsers =
        usersFromLocalDB.where((user) => user.changedLocally);

    for (final user in changedLocallyUsers) {
      await _changeUserInRemoteDatabase(user.copyWith(changedLocally: false));
    }

    final deletedLocallyUsersIds =
        await _localDatabaseRepository.getDeletedUserIds();

    if (deletedLocallyUsersIds.isNotEmpty) {
      for (final deletedUserId in deletedLocallyUsersIds) {
        await _firebaseRepository
            .deleteUserFromFirestore(deletedUserId.toString());
      }
      await _localDatabaseRepository.clearDeletedUsersIds();
    }
  }

  Future<List<User>> _getUsersFromLocalDataBase() async {
    return await _localDatabaseRepository.getAllUsers();
  }

  Future<List<User>> _getUsersFromRemoteDatabase() async {
    return await _firebaseRepository.getUsersFromFirestore();
  }

  Future<void> _changeUserInLocalDatabase(User user) async {
    await _localDatabaseRepository.updateUser(
      user.copyWith(changedLocally: true),
    );
  }

  Future<void> _changeUserInRemoteDatabase(User user) async {
    await _firebaseRepository.updateUserInFirestore(user);
  }

  @override
  Future<Either<Failure, void>> deleteUser(UserEntity user) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) ) {
      return await safeExecute(() async {
        await _localDatabaseRepository.deleteUser(
          user.id,
          deletedOnlyLocally: true,
        );
      });
    } else {
      return await safeExecute(() async {
        await _firebaseRepository.deleteUserFromFirestore(user.id.toString());
        await _localDatabaseRepository.deleteUser(user.id);
      });
    }
  }

  @override
  Future<Either<Failure, void>> changeUser(UserEntity user) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final company = Company(
      id: user.company.id,
      name: user.company.name,
      catchPhrase: user.company.catchPhrase,
      bs: user.company.bs,
    );

    final address = Address(
      id: user.address.id,
      street: user.address.street,
      suite: user.address.suite,
      city: user.address.city,
      zipcode: user.address.zipcode,
    );

    final userModel = User(
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      address: address,
      phone: user.phone,
      website: user.website,
      company: company,
    );
    if (!connectivityResult.contains(ConnectivityResult.none) ) {
      return await safeExecute(() async {
        return await _changeUserInRemoteDatabase(userModel);
      });
    } else {
      return await safeExecute(() async {
        await _changeUserInLocalDatabase(userModel);
      });
    }
  }

  @override
  Future<void> addMockUsersToFirebase() async {
    final mockUsers = _parseUsers(jsonData);
    final mockUsersWithCompanyAndAdressIds = <User>[];
    for (final user in mockUsers) {
      final userWithIds = user.copyWith(
        company: user.company.copyWith(id: user.id),
        address: user.address.copyWith(id: user.id),
      );
      mockUsersWithCompanyAndAdressIds.add(userWithIds);
    }

    await _firebaseRepository
        .addUsersToFirestore(mockUsersWithCompanyAndAdressIds);
  }

  List<User> _parseUsers(List<dynamic> json) {
    return json.map((userJson) => User.fromJson(userJson)).toList();
  }
}
