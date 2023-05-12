import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vivaapp/controller/const.dart';
import '../controller/utils.dart';
import '../controller/widgets/custom_textformfield.dart';
import '../main.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final formKey = GlobalKey<FormState>();
  bool isTextLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  dynamic emaiHeight = 0.06;
  dynamic passHeight = 0.06;
  dynamic cpassHeight = 0.06;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      height: emaiHeight,
                      size: size,
                      hintText: 'Email',
                      isPassword: false,
                      controller: emailController,
                      validator: (e) {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text);
                        return emailValid != true
                            ? 'Please Enter a valid Email'
                            : null;
                      },
                    ),
                    CustomTextField(
                      height: passHeight,
                      size: size,
                      hintText: 'Password',
                      isPassword: true,
                      controller: passwordController,
                      validator: (pass) {
                        return pass != null && pass.length < 6
                            ? 'Please Enter 6 Character'
                            : null;
                      },
                    ),
                    !isTextLogin
                        ? CustomTextField(
                            height: cpassHeight,
                            size: size,
                            hintText: 'Confirm Password',
                            isPassword: true,
                            controller: cpasswordController,
                            validator: (cpass) {
                              return cpasswordController.text !=
                                      passwordController.text
                                  ? 'Please Check Password'
                                  : null;
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  isTextLogin ? login() : signup();
                },
                child: Text(isTextLogin ? 'Login' : 'Signup'),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: isTextLogin
                            ? 'Dont have an Account? '
                            : 'Already Have an account? '),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          makeChanges();
                        },
                      text: isTextLogin ? 'Sign Up' : 'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: blueColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      log('Error == $e');
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signup() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      log('Error == $e');
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  makeChanges() {
    setState(() {
      isTextLogin = !isTextLogin;
    });
  }
}
