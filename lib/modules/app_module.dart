import 'package:economiza_sc/guards/auth_guard.dart';
import 'package:economiza_sc/pages/sign_up_page.dart';
import 'package:economiza_sc/services/auth_service.dart';
import 'package:economiza_sc/services/markets_service.dart';
import 'package:economiza_sc/services/products_service.dart';
import 'package:economiza_sc/services/sign_up_service.dart';
import 'package:economiza_sc/stores/auth_store.dart';
import 'package:economiza_sc/stores/filters_store.dart';
import 'package:economiza_sc/stores/products_store.dart';
import 'package:economiza_sc/stores/markets_store.dart';
import 'package:economiza_sc/stores/sign_up_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:economiza_sc/pages/home_page.dart';
import 'package:economiza_sc/pages/login_page.dart';
import 'package:economiza_sc/config/environment_variables.dart';
import 'package:dio/dio.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    // SignUpStore
    i.addSingleton<AuthService>(() => AuthService());
    i.addSingleton<MarketsService>(() => MarketsService());
    i.addSingleton<ProductsService>(() => ProductsService());
    i.addSingleton<SignUpService>(() => SignUpService());
    i.addSingleton<AuthStore>(() => AuthStore());
    i.addSingleton<FiltersStore>(() => FiltersStore());
    i.addSingleton<MarketsStore>(() => MarketsStore());
    i.addSingleton<ProductsStore>(() => ProductsStore());
    i.addSingleton<SignUpStore>(() => SignUpStore());
    i.addSingleton<Dio>(() {
      final options = BaseOptions(baseUrl: EnvironmentVariable.apiBaseUrl);
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
    r.child('/sign-up', child: (_) => const SignUpPage());
  }
}
