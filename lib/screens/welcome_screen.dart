import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/component/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WelcomeScreen extends StatefulWidget{

  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin  {
  AnimationController controller;
  Animation animation;
  @override
  void initState(){
    super.initState();

    controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync:  this,
      // upperBound: 100,
    );

    //curve: Curves.decelerate
   // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = ColorTween(begin: Colors.blueGrey, end:  Colors.white).animate(controller);
     controller.forward();

   // controller.reverse(from: 1.0);
   //  controller.addStatusListener((status) {
   //    //print(status);
   //    if(status == AnimationStatus.completed){
   //      controller.reverse(from: 1.0);
   //    }
   //    else if(status == AnimationStatus.dismissed){
   //      controller.forward();
   //    }
   //  });

    /*
    For the below code is use for the large to the small;
     controller.reverse(from: 1.0);
     */
  //  controller.reverse(from: 1.0);

    controller.addListener(() {
      setState(() {

      });
    //  print(controller.value);
    //  print(animation.value);
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red.withOpacity(controller.value),
    //  backgroundColor: Colors.white,
      backgroundColor: animation.value,
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
                    height: 60.0,
                  //   height: controller.value,
                   // height: animation.value * 100,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:
                  ['Flash Chat'],
                //  '${controller.value.toInt()}%',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
