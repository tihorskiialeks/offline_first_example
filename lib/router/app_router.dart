import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/presentation/pages/user_profile_page.dart';
import 'package:offline_first/features/users/presentation/pages/users_page.dart';


part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter  {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: UsersRoute.page,
          path: '/users_page',
        ),
        AutoRoute(
          page: UserProfileRoute.page,
          path: '/user_profile_page',
        ),
      ];
}
