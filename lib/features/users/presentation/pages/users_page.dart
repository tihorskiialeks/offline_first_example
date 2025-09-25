import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';
import 'package:offline_first/di/locator.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/presentation/cubit/users/users_page_cubit.dart';
import 'package:offline_first/features/users/presentation/cubit/users/users_page_state.dart';
import 'package:offline_first/router/app_router.dart';


@RoutePage()
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  void _stateListener(BuildContext context, UsersPageState state) {
    switch (state.status) {
      case StateStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
          ),
        );
        return;
      case StateStatus.initial:
      case StateStatus.loading:
      case StateStatus.success:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersPageCubit(locator())..getUsers(),
      child: BlocConsumer<UsersPageCubit, UsersPageState>(
        listener: _stateListener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Users list'),
            ),
            body: state.status.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.users?.length ?? 0,
                    itemBuilder: (context, index) {
                      final user = state.users![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildProfileTile(context, state, user),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context,
    UsersPageState state,
    UserEntity user,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(user.username),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 84,
          height: 43,
          child: ElevatedButton(
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(84, 43)),
              padding: WidgetStatePropertyAll(
                EdgeInsets.all(8),
              ),
            ),
            onPressed: () {
              context.router.push(UserProfileRoute(user: user)).then(
                (_) {
                  if (!context.mounted) return null;
                  return context.read<UsersPageCubit>().getUsers();
                },
              );
            },
            child: const Text('Show info'),
          ),
        ),
      ],
    );
  }
}
