import 'package:equatable/equatable.dart';
import 'package:offline_first/core/base_cubit/base_state.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';



class UsersPageState extends Equatable implements BaseState<UsersPageState> {
  @override
  final String? errorMessage;
  @override
  final StateStatus status;
  final List<UserEntity>? users;

  const UsersPageState({
    this.errorMessage,
    this.status = StateStatus.initial,
    this.users,
  });

  @override
  UsersPageState copyWith({
    String? errorMessage,
    StateStatus? status,
    List<UserEntity>? users,
  }) {
    return UsersPageState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [errorMessage, status, users];
}
