import 'package:get_storage/get_storage.dart';
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

  @preResolve
  @singleton
  Future<GetStorage> get initializeGetStorage async {
    var storageName = "liked_products";
    await GetStorage.init(storageName);
    return GetStorage(storageName);
  }
}
