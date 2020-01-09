import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import './friends_screen.dart';
class LoginScreen extends StatefulWidget {

  static const route = "/loginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  String _email;
  String _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> loginUser() async{
    setState(() {
      loading = true;
    });
    _email = _emailController.text;
    _password = _passwordController.text;
     await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password
    );
  Navigator.of(context).pushReplacementNamed(FriendsScreen.route , arguments: _email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "Logo",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/images/logo.jpg",
                  fit: BoxFit.cover,
                  width: 150,
                  height: 100,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.email),
                  hintText: "Enter your email",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 300,
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Enter your password",
                ),
              ),
            ),
             !loading ? CustomButton(
              onPressed: loginUser,
              text: "Login",
            ) : CircularProgressIndicator()
          ],
        ),
      ) ,
    );
  }
}
