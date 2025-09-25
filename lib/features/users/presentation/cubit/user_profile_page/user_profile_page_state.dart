import 'package:equatable/equatable.dart';
import 'package:offline_first/core/base_cubit/base_state.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';


class UserProfileState extends Equatable
    implements BaseState<UserProfileState> {
  @override
  final StateStatus status;
  @override
  final String? errorMessage;

  const UserProfileState({
    this.status = StateStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];

  @override
  bool get stringify => true;
  
  @override
  UserProfileState copyWith({
    StateStatus? status,
    String? errorMessage,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
