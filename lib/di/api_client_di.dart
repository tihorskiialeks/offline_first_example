part of 'locator.dart';

Future<void> initApiClients() async {
  final dio = Dio();

  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<BaseApiClient>(BaseApiClient(dio));
}
