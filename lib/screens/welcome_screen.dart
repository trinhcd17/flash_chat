import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();

    controller=AnimationController(vsync: this,duration: Duration(seconds: 1));
    controller.forward();

    controller.addListener(() {
      setState(() {
      });
    });

  }
@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value*80,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 400),
                  isRepeatingAnimation: true,
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Login',color: Colors.lightBlueAccent,onPressed: (){
            Navigator.pushNamed(context, LoginScreen.id);
            }),
            RoundedButton(title: 'Register',color: Colors.blueAccent,onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}



