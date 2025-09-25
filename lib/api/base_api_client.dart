import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_first/features/users/data/models/user.dart';

import 'package:retrofit/retrofit.dart';



part 'base_api_client.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class BaseApiClient {
  @factoryMethod
  factory BaseApiClient(Dio dio) = _BaseApiClient;

  @GET('/users')
  Future<List<User>> getUsers();
}
