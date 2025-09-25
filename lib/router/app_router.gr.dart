// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [UserProfilePage]
class UserProfileRoute extends PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    required UserEntity user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserProfileRoute.name,
          args: UserProfileRouteArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserProfileRouteArgs>();
      return UserProfilePage(user: args.user, key: args.key);
    },
  );
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({required this.user, this.key});

  final UserEntity user;

  final Key? key;

  @override
  String toString() {
    return 'UserProfileRouteArgs{user: $user, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserProfileRouteArgs) return false;
    return user == other.user && key == other.key;
  }

  @override
  int get hashCode => user.hashCode ^ key.hashCode;
}

/// generated route for
/// [UsersPage]
class UsersRoute extends PageRouteInfo<void> {
  const UsersRoute({List<PageRouteInfo>? children})
      : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UsersPage();
    },
  );
}
