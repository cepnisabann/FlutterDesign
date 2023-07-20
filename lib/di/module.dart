import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../service/rest_client.dart';

@module
abstract class AppModule {
  @singleton
  Dio get dioInstance {
    var dio = Dio(BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    return dio;
  }

  @singleton
  RestClient get restClient => RestClient(dioInstance);
}
