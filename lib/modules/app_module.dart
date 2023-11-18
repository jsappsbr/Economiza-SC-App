import 'package:economiza_sc/guards/auth_guard.dart';
import 'package:economiza_sc/services/auth_service.dart';
import 'package:economiza_sc/stores/auth_store.dart';
import 'package:economiza_sc/stores/filters_store.dart';
import 'package:economiza_sc/stores/products_store.dart';
import 'package:economiza_sc/stores/markets_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:economiza_sc/pages/home_page.dart';
import 'package:economiza_sc/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthService>(() => AuthService());
    i.addSingleton<AuthStore>(() => AuthStore());
    i.addSingleton<ProductsStore>(() => ProductsStore());
    i.addSingleton<MarketsStore>(() => MarketsStore());
    i.addSingleton<FiltersStore>(() => FiltersStore());
    i.addSingleton<Dio>(() {
      String baseUrl = '';

      if (kIsWeb) {
        baseUrl = 'http://localhost:8000/api';
      } else if (Platform.isIOS || Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8000/api';
      } else {
        baseUrl = 'http://localhost:8000/api';
      }

      final options = BaseOptions(baseUrl: baseUrl);
      final dio = Dio(options);

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await Modular.get<AuthService>().getApiToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ));

      return dio;
    });
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage(), guards: [AuthGuard()]);
    r.child('/login', child: (_) => const LoginPage());
  }
}
