import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import '../../../core/utils.dart';
import '../constants/constants.dart';
import 'LoginScreen.dart';


class SignupScreen extends ConsumerStatefulWidget {
  static String id='signup_screen';
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {


  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  String? email;
  String? password;

  void onSignUp(){
    if(validateForm(email!, password!)){
     final res=ref.read(authControllerprovider.notifier).signUp(email: emailController.text, password: passwordController.text, context: context);
    }
  }

  bool validateForm(String email, String password) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      print("Please enter a valid email address");
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      print("Password must be at least 6 characters long");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isLoading=ref.watch(authControllerprovider);

    return isLoading? const LoadingPage(): Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: SvgPicture.asset('assets/svgs/twitter_logo.svg',
                    color: Colors.lightBlueAccent,),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text('Sign Up',
                style: kSendButtonTextStyle.copyWith(
                    fontSize: 30.0, color: Colors.lightBlueAccent),
                textAlign: TextAlign.center),
            const SizedBox(height: 10.0),
            TextField(
              controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                style: kTextStyle,
                decoration: kTextFieldDesign(
                    borderColor: Colors.lightBlueAccent,
                    hintTexts: 'Enter Your Email')),
            const SizedBox(height: 8.0),
            TextField(
              controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDesign(
                    borderColor: Colors.lightBlueAccent,
                    hintTexts: 'Enter Your Password'),
                style: kTextStyle),
            const SizedBox(height: 24.0),
            RoundButton(
              title: 'Sign Up',
              colour: Colors.lightBlueAccent,
              onPress: () async {
                onSignUp();
              }, Size: 200.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Already Have Account",
                    style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black)),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: const Text("Login",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.lightBlueAccent))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
