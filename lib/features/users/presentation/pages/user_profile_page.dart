import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/di/locator.dart';
import 'package:offline_first/features/users/domain/entities/company_entity.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/presentation/cubit/user_profile_page/user_profile_page_cubit.dart';
import 'package:offline_first/features/users/presentation/cubit/user_profile_page/user_profile_page_state.dart';


@RoutePage()
class UserProfilePage extends StatefulWidget {
  final UserEntity user;

  const UserProfilePage({
    required this.user,
    super.key,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final newUserNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final webSiteController = TextEditingController();
  final companyNameController = TextEditingController();

  Future<void> _onChangeUserPress(BuildContext context) async {
    final updatedCompany = CompanyEntity(
      id: widget.user.company.id,
      name: companyNameController.text.isNotEmpty
          ? companyNameController.text
          : widget.user.company.name,
      catchPhrase: widget.user.company.catchPhrase,
      bs: widget.user.company.bs,
    );

    final updatedUser = UserEntity(
      id: widget.user.id,
      name: newUserNameController.text.isNotEmpty
          ? newUserNameController.text
          : widget.user.name,
      username: widget.user.username,
      email: emailController.text.isNotEmpty
          ? emailController.text
          : widget.user.email,
      address: widget.user.address,
      phone: phoneController.text.isNotEmpty
          ? phoneController.text
          : widget.user.phone,
      website: webSiteController.text.isNotEmpty
          ? webSiteController.text
          : widget.user.website,
      company: updatedCompany,
    );

    await context.read<UserProfileCubit>().changeUser(updatedUser);
    if (!context.mounted) return;
    await context.router.maybePop();
  }

  Future<void> _onDeleteUserPress(BuildContext context) async {
    await context.read<UserProfileCubit>().deleteUser(widget.user);
    if (!context.mounted) return;
    await context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(locator(), locator()),
      child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.user.username),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildBody(),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Change user'),
                onPressed: () => _onChangeUserPress(context),
              ),
              TextButton(
                child: const Text('Delete user'),
                onPressed: () => _onDeleteUserPress(context),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUserData(),
          const SizedBox(height: 20),
          _buildChangeUserData(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildChangeUserData() {
    return Column(
      children: [
        const Text(
          'Change User in database',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        TextField(
          controller: newUserNameController,
          decoration: const InputDecoration(
            labelText: 'New name',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'New email',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'New phone',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: webSiteController,
          decoration: const InputDecoration(
            labelText: 'New website',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: companyNameController,
          decoration: const InputDecoration(
            labelText: 'New company name',
          ),
        ),
      ],
    );
  }

  Widget _buildUserData() {
    final address = widget.user.address;
    final company = widget.user.company;
    return Column(
      spacing: 10,
      children: [
        Text(widget.user.name),
        Text(widget.user.email),
        Text(widget.user.phone),
        Text(widget.user.website),
        Text('${address.city} ${address.street} ${address.suite}'),
        Text('${company.name} ${company.catchPhrase}'),
      ],
    );
  }
}
