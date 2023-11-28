import 'package:economiza_sc/pages/sign_up_page.dart';
import 'package:economiza_sc/services/sign_up_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignUpModule extends Module {
  
  @override
  void binds(i) {
    i.addSingleton<SignUpService>(() => SignUpService());
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const SignUpPage());
  }
}
