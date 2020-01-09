import 'package:flutter/material.dart';
import './login_screen.dart';
import './signup_screen.dart';
import '../widgets/custom_button.dart';

class MainScreen extends StatelessWidget {
  static const route = "/mainScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "Logo",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                
                child: Image.asset("assets/images/logo.jpg" , fit: BoxFit.cover,width: 150, height: 100,),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            CustomButton(
              text: "Login",
              onPressed: () => Navigator.of(context).pushReplacementNamed(LoginScreen.route),
            ),
            CustomButton(
              text: "Register",
              onPressed: () => Navigator.of(context).pushReplacementNamed(SignupScreen.route),
            )
          ],
        ),
      ),
    );
  }
}
