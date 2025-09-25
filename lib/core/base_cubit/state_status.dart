enum StateStatus {
  initial,
  loading,
  error,
  success;

  bool get isLoading => this == loading;
  bool get isError => this == error;
  bool get isInitial => this == initial;
  bool get isSuccess => this == success;
  bool get isLoadingOrSuccess => this == loading || this == success;
}
