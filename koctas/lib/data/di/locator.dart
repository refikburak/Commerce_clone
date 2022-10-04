import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:koctas/data/service/rest_client.dart';
import 'package:dio/dio.dart';
import 'locator.config.dart';

GetIt getIt = GetIt.instance;

@injectableInit
void setupDI() => $initGetIt(getIt);
