import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:koctas/data/di/locator.dart';
import 'package:koctas/data/service/rest_client.dart';

void main() {
  setUpAll(() {
    setupDI();
  });
  test("Get Products", () async {
    var restClient = getIt<RestClient>();

    await restClient.getProduct().then((value) {
      for (var element in value) {
        print(element.images);
      }
    });
  });
}
