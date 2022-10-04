import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:koctas/data/service/rest_client.dart';

@module
abstract class AppModule {
  @singleton
  Dio get dioInstance {
    var dio = Dio(BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1/',
      connectTimeout: 20000,
      receiveTimeout: 15000,
    ));
    return dio;
  }

  @singleton
  RestClient get restClient => RestClient(dioInstance);
}
