// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import '../../utils/auth.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Auth().logOut(context);

        return true;
      },
      child: Scaffold(
        body: Container(
          height: double.maxFinite,
          width: double.infinity,
          alignment: AlignmentDirectional.center,
          child: ListView(
            children: [
              const Image(
                // image: AssetImage("assets/Logo_CMT.png"),
                image: AssetImage("assets/Logo_CMT.png"),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                child: Text(
                  "Password anda telah direset!",
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                child: Text(
                  "Silahkan masukkan password baru anda!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 15, bottom: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 100),
                child: TextButton(
                  onPressed: () async {
                    if (await Auth()
                        .resetPassword(context, _passwordController.text)) {
                      Auth().logOut(context);
                    }
                    ModalBottomSheetComponent().loadingIndicator(context,
                        "Berhasil mengganti password, silahkan login ulang");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
