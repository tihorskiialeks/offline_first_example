import 'package:offline_first/core/base_cubit/state_status.dart';

abstract class BaseState<T> {
  final StateStatus status;
  final String? errorMessage;

  BaseState(this.status, [this.errorMessage]);

  T copyWith({
    StateStatus? status,
    String? errorMessage,
  });
}
