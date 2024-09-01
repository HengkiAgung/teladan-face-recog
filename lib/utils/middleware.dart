// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../components/modal_bottom_sheet_component.dart';
import '../page/auth/login_page.dart';
import '../repositories/user_repository.dart';
import 'auth.dart';

class Middleware {
  Future<void> authenticated(BuildContext context) async { 
    String token = await Auth().getToken();   
    if (token != "") {
      var user = await UserRepository().getUser(token);

      if (user.email == "") {
        Auth().logOut(context);

        ModalBottomSheetComponent().errorIndicator(context, "Sesi telah berakhir, silahkan Log-In ulang.");
      }
    }
  }


  void redirectToLogin(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    while (navigator != null && navigator.canPop()) {
      Navigator.pop(context);
    }
    
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }
}