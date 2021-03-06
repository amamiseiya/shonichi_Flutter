import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth.dart';
import '../pages/home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Login'.tr),
        ),
        body: GestureDetector(
            onTap: () {
              if (_emailNode.hasFocus) {
                _emailNode.unfocus();
              }
              if (_passwordNode.hasFocus) {
                _passwordNode.unfocus();
              }
            },
            child: ListView(children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    minHeight: MediaQuery.of(context).size.height / 6,
                    maxWidth: MediaQuery.of(context).size.width / 2,
                    maxHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  child: Center(
                      child: Text(
                    '初心忘るべからず',
                    style: GoogleFonts.notoSerif(),
                  ))),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      child: Column(children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailNode,
                      decoration:
                          InputDecoration(labelText: 'Email address'.tr),
                      onEditingComplete: () {},
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      decoration: InputDecoration(labelText: 'Password'.tr),
                      onEditingComplete: () {},
                    )
                  ]))),
              Row(children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text('Sign in'.tr),
                          onPressed: () async {
                            await authController.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text);
                          },
                        ))),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text('Sign up'.tr),
                          onPressed: () async {
                            await authController.createUserWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text);
                          },
                        )))
              ]),
              Obx(() {
                if (authController.user.value != null) {
                  Future.delayed(Duration(milliseconds: 300))
                      .then((_) => Get.off(() => HomePage()));
                }
                return Container();
              })
            ])));
  }
}
